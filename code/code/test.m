Image = imread(fullfile('training','001-2.jpg'));




p = find_marks(Image);
cropped_image = projectiveCrop(Image, p);

imshow(cropped_image);

%filelist = dir(['training' filesep '*.jpg']);
%fileNames = {filelist.name}';

%p = find_marks(Image);


%cropped_image = projectiveCrop(Image, p);

%bin_image = backgroundSubtraction(cropped_image, 0.15);

%vgl_image = overlay_bitmask(cropped_image, bin_image);
 
%imshow(vgl_image);



