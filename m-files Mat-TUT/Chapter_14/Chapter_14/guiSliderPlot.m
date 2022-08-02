function guiSliderPlot
% guiSliderPlot has a slider
% It plots sin(x) from 0 to the value of the slider
% Format: guisliderPlot
 
f = figure('Visible', 'off','Position',...
   [360, 500, 400,400]);
 
% Minimum and maximum values for slider
minval = 0;
maxval = 4*pi;
 
% Create the slider object
slhan = uicontrol('Style','slider','Position',[140,280,100,50], ...
    'Min', minval, 'Max', maxval,'Callback', @callbackfn);
% Text boxes to show the min and max values and slider value
hmintext = uicontrol('Style','text','BackgroundColor', 'white', ...
    'Position', [90, 285, 40,15], 'String', num2str(minval));
hmaxtext = uicontrol('Style','text', 'BackgroundColor', 'white',...
    'Position', [250, 285, 40,15], 'String', num2str(maxval));
hsttext = uicontrol('Style','text','BackgroundColor', 'white',...
    'Position', [170,340,40,15],'Visible','off');
% Create axes handle for plot
axhan = axes('Units','Pixels','Position', [100,50,200,200]);
 
set(f,'Name','Slider Example with sin plot')
movegui(f,'center')
set([slhan,hmintext,hmaxtext,hsttext,axhan], 'Units','normalized')
set(f,'Visible','on');
 
% Call back function displays the current slider value & plots sin
   function callbackfn(source,eventdata)
       % callbackfn is called by the 'Callback' property
       % in the slider
       num=get(slhan, 'Value');
       set(hsttext,'Visible','on','String',num2str(num))
       x = 0:num/50:num;
       y = sin(x);
       plot(x,y);       
    end
end
