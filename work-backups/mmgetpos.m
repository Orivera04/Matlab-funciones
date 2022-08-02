function p=mmgetpos(H,u,cp)
%MMGETPOS Get Object Position Vector in Specified Units. (MM)
% MMGETPOS(H,'Units') returns the position vector associated with the
% graphics object having handle H in the units specified by 'Units'.
% 'Units' is one of: 'pixels', 'normalized', 'points', 'inches', 'cent'.
% 'Units' equal to 'data' is valid for text objects.
%
% MMGETPOS does the "right thing", i.e., it: (1) saves the current units,
% (2) sets the units to those requested, (3) gets the position, then
% (4) restores the original units.
%
% MMGETPOS(H,'Units','CurrentPoint') returns the 'CurrentPoint' position
% of the figure having handle H in the units specified by 'Units'.
%
% MMGETPOS(H,'Units','Extent') returns the 'Extent' rectangle of the text
% object having handle H.
%
% 'Uimenu', 'image', 'line', 'patch', 'surface', and 'light' objects
%  do NOT have position properties.

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 10/29/96, v5: 1/14/97, 8/22/97, 9/11/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if ~ischar(u), error('Units Must be a Valid String.'), end
if ~ishandle(H), error('H is Not a Valid Handle.'), end
Htype=get(H,'Type');

if nargin==3 & ~isempty(cp) & ischar(cp)
   if strcmp(Htype,'figure') & lower(cp(1))=='c'
      pname='CurrentPoint';
   elseif strcmp(Htype,'text') & lower(cp(1))=='e'
      pname='Extent';
   else
      error('Unknown Input Syntax.')
   end
elseif H~=0
   pname='Position';
elseif H==0
   pname='ScreenSize';
else
   error('Unknown Input Syntax.')
end
hu=get(H,'units');
set(H,'units',u)
p=get(H,pname);
set(H,'units',hu)
