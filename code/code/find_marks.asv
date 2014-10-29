function p = find_marks( Image )
% Function to determine the position of the 4 blue marks
% Warning: Currently only works, if 4 connected components are found
% Could be improved by closing holes
    
    %Use ecbp to extract the 4 blue marks:
    image_blue = ecbp(Image, 3, 30);
    
    %Use threshold on the blue channel:
    image_bin = image_blue(:, :, 3) > 1;
    
    %Find connected components and determine the center
    %CC = bwconncomp(image_bin);
    S = regionprops(image_bin,'centroid');
    %S is a structure, use cat to convert its elements to a matrix
    p = cat(1, S.Centroid);




end

