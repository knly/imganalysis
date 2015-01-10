function [coinList, L] = findCoins(I)
% Zu jedem Bild wird eine coinList erstellt. Sie ist vom Typ ObjectList
% und enthält Objektgrösse und Objektmittelpunkt
% L enthält das Binärbild, wobei die Wertigkeit der Pixel abhängig von 
% ihrer Zusammenhangskomponente ist
    
    I_hsv = rgb2hsv(I);
    I_hue = I_hsv(:,:,1);
    I_sat = I_hsv(:,:,2);
    
    %Saturation is best used to view only foreground, Saturation is channel
    %2. Create a binary mask by using a threshold on the hsv image:
    binary_mask = I_hsv(:,:,2) > 0.15;
    
    % close holes with dilate, then erode by the
    % same amount to get back to the original size
    
    % SE: Erode/Dilate parameter; Check for a disk shaped region of radius
    % 20, N=6 (Some algorithm parameter)
    SE = strel('disk', 5, 6);
    binary_mask = imdilate(binary_mask, SE);
    binary_mask = imerode(binary_mask, SE);
    
    B = binary_mask;

    
    
    
    CC = bwconncomp(B);
    numObj   = CC.NumObjects;
    S = regionprops(CC,'Centroid');
    p = cat(1, S.Centroid); % Struct2Mat
    P = regionprops(CC,'PixelList');
    
    coinList = ObjectList();
    m = 0;
    L = zeros(size(I));
    for i=1:numObj
        pixels = P(i).PixelList;
        objectSize   = numel(pixels);
        
        if objectSize > 5000
            m = m + 1; % Wert für Zusammenhangskomponente
            L(pixels) = m;
            
            objectCenter = p(i, :);
            
            linear_indices = cell2mat(CC.PixelIdxList(i));
            hues = I_hue(linear_indices);
            sats = I_sat(linear_indices);
            hue = mean(hues);
            sat = mean(sats);
        
            coinList.addObject(objectCenter,objectSize,hue,sat);
        end
     
    end
    %coinList.showHist();
end
