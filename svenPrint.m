function svenPrint(text, color)

    colorMode = true; % Switch off if color doesn't work

    text = ['Sven sagt: ' text];

    if nargin~=2
        color = [0,0,0];
    end
    
    if colorMode
        cprintf(color, text);
    else
        fprintf(text);
    end

end