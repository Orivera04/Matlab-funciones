% fbungie_calculo :
function fbungie_calculo ( )
% Obtem os valores da tela de interface criada no GUIDE
hf = gcf;
obj  = findobj(hf,'Tag','M');         % Paramentro m
m = str2double(get(obj,'String'));
obj  = findobj(hf,'Tag','K');         % Paramentro K
k = str2double(get(obj,'String'));
obj  = findobj(hf,'Tag','B');         % Paramentro B
b = str2double(get(obj,'String'));
[t,y]=ode45('fbungie',[0 1000],[1;0],[],m,k,b); 
ha  = findobj(hf,'Tag','Axes1');  
axes(ha);
plot(t,-y(:,1))
title('Deslocamento');
ha  = findobj(hf,'Tag','Axes2');    
axes(ha);
plot(t,y(:,2),'g');
title('Velocidade');
ha  = findobj(hf,'Tag','Axes1');  