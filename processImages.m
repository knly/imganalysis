function processImages(imageList, dataPath, classificator, showResults)
    [~, ~, ~] = mkdir([dataPath '-crop']);
    [~, ~, ~] = mkdir([dataPath '-bg']);
    [~, ~, ~] = mkdir([dataPath '-list']);
    colorMode = true;
    % Iterate images
    for i=1:numel(imageList)
        tProcessing = tic;
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
        %cprintf('_blue', '\n- Processing image %s...\n', imageList{i});
        svenPrint('_blue', sprintf('\n- Processing image %s...\n', imageList{i}), colorMode);
        
        % Find marks & Crop
        fileCROP = strrep(imageList{i}, dataPath, [dataPath '-crop']);
        if(exist(fileCROP,'file')==0)
            tCrop = tic;
            fprintf('Finding marks and cropping...\n');
            I1  = imread(imageList{i});
            
            p  = find_marks(I1);
            if p == 0
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
               %cprintf('_red', 'Error finding marks on image %s\n', imageList{i});
               svenPrint('_red', sprintf('Error finding marks on image %s\n', imageList{i}), colorMode);
               continue; 
            end
            
            I = projectiveCrop(I1, p);
            imwrite(I, fileCROP); 
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %cprintf([.2,.65,.4], '%c ', char(10004));
            %cprintf('text', 'Done cropping image in %s.\n', toc(tCrop));
            checkmark(colorMode);
            svenPrint([0,0,0], sprintf('Done cropping image in %s.\n', toc(tCrop)), colorMode);
            
        else
            I = imread(fileCROP);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %cprintf([.2,.65,.4], '%c ', char(10004));
            %cprintf('text', 'Already cropped image.\n');
            checkmark(colorMode);
            svenPrint([0,0,0], sprintf('Already cropped image.\n'), colorMode);
        end
        
        % Background subtraction
        fileBG   = strrep(imageList{i}, dataPath, [dataPath '-bg']);
        if (exist(fileBG,'file')==0)
            tBG = tic;
            fprintf('Finding background...\n');
            B  = backgroundSubtraction(I); 
            imwrite(B, fileBG);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %cprintf([.2,.65,.4], '%c ', char(10004));
            %cprintf('text', 'Done finding background in %s. \n', toc(tBG));
            checkmark(colorMode);
            svenPrint([0,0,0], sprintf('Done finding background in %s. \n', toc(tBG)), colorMode);
        else
            B = imread(fileBG);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %cprintf([.2,.65,.4], '%c ', char(10004));
            %cprintf('text', 'Already found background.\n');
            checkmark(colorMode);
            svenPrint([0,0,0], sprintf('Already found background.\n'), colorMode);
        end

        % Find Coins and save to list
        [~,filename,~] = fileparts(imageList{i});
        fileLIST = fullfile([dataPath '-list'], [filename '.mat']);
        if(exist(fileLIST,'file')==0||true)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
                    size = classificator.valueForCoinSize(coinList.List(n).size);
                    coinList.setObjectValue(n,size);
                end    
            end;
            
            save(fileLIST,'coinList');
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %cprintf([.2,.65,.4], '%c ', char(10004));
            %cprintf('text', 'Done finding coins in %s. \n', toc(tFind));
            checkmark(colorMode);
            svenPrint([0,0,0], sprintf('Done finding coins in %s. \n', toc(tFind)), colorMode);
        else
            load(fileLIST, 'coinList');
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %cprintf([.2,.65,.4], '%c ', char(10004));
            %cprintf('text', 'Already found coins. \n');
            checkmark(colorMode);
            svenPrint([0,0,0], sprintf('Already found coins. \n'), colorMode);
        end
        
        fprintf('Processing took %s.\n', toc(tProcessing)); 
       
        % Show results
        if (showResults)
            scrsz = get(0,'ScreenSize');
            figure('Position',[1 1 scrsz(3) scrsz(4)])
            subplot(1,2,1);
            coinList.show(I, false);
            subplot(1,2,2);
            coinList.show(B, classificator);
            k = waitforbuttonpress();
            close;
        end
    end

end