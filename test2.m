Image = imread(fullfile('training', '001-7.jpg'));

p = mark(Image);

P0 = [1, 2000; 1450, 2000; 1450, 1; 1, 1];

transform = fitgeotrans(p, P0, 'Affine');


imgref = imref2d([2000, 1450]);
trans_im = imwarp(Image, transform, 'OutputView', imgref);
trans_im = imrotate(trans_im, 90);



imshow(trans_im);


%Position der Kreuze:
%211,320;  651,77
%cp2tform
