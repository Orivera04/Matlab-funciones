function radio2 ( )
h=gcf;  % Figura corrente
obj=findobj(h,'Tag','radiobutton2'); 
value=get(obj,'Value'); % Obtem valor indicado
display(value)
