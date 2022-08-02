% Rangescale is here & not in the Callback so it is checked each time the color is changed.
% Rangescale does not have an automated Round
% Even though unrounded numbers give an error, it still calculates a unique color scale giving you more control over the color scale.

randescaleerror=0;
try
    rangescale = eval(get(findobj('Tag','rangescaleinput'),'string'));
    set(findobj('Tag','rangescaleinput'),'string', rangescale);
catch
    set(findobj('Tag','rangescaleinput'),'string', 256);
    rangescale = eval(get(findobj('Tag','rangescaleinput'),'string'));
    randescaleerror=1;
end

if rangescale>=1 & rangescale<=256;
else
    set(findobj('Tag','rangescaleinput'), 'String', 256);
    rangescale = eval(get(findobj('Tag','rangescaleinput'),'string'));
    randescaleerror=1;
end;

if colorchosen==1; colordisplay=jet(rangescale);
elseif colorchosen==2; colordisplay=flipud(gray(rangescale));
end;
if colorreverse==1; colordisplay=flipdim(colordisplay,1); end;

if randescaleerror==1;
    if exist('a'); opening_iteration; CA_Display; end;
    errordlg('Input must be between 0 and 256','Error');
end;
