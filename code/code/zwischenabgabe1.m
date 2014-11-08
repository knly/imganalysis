clear;
getImageLists;

for i=1:numel(trainImageList) 
    fileBG   = strrep(trainImageList{i}, 'training', 'training-bg');
    fileBG   = strrep(fileBG, 'test', 'test-BG'); 
    fileCROP = strrep(trainImageList{i}, 'training', 'training-crop');
    fileCROP = strrep(fileCROP, 'test', 'test-crop');
    if(exist(fileCROP,'file')==0||exist(fileBG,'file')==0)
        I  = imread(trainImageList{i});
        p  = find_marks(I);
        I2 = projectiveCrop(I,p);
        B  = backgroundSubtraction(I2); 
        imwrite(I2, fileCROP); 
        imwrite(B, fileBG);
   % else
   %     I2 = imread(fileCROP);
   %     B  = imread(fileBG);
    end
end

saveLists(['.' filesep 'list' filesep],trainImageList);

