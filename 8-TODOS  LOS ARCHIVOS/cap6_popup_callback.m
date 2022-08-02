function cap6_popup_callback( )
h=gcf;  % Figura corrente
obj=findobj(h,'Tag','popupmenu1'); % Objeto popupmenu1
cores=get(obj, 'String');
indice=get(obj, 'Value');
figure;
surf(peaks)
colormap(cores{indice})
