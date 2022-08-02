function updatelims(this)
%UPDATELIMS  Custom limit picker for time plots.

%  Author(s): P. Gahinet, Bora Eryilmaz
%  Copyright 1986-2002 The MathWorks, Inc. 
%  $Revision: 1.1.4.1 $ $Date: 2004/04/16 22:21:18 $
AxesGrid = this.AxesGrid;

% Update X range 
% RE: Do not use SETXLIM in order to preserve XlimMode='auto'
% REVISIT: make it unit aware
ax = getaxes(this);  % takes I/O grouping into account
AutoX = strcmp(AxesGrid.XLimMode,'auto');
for ct=1:size(ax,2)
   if AutoX(ct)
      set(ax(:,AutoX),'Xlim',this.TimeFocus{ct});
   end
end

if strcmp(AxesGrid.YNormalization,'on')
   % Reset auto limits to [-1,1] range
   set(ax(strcmp(AxesGrid.YLimMode,'auto'),:),'Ylim',[-1.1 1.1])
else
   % Update Y limits
   AxesGrid.updatelims('manual',[])
end
