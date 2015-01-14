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
                
        function [v, p] = valueForCoin(self, coin)
            feature_names = self.coinList.featureNames();
            weight = [2, 1, 1, 1];
            for i=1:numel(self.values);
                value = self.values(i);
                mu = self.mu{i};
                sigma = self.sigma{i};
                p(i) = 1;
                for feature_i=1:numel(feature_names)
                    p(i) = p(i) * ( normpdf(getfield(coin, feature_names{feature_i}), mu(feature_i), sigma(feature_i)) * 1/8 * sigma(feature_i) ) ^ weight(feature_i);
                end
                %p(i) = mvnpdf([coin.size, coin.hue, coin.sat], self.mu{i}, self.sigma{i});                
            end
            p = p / sum(p);
            [~, indices] = sort(p);
            v = self.values(indices(numel(indices)));
        end
        
    end
    
end