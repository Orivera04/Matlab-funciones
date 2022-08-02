function radio_callback ( )
h=gcf;  % Figura corrente
obj=findobj(h,'Tag','radiobutton1'); 
value=get(obj,'Value'); % Obtem valor indicado
if value == 1
    msgbox('ON')
else
    msgbox('OFF')
end
