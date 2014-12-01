classdef Classificator < handle
   
    properties 
        coinList;
    end
    
    methods
    
        function self = Classificator()
            self.coinList = ObjectList();
        end
        
        function learnFromCoinList(self, coinList)
            self.coinList.addObjects(coinList);
        end
        
        function v = valueForCoinSize(self, size)
            values = self.coinList.allValues();
            for i=1:numel(values);
                value = values(i);
                [mu, sigma] = self.coinList.statsForValue(value);
                p(i) = normpdf(size, mu, sigma);
            end
            [~, indices] = sort(p);
            v = values(indices(numel(indices)));
        end
        
    end
    
end