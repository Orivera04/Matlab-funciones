function mmedit(Ht)
%MMEDIT Edit Axes Text using Mouse. (MM)
% MMEDIT waits for a mouse click on a text object,
% then allows it to be edited in place.
% Editing is terminated when the mouse is clicked outside
% the edit box.
%
% MMEDIT(Ht) edits the text having handle Ht.
%
% MMEDIT aborts if a keyboard key or something other
% than a text object is clicked on.

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 6/17/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==0 % get user to click on a text object
   shh=get(0,'ShowHiddenHandles');
   set(0,'ShowHiddenHandles','on') % make x,y,z labels visible
   key=waitforbuttonpress; % get buttonpress
   
   set(0,'ShowHiddenHandles',shh)
   if ~key % mouse key pressed on object
      Ht=gco;
   else
      disp('Keyboard Abort.')
      return
   end
end
if ~isempty(Ht) & strcmp(get(Ht(1),'type'),'text') % handle points to text
   set(Ht(1),'Editing','on')
else
   disp('Selected Object is Not Text.')
end

