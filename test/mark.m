function mat_out = mark( Image_in )
% Shows an Image and lets you define 4 Positions
%   
    imshow(Image_in);
    p = ginput(4);
    
    % Mitteln 1->2 = 3->4 = (1->2 + 3->4) / 2, (2->3 + 4->1) / 2:
    
    %p_mean = p;
    %length1 = (sqrt((p(1,1)-p(2,1))^2+(p(1,2)-p(2,2))^2)+sqrt((p(3,1)-p(4,1))^2+(p(3,2)-p(4,2))^2))/2;
    %length2 = (sqrt((p(2,1)-p(3,1))^2+(p(2,2)-p(3,2))^2)+sqrt((p(4,1)-p(1,1))^2+(p(4,2)-p(1,2))^2))/2;
    %length1
    %length2
    mat_out = p;
    

end

