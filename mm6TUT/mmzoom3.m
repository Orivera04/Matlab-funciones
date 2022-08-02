function mmzoom3(arg)
%MMZOOM3 Simple 3-D Zoom-In Function Using RBBOX. (MM)
% MMZOOM3 changes the view of the current axes to 2-D then the
% user drags a rubberband box to select part of the X-Y plane
% for zooming. Finally the 3-D plot is redrawn with the new
% X and Y axis limits and the Z axis remains autoscaled.
% Works for a single surface plot only.
% 
% MMZOOM3 x     zooms the x-axis only.
% MMZOOM3 y     zooms the y-axis only.
% MMZOOM3 reset restores original axis limits.
%
% Striking a key on the keyboard aborts the command.
% MMZOOM3 becomes inactive after zoom is complete or aborted.

% Calls: mmgcf mmgca mmbox mmxtract

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 2/21/96, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

global MMZOOM3_HS MMZOOM3_V MMZOOM3_X  MMZOOM3_Y MMZOOM3_Z MMZOOM3_C

% Note MATLAB does not clip 3-D plots correctly so zoom
% is accomplished by restricting data plotted, rather than
% by simply changing axis limits.

Hf=mmgcf(1);
Ha=mmgca(Hf,1);
if nargin==0, arg=' '; end
arg=arg(1);

if (arg=='r'|arg=='o') &~isempty(MMZOOM3_HS)  % reset request
   set(MMZOOM3_HS,'Xdata',MMZOOM3_X,'Ydata',MMZOOM3_Y,...
      'Zdata',MMZOOM3_Z,'Cdata',MMZOOM3_C)
   Ha=get(MMZOOM3_HS,'Parent');
   set(Ha,'View',MMZOOM3_V,'CLimMode','auto'); 
   MMZOOM3_HS=[];MMZOOM3_V=[];
   MMZOOM3_X=[];MMZOOM3_Y=[];MMZOOM3_Z=[];MMZOOM3_C=[];
   return
elseif (arg=='r'|arg=='o') % already reset
   return
end
figure(Hf) % bring current figure forward
Ha=gca;
MMZOOM3_V=get(Ha,'View');
if all(MMZOOM3_V==[0 90]),error('Plot must be 3-D.'), end
MMZOOM3_HS=findobj(Ha,'Type','surface');
if isempty(MMZOOM3_HS)
   error('No Surface Available to Zoom')
elseif isempty(MMZOOM3_C) % store original data
   MMZOOM3_HS=MMZOOM3_HS(1);	% take first surface
   MMZOOM3_X=get(MMZOOM3_HS,'Xdata');
   MMZOOM3_Y=get(MMZOOM3_HS,'Ydata');
   MMZOOM3_Z=get(MMZOOM3_HS,'Zdata');
   MMZOOM3_C=get(MMZOOM3_HS,'Cdata');
   set(Ha,'CLim',[min(min(MMZOOM3_C)) max(max(MMZOOM3_C))]);
end
set(Ha,'View',[0 90])

p=mmbox;  % use mmbox to get axis vector
if isempty(p) % abort
   mmzoom3('reset')  % clean stuff up with a recursive call
else    % vector returned			
   if arg=='x', p(3:4)=[-inf inf];
   elseif arg=='y' p(1:2)=[-inf inf];
   end
   [X,Y,Z,C]=mmxtract(MMZOOM3_X,MMZOOM3_Y,MMZOOM3_Z,...
      MMZOOM3_C,p(1:2),p(3:4));	
   set(MMZOOM3_HS,'Xdata',X,'Ydata',Y,'Zdata',Z,'Cdata',C)
   set(Ha,'view',MMZOOM3_V)
end
