function pr_3dlines(obj)
%PR_3DLINES Private function
% 
%  PR_3DLINES(obj) creates a 3d etched look around the frame

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:36:12 $

ud=get(obj.title,'userdata');
pos=get(obj,'innerposition');
if ud.title
   pos(4)=pos(4)-6;  
end
pos(3:4)=max(pos(3:4),[2 2]);

% need 2 lines which should be in axes already
rend = lower(get(get(obj,'parent'),'renderer'));

if strcmp(rend,'zbuffer')
   % zbuffer renderer - works as expected
   set(obj.grayline,'xdata',pos(1)+ [0 0 pos(3)-2 pos(3)-2 0],...
      'ydata',pos(2)+ [1 pos(4)-1 pos(4)-1 1 1]);
   set(obj.whiteline,'xdata',pos(1)+[1 1 pos(3)-2 pos(3)-1 pos(3)-1 0],...
      'ydata',pos(2)+[2 pos(4)-2 pos(4)-2 pos(4)-1 0 0]);
else
   % painters - (and opengl, but this never works properly whatever!)
   %            Needs a couple of hacks to make things join up!
   
   set(obj.grayline,'xdata',pos(1)+[0 0 pos(3)-2 pos(3)-2 0],...
      'ydata',pos(2)+[1 pos(4)-1 pos(4)-1 1 1]);
   set(obj.whiteline,'xdata',pos(1)+[1 1 pos(3)-2 pos(3)-1 pos(3)-1 -1],...
      'ydata',pos(2)+[2 pos(4)-2 pos(4)-2 pos(4)-1 0 0]);   
end
