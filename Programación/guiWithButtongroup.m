function guiWithButtongroup
% guiWithButtongroup has a button group with 2 radio buttons
% Format: guiWithButtongroup
 
% Create the GUI but make it invisible for now while 
%  it is being initialized
f = figure('Visible', 'off','color','white','Position',...
    [360, 500, 400,400]);
 
% Create a button group
grouph = uibuttongroup('Parent',f,'Units','Normalized',...
    'Position',[.2 .5 .4 .4], 'Title','Choose Color',...
    'SelectionChangeFcn',@whattodo);
 
% Put two radio buttons in the group
toph = uicontrol(grouph,'Style','radiobutton',...
    'String','Blue','Units','Normalized',...
    'Position', [.2 .7 .4 .2]);
 
both = uicontrol(grouph, 'Style','radiobutton',...
    'String','Green','Units','Normalized',...
    'Position',[.2 .4 .4 .2]);
 
% Put a static text box to the right
texth = uicontrol('Style','text','Units','Normalized',...
    'Position',[.6 .5 .3 .3],'String','Hello',...
    'Visible','off','BackgroundColor','white');
 
set(grouph,'SelectedObject',[]) % No button selected yet
 
set(f,'Name','GUI with button group')
movegui(f,'center')
 
% Now the GUI is made visible
set(f,'Visible','on');
 
    function whattodo(source, eventdata)
    % whattodo is called by the 'SelectionChangeFcn' property
    % in the button group
    
    which = get(grouph,'SelectedObject');
 
    if which == toph
        set(texth,'ForegroundColor','blue')
    else
        set(texth,'ForegroundColor','green')
    end
 
    set(texth,'Visible','on')
    end
 
end
