function guiMultiplierIf
% guiMultiplierIf has 2 edit boxes for numbers and 
%   multiplies them
% Format: guiMultiplierIf or guiMultiplierIf()

f = figure('Visible', 'off','color','white','Position',...
   [360, 500, 300,300]);
firstnum=0;
secondnum=0;
product=0;
 
hsttext = uicontrol('Style','text','BackgroundColor','white',...
    'Position',[120,150,40,40],'String','X');
hsttext2 = uicontrol('Style','text','BackgroundColor','white',...
    'Position',[200,150,40,40],'String','=');
hsttext3 = uicontrol('Style','text','BackgroundColor','white',...
    'Position',[240,150,40,40],'Visible','off');
huitext = uicontrol('Style','edit','Position',[80,170,40,40],...
    'String',num2str(firstnum));
huitext2 = uicontrol('Style','edit','Position',[160,170,40,40],...
    'String',num2str(secondnum),...
    'Callback',@callbackfn);
 
set(f,'Name','GUI Multiplier')
movegui(f,'center')
 
hbutton = uicontrol('Style','pushbutton',...
'String','Multiply me!',...
   	'Position',[100,50,100,50], 'Callback',@callbackfn);
 
 
set(f,'Visible','on');
 
   function callbackfn(source,eventdata)
        % callbackfn is called by the 'Callback' property
        % in either the second edit box or the pushbutton

       firstnum=str2num(get(huitext,'String'));
       secondnum=str2num(get(huitext2,'String'));
       set(hsttext3,'Visible','on',...
            'String',num2str(firstnum*secondnum))
       if source == hbutton
            set(hsttext3,'ForegroundColor','g')
       else
            set(hsttext3,'ForegroundColor','r')
       end
    end
end
