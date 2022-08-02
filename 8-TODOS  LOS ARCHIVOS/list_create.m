function list_create( )
h=gcf;  % Figura corrente
obj=findobj(h,'Tag','listbox1'); % Objeto listbox1
sh= { 'FLAT'; 'FACETED'; 'INTERP'};
set(obj,'String',sh)
