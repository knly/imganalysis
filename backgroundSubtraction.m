function B = backgroundSubtraction(I, t)
    % Set a defaultparameter for t
    if nargin < 2, t = 0.15; end;
    
    %Convert Image rgb->HSV
    hsv_image = rgb2hsv(I);
    
    %Saturation is best used to view only foreground, Saturation is channel
    %2. Create a binary mask by using a threshold on the hsv image:
    binary_mask = hsv_image(:, :, 2) > t;
    
    %If there are any holes in, close them with dilate, then erode by the
    %same amount to get back to the original size
    
    % SE: Erode/Dilate parameter; Check for a disk shaped region of radius
    % 20, N=6 (Some algorhythm parameter)
    SE = strel('disk', 5, 6);
    binary_mask = imdilate(binary_mask, SE);
    binary_mask = imerode(binary_mask, SE);
    
    B = binary_mask;
    
   
end