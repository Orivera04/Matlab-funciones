function guiWithTwoPushbuttons
% guiWithTwoPushbuttons has two pushbuttons, each
%   of which has a separate callback function
% Format: guiWithTwoPushbuttons
 
% Create the GUI but make it invisible for now while 
%  it is being initialized
f = figure('Visible', 'off','color','white',...
    'Position', [360, 500, 400,400]);
set(f,'Name','GUI with 2 pushbuttons')
movegui(f,'center')
 
% Create a pushbutton that says "Push me!!"
hbutton1 = uicontrol('Style','pushbutton','String',...
    'Push me!!', 'Position',[150,275,100,50], ...
    'Callback',@callbackfn1);
 
% Create a pushbutton that says "No, Push me!!"
hbutton2 = uicontrol('Style','pushbutton','String',...
    'No, Push me!!', 'Position',[150,175,100,50], ...
    'Callback',@callbackfn2);
% Now the GUI is made visible
set(f,'Visible','on');
 
    % Call back function for first button
    function callbackfn1(source,eventdata)
       % callbackfn is called by the 'Callback' property
       % in the first pushbutton

        set([hbutton1 hbutton2],'Visible','off');
        hstr = uicontrol('Style','text',...
            'BackgroundColor', 'white', 'Position',...
            [150,200,100,100], 'String','!!!!!', ...
            'ForegroundColor','Red','FontSize',30);
        set(hstr,'Visible','on')
    end
 
    % Call back function for second button
    function callbackfn2(source,eventdata)
       % callbackfn is called by the 'Callback' property
       % in the second pushbutton

        set([hbutton1 hbutton2],'Visible','off');
        hstr = uicontrol('Style','text',...
            'BackgroundColor','white', ...
            'Position',[150,200,100,100],...
            'String','*****', ...
            'ForegroundColor','Blue','FontSize',30);
        set(hstr,'Visible','on')
    end
 
end
