function p = find_marks( Image )
% Function to determine the position of the 4 blue marks
% Warning: Currently only works, if 4 connected components are found
% Could be improved by closing holes

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
        
    %if (( p(2, 1) < p(3, 1) ) && ( p(2, 1) < p(1, 1) ))
    %    p = p([1,3,2,4], :);        % Permutiere ggf. 2 &3 Koordinate
    %end
    
    %if ~(( p(4, 1) < p(2, 1) ) && ( p(4, 1) < p(3, 1) ))
    %    p = p([1,2,4,3], :);            % Tausche 4 &3
    %end
        
    % Prüfe nach Hochformat/Querformat:
    distance12 = (p(1,1) - p(2,1)).^2 + (p(1,2) - p(2,2)).^2;
    distance41 = (p(1,1) - p(4,1)).^2 + (p(1,2) - p(4,2)).^2;
    if distance12 < distance41
        p = p([4,1,2,3], :);    % Permutation, falls p im Hochformat vorliegt
    end
    
end

