Image = imread(fullfile('training','001-6.jpg'));

p = mark(Image);
cropped_image = projectiveCrop(Image, p);

bin_image = backgroundSubtraction(cropped_image, 0.5);

vgl_image = overlay_bitmask(cropped_image, bin_image);
 
imshow(vgl_image);

