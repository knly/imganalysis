function imageList = getImageList(dataPath)

    filelist = dir([dataPath filesep '*.jpg']);
    imageList = cellfun(@(n) fullfile(dataPath,n), {filelist.name}', 'UniformOutput',false);
    
end