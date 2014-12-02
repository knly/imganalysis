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
    function addObjects(obj,objectList)
        prevSize = obj.Size;
        obj.Size = obj.Size+objectList.Size;
        for i=1:objectList.Size
            obj.List(prevSize+i).size   = objectList.List(i).size;
            obj.List(prevSize+i).center = objectList.List(i).center;
            obj.List(prevSize+i).value  = objectList.List(i).value;
        end
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
    
    function values = allValues(obj)
        for i=1:obj.Size
            values(i) = obj.List(i).value;
        end
        values = unique(values);
    end
    
    function [mu, sigma] = statsForValue(obj, value)
        j = 1;
        for i=1:obj.Size
            if (obj.List(i).value == value)
                sizes(j) = obj.List(i).size;
                j = j+1;
            end
        end
        mu = mean(sizes);
        sigma = std(sizes);
    end
    
    function show(obj, I, classificator)
       imshow(I); 
       hold on;
       for k=1:obj.Size
           text(obj.List(k).center(1),obj.List(k).center(2),[num2str(k),' (',num2str(obj.List(k).value),')'],'Color',[1,0,0]);
       end
       
       if classificator ~= false
           for k=1:obj.Size
                subAxes = axes('Position', [0.4 0.1 0.2 0.2]);
                maxY = 0;
                for i=1:numel(classificator.values);
                    mu = classificator.mu(i);
                    sigma = classificator.sigma(i);
                    value = classificator.values(i);
                    x = linspace(mu-5*sigma, mu+5*sigma, 200);
                    yy = normpdf(mu, mu, sigma);
                   plot(x, normpdf(x, mu, sigma), 'LineWidth', 1); hold on;

                    if yy > maxY
                        maxY = yy;
                    end          
                               
                end
               legend('001','002','005','010','020','050','100','200'); 
               line('XData', [obj.List(k).size obj.List(k).size], 'YData', [0 maxY], 'LineWidth', 1);
               break;
            end
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
