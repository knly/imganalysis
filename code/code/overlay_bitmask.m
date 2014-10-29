function img_out = overlay_bitmask( Image, bitmask)
%This function adds a bitmask to an rgb Image.

%First convert the bitmask: 
%   1->255,255,255
%   0->0,0,0

    dim_mask = zeros(size(Image));
    dim_mask(:, :, 1) = bitmask .* 255;
    dim_mask(:, :, 2) = bitmask .* 255;
    dim_mask(:, :, 3) = bitmask .* 255;
    dim_mask = uint8(dim_mask);
    
    % Add both for the output
    
    img_out = Image + dim_mask ./ 2;
end