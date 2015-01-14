function mat = confusionAll( )
% Sums up all Confusionmats
    
    mat = zeros(9);
    
    coinListFiles = dir(['test-list-confusiondata' filesep '*.mat']);
    coinListFiles = {coinListFiles.name}';
    %coinListFiles = cellfun(@(n) fullfile('test-list',n), {coinListFiles.name}', 'UniformOutput',false);
    %coinListFiles = strrep(coinListFiles, 'test-list\', '');
    
    [numFiles, ~] = size(coinListFiles);
    
    for i = 1:numFiles
        mat = mat + confusionmat(coinListFiles{i});
    end
    
    mat(1, :) = mat(1, :)/(numFiles);
    mat(:, 1) = mat(:, 1)/(numFiles);
    
    totalAmount = sum(sum(mat(2:9, 2:9)));
    svenPrint(sprintf('Total amount: %s\n', num2str(totalAmount)));
    wrongAmount = sum(sum(mat(2:9, 2:9)-diag(diag(mat(2:9, 2:9)))));    
    svenPrint(sprintf('Amount wrong coins: %s\n', num2str(wrongAmount)));
    rate = 100-wrongAmount/totalAmount*100;
    svenPrint(sprintf('Success rate: %s', num2str(rate)));
end

