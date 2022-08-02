function demo_surface(arg)
%DEMO_SURFACE
%  Demonstrates SELECT3D. Click on the surface plot
%  and you should see the 3-D point selected along with
%  the nearest vertex.

%  Copyright Joe Conti 2002 
%  Send comments to jconti@mathworks.com

if nargin>0
    feval(arg);
    return;
end

fig = figure;
surf(peaks); drawnow;
zoom(4);
axis manual; % Prevent resize

set(gca,'projection','o');

% Markers
selection_marker = line('marker','o','markerfacecolor','k','erasemode','xor','visible','off');
selection_vertex = line('marker','o','markerfacecolor','k','erasemode','xor','visible','off');
selection_face = line('marker','o','markerfacecolor','k','erasemode','xor','visible','off');

setappdata(0,'selection_marker',selection_marker);
setappdata(0,'selection_vertex',selection_vertex);
setappdata(0,'selection_face',selection_face);

set(fig,'windowbuttondownfcn','demo_surface(''update'')');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function update

[p v vi face facei] = select3d(gco);

if isempty(p)
    return
end

selection_marker = getappdata(0,'selection_marker');
selection_vertex = getappdata(0,'selection_vertex');
selection_face = getappdata(0,'selection_face');

set(selection_marker,'visible','on','xdata',p(1),'ydata',p(2),'zdata',p(3));

set(selection_vertex,'visible','on','xdata',v(1),'ydata',v(2),'zdata',v(3));
disp(sprintf('\nX: %.2f\nY: %.2f\nZ: %.2f',p(1),p(2),p(3)'))