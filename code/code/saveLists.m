function saveLists(listpath, imageList)
    for i=1:numel(imageList)
        tic;
        
        fileBG = strrep(imageList{i}, 'training', 'training-bg');
        fileBG = strrep(fileBG, 'test', 'test-BG'); 
        fileCROP = strrep(imageList{i}, 'training', 'training-crop');
        fileCROP = strrep(fileCROP, 'test', 'test-crop');
        sep = strfind(imageList{i}, filesep);
        dataname = imageList{i}(sep(numel(sep)):numel(imageList{i})-4);
        fileLIST = [listpath, dataname, 'mat'];
        if(numel(strfind(dataname,'001'))>0), value = 0.01; end;
        if(numel(strfind(dataname,'002'))>0), value = 0.02; end;
        if(numel(strfind(dataname,'005'))>0), value = 0.05; end;
        if(numel(strfind(dataname,'010'))>0), value = 0.10; end;
        if(numel(strfind(dataname,'020'))>0), value = 0.20; end;
        if(numel(strfind(dataname,'050'))>0), value = 0.50; end;
        if(numel(strfind(dataname,'100'))>0), value = 1.00; end;
        if(numel(strfind(dataname,'200'))>0), value = 2.00; end;
        
        
        if(exist(fileLIST,'file')==0)
            B = imread(fileBG);
            I = imread(fileCROP);
            [coinList, L] = findCoins(B);
            for n=1:coinList.Size, 
                coinList.setObjectValue(n,value); 
                coinList.setObjectFeature(n,[]);        
            end;
            
            scrsz = get(0,'ScreenSize');
            figure('Position',[1 scrsz(4) scrsz(3) scrsz(4)])
            subplot(1,2,1);
            coinList.show(I);
            subplot(1,2,2);
            coinList.show(B);
            %k = waitforbuttonpress();
            close;
            save(fileLIST,'coinList');
        end
        toc;
    end
end