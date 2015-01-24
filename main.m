clear;

%%%
% In processImages, 3 folders are created with the given prefix 'training'
% or 'test' and the following suffixes:
% - 'crop' for the processed images,
% - 'list' for the coin data found in them, and
% - 'result' for images showing the coins overlaid with
%   their computed value
%%%

%%%
% The confusion matrix can be computed from the saved data in 'test-list'
% by running:
% confusionAll()
%%%


%% Training
fprintf('\n')
svenPrint('# Training\n')
fprintf('\n')

% Get training image files
trainImageList = getImageList('training');

% Process training images to produce training dataset
processImages(trainImageList, 'training', false, false)


%% Evaluate Training Data
fprintf('\n')
fprintf('\n')
svenPrint('# Evaluate Training Data\n')
fprintf('\n')

classificator = Classificator();

coinListFiles = dir(['training-list' filesep '*.mat']);
coinListFiles = cellfun(@(n) fullfile('training-list',n), {coinListFiles.name}', 'UniformOutput',false);
for i=1:numel(coinListFiles)
    load(coinListFiles{i},'coinList');
    classificator.learnFromCoinList(coinList);
end


%% Test
fprintf('\n')
fprintf('\n')
svenPrint('# Test\n')
fprintf('\n')

% Get test image files
testImageList = getImageList('test');

% Process test images to find coins
processImages(testImageList, 'test', classificator, true) % change last boolean to false to not show the result after every step
