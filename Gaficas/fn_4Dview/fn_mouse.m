function varargout = fn_mouse(varargin)
% function [x y] = fn_mouse([axes handler][,mode])
% 
% multi-functions function using mouse events
% mode defines action:
% 'point'       [default] get coordinates on mouse click
% 'cross'       get coordinates on mouse click - draw crossing lines from
%               mouse position
% 'rect'        get a rectangle selection (uses matlab 'rbbox' function)
% 'poly'        polygone selection
% options: (ex: 'rect+', 'poly-@:.25:')
% +     selection is drawn (all modes)
% -     use as first point the current point in axes (rect, poly)
% @     plots open line instead of closed polygone (poly)
% :num: interpolates line with one point every 'num' pixel (poly)
%
%------
% Thomas Deneux
% last modification: 26/11/2006


i=1;
h=gca;
mode='point';
while i<=nargin
    arg = varargin{i};
    if ishandle(arg), h=arg;
    elseif ischar(arg), mode=arg;
    else error('bad argument')
    end
    i=i+1;
end

if findstr(mode,'point')
    SuspendCallbacks
    waitforbuttonpress
    RestoreCallbacks
    point = get(gca,'CurrentPoint');    % button down detected
    if nargout<=1, varargout={point(1,:)}; 
    elseif nargout==2, varargout=num2cell(point(1,1:2));
    elseif nargout==3, varargout=num2cell(point(1,1:3));
    end
    if findstr(mode,'+')
        oldnextplot=get(gca,'NextPlot'); set(gca,'NextPlot','add') 
        plot(point(1,1),point(1,2),'+'), 
        set(gca,'NextPlot',oldnextplot) 
    end
elseif findstr(mode,'cross')
    SuspendCallbacks
    point = ginput(1);
    RestoreCallbacks
    if nargout<=1, varargout={point(1,:)}; 
    elseif nargout==2, varargout=num2cell(point(1,1:2));
    elseif nargout==3, varargout=num2cell(point(1,1:3));
    end
    if findstr(mode,'+'), 
        oldnextplot=get(gca,'NextPlot'); set(gca,'NextPlot','add') 
        plot(point(1,1),point(1,2),'+'), 
        set(gca,'NextPlot',oldnextplot) 
    end
elseif findstr(mode,'rect')
    SuspendCallbacks
    if isempty(findstr(mode,'-')), waitforbuttonpress, end
    point1 = get(gca,'CurrentPoint');
    rbbox                   % return figure units
    RestoreCallbacks
    point2 = get(gca,'CurrentPoint');
    finalRect = [min(point1(1,1:2),point2(1,1:2)) abs(point2(1,1:2)-point1(1,1:2))];
    if nargout<=1, varargout={finalRect};
    end
    if findstr(mode,'+'), 
        oldnextplot=get(gca,'NextPlot'); set(gca,'NextPlot','add') 
        plot([point1(1,1) point2(1,1) point2(1,1) point1(1,1) point1(1,1)],...
            [point1(1,2) point1(1,2) point2(1,2) point2(1,2) point1(1,2)],'k-'), 
        plot([point1(1,1) point2(1,1) point2(1,1) point1(1,1) point1(1,1)],...
            [point1(1,2) point1(1,2) point2(1,2) point2(1,2) point1(1,2)],'w:'), 
        set(gca,'NextPlot',oldnextplot) 
    end
elseif findstr(mode,'poly')
    SuspendCallbacks
    if isempty(findstr(mode,'-')), waitforbuttonpress, end
    [xi,yi] = fn_getline;                   % return figure units
    RestoreCallbacks
    x = [xi yi];
    if findstr(mode,'+'), 
        if findstr(mode,'@'), back=[]; else back=1; end
        oldnextplot=get(gca,'NextPlot'); set(gca,'NextPlot','add')         
        plot(x([1:end back],1),x([1:end back],2),'k-'), 
        plot(x([1:end back],1),x([1:end back],2),'w:'), 
        set(gca,'NextPlot',oldnextplot) 
    end    
    if findstr(mode,':')
        f = find(mode==':'); f = [f length(mode)+1];
        ds = str2num(mode(f(1)+1:f(2)-1));
        if ~findstr(mode,'@'), x(end+1,:)=x(1,:); end
        ni = size(x,1);
        L = zeros(ni-1,1);
        for i=2:ni, L(i) = L(i-1)+norm(x(i,:)-x(i-1,:)); end
        if ~isempty(L), x = interp1(L,x,0:ds:L(end)); end
    end
    if nargout==1, varargout={x}; end
end

%-------------------------------------------------
function SuspendCallbacks
% se pr�munir des callbacks divers et vari�s

setappdata(gca,'uistate',uisuspend(gcf))
setappdata(gca,'oldtag',get(gca,'Tag'))
set(gca,'Tag','fn_mouse') % pour bloquer fn_imvalue !

%-------------------------------------------------
function RestoreCallbacks
% r�tablissement des callbacks avant les affichages

set(gca,'Tag',getappdata(gca,'oldtag'))
rmappdata(gca,'oldtag')
uirestore(getappdata(gca,'uistate'))

