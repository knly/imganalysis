function p = mark(I)
    % display image I in figure
    imshow(I);
    
    % get the position of the 4 markers
    p = ginput(4);
    
    % close the figure
    close;
end