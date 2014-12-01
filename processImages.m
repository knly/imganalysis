function processImages(imageList, dataPath, classificator, showResults)
    [~, ~, ~] = mkdir([dataPath '-crop']);
    [~, ~, ~] = mkdir([dataPath '-bg']);
    [~, ~, ~] = mkdir([dataPath '-list']);
    % Iterate images
    for i=1:numel(imageList)
        tProcessing = tic;
        cprintf('_blue', '\n- Processing image %s...\n', imageList{i});
        
        % Find marks & Crop
        fileCROP = strrep(imageList{i}, dataPath, [dataPath '-crop']);
        if(exist(fileCROP,'file')==0)
            tCrop = tic;
            fprintf('Finding marks and cropping...\n');
            I1  = imread(imageList{i});
            
            p  = find_marks(I1);
            if p == 0
               cprintf('_red', 'Error finding marks on image %s\n', imageList{i});
               continue; 
            end
            
            I = projectiveCrop(I1, p);
            imwrite(I, fileCROP); 
            cprintf([.2,.65,.4], '%c ', char(10004));
            cprintf('text', 'Done cropping image in %s.', toc(tCrop));
        else
            I = imread(fileCROP);
            cprintf([.2,.65,.4], '%c ', char(10004));
            cprintf('text', 'Already cropped image.\n');
        end
        
        % Background subtraction
        fileBG   = strrep(imageList{i}, dataPath, [dataPath '-bg']);
        if (exist(fileBG,'file')==0)
            tBG = tic;
            fprintf('Finding background...\n');
            B  = backgroundSubtraction(I); 
            imwrite(B, fileBG);
            cprintf([.2,.65,.4], '%c ', char(10004));
            cprintf('text', 'Done finding background in %s.\n', toc(tBG));
        else
            B = imread(fileBG);
            cprintf([.2,.65,.4], '%c ', char(10004));
            cprintf('text', 'Already found background.\n');
        end

        % Find Coins and save to list
        [~,filename,~] = fileparts(imageList{i});
        fileLIST = fullfile([dataPath '-list'], [filename '.mat']);
        if(exist(fileLIST,'file')==0)
            tFind = tic;
            fprintf('Finding Coins...\n');
            [coinList, L] = findCoins(B);
            % Get coin value from file name
            if (classificator==false)
                if(numel(strfind(filename,'001'))>0), value = 0.01; end;
                if(numel(strfind(filename,'002'))>0), value = 0.02; end;
                if(numel(strfind(filename,'005'))>0), value = 0.05; end;
                if(numel(strfind(filename,'010'))>0), value = 0.10; end;
                if(numel(strfind(filename,'020'))>0), value = 0.20; end;
                if(numel(strfind(filename,'050'))>0), value = 0.50; end;
                if(numel(strfind(filename,'100'))>0), value = 1.00; end;
                if(numel(strfind(filename,'200'))>0), value = 2.00; end;
            end
            
            for n=1:coinList.Size,
                if (classificator==false)
                    coinList.setObjectValue(n,value);
                else
                    size = classificator.valueForCoinSize(coinList.List(n).size)
                    coinList.setObjectValue(n,size);
                end    
            end;
            
            save(fileLIST,'coinList');
            
            cprintf([.2,.65,.4], '%c ', char(10004));
            cprintf('text', 'Done finding coins in %s.\n', toc(tFind));
        else
            load(fileLIST, 'coinList');
            cprintf([.2,.65,.4], '%c ', char(10004));
            cprintf('text', 'Already found coins.\n');
        end
        
        fprintf('Processing took %s.\n', toc(tProcessing)); 
       
        % Show results
        if (showResults)
            scrsz = get(0,'ScreenSize');
            figure('Position',[1 1 scrsz(3) scrsz(4)])
            subplot(1,2,1);
            coinList.show(I);
            subplot(1,2,2);
            coinList.show(B);
            k = waitforbuttonpress();
            close;
        end
    end

end