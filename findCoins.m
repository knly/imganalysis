function [coinList, L] = findCoins(B,I)
% Zu jedem Bild wird eine coinList erstellt. Sie ist vom Typ ObjectList
% und enthält Objektgrösse und Objektmittelpunkt
% L enthält das Binärbild, wobei die Wertigkeit der Pixel abhängig von 
% ihrer Zusammenhangskomponente ist
    
    I_hsv = rgb2hsv(I);
    I_hue = I_hsv(:,:,1);
    I_sat = I_hsv(:,:,2);
    img_size = size(I);
    L        = zeros(size(B));
    coinList = ObjectList();
    CC = bwconncomp(B);
    numObj   = CC.NumObjects;
    S = regionprops(CC,'Centroid');
    p = cat(1, S.Centroid); % Struct2Mat
    P = regionprops(CC,'PixelList');
    m = 0;
    for i=1:numObj
        pixels = P(i).PixelList;
        objectSize   = numel(pixels);
        
        if objectSize > 5000
            m = m + 1; % Wert für Zusammenhangskomponente
            L(pixels) = m;
            %for k = 1:numel(pixels)            
             %   L(ind2sub(CC.ImageSize,pixels(k))) = i;
            %end
            
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
