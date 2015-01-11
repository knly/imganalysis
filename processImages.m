function processImages(imageList, dataPath, classificator, showResults)
    [~, ~, ~] = mkdir([dataPath '-crop']);
    [~, ~, ~] = mkdir([dataPath '-list']);
    [~, ~, ~] = mkdir([dataPath '-result']);

    % Iterate images
    for i=1:numel(imageList)
        tProcessing = tic;
        fprintf('\n')
        svenPrint(sprintf('- Processing image %s...\n', imageList{i}), '_blue');
        landscape = 0;
        
        % Find marks & Crop
        fileCROP = strrep(imageList{i}, dataPath, [dataPath '-crop']);
        if(exist(fileCROP,'file')==0)
            tCrop = tic;
            svenPrint('Finding marks and cropping...\n');
            I_original  = imread(imageList{i});
            
            if sum([strfind(imageList{i}, 't01-3') strfind(imageList{i}, 't03-3') strfind(imageList{i}, 't04-3') strfind(imageList{i}, 't06-4')])>0
                landscape = 1;
            end
                
            p  = find_marks(I_original, landscape);
            if p == 0
               svenPrint(sprintf('Error finding marks on image %s\n', imageList{i}), '_red');
               continue; 
            end
            
            I = projectiveCrop(I_original, p);
            imwrite(I, fileCROP); 
            checkmark();
            svenPrint(sprintf('Done cropping image in %s.\n', toc(tCrop)), [0,0,0]);
            
        else
            I = imread(fileCROP);
            checkmark();
            svenPrint(sprintf('Already cropped image.\n'), [0,0,0]);
        end
        
        % Find Coins and save to list
        [~,filename,~] = fileparts(imageList{i});
        fileLIST = fullfile([dataPath '-list'], [filename '.mat']);
        if(exist(fileLIST,'file')==0||false) % WARNING: Always enabled for testing when set to ||true
            tFind = tic;
            svenPrint('Finding Coins...\n');
            coinList = findCoins(I);
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
                    v = classificator.valueForCoin(coinList.List(n));
                    coinList.setObjectValue(n,v);
                end
            end;
            
            save(fileLIST,'coinList');
            checkmark();
            svenPrint(sprintf('Done finding coins in %s. \n', toc(tFind)), [0,0,0]);
        else
            load(fileLIST, 'coinList');
            checkmark();
            svenPrint(sprintf('Already found coins. \n'), [0,0,0]);
        end
        
        svenPrint(sprintf('Processing took %s.\n', toc(tProcessing))); 
       
        % Show results
        if showResults
            scrsz = get(0,'ScreenSize');
            f = figure('Position',[1 1 scrsz(3) scrsz(4)]);
        else
            f = figure('Visible', 'off');
        end

        %subplot(1,2,1);

        if classificator~=false
            load(['test-list-confusiondata' filesep filename]);
            confusionmat(filename);
        else
            confData = false;
        end

        coinList.show(I, false, confData);

        %subplot(1,2,2);
        %coinList.show(B, classificator);

        print(f, '-dpng', [dataPath '-result' filesep filename])

        if showResults
            k = waitforbuttonpress();
            close;
        end
    end

end