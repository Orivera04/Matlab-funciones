fun=figure(...
   'position',[200 100 400 400],...
   'color',[0 0 0.5],...
   'numbertitle','off',...
   'name','Funciones definidas por el usuario',...
   'resize','off');
texto1=...
   ['fprintf(''Numero 1 \n'');'];
texto2=...
   ['fprintf(''Numero 2 \n'');'];

%FRAMES************************************************************************************
uicontrol( ...
   'style','frame',...
   'position',[10 10 380 230],...
   'backgroundcolor',[0 0.3 0],...
   'foregroundcolor',[0.7 0.7 0.7]);
uicontrol( ...
   'style','frame',...
   'position',[10 245 200 150],...
   'backgroundcolor',[0 0 0.5],...
   'foregroundcolor',[0.7 0.7 0.7]);
uicontrol( ...
   'style','frame',...
   'position',[220 245 170 150],...
   'backgroundcolor',[0 0 0.6],...
   'foregroundcolor',[0.7 0.7 0.7]);

txtcomandos=uicontrol( ...
   'style','edit',...
   'max',25,...
   'position',[11 246 198 148],...
   'backgroundcolor',[0 0 0],...
   'foregroundcolor',[0 1 1]);

%BOTONES DE OPCION*************************************************************************
uicontrol( ...
   'style','text',...
   'horizontalalignment','left',...
   'position',[90 190 280 30],...
   'backgroundcolor',[0 0.3 0],...
   'foregroundcolor',[0 1 1],...
   'string','N?meros aleatorios uniformes entre 0 y 10.0');

uicontrol( ...
   'style','text',...
   'horizontalalignment','left',...
   'position',[90 150 280 30],...
   'backgroundcolor',[0 0.3 0],...
   'foregroundcolor',[0 1 1],...
   'string','N?meros aleatorios uniformes entre -1 y +1');

uicontrol( ...
   'style','text',...
   'horizontalalignment','left',...
   'position',[90 110 280 30],...
   'backgroundcolor',[0 0.3 0],...
   'foregroundcolor',[0 1 1],...
   'string','N?meros aleatorios uniformes entre -20 y -10');

uicontrol( ...
   'style','text',...
   'horizontalalignment','left',...
   'position',[90 70 280 30],...
   'backgroundcolor',[0 0.3 0],...
   'foregroundcolor',[0 1 1],...
   'string','N?meros aleatorios uniformes entre 4.5 y 5.0');

uicontrol( ...
   'style','text',...
   'position',[90 30 280 30],...
   'horizontalalignment','left',...
   'backgroundcolor',[0 0.3 0],...
   'foregroundcolor',[0 1 1],...
   'string','N?meros aleatorios uniformes entre -pi y pi');

%BOTONES**********************************************************************************
texto1=str2mat(...
   'clc;',...
'alea=(10-1)*rand(10,1)+1;',...
'disp(alea);');
texto2=str2mat(...
   'clc;',...
'alea=(1-(-1))*rand(10,1)-1;',...
'disp(alea);');
texto3=str2mat(...
   'clc;',...
'alea=(-10-(-20))*rand(10,1)-20;',...
'disp(alea);');
texto4=str2mat(...
   'clc;',...
'alea=(5.0-4.5)*rand(10,1)+4.5;',...
'disp(alea);');
texto5=str2mat(...
   'clc;',...
'alea=(pi-(-pi))*rand(10,1)-pi;',...
'disp(alea);');

b1=uicontrol( ...
   'style','pushbutton',...
   'position',[15 200 70 25],...
   'string','VER',...
   'callback','set(txtcomandos,''string'',texto1);');
b2=uicontrol( ...
   'style','pushbutton',...
   'position',[15 160 70 25],...
   'string','VER',...
   'callback','set(txtcomandos,''string'',texto2);');
b3=uicontrol( ...
   'style','pushbutton',...
   'position',[15 120 70 25],...
   'string','VER',...
   'callback','set(txtcomandos,''string'',texto3);');
b4=uicontrol( ...
   'style','pushbutton',...
   'position',[15 80 70 25],...
   'string','VER',...
   'callback','set(txtcomandos,''string'',texto4);');
b5=uicontrol( ...
   'style','pushbutton',...
   'position',[15 40 70 25],...
   'string','VER',...
   'callback','set(txtcomandos,''string'',texto5);');

cmdgenerar=uicontrol( ...
   'style','pushbutton',...
   'position',[240 350 130 30],...
   'backgroundcolor',[0 0.3 0],...
   'foregroundcolor',[0 1 1],...
   'string','GENERAR...',...
   'callback','evaluar(txtcomandos);');
cmdcerrar=uicontrol( ...
   'style','pushbutton',...
   'position',[240 300 130 30],...
   'backgroundcolor',[0 0.3 0],...
   'foregroundcolor',[0 1 1],...
   'string','CERRAR',...
   'callback','close;');