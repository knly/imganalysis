clear;


%% Training

% Get training image files
trainImageList = getImageList('training');

% Process training images to produce training dataset
processImages(trainImageList, 'training', false, false)


%% Evaluate Training Data

classificator = Classificator();

coinListFiles = dir(['training-list' filesep '*.mat']);
coinListFiles = cellfun(@(n) fullfile('training-list',n), {coinListFiles.name}', 'UniformOutput',false);
for i=1:numel(coinListFiles)
    load(coinListFiles{i},'coinList');
    classificator.learnFromCoinList(coinList);
end


%% Test
 
% Get test image files
testImageList = getImageList('test');

% Process test images to find coins
processImages(testImageList, 'test', classificator, true)
