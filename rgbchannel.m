function Image_out = rgbchannel( Image_in, channel )
% Syntax: 
%   Image_in: Image of the format (x, y, dim)
%   channel: 1, 2, 3 corresponding to r, g, b for an output channel

% Description:
% The rgbchannel function will take an image and output its r, g or b
% channel. If channel is higher than the number of colordimensions of the
% image, the image itself will be returned. This may be the case if you
% want the g channel of a grayscale picture. The image returned from this 
% function will have every channel other than channel set to 0 at every
% coordinate.

    [x_check, y_check, dim_check] = size(Image_in);
    if (channel > dim_check)
        Image_out = Image_in;
    else
        
        temp_out = Image_in;
        for i = 1:dim_check
            if i ~= channel
                temp_out(:, :, i) = zeros(x_check, y_check);
            end
        end
        
        Image_out = temp_out;       
    end;
    
end
