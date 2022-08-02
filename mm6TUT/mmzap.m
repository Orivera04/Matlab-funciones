function mmzap(arg)
%MMZAP Delete Graphics Object Using Mouse. (MM)
% MMZAP waits for a mouse click on an object in
% a figure window and deletes the object.
% MMZAP or MMZAP text erases text objects.
% MMZAP axes  erases axes objects.
% MMZAP line  erases line objects.
% MMZAP surf  erases surface objects.
% MMZAP patch  erases patch objects.
%
% Clicking on an object other than the selected type, or striking
% a key on the keyboard aborts the command.

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 3/29/95, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin<1, arg='text'; end

Hf=get(0,'CurrentFigure');
if isempty(Hf)
   error('No Figure Window Exists.')
end
if length(findobj(0,'Type','figure'))==1
   figure(Hf) % bring only figure forward
end
key=waitforbuttonpress;
if key  % key on keyboard pressed
   return
else    % object selected
   object=gco;
   type=get(object,'Type');
   if strncmp(type,arg,4)
      delete(object)
   end
end
