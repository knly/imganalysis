function Image_out = ecbp( Image_in, channel, tolerance )
% Syntax:
%   Image_in: Image of format (x, y, 3)
%   channel: colorchannel
%   tolerance: higher tolerance -> purer color

% Description:
% ecbp (extract color by purity) will return an Image which will only
% contain Pixels which are 'pure'. A 'pure'-colored Pixel is a Pixel, where
% the value of the specified color channel is higher than the values of the
% remaining 2 color channels. tolerance will be added to the remaining 2
% channels.
% tolerance can be used to erase grey/white; It's value determines by how much
% the color values have to differ for them to be treated as different. A
% Pixel [100, 91, 109] for example will be erased if the tolerance is set
% to 10, but not if it is set to 9 (channel = 1). To eliminate
% Paper-white, a tolerance of 5 is sufficient. Higher Tolerance means
% purer color. and can be used to isolate the blue marks on the paper.


    
    % Check if the specified channel is valid
    [x, y, ~] = size(Image_in);
    if (channel > 3)
        Image_out = Image_in;
    else
        
        
        
        temp_out = Image_in;
            
        %RGB(150, 89, 67)    

        bool_chart = zeros(x, y); % Will save 0 or 1 representing an allowed/not allowed pixel.
        bool_chart = (temp_out(:, :, channel) >= temp_out(:, :, mod(channel+1, 3)+1)+tolerance)&(temp_out(:, :, channel) >= temp_out(:, :, mod(channel, 3)+1)+tolerance);
        
        %Multiply the Bool chart with the Image:
        for i = 1:3
            temp_out(:, :, i) = Image_in(:, :, i) .* uint8(bool_chart);            
        end
        
        Image_out = temp_out;       
    end;



end

