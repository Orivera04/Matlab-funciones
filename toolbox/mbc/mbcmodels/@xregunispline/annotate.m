function annotate(m,Xs,Ys,ax)
%ANNOTATE Annotate response plot (from model/plot)
%
%  ANNOTATE(M, X, Y, AX), where X and Y are the plotted model data and AX
%  is the axes to draw into, annotates the model value plot.  For a
%  free-knot spline this involves plotting the knot locations.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:58:14 $

% add the knot positions
ylim = get(ax,'ylim');
val = get(m.mv3xspline,'knots');
val = invcode(m,val(:),get(m.mv3xspline,'spline'));
yval = repmat(ylim(1),size(val));
line('parent',ax,...
    'xdata',val,'ydata',yval,...
    'Marker','^',...
    'LineWidth',2,...
    'LineStyle','none',...
    'tag','free knot line',...
    'color','k');
