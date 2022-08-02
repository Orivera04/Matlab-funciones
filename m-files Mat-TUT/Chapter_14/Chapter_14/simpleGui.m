function simpleGui
% simpleGui creates a simple GUI with just a static text box
% Format: simpleGui or simpleGui()
 
% Create the GUI but make it invisible for now while 
%  it is being initialized
f = figure('Visible', 'off','color','white','Position',...
    [300, 400, 450,250]);
htext = uicontrol('Style','text','Position', ...
    [200,50, 100, 25], 'String','My First GUI string');
 
% Put a name on it and move to the center of the screen
set(f,'Name','Simple GUI')
movegui(f,'center')
 
% Now the GUI is made visible
set(f,'Visible','on');
end
