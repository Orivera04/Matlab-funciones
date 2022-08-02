function radio1 ( )
h=gcf;  % Figura corrente
obj=findobj(h,'Tag','radiobutton1'); 
value=get(obj,'Value'); % Obtem valor indicado
display(value)
