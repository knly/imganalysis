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
            %fprintf('value: %.2f, mu: %f, sigma: %f\n', [self.values; self.mu; self.sigma])
        end
        
        % Compute mu, sigma
        function computeStats(self);
            self.values = self.coinList.allValues();            
            for i=1:numel(self.values);
                value = self.values(i);
                [mu, sigma] = self.coinList.statsForValue(value);
                self.mu{i} = mu;
                self.sigma{i} = sigma;
            end
        end
                
        function v = valueForCoin(self, coin)
            
            for i=1:numel(self.values);
                value = self.values(i);
                mu = self.mu{i};
                sigma = self.sigma{i};
                p(i) = normpdf(coin.size, mu(1), sigma(1)) * 1/8 * sigma(1);
                p(i) = p(i) * normpdf(coin.hue, mu(2), sigma(2)) * 1/8 * sigma(2);
                p(i) = p(i) * normpdf(coin.sat, mu(3), sigma(3)) * 1/8 * sigma(3);
                %p(i) = mvnpdf([coin.size, coin.hue, coin.sat], self.mu{i}, self.sigma{i});                
            end
            [~, indices] = sort(p);            
            v = self.values(indices(numel(indices)));
        end
        
    end
    
end