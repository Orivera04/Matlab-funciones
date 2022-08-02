function LYT=printcopy(obj,fig)
%PRINTCOPY  Create a printer-friendly copy of mvgraph1d
%
%  LYT=PRINTCOPY(OBJ,FIG)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:19:49 $


% copy main axes always
ax=copyobj(obj.axes,fig);
ax=axiswrapper(ax);

% add colorbar
axcol=copyobj(obj.colorbar.axes,fig);
set(get(axcol,'children'),'buttondownfcn','','userdata',[]);
   
LYT=xreggridlayout(fig,'correctalg','on',...
   'dimension',[1 2],...
   'colsizes',[-1 20],...
   'gapx',30,...
   'border',[60 50 40 30],...
   'elements',{ax,axcol});