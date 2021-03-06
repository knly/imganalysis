function p = find_marks( Image, landscape )
% Function to determine the position of the 4 blue marks
% Warning: Currently only works, if 4 connected components are found
% Could be improved by closing holes
    if nargin<2
        landscape = 0;
    end
    count = 0;  % counts # of blue components
    
    threshold = 6;
    while ((count ~= 4)&&(threshold < 30))
             
        %Use ecbp to extract the 4 blue marks:
        image_blue = ecbp(Image, 3, threshold);

        %Use threshold on the blue channel:
        image_bin = image_blue(:, :, 3) > 1;

        %Close Holes

        SE = strel('disk', 10, 6);
        image_bin = imdilate(image_bin, SE);
        image_bin = imerode(image_bin, SE);
   
    
        %Find connected components and determine the center
        %CC = bwconncomp(image_bin);
        S = regionprops(image_bin,'centroid');
        %S is a structure, use cat to convert its elements to a matrix
        p = cat(1, S.Centroid);
        [count, ~] = size(p);
        threshold = threshold +1;
    end
    
    if count ~= 4
        p = 0;
        return
    end
    
    
    [~, indices] = sort(p);
    p(:, :) = p(indices(:, 2), :);  % Punkte nach y Werten sortiert
    
    % Sortiere obere 2 Punkte, links bildet den Anfang:
    if ( p(1, 1) > p(2, 1) )
        p = p([2,1,3,4], :);
    end
    
    %Sortiere untere 2 Punkte, rechts bildet den Anfang:
    if ( p(4, 1) > p(3, 1) )
        p = p([1,2,4,3], :);
    end
    
    % Vektoren
    v12 = p(2,:)-p(1,:);
    v23 = p(3,:)-p(2,:);
    v34 = p(4,:)-p(3,:);
    v41 = p(1,:)-p(4,:);
      
    % L�ngen
    distance12 = sqrt((p(1,1) - p(2,1)).^2 + (p(1,2) - p(2,2)).^2);
    distance23 = sqrt((p(2,1) - p(3,1)).^2 + (p(2,2) - p(3,2)).^2);
    distance34 = sqrt((p(3,1) - p(4,1)).^2 + (p(3,2) - p(4,2)).^2);
    distance41 = sqrt((p(1,1) - p(4,1)).^2 + (p(1,2) - p(4,2)).^2);
    
    % Winkel
    arc1 = abs(acos((v12*(-v41'))/(distance12*distance41))/3.14*180);
    arc2 = abs(acos((v23*(-v12'))/(distance12*distance23))/3.14*180);
    arc3 = abs(acos((v34*(-v23'))/(distance23*distance34))/3.14*180);
    arc4 = abs(acos((v41*(-v34'))/(distance34*distance41))/3.14*180);
    
    % Pr�fe nach Hochformat/Querformat:
    %%if distance12 < distance41
    if xor(((distance12 < distance41) || (abs(arc1-arc3)+abs(arc2-arc4))>40), landscape)
        p = p([4,1,2,3], :);    % Permutation, falls p im Hochformat vorliegt
    end
    
end

