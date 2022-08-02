function annotate(m,Xs,Ys,ax)
%ANNOTATE Annotate response plot (from model/plot)
%
%  ANNOTATE(M, X, Y, AX), where X and Y are the plotted model data and AX
%  is the axes to draw into, annotates the model value plot.  For a hybrid
%  RBF this involves plotting the center locations.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:47:59 $

c = get(m.rbfpart,'centers');
TermsIn = Terms(m);
nlmterms = length(double(m.linearmodpart));
[unused,aind] = intersect(code(m,Xs),c(TermsIn(nlmterms+1:end),:),'rows');

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
