function measure
% function to do measures with the mouse inside a figure axis
%
% measure  -> first time: creates a menu function for measurement in the current figure
%             second time: deletes the menu function in the current figure
%
% Measurement starts/ends when pressing/releasing the mouse button.
% A dialog box shows the measurement results.
%
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
% Jordi Palacin (V1.0 - 2003)
% http://robotica.udl.es

hmenu = findobj(gcf,'label','Measure');

if (isempty(hmenu)),
    uimenu(gcf,'label','Measure','callback',@measure_data);
    disp('Measure menu has been added');
    
    % situar la figura en primer plano
    figure(gcf);
else,
    delete(hmenu);

    % borrar tambien la linea
    hmeas = findobj(gcf,'Tag','MEASURE FCN');
    if (~isempty(hmeas)),
        delete(hmeas);
    end,
    
    disp('Measure menu has been deleted');
end,
% ########################################################################################

% ########################################################################################
function measure_data(hco,eventStruct)

% borrar medida antigua
hmeas = findobj(gcf,'Tag','MEASURE FCN');
if (~isempty(hmeas)),
    delete(hmeas);
end,
set(gcf,'DoubleBuffer','on');
refresh;

% realizar la medida

% funciones antiguas del mouse
meas.fun_down   = get(gcf,'WindowButtonDownFcn');
meas.fun_motion = get(gcf,'WindowButtonMotionFcn');
meas.fun_up     = get(gcf,'WindowButtonUpFcn');

% eliminar funciones del mouse
set(gcf,'WindowButtonDownFcn','');
set(gcf,'WindowButtonMotionFcn','');
set(gcf,'WindowButtonUpFcn','');

% cursor especial
meas.fig_pointer = get(gcf,'Pointer');

set(gcf,'Pointer','fullcrosshair');
% memorizar el estado hold
meas.hold_status = ishold;
% desconectar el zoom
zoom off;

% preparar para cuando se pulse
waitforbuttonpress;
pos1 = get(gca,'currentpoint');
hold on;
meas.hdata = plot([pos1(1,1) pos1(1,1)],[pos1(1,2) pos1(1,2)],'r+:','Tag','MEASURE FCN');
% guardat datos
set(meas.hdata,'UserData',meas);

% dibujar la line hasta que se suelte el boton
set(gcf,'WindowButtonMotionFcn',@measbuttonmotionfcn);
set(gcf,'WindowButtonUpFcn',@measbuttonupfcn);
% ########################################################################################

% ########################################################################################
function measbuttonmotionfcn(hco,struct)

% localizar la linea
hmeas = findobj(gcf,'Tag','MEASURE FCN');
meas = get(hmeas,'UserData');

% actualizar el grafico
pos2 = get(gca,'currentpoint');

xdata = get(meas.hdata,'XData');
ydata = get(meas.hdata,'YData');

set(meas.hdata,'XData', [xdata(1) pos2(1,1)]);
set(meas.hdata,'YData', [ydata(1) pos2(1,2)]);
drawnow;
% ########################################################################################

% ########################################################################################
function measbuttonupfcn(hco,struct)

% finalizar la medida

% eliminar funciones del mouse
set(gcf,'WindowButtonDownFcn','');
set(gcf,'WindowButtonMotionFcn','');
set(gcf,'WindowButtonUpFcn','');

% localizar la linea
hmeas = findobj(gcf,'Tag','MEASURE FCN');
meas = get(hmeas,'UserData');

% recuperar el cursor antiguo
set(gcf,'Pointer',meas.fig_pointer);

% recuperar los datos
xdata = get(meas.hdata,'XData');
ydata = get(meas.hdata,'YData');

% presentar el resultado
answer = inputdlg({'X distance','Y distance'},'Measurement results...',1,{num2str(xdata(2)-xdata(1)),num2str(ydata(2)-ydata(1))});

% recuperar estado de hold
if (~meas.hold_status),
    hold off;
end,

% recuperar funciones antiguas del mouse
set(gcf,'WindowButtonMotionFcn',meas.fun_motion);
set(gcf,'WindowButtonUpFcn',meas.fun_up);
set(gcf,'WindowButtonDownFcn',meas.fun_down);