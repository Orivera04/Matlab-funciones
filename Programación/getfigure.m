function getfigure
% funcion que añade al Figure actual un menu para capturar la grafica de otros Figures
% es decir, añadir al Figure actual la grafica de otro (seleccionable con el mouse)
%
% la primera ejecucion añade el menu, la segunda lo quita
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% this function adds a new menu option to copy other figure Figure plots
% adds to the current Figure the plot of another (mouse selection)
%
% first call adds the menu, second call deletes the menu
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Jordi Palacin (V1.1 - 2003)
% http://robotica.udl.es

hmenu = findobj(gcf,'label','Get Figure');

if (isempty(hmenu)),
    uimenu(gcf,'label','Get Figure','callback',@combinar_datos);
    disp('Get Figure menu has been added');
else,
    delete(hmenu);
    disp('Get Figure menu has been deleted');
end,

function combinar_datos(hco,eventStruct)
% funcion para combinar los datos del figure actual con los datos de otro figure

% figure actual
hfig = gcf;

% avisar para seleccionar el figure del que extraer los datos
uiwait(msgbox({'Step 1: Close this window','Step 2: Select the figure to be copied','Step 3: Strike a key...'},'Get Figure','modal'));

% esperar a que pulse una tecla
pause;

% figure seleccionado
hcomb = gcf;
hcomb_line = findobj(hcomb,'Type','line');

% averiguar cuantos lines hay
n_lines = length(hcomb_line);

if (hfig ~= hcomb),
    
    % añadirlos uno a uno
    figure(hfig);
    for (i = 1:1:n_lines),
    
        % extraer los datos a combinar
        x = get(hcomb_line(i),'xData');
        y = get(hcomb_line(i),'yData');
    
        Color = get(hcomb_line(i),'Color');
    	LineStyle = get(hcomb_line(i),'LineStyle');
    	LineWidth = get(hcomb_line(i),'LineWidth');
    	Marker = get(hcomb_line(i),'Marker');
    	MarkerSize = get(hcomb_line(i),'MarkerSize');
        
        if (ishold),
            plot(x,y,'Color',Color,'LineStyle',LineStyle,'LineWidth',LineWidth,'Marker',Marker,'MarkerSize',MarkerSize);
        else,
            hold on;
            plot(x,y,'Color',Color,'LineStyle',LineStyle,'LineWidth',LineWidth,'Marker',Marker,'MarkerSize',MarkerSize);
            hold off;
        end,
    end,
end,
