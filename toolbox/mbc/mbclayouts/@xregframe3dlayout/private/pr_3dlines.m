function pr_3dlines(obj)
% PR_3DLINES   Private function
% 
%   PR_3DLINES(ax) creates a 3d depressed look around the axes ax
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:36:03 $


pos=get(obj,'innerposition');
pos(3:4)=max(pos(3:4),[5 5]);

pos=round(pos);
ud=get(obj.blackline,'userdata');
rend=get(get(obj.axes,'parent'),'renderer');

switch lower(rend)
case 'zbuffer'
   % reset background
   set(obj.background,'xdata',pos(1)+[2 2 pos(3)-3 pos(3)-3],...
       'ydata',pos(2)+[1 pos(4)-3 pos(4)-3 1],...
       'zdata',[-1 -1 -1 -1]);
   % reset button press region
   set(obj.cbobject,'xdata',pos(1)+[5 5 pos(3)-6 pos(3)-6],...
       'ydata',pos(2)+[4 pos(4)-6 pos(4)-6 4],...
       'zdata',[-.5 -.5 -.5 -.5]);
   % set tag text
   set(obj.tagtext,'position',[pos(1)+2 pos(2)+pos(4) 1]);
   
   if ud.tagtext
      ext=ud.tagextent;
      % reposition text background
      set(obj.tagback,'xdata',pos(1)+[0 0 ext(3) ext(3)],...
         'ydata',pos(2)+[pos(4)-ext(4)-1 pos(4)-1 pos(4)-1 pos(4)-ext(4)],...
         'zdata',[.5 .5 .5 .5]);
      % need to wrap lines around the text object
      set(obj.blackline,'xdata',pos(1)+[1 1 ext(3)+2 ext(3)+2 pos(3)-2],...
         'ydata',pos(2)+[2 pos(4)-ext(4)-2 pos(4)-ext(4)-2 pos(4)-2 pos(4)-2]);
      set(obj.darkline,'xdata',pos(1)+[0 0 ext(3)+1 ext(3)+1 pos(3)-1],...
         'ydata',pos(2)+[1 pos(4)-ext(4)-1 pos(4)-ext(4)-1 pos(4)-1 pos(4)-1]);
   else
      set(obj.blackline,'xdata',pos(1)+[1 1 pos(3)-3],'ydata',pos(2)+[2 pos(4)-2 pos(4)-2]);
      set(obj.darkline,'xdata',pos(1)+[0 0 pos(3)-2],'ydata',pos(2)+[1 pos(4)-1 pos(4)-1]);
   end
   set(obj.midline,'xdata',pos(1) +[1 pos(3)-2 pos(3)-2],'ydata',pos(2)+[1 1 pos(4)-2]);
   set(obj.lightline,'xdata',pos(1)+[0 pos(3)-1 pos(3)-1],'ydata',pos(2)+[0 0 pos(4)-1]);
otherwise
   % reset background
   set(obj.background,'xdata',pos(1)+[2 2 pos(3)-2 pos(3)-2],...
       'ydata',pos(2)+[1 pos(4)-3 pos(4)-3 1],...
       'zdata',[-1 -1 -1 -1]);
   % reset button press region
   set(obj.cbobject,'xdata',pos(1)+[5 5 pos(3)-5 pos(3)-5],...
       'ydata',pos(2)+[4 pos(4)-6 pos(4)-6 4],...
       'zdata',[-.5 -.5 -.5 -.5]);
   % set tag text
   set(obj.tagtext,'position',[pos(1)+2 pos(2)+pos(4) 1]);
   
   if ud.tagtext
      % reposition text background
      ext=ud.tagextent;
      set(obj.tagback,'xdata',pos(1)+[0 0 ext(3)+1 ext(3)+1],...
         'ydata',pos(2)+[pos(4)-ext(4)-1 pos(4)-1 pos(4)-1 pos(4)-ext(4)],...
         'zdata',[.5 .5 .5 .5]);
      % need to wrap lines around the text object
      set(obj.blackline,'xdata',pos(1)+[1 1 ext(3)+2 ext(3)+2 pos(3)-2],...
         'ydata',pos(2)+[2 pos(4)-ext(4)-2 pos(4)-ext(4)-2 pos(4)-2 pos(4)-2]);
      set(obj.darkline,'xdata',pos(1)+[0 0 ext(3)+1 ext(3)+1 pos(3)-1 ],...
         'ydata',pos(2)+[1 pos(4)-ext(4)-1 pos(4)-ext(4)-1 pos(4)-1 pos(4)-1]);
   else
      % need 4 lines which should be in axes already
      set(obj.blackline,'xdata',pos(1)+[1 1 pos(3)-2],'ydata',pos(2)+[2 pos(4)-2 pos(4)-2]);
      set(obj.darkline,'xdata',pos(1)+[0 0 pos(3)-1],'ydata',pos(2)+[1 pos(4)-1 pos(4)-1]);
   end
   set(obj.midline,'xdata',pos(1) +[1 pos(3)-2 pos(3)-2],'ydata',pos(2)+[1 1 pos(4)-1]);
   set(obj.lightline,'xdata',pos(1)+[0 pos(3)-1 pos(3)-1],'ydata',pos(2)+[0 0 pos(4)]);
end

return