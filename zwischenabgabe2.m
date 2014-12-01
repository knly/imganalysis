clear;


%% Training

% Get training image files
trainImageList = getImageList('training');

% Process training images to produce training dataset
processImages(trainImageList, 'training', false, false)


%% Test
 
% Get test image files
testImageList = getImageList('test');

% Process test images to find coins
processImages(testImageList, 'test', false, false)

