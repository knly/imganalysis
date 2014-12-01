clear;
getImageLists;

for i=1:numel(trainImageList) 
    fileBG   = strrep(trainImageList{i}, 'training', 'training-bg');
    fileBG   = strrep(fileBG, 'test', 'test-BG'); 
    fileCROP = strrep(trainImageList{i}, 'training', 'training-crop');
    fileCROP = strrep(fileCROP, 'test', 'test-crop');
    if(exist(fileCROP,'file')==0||exist(fileBG,'file')==0)
        t = tic;
        fprintf('Processing image %s...\n', trainImageList{i});
        I  = imread(trainImageList{i});
        p  = find_marks(I);
        I2 = projectiveCrop(I,p);
        B  = backgroundSubtraction(I2); 
        imwrite(I2, fileCROP); 
        imwrite(B, fileBG);
        fprintf('Finished processing in %s', toc(t));
   % else
   %     I2 = imread(fileCROP);
   %     B  = imread(fileBG);
    else
        fprintf('Already processed image %s.\n', trainImageList{i})
    end
end

saveLists(['.' filesep 'list' filesep],trainImageList);

