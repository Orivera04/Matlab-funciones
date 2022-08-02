function reverseplot
% esta funcion crea un Figure con un menu que permite abrir un fichero grafico
% que contenga una grafica para recuperarla. Se debe de seleccionar manualmente:
% - posicion del eje de coordenadas y sus valores
% - posiciones maximas y sus valores de ambos ejes
% - seleccionar los puntos de la grafica manualmente o automaticamente.
%
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% this function creates a Figure with a menu to open an image file of a graphic and
% recover its information. Some actions must be done:
% - select axis origin and its values
% - select maximum axis position and its values
% - select the data points with the mouse or automaticaly
%
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Jordi Palacin (V1.2 - 2004)
% http://robotica.udl.es

himatge = findobj('Tag','reverse');
if (isempty(himatge)),

    % crear la nueva figura
    himatge = figure;

    set(himatge,'numbertitle','off');
    set(himatge,'name','ReversePlot :');
    set(himatge,'MenuBar','none');
    set(himatge,'doublebuffer','on');    % dos bufers graficos
    set(himatge,'Tag','reverse');        % identificar figura

    % ######  MENU  ######################################

    Hm_se   = uimenu('Label','&Illustration');
    Hm_load = uimenu(Hm_se,'Label','&Open...','Callback',@loaddata);
    Hm_opt  = uimenu('Label','&Select in figure...','enable','off','Tag','FIG');
    Hm_s1   = uimenu(Hm_opt,'Label','X and Y axis origin','Callback',@dibor,'Tag','STEP1');
    Hm_s2   = uimenu(Hm_opt,'Label','X axis maximum','Callback',@dibxmax,'separator','on','enable','off','Tag','STEP2');
    Hm_s3   = uimenu(Hm_opt,'Label','X axis type','enable','off','Tag','STEP2');
    Hm_s31  = uimenu(Hm_s3,'Label','Linear','Callback',@toggle,'Tag','X','checked','on');
    Hm_s32  = uimenu(Hm_s3,'Label','Logarithmic','Callback',@toggle,'Tag','X');
    Hm_s4   = uimenu(Hm_opt,'Label','Y axis maximum','Callback',@dibymax,'separator','on','enable','off','Tag','STEP3');
    Hm_s5   = uimenu(Hm_opt,'Label','Y axis type','enable','off','Tag','STEP3');
    Hm_s51  = uimenu(Hm_s5,'Label','Linear','Callback',@toggle,'Tag','Y','checked','on');
    Hm_s52  = uimenu(Hm_s5,'Label','Logarithmic','Callback',@toggle,'Tag','Y');
    Hm_s6   = uimenu(Hm_opt, 'Label','Manual Data points ([enter] to stop)','Callback',@mangraf,'separator','on','enable','off','Tag','STEP4');
    Hm_s7   = uimenu(Hm_opt, 'Label','Automatic Data points (select a line with the mouse)...','Callback',@autograf,'enable','off','Tag','STEP4');
    Hm_s8   = uimenu(Hm_opt, 'Label','Delete Data points (select area with the mouse)...','Callback',@delarea,'enable','off','Tag','STEP5');
    Hm_s9   = uimenu(Hm_opt, 'Label','Add new Data points (select Data line with the mouse)...','Callback',@addarea,'enable','off','Tag','STEP5');
    
    Hm_cfs  = uimenu('Label','&Plot new figure','Callback',@dibuixar,'enable','off','Tag','STEP6');
    
    % initial values
    hvisio.orvalx=0;
    hvisio.orvaly=0;
    hvisio.xmaxval=0;
    hvisio.ymaxval=0;
    
    set(himatge,'userdata',hvisio);
else,
    figure(himatge);
end,
% ###################################################################################

% ###################################################################################
function loaddata(hco,eventStruct)
% funcion para recuperar los datos

[filename, pathname] = uigetfile('*.*', 'Load illustration...');
if (ischar(filename)),
    himatge = findobj('Tag','reverse');
    hvisio = get(himatge,'userdata');

    % recuperar imagen
    try,
    info = imfinfo([lower(pathname) lower(filename)]);
    
    [a,map] = imread([lower(pathname) lower(filename)]);
    catch,
        return;
    end,
    
    % adecuar el formato
    switch info.ColorType
    case 'grayscale',
        
        % pasar a indexada y a rgb
        [a,map] = gray2ind(a);
        a = ind2rgb(a,map);
        
    case 'indexed',
        
        % pasar a rgb
        a = ind2rgb(a,map);
        
    case 'truecolor',
        
        % ver si es double
        if (isa(a,'uint8')),
            % no lo es
            a = double(a)/255;
        end,
            
    end,
        
    image(a);
    
    % guardar imagen en niveles de gris
    hvisio.image=rgb2gray(a);
    set(himatge,'userdata',hvisio);
    
    % nombre del fichero
    set(findobj('Tag','reverse'),'name',['ReversePlot : ' lower(filename)]);
    
    set(findobj('Tag','FIG'),'enable','on');
    set(findobj('Tag','STEP2'),'enable','off');
    set(findobj('Tag','STEP3'),'enable','off');
    set(findobj('Tag','STEP4'),'enable','off');
    set(findobj('Tag','STEP5'),'enable','off');
    set(findobj('Tag','STEP6'),'enable','off');
  
end,
% ###################################################################################

% ###################################################################################
function toggle(hco, eventStruct)

% desactivar las opciones
set(findobj('Tag',get(hco,'Tag')),'checked','off');

% activar la opcion
set(hco,'checked','on');
% ###################################################################################

% ###################################################################################
function dibor(hco, eventStruct)
himatge = findobj('Tag','reverse');
hvisio = get(himatge,'userdata');

delete(findobj('TAG','ORG'));

[x,y]=ginput(1);
if (isempty(x)),
    set(findobj('Tag','STEP2'),'enable','off');
    set(findobj('Tag','STEP3'),'enable','off');
    set(findobj('Tag','STEP4'),'enable','off');
    set(findobj('Tag','STEP5'),'enable','off');
    set(findobj('Tag','STEP6'),'enable','off');
    return;
end,

hold on;
plot(x,y,'o','TAG','ORG','LineWidth',2);
hold off;
answer=inputdlg({'X axis origin value','Y axis origin value'},'X and Y axis origin',1,{num2str(hvisio.orvalx),num2str(hvisio.orvaly)});
if (isempty(answer)),
    % borrar la marca
    delete(findobj('TAG','ORG'));
    
    set(findobj('Tag','STEP2'),'enable','off');
    set(findobj('Tag','STEP3'),'enable','off');
    set(findobj('Tag','STEP4'),'enable','off');
    set(findobj('Tag','STEP5'),'enable','off');
    set(findobj('Tag','STEP6'),'enable','off');
    return;
end,

set(findobj('Tag','STEP2'),'enable','on');
set(findobj('Tag','STEP3'),'enable','off');
set(findobj('Tag','STEP4'),'enable','off');
set(findobj('Tag','STEP5'),'enable','off');
set(findobj('Tag','STEP6'),'enable','off');

hvisio.orx=x;
hvisio.ory=y;
hvisio.orvalx=str2num(char(answer(1)));
hvisio.orvaly=str2num(char(answer(2)));
set(himatge,'userdata',hvisio);
% ###################################################################################

% ###################################################################################
function dibxmax(hco, eventStruct)
himatge = findobj('Tag','reverse');
hvisio = get(himatge,'userdata');

delete(findobj('TAG','XMAX'));

[x,y]=ginput(1);
if (isempty(x)),
    set(findobj('Tag','STEP3'),'enable','off');
    set(findobj('Tag','STEP4'),'enable','off');
    set(findobj('Tag','STEP5'),'enable','off');
    set(findobj('Tag','STEP6'),'enable','off');
    return;
end,

hold on;
plot(x,y,'o','TAG','XMAX','LineWidth',2);
hold off;
answer=inputdlg('X axis maximum value','X axis',1,{num2str(hvisio.xmaxval)});
if (isempty(answer)),
    delete(findobj('TAG','XMAX'));
    
    set(findobj('Tag','STEP3'),'enable','off');
    set(findobj('Tag','STEP4'),'enable','off');
    set(findobj('Tag','STEP5'),'enable','off');
    set(findobj('Tag','STEP6'),'enable','off');
    return;
end,

set(findobj('Tag','STEP3'),'enable','on');
set(findobj('Tag','STEP4'),'enable','off');
set(findobj('Tag','STEP5'),'enable','off');
set(findobj('Tag','STEP6'),'enable','off');

hvisio.xmaxx=x;
hvisio.xmaxy=y;
hvisio.xmaxval=str2num(char(answer));
set(himatge,'userdata',hvisio);
% ###################################################################################

% ###################################################################################
function dibymax(hco, eventStruct)
himatge = findobj('Tag','reverse');
hvisio = get(himatge,'userdata');

delete(findobj('TAG','YMAX'));

[x,y]=ginput(1);
if (isempty(x)),
    set(findobj('Tag','STEP4'),'enable','off');
    set(findobj('Tag','STEP5'),'enable','off');
    set(findobj('Tag','STEP6'),'enable','off');
    return;
end,

hold on;
plot(x,y,'o','TAG','YMAX','LineWidth',2);
hold off;
answer=inputdlg('Y axis maximum value','Y axis',1,{num2str(hvisio.ymaxval)});
if (isempty(answer)),
    delete(findobj('TAG','YMAX'));
    
    set(findobj('Tag','STEP4'),'enable','off');
    set(findobj('Tag','STEP5'),'enable','off');
    set(findobj('Tag','STEP6'),'enable','off');
    return;
end,

set(findobj('Tag','STEP4'),'enable','on');
set(findobj('Tag','STEP5'),'enable','off');
set(findobj('Tag','STEP6'),'enable','off');

hvisio.ymaxx=x;
hvisio.ymaxy=y;
hvisio.ymaxval=str2num(char(answer));
set(himatge,'userdata',hvisio);
% ###################################################################################

% ###################################################################################
function mangraf(hco, eventStruct)
himatge = findobj('Tag','reverse');
hvisio = get(himatge,'userdata');

% borrar datos antiguos
delete(findobj(gcf,'TAG','XYDATA'));

[x,y]=ginput;
if (isempty(x)),
    set(findobj('Tag','STEP5'),'enable','off');
    set(findobj('Tag','STEP6'),'enable','off');
    return;
end,

hold on;
plot(x,y,'m-*','TAG','XYDATA','LineWidth',2);
hold off;
hvisio.dades_x=x;
hvisio.dades_y=y;

set(findobj('Tag','STEP5'),'enable','on');
set(findobj('Tag','STEP6'),'enable','on');

set(himatge,'userdata',hvisio);
% ###################################################################################

% ###################################################################################
function autograf(hco, eventStruct)
himatge = findobj('Tag','reverse');
hvisio = get(himatge,'userdata');

% borrar datos antiguos
delete(findobj(gcf,'TAG','XYDATA'));

% pulsar cerca de la linea
[x,y]=ginput(1);
if (isempty(x)),
    set(findobj('Tag','STEP5'),'enable','off');
    set(findobj('Tag','STEP6'),'enable','off');
    return;
end,
x = round(x);
y = round(y);

% analizar imagen en escala de grises
nivel_max = max(max(hvisio.image));
nivel_min = min(min(hvisio.image));
nivel_med = mean(mean(hvisio.image));

% ver si se ha pulsado sobre la linea
if ((nivel_max - nivel_med) < (nivel_med - nivel_min)),
    % el color de fondo predominante es claro
    % la linea deberia ser oscura
    color_linea = min(min(hvisio.image(y-2:y+2,x)));
    
    if (color_linea < nivel_med),
        % linea localizada -> continuar
    else,
        % fallo !!!
        return;
    end,
else,
    % el color de fondo predominante es oscuro
    % la linea deberia ser clara
    color_linea = max(max(hvisio.image(y-5:y+5,x-5:x+5)));
        
    if (color_linea > nivel_med),
        % linea localizada -> continuar
    else,
        % fallo !!!
        return;
    end,
end,

% buscar centro de la linea
[xc, yc] = busca_centro(hvisio.image, x, y, color_linea, 0.3);
x_dades = xc;
y_dades = yc;
        
% a partir del punto seleccionado realizar un barrido hacia derercha e izquierda
yi = yc;
for (x = xc-1:-1:hvisio.orx),
    [xi, yi] = busca_centro(hvisio.image, x, yi, color_linea, 0.3);
            
    if (isempty(xi)),
        break;
    end,
            
    x_dades = [xi x_dades];
    y_dades = [yi y_dades];
end,
yi = yc;
for (x = xc+1:+1:hvisio.xmaxx),
    [xi, yi] = busca_centro(hvisio.image, x, yi, color_linea, 0.3);
      
    if (isempty(xi)),
        break;
    end,
      
    x_dades = [x_dades xi];
    y_dades = [y_dades yi];
end,

hold on;
plot(x_dades,y_dades,'r-','TAG','XYDATA','LineWidth',2);
hold off;
hvisio.dades_x=x_dades;
hvisio.dades_y=y_dades;

set(findobj('Tag','STEP5'),'enable','on');
set(findobj('Tag','STEP6'),'enable','on');

set(himatge,'userdata',hvisio);
% ###################################################################################

% ###################################################################################
function [xp, yp] = busca_centro(imatge, x, y, color_linea, tolerancia)

% la imatge se suposa en blanc i negre
[y_dim,x_dim] = size(imatge);

y_sup = [];
y_inf = [];

% buscar sobre eix y
for (y_i=y+1:+1:y_dim),
    % analitzar color
    if (abs(imatge(y_i, x)-color_linea) < tolerancia),
        y_sup = y_i;
    else,
        break;
    end,
end,
for (y_i=y-1:-1:1),
    % analitzar color
    if (abs(imatge(y_i, x)-color_linea) < tolerancia),
        y_inf = y_i;
    else,
        break;
    end,
end,

if (isempty(y_sup) & isempty(y_inf)),
    xp = [];
    yp = [];
    return;
elseif (isempty(y_sup)),
    y_sup = y;
elseif (isempty(y_inf)),
    y_inf = y;
end,

% trobar i retornar el punt mig
yp = round(mean([y_sup y_inf]));
xp = x;
% ###################################################################################

% ###################################################################################
function delarea(hco, eventStruct)
% eliminar el area seleccionada

% recuperar datos
himatge = findobj('Tag','reverse');
hvisio = get(himatge,'userdata');

% modificar el cursor
set(gcf,'Pointer','fullcrosshair');

% marcar el area con el mouse
%waitforbuttonpress;
%pos1 = get(gca,'currentpoint');
pos1 = ginput(1);
rbbox([pos1(1) pos1(2) 0 0],get(gcf,'currentpoint'));
pos2 = get(gca,'currentpoint');

% limites
[y_dim,x_dim] = size(hvisio.image);

% localizacion en pantalla
i_inicio = min(pos1(1,1),pos2(1,1));
i_final  = max(pos1(1,1),pos2(1,1));

% localizar sobre los datos
i = find((hvisio.dades_x >= i_inicio) & (hvisio.dades_x <= i_final));

% eliminar
hvisio.dades_x(i) = [];
hvisio.dades_y(i) = [];

% borrar datos antiguos
delete(findobj(gcf,'TAG','XYDATA'));

% mirar si quedan datos
if (isempty(hvisio.dades_x)),
    set(findobj('Tag','STEP5'),'enable','off');
    set(findobj('Tag','STEP6'),'enable','off');
end,

% redibujar
hold on;
plot(hvisio.dades_x,hvisio.dades_y,'r-','TAG','XYDATA','LineWidth',2);
hold off;

% modificar el cursor
set(gcf,'Pointer','arrow');

% guardar
set(himatge,'userdata',hvisio);
% ###################################################################################

% ###################################################################################
function addarea(hco, eventStruct)
himatge = findobj('Tag','reverse');
hvisio = get(himatge,'userdata');

% no borrar datos antiguos -> estamos añadiendo

% pulsar cerca de la linea
[x,y]=ginput(1);
if (isempty(x)),
    % no pasa nada si no se añaden extras
    return;
end,
x = round(x);
y = round(y);

% ver si se ha pulsado sobre un area "libre"
if ((x > max(hvisio.dades_x)) | (x < max(hvisio.dades_x))),
    %OK estamos sobre un area libre
else,
    return;
end,

% analizar imagen en escala de grises
nivel_max = max(max(hvisio.image));
nivel_min = min(min(hvisio.image));
nivel_med = mean(mean(hvisio.image));

% ver si se ha pulsado sobre la linea
if ((nivel_max - nivel_med) < (nivel_med - nivel_min)),
    % el color de fondo predominante es claro
    % la linea deberia ser oscura
    color_linea = min(min(hvisio.image(y-2:y+2,x)));
    
    if (color_linea < nivel_med),
        % linea localizada -> continuar
    else,
        % fallo !!!
        return;
    end,
else,
    % el color de fondo predominante es oscuro
    % la linea deberia ser clara
    color_linea = max(max(hvisio.image(y-5:y+5,x-5:x+5)));
        
    if (color_linea > nivel_med),
        % linea localizada -> continuar
    else,
        % fallo !!!
        return;
    end,
end,

% buscar centro de la linea
[xc, yc] = busca_centro(hvisio.image, x, y, color_linea, 0.3);
x_dades = xc;
y_dades = yc;
        
% a partir del punto seleccionado realizar un barrido hacia la izquierda
% establecer los limites
if (xc > max(hvisio.dades_x)),
    % el inicio de la zona de datos
    x_lim = max(hvisio.dades_x);
else,
    % el origen
    x_lim = hvisio.orx;
end,

yi = yc;
for (x = xc-1:-1:x_lim),
    [xi, yi] = busca_centro(hvisio.image, x, yi, color_linea, 0.3);
            
    if (isempty(xi)),
        break;
    end,
            
    x_dades = [xi x_dades];
    y_dades = [yi y_dades];
end,

% hacia la derecha
% establecer los limites
if (xc < min(hvisio.dades_x)),
    % el inicio de la zona de datos
    x_lim = min(hvisio.dades_x);
else,
    % el final de los datos
    x_lim = hvisio.xmaxx;
end,

yi = yc;
for (x = xc+1:+1:x_lim),
    [xi, yi] = busca_centro(hvisio.image, x, yi, color_linea, 0.3);
      
    if (isempty(xi)),
        break;
    end,
      
    x_dades = [x_dades xi];
    y_dades = [y_dades yi];
end,

% ensamblar los nuevos datos con los antiguos
if (max(x_dades) > max(hvisio.dades_x)),
    % añadir al final
    hvisio.dades_x = [hvisio.dades_x x_dades];
    hvisio.dades_y = [hvisio.dades_y y_dades];
else,
    % añadir al principio
    hvisio.dades_x = [x_dades hvisio.dades_x];
    hvisio.dades_y = [y_dades hvisio.dades_y];
end,

% borrar datos antiguos
delete(findobj('TAG','XYDATA'));

hold on;
plot(hvisio.dades_x,hvisio.dades_y,'r-','TAG','XYDATA','LineWidth',2);
hold off;

set(himatge,'userdata',hvisio);
% ###################################################################################

% ###################################################################################
function dibuixar(hco, eventStruct)
himatge=findobj('Tag','reverse');
hvisio=get(himatge,'userdata');

% detectar ejes
hx = findobj('Tag','X','checked','on');
hy = findobj('Tag','Y','checked','on');

eje_x = get(hx,'Label');
eje_y = get(hy,'Label');

if (length(hvisio.dades_x) > 100),
    str_plot = 'k-';
else,
    str_plot = 'ko-';
end,

figure;
if (findstr(eje_x,'Lin') & findstr(eje_y,'Lin')),
    
    % normalizar datos lineal
    dades_x = (hvisio.dades_x-hvisio.orx)/(hvisio.xmaxx-hvisio.orx);
    % escalar
    dades_x = dades_x * (hvisio.xmaxval-hvisio.orvalx) + hvisio.orvalx;

    % normalizar datos lineal
    dades_y = (hvisio.dades_y-hvisio.ory)/(hvisio.ymaxy-hvisio.ory);
    % escalar
    dades_y = dades_y * (hvisio.ymaxval-hvisio.orvaly) + hvisio.orvaly;
    
    plot(dades_x, dades_y,str_plot);
    
elseif (findstr(eje_x,'Lin') & findstr(eje_y,'Log')),
    
    % normalizar datos lin
    dades_x = (hvisio.dades_x-hvisio.orx)/(hvisio.xmaxx-hvisio.orx);
    % escalar
    dades_x = dades_x * (hvisio.xmaxval-hvisio.orvalx) + hvisio.orvalx;

    % normalizar datos log
    dades_y = (hvisio.dades_y-hvisio.ory)/(hvisio.ymaxy-hvisio.ory);
    % escalar
    dades_y = dades_y * (log10(hvisio.ymaxval)-log10(hvisio.orvaly)) + log10(hvisio.orvaly);
    dades_y = 10.^dades_y;
    
    semilogy(dades_x, dades_y,str_plot);
    
elseif (findstr(eje_x,'Log') & findstr(eje_y,'Lin')),
    
    % normalizar datos log
    dades_x = (hvisio.dades_x-hvisio.orx)/(hvisio.xmaxx-hvisio.orx);
    % escalar
    dades_x = dades_x * (log10(hvisio.xmaxval)-log10(hvisio.orvalx)) + log10(hvisio.orvalx);
    dades_x = 10.^dades_x;

    % normalizar datos log
    dades_y = (hvisio.dades_y-hvisio.ory)/(hvisio.ymaxy-hvisio.ory);
    % escalar
    dades_y = dades_y * (log10(hvisio.ymaxval)-log10(hvisio.orvaly)) + log10(hvisio.orvaly);
    dades_y = 10.^dades_y;
    
    semilogx(dades_x, dades_y,str_plot);
    
else,
    
    % normalizar datos log
    dades_x = (hvisio.dades_x-hvisio.orx)/(hvisio.xmaxx-hvisio.orx);
    % escalar
    dades_x = dades_x * (log10(hvisio.xmaxval)-log10(hvisio.orvalx)) + log10(hvisio.orvalx);
    dades_x = 10.^dades_x;

    % normalizar datos log
    dades_y = (hvisio.dades_y-hvisio.ory)/(hvisio.ymaxy-hvisio.ory);
    % escalar
    dades_y = dades_y * (log10(hvisio.ymaxval)-log10(hvisio.orvaly)) + log10(hvisio.orvaly);
    dades_y = 10.^dades_y;
    
    loglog(dades_x, dades_y,str_plot);
    
end,

% recuperar el axis
axis([hvisio.orvalx hvisio.xmaxval hvisio.orvaly hvisio.ymaxval]);