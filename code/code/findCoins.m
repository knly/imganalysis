function [coinList, L] = findCoins(B)
    L        = zeros(size(B));
    coinList = ObjectList();
    CC = bwconncomp(B);
    numObj   = CC.NumObjects;
    S = regionprops(CC,'Centroid');
    p = cat(1, S.Centroid); % Struct2Mat
    P = regionprops(CC,'PixelList');
    for i=1:numObj
        pixels = P(i).PixelList;
        objectSize   = numel(pixels);
        if objectSize > 5000
            L(pixels) = i;
            %for k = 1:numel(pixels)            
             %   L(ind2sub(CC.ImageSize,pixels(k))) = i;
            %end
            
            objectCenter = p(i, :);
            coinList.addObject(objectSize,objectCenter);
        end
    end
    %coinList.showHist();

end
