import pandas, json, sys, math, numpy               

events=[]                                           
df = pandas.read_csv(sys.argv[1], header=None)      
names="id text entities eventDate sources images areas titles twitter".split()                           
desired_names="id entities eventDate images areas titles".split()                                        
idxs = [d for d in df]                              
for index, row in df.iterrows():                    
    event={}                                        
    print()                                         
    for i in idxs:                                  
        data = row[i]                               
        #if type(data) == str and len(data) > 100: data = data[:100]                                     
        name=names[i]                               
        if name not in desired_names:               
            continue                                

        if data is numpy.nan:                       
            data = []                               

        if name == 'entities':                      
            newdata=[]                              
            if data:                                
                data=eval(data)                     
                for s in data:                      
                    uuid, plabel, conc = s.split(",")                                                    
                    newdata.append({"thesaurus_uuid":uuid, "prefLabel":plabel, "concept_uri":conc})      
            data = newdata                          

        if name == "images":                        
            newdata=[]                              
            if data:                                
                data=eval(data)                     
                for link in data:                   
                    newdata.append({"link":link,"place":data[link]})                                     
            data=newdata                            

        if name == "areas":                         
            newdata=[]                              
            if data:                                
                data = eval(data)                   
                for place in data:                  
                    geom = data[place]              
                    gtype, geom = geom.split(" ",1) 
                    geom = geom.replace("(","")     
                    geom = geom.replace(")","")     
                    #print('raw geom:', geom)       
                    geom = geom.split(",")          
                    floatgeom = []                  
                    for strgeom in geom:            
                        floatgeom.append(list(map(float,strgeom.split())))                               
                    #print(gtype)                   
                    #print('floatgeom:',floatgeom)  
                    newdata.append({"name":place,"geometry":floatgeom})                                  
            data = newdata                          

        event[name]=data                            
    events.append(event)                            

#print(json.dumps(events, indent=4, sort_keys=True))                                                     
with open("events_parsed.json","w") as f:           
    json.dump(events, f)
