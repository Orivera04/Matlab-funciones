function guiSlider
% guiSlider is a GUI with a slider
 
f = figure('Visible', 'off','color','white','Position',...
   [360, 500, 300,300]);
 
% Minimum and maximum values for slider
minval = 0;
maxval = 5;
 
% Create the slider object
slhan = uicontrol('Style','slider','Position',[80,170,100, 50], ...
    'Min', minval, 'Max', maxval,'Callback', @callbackfn);
% Text boxes to show the minimum and maximum values
hmintext = uicontrol('Style','text','BackgroundColor','white', ...
    'Position', [40, 175, 30,30], 'String', num2str(minval));
hmaxtext = uicontrol('Style', 'text','BackgroundColor','white',...
    'Position', [190, 175, 30,30], 'String', num2str(maxval));
% Text box to show the current value (off for now)
hsttext = uicontrol('Style','text','BackgroundColor','white',...
    'Position',[120,100,40,40],'Visible', 'off');
 
set(f,'Name','Slider Example')
movegui(f,'center')
set(f,'Visible','on');
 
% Call back function displays the current slider value
   function callbackfn(source,eventdata)
       % callbackfn is called by the 'Callback' property
       % in the slider

       num=get(slhan, 'Value');
       set(hsttext,'Visible','on','String',num2str(num))
    end
end
