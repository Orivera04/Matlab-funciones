function xregmenuenable(mnH)
%XREGMENUENABLE  Check enable status of top menu
%
%  XREGMENUENABLE(H)  checks the enable status of the child
%  menus and turns the parent off if they are all off
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:34:28 $


ch=get(mnH,'children');
en=get(ch,{'enable'});
vis=get(ch,{'visible'});
if all(strcmp(en,'off') | strcmp(vis,'off'))
   set(mnH,'enable','off');
else
   set(mnH,'enable','on');
end