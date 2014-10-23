function B = backgroundSubtraction(I, t)
    % Set a defaultparameter for t
    if nargin < 2, t = 0.15; end;
  
    % Calculate the binary segmentation
    B = zeros(size(I,1),size(I,2)); %this is a dummy
end