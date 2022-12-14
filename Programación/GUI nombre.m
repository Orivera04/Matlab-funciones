%foto=imread('vortice.jpg');
vent=figure(...
    'Units','pixels',...
    'Position',[100,100,600,400],...
    'Menubar','none',...
    'Color',[0.5 .5 .5],...
    'Name','VENTANA DE PRUEBA',...
    'NumberTitle','off',...
    'Resize','off',...
    'WindowStyle','normal'...
)
%image(foto); 
grid off
axis off
b=uicontrol(...
    'Position',[100 100 100 50],...
    'Style','listbox',...
    'String','Rommel|Jose|Briones|Mena'...
    )
f = uimenu('Label','Workspace');
    uimenu(f,'Label','New Figure','Callback','figure');
    uimenu(f,'Label','Save','Callback','save');
    uimenu(f,'Label','Quit','Callback','close(vent)',...
           'Separator','on','Accelerator','Q');