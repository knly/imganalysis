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
            svenPrint(sprintf('Learnt from %i coins.\n', coinList.Size))
            fprintf('value: %.2f, mu: %f, sigma: %f\n', [self.values; self.mu; self.sigma])
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
                p(i) = normpdf(size, self.mu(i), self.sigma(i)) * 1/8 * self.sigma(i);                
            end
            [~, indices] = sort(p);            
            v = self.values(indices(numel(indices)));
        end
        
    end
    
end