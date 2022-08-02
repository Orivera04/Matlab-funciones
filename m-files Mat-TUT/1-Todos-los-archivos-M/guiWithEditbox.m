function guiWithEditbox
% guiWithEditbox has an editable text box
%  and a callback function that prints the user's
%  string in red
% Format: guiWithEditbox or guiWithEditbox()
 
% Create the GUI but make it invisible for now 
f = figure('Visible', 'off','color','white','Position',...
    [360, 500, 800,600]);
% Put a name on it and move it to the center of the screen
set(f,'Name','GUI with editable text')
movegui(f,'center')
% Create two objects: a box where the user can type and 
%  edit a string and also a text title for the edit box
hsttext = uicontrol('Style','text',...
    'BackgroundColor','white',...
    'Position',[100,425,400, 55],...
    'String','Enter your string here');
huitext = uicontrol('Style','edit',...
    'Position',[100,400,400,40], ...
    'Callback',@callbackfn);
 
% Now the GUI is made visible
set(f,'Visible','on');
 
    % Call back function
    function callbackfn(source,eventdata)
        % callbackfn is called by the 'Callback' property
        % in the editable text box
        set([hsttext huitext],'Visible','off');
        % Get the string that the user entered and print 
        %   it in big red letters
        printstr = get(huitext,'String');
        hstr = uicontrol('Style','text',...
            'BackgroundColor','white',...
            'Position',[100,400,400,55],...
		  'String',printstr,...
            'ForegroundColor','Red','FontSize',30);
        set(hstr,'Visible','on')
    end
end
