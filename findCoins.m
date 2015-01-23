function coinList = findCoins(I)
    
    %% Background Subtraction
    I_hsv = rgb2hsv(I);
    I_hue = I_hsv(:,:,1);
    I_sat = I_hsv(:,:,2);
    
    % thresholding..
    B = I_hsv(:,:,2) > 0.08;
    
    % closing holes..
    B = imfill(B,'holes');

    %% Coin detection
    % finding components..
    all_components = regionprops(bwconncomp(B),'Centroid','PixelIdxList','Eccentricity','MinorAxisLength');
    %centers = regionprops(all_components,'Centroid');
    %centers = cat(1, centers.Centroid); % Struct2Mat
    
    % iterating components to build coin list..
    coinList = ObjectList();
    for i=1:numel(all_components)
        if numel(all_components(i).PixelIdxList) < 5000
            continue;
        end
        % separating coins that may stick together..
        individual_components = {};
        if all_components(i).Eccentricity > 0.7
            reduce = strel('disk', 60, 6);
            B_reduced = zeros(size(B));
            B_reduced(all_components(i).PixelIdxList) = 1;
            B_reduced = imerode(B_reduced, reduce);
            separated_components = bwconncomp(B_reduced);
            for j=1:separated_components.NumObjects
                B_individual = zeros(size(B));
                B_individual(cell2mat(separated_components.PixelIdxList(j))) = 1;
                %individual_component_reduced = bwconncomp(B_individual);
                %linear_indices_reduced = cell2mat(individual_component_reduced.PixelIdxList);
                B_individual = imdilate(B_individual, reduce);
                individual_components{j} = regionprops(bwconncomp(B_individual),'Centroid','PixelIdxList','MinorAxisLength');
            end
        else
            individual_components = { all_components(i) };
        end
        
        for k=1:numel(individual_components)
            % computing coin size..
            individual_component = individual_components{k};
            linear_indices = individual_component.PixelIdxList;
            objectSize = numel(linear_indices); % seems to yield better results than 'MinorAxisLength'
            %objectSize = individual_component.MinorAxisLength;

            % filter small objects
            if numel(linear_indices) > 5000
                objectCenter = individual_component.Centroid;

                % compute coin features
                hues = I_hue(linear_indices);
                sats = I_sat(linear_indices);
                hue = mean(hues);
                sat = mean(sats);
                inner_radius = individual_component.MinorAxisLength / 4;
                s = size(B);
                [rr cc] = meshgrid(1:s(2),1:s(1));
                B_inner = sqrt((rr-objectCenter(1)).^2+(cc-objectCenter(2)).^2)<=inner_radius;
                sat_diff = mean(I_sat(B_inner)) / sat;

                coinList.addObject(objectCenter,objectSize,hue,sat,sat_diff);
            end
        end
     
    end

end
