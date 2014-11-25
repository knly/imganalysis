classdef ObjectList < handle
   properties
     Size;
     List;
   end % properties
   methods
    function obj = ObjectList()
       obj.Size=0;
    end
    
    function addObject(obj,objSize,objCenter)
        N = obj.Size+1;
        obj.Size = N;
        obj.List(N).size   = objSize;
        obj.List(N).center = objCenter;
        obj.List(N).value  = 0;       
    end
    function setObjectFeature(objList,objNumber,objFeature)
        objList.List(objNumber).feature  = objFeature;       
    end  
    function setObjectValue(objList,objNumber,objValue)
        objList.List(objNumber).value  = objValue;       
    end    
    function save(objList,filename)
        save(filename,'objList');       
    end 
    function show(obj,I)
       imshow(I); 
       hold on;
       for k=1:obj.Size
            text(obj.List(k).center(1),obj.List(k).center(2),[num2str(k),' (',num2str(obj.List(k).size),')'],'Color',[1,0,0]);
       end
       hold off;
    end
    
    function showHist(obj)
        sizes = zeros(obj.Size,1);
        for i=1:numel(sizes)
            sizes(i) = obj.List(i).size;
        end
        hist(sizes, 50)
    end    
    
   end% methods
end% classdef
