Image = imread(fullfile('training', '001-7.jpg'));

p = mark(Image);

P0 = [1, 2000; 1450, 2000; 1450, 1; 1, 1];


trans_im = projectiveCrop(Image, p, P0);



imshow(trans_im);


%Position der Kreuze:
%211,320;  651,77
%cp2tform
