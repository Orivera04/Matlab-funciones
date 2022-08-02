function popup_create( )
h=gcf;  % Figura corrente
obj=findobj(h,'Tag','popupmenu1'); % Objeto popupmenu1
cores= { 'default'; 'autumn'; 'bone'; ...
    'cool'; 'hot'; 'spring'; 'summer';'winter' };
set(obj,'String',cores)
    