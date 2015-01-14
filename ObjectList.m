classdef ObjectList < handle
   properties
     Size;
     List;
   end % properties
   methods
    function obj = ObjectList()
       obj.Size=0;
    end
    
    function feature_names = featureNames(self)
        feature_names{1} = 'size';
        feature_names{2} = 'hue';
        feature_names{3} = 'sat';
        feature_names{4} = 'sat_diff';
    end
    
    function addObject(self,center,size,hue,sat,sat_diff)
        N = self.Size+1;
        self.Size = N;
        self.List(N).size   = size;
        self.List(N).center = center;
        self.List(N).hue = hue;
        self.List(N).sat = sat;
        self.List(N).sat_diff = sat_diff;
    end
    function addObjects(obj,objectList)
        prevSize = obj.Size;
        obj.Size = obj.Size+objectList.Size;
        for i=1:objectList.Size
            obj.List(prevSize+i).size   = objectList.List(i).size;
            obj.List(prevSize+i).center = objectList.List(i).center;
            obj.List(prevSize+i).value  = objectList.List(i).value;
            obj.List(prevSize+i).hue  = objectList.List(i).hue;
            obj.List(prevSize+i).sat  = objectList.List(i).sat;
            obj.List(prevSize+i).sat_diff  = objectList.List(i).sat_diff;
        end
    end
    function setObjectValue(self,i,value)
        self.List(i).value  = value;       
    end
    function save(self,filename)
        save(filename,'objList');       
    end 
    
    function values = allValues(obj)
        for i=1:obj.Size
            values(i) = obj.List(i).value;
        end
        values = unique(values);
    end
    
    function [mu, sigma] = statsForValue(self, value)
        feature_names = self.featureNames();
        for feature_i=1:numel(feature_names)
            j = 1;
            for i=1:self.Size
                if (self.List(i).value == value)
                    vs(j) = getfield(self.List(i),feature_names{feature_i});
                    j = j+1;
                end
            end
            mu(feature_i) = mean(vs);
            sigma(feature_i) = std(vs);
        end
    end
    
    function show(obj, I, classificator, correctValues)
       imshow(I);
       hold on;
       for k=1:obj.Size
           if correctValues == false
               isCorrect = 1;
           else
               isCorrect = correctValues(k)==obj.List(k).value;
           end
           if isCorrect
               textColor = 'green';
           else
               textColor = 'red';
           end
           %values = [0.01,0.02,0.05,0.1,0.2,0.5,1,2];
           %value_i = find(values==obj.List(k).value);
           %p_value = obj.List(k).p(value_i) * 100;
           %correctValue = correctValues(k);
           %correctValue_i = find(values==correctValue);
           %p_correctValue = obj.List(k).p(correctValue_i) * 100;
           text(obj.List(k).center(1),obj.List(k).center(2),[num2str(k),' (',num2str(obj.List(k).value),' EUR)' ],'Color',textColor,'BackgroundColor',[1,1,1]);
       end
       
       feature_i = 1;
       
       if classificator ~= false
           for k=1:obj.Size
                subAxes = axes('Position', [0.4 0.1 0.2 0.2]);
                maxY = 0;
                for i=1:numel(classificator.values);
                    mu = classificator.mu{i};
                    mu = mu(feature_i);
                    sigma = classificator.sigma{i};
                    sigma = sigma(feature_i);
                    value = classificator.values(i);
                    x = linspace(mu-5*sigma, mu+5*sigma, 200);
                    yy = normpdf(mu, mu, sigma) * 1/8 * sigma;
                    plot(x, normpdf(x, mu, sigma) * 1/8 * sigma, 'LineWidth', 1); hold on;
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
