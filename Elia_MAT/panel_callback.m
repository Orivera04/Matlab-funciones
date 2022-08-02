function panel_callback( )
h=gcf;  % Figura corrente
obj=findobj(h,'Tag','inicio'); % Objeto inicio
v_inicio=str2num(get(obj,'String'));
obj=findobj(h,'Tag','final'); % Objeto final
v_final=str2num(get(obj,'String'));
obj=findobj(h,'Tag','amplitude'); % Objeto inicio
v_amplitude=str2num(get(obj,'String'));
obj=findobj(h,'Tag','frequencia'); % Objeto final
v_frequencia=str2num(get(obj,'String'));
% Grafico
x=linspace(v_inicio,v_final,200);
y=v_amplitude*(sin(5*x*v_frequencia)+3*cos(x*v_frequencia));
plot(x,y)
