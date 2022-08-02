function mbcaxesmessage(ax,msg,fontsize)
%MBCAXESMESSAGE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $

delete(get(ax,'children'));
xlim = get(ax,'xlim');
ylim = get(ax,'ylim');
zlim = get(ax,'zlim');

if nargin<3
    fontsize = 15;
end

x = (xlim(1) + xlim(2))/2;
y = (ylim(1) + ylim(2))/2;
z = (zlim(1) + zlim(2))/2;

text('parent',ax,'string',msg,'fontsize',fontsize,...
         'position',[x y z],'horizontalAlignment','center');

