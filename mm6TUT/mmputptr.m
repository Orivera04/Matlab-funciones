function mmputptr(H,xy)
%MMPUTPTR Place Mouse Pointer. (MM)
% MMPUTPTR(H) sets the pointer location to the center of the object
% having handle H. If H is an axes child other than text, the pointer
% is placed in the axes center. For text objects in 2D axes the pointer
% is placed on the text, in 3D axes the pointer is placed in the axes center.
%
% MMPUTPTR(Ha,[x y]) sets the pointer location to the x,y DATA coordinates
% in the axes having handle Ha.

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 9/1/97, 6/2/99
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if ~ishandle(H)
   error('Input H Must be a Valid Handle.')
end
[Hp,Htype]=mmget(H,'Parent','Type');
Hptype=get(Hp,'Type');
hppos=mmgetpos(Hp,'pixels');
Runits=get(0,'Units');

if nargin==1
   if strcmp(Hptype,'axes') % parent is an axes
      if strcmp(Htype,'text') & mmis2d(Hp)
         tmp=mmgetpos(H,'data');
         mmputptr(Hp,tmp(1:2))
         return
      else
         hpos=hppos; % position of axes
      end
      hppos=mmgetpos(get(Hp,'Parent'),'pixels');
   else
      hpos=mmgetpos(H,'pixels');
   end
   ppos=hppos(1:2)+hpos(1:2)+hpos(3:4)/2;
   set(0,  'Units','pixels',...
      'PointerLocation',ppos,...
      'Units',Runits)
   
elseif nargin==2
   if ~strcmp(Htype,'axes')
      error('H Must be an Axes Handle.')
   end
   if prod(size(xy))~=2
      error('[x y] Must be a Two-Element Vector.')
   end
   [xscale,xdir,xlim]=mmget(H,'Xscale','Xdir','Xlim');
   [yscale,ydir,ylim]=mmget(H,'Yscale','Ydir','Ylim');
   if any(get(H,'view')~=[0 90])
      error('Standard 2-D Viewpoint Required.')
   end
   if strcmp(xscale,'log') % log X-axis
      xlim=log10(xlim);
      xy(1)=log10(xy(1));
   end	
   dx=abs(xy(1)-xlim(1))/abs(xlim(2)-xlim(1));
   if strcmp(xdir,'reverse')
      dx=1-dx;
   end
   if strcmp(yscale,'log') % log Y-axis
      ylim=log10(ylim);
      xy(2)=log10(xy(2));
   end
   dy=abs(xy(2)-ylim(1))/abs(ylim(2)-ylim(1));
   if strcmp(ydir,'reverse')
      dy=1-dy;
   end
   hpos=mmgetpos(H,'pixels');
   dx=dx*hpos(3); % convert to pixels
   dy=dy*hpos(4);
   ppos=hppos(1:2)+hpos(1:2)+[dx dy];
   set(0,  'Units','pixels',...
      'PointerLocation',ppos,...
      'Units',Runits)
else
   error('Incorrect Number of Input Arguments.')
end
