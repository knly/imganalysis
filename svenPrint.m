function svenPrint( color, text, colorMode)

    if colorMode
        cprintf(color, text);
    else
        fprintf(text);
    end

end