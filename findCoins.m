function coinList = findCoins(I)
% Zu jedem Bild wird eine coinList erstellt. Sie ist vom Typ ObjectList
% und enthält Objektgrösse und Objektmittelpunkt
% L enthält das Binärbild, wobei die Wertigkeit der Pixel abhängig von 
% ihrer Zusammenhangskomponente ist
    
    %imshow(I);
    %waitforbuttonpress();
    %close;

    I_hsv = rgb2hsv(I);
    I_hue = I_hsv(:,:,1);
    I_sat = I_hsv(:,:,2);
    
    B = I_hsv(:,:,2) > 0.15;
    
    close_holes = strel('disk', 10, 6);
    B = imdilate(B, close_holes);
    B = imerode(B, close_holes);

    reduce = strel('disk', 50, 6);
    B_reduced = imerode(B, reduce);
    
    all_components = bwconncomp(B_reduced);
    centers = regionprops(all_components,'Centroid');
    centers = cat(1, centers.Centroid); % Struct2Mat
    
    coinList = ObjectList();
    
    B = zeros(size(B));
    for i=1:all_components.NumObjects
        B_individual = zeros(size(B));
        linear_indices = cell2mat(all_components.PixelIdxList(i));
        B_individual(linear_indices) = 1;
        
        individual_component_reduced = bwconncomp(B_individual);
        linear_indices_reduced = cell2mat(individual_component_reduced.PixelIdxList);

        B_individual = imdilate(B_individual, reduce);
        
        B = B | B_individual;
        
        individual_component = bwconncomp(B_individual);
        %r = regionprops(individual_component,'MajorAxisLength').MajorAxisLength / 2        
        linear_indices = cell2mat(individual_component.PixelIdxList);
        objectSize = numel(linear_indices);
        
        if objectSize > 5000
            objectCenter = centers(i, :);
            
            hues = I_hue(linear_indices);
            sats = I_sat(linear_indices);
            hue = mean(hues);
            sat = mean(sats);
            sat_diff = mean(I_sat(linear_indices_reduced)) / sat;
            
            %imshow(B_individual);
            %waitforbuttonpress();
            %close;
        
            coinList.addObject(objectCenter,objectSize,hue,sat,sat_diff);
        end
     
    end
    
    %imshow(B);
    %waitforbuttonpress();
    %close;
    
    %coinList.showHist();
end
