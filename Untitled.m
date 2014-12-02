figure;
            maxY = 0;
            for i=1:numel(values);
                value = values(i);
                [mu, sigma] = self.coinList.statsForValue(value);
                p(i) = normpdf(size, mu, sigma);
                x = linspace(mu-5*sigma, mu+5*sigma, 1000);
                
                yy = normpdf(mu, mu, sigma);
                plot(x, normpdf(x, mu, sigma), 'LineWidth', 2); hold on;
                
                if yy > maxY
                    maxY = yy;
                end
                
            end