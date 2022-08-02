function DisplayGUI(mdev,ud);
%DISPLAYGUI

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:09:31 $

mdev= fitmodel(mdev);
pointer(mdev);
m= mdev.Model;

% replace this by call to diag_plot method.
delete(get(ud.Global.plot,'children'));
diag_plot(m,{'studres/pred'},ud.Global.plot);

yinv=texlabel(char(get(m,'yinv')));
mc= str2mat(yinv);

ssedf= stats(m,'ssedf');
p=sum(Terms(m));

mc= str2mat('Model Summary:',...
   [' ',str_func(m,1)],...
   sprintf(' %-17s: %2d','#Obs',ssedf(2)+p),...
   sprintf(' %-17s: %-2d','#Terms', p),...
   sprintf(' %-17s: %-3.3g','Box-Cox Transform', get(m,'boxcox')));
ud.Global.Summary= text('Parent',ud.Global.plot,...
   'units','norm',...
   'pos',[0 -0.45],...
   'Fontname','Lucida Console',...
   'FontSize',10,...
   'Horizontal','left',...
   'string',mc,...
   'Vertical','Top');

dispstats('display',ud.Global.Info,m);
