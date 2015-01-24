function mat = confusionmat( name )

    % Lade confdaten in vektor
    % Lade zugehörige test-list daten
    % Erstelle Matrix
    
    % Load confusiondata for specified image, var name is confData
    load(['test-list-confusiondata' filesep name]);
    
    % Load test-list data, var name will be tlData
    load(['test-list' filesep name]);
    % Get coinvalues, convert them to a vector
    nvar = struct2cell(coinList.List);
    tlData = cell2mat(cat(1, nvar(6, :)));
    
    confmat = zeros(9,9);
    confmat(1, 2:9) = [0.01,0.02,0.05,0.1,0.2,0.5,1,2];
    confmat(2:9, 1) = confmat(1, 2:9);
        
    % # iterations
    [~, iterations] = size(confData);
    
    [~, size2] = size(tlData);
    
    if size2 ~= iterations
       svenPrint(['Wrong amount of coins found in ' name '\n']);
       mat = zeros(9,9);
       mat(1, 2:9) = [0.01,0.02,0.05,0.1,0.2,0.5,1,2];
       mat(2:9, 1) = mat(1, 2:9);
       return
    end
    
    for i = 1:iterations
    
        currenttl = tlData(i);
        currentconf = confData(i);
        % get index positions:
        index_j = find(confmat(1, :)==currenttl);
        index_i = find(confmat(1, :)==currentconf);
        
        % increment
        confmat(index_i, index_j) = confmat(index_i, index_j) + 1;
    end
    
    mat = confmat;
    % Confmat liest sich: 'Zeile' wurde mit 'Spalte' verwechselt
    
end

