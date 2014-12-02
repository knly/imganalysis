classdef Classificator < handle
   
    properties 
        coinList;
        values;
        mu;
        sigma;
    end
    
    methods
    
        function self = Classificator()
            self.coinList = ObjectList();
        end
        
        function learnFromCoinList(self, coinList)
            self.coinList.addObjects(coinList);
            self.computeStats();
        end
        
        % Compute mu, sigma
        function computeStats(self)
            self.values = self.coinList.allValues();            
            for i=1:numel(self.values);
                value = self.values(i);
                [self.mu(i), self.sigma(i)] = self.coinList.statsForValue(value);                  
            end
        end
                
        function v = valueForCoinSize(self, size)
            
            for i=1:numel(self.values);
                value = self.values(i);
                p(i) = normpdf(size, self.mu(i), self.sigma(i));                
            end
            [~, indices] = sort(p);            
            v = self.values(indices(numel(indices)));
        end
        
    end
    
end