function annotate(m,Xs,Ys,ax)
%ANNOTATE Annotate response plot (from model/plot)
%
%  ANNOTATE(M, X, Y, AX), where X and Y are the plotted model data and AX
%  is the axes to draw into, annotates the model value plot.  For an RBF
%  this involves plotting the center locations.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:54:18 $

c = m.centers;
[unused, aind] = intersect(code(m,Xs),c(Terms(m),:),'rows');

h = findobj(ax,'tag','main line');
Xdata = get(h,'xdata');
Ydata = get(h,'ydata');
hc = line('parent',ax,...
    'xdata',Xdata(aind),'ydata',Ydata(aind),...
    'Marker','*','MarkerSize',12,...
    'LineWidth',2,...
    'tag','rbf center mark',...
    'LineStyle','none','color',[1 0 1]);

uistack(hc,'bottom');
