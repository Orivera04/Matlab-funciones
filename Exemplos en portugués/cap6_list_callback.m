function cap6_list_callback( )
h=gcf;  % Figura corrente
obj=findobj(h,'Tag','popupmenu1'); % Objeto popupmenu1
cores=get(obj, 'String');
indcor=get(obj, 'Value');
obj=findobj(h,'Tag','listbox1'); % Objeto listbox1
sh=get(obj, 'String');
indsh=get(obj, 'Value');
figure;
surf(peaks)
colormap(cores{indcor});
shading(sh{indsh});
