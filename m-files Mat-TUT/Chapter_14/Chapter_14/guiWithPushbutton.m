function guiWithPushbutton
% guiWithPushbutton has an editable text box and a pushbutton
% Format: guiWithPushbutton or guiWithPushbutton()
 
% Create the GUI but make it invisible for now while 
%  it is being initialized
f = figure('Visible', 'off','color','white','Position',...
    [360, 500, 800,600]);
hsttext = uicontrol('Style','text','BackgroundColor','white',...
    'Position',[100,425,400, 55],...
    'String','Enter your string here');
huitext = uicontrol('Style','edit','Position',[100,400,400,40]);
set(f,'Name','GUI with pushbutton')
movegui(f,'center')
 
% Create a pushbutton that says "Push me!!"
hbutton = uicontrol('Style','pushbutton','String',...
    'Push me!!', 'Position',[600,50,150,50], ...
    'Callback',@callbackfn);
 
% Now the GUI is made visible
set(f,'Visible','on');
 
% Call back function
    function callbackfn(source,eventdata)
        % callbackfn is called by the 'Callback' property
        % in the pushbutton
        set([hsttext huitext hbutton],'Visible','off');
        printstr = get(huitext,'String');
        hstr = uicontrol('Style','text','BackgroundColor',...
            'white', 'Position',[100,400,400,55],...
            'String',printstr, ...
            'ForegroundColor','Red','FontSize',30);
        set(hstr,'Visible','on')
    end
end
