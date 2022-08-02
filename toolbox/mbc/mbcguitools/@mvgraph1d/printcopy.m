function LYT=printcopy(obj,fig)
%PRINTCOPY  Create a printer-friendly copy of mvgraph1d
%
%  LYT=PRINTCOPY(OBJ,FIG)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:18:54 $




% copy 1d axis always
ax1d=copyobj(obj.axes,fig);
set(ax1d,'userdata',[]);
facts=get(obj.factorsel,'string');
if ~isempty(facts) 
   set(get(ax1d,'xlabel'),'string',facts{get(obj.factorsel,'value')});
end
ax1d=axiswrapper(ax1d);
if get(obj.hist.axes,'userdata')
   axhist=copyobj(obj.hist.axes,fig);
   set(axhist,'userdata',[]);
   axhist=axiswrapper(axhist);
   LYT=xreggridlayout(fig,'correctalg','on',...
      'dimension',[2 1],...
      'gapy',20,...
      'rowsizes',[-1 5 ],...
      'elements',{axhist,ax1d},...
      'border',[30 45 10 30]);
   
else
   % no histogram
   LYT=xreggridlayout(fig,'correctalg','on',...
      'dimension',[3 1],...
      'rowsizes',[-1 5 -1],...
      'elements',{[],ax1d},...
      'border',[30 45 10 20]);
end