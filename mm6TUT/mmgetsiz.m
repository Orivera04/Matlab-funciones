function s=mmgetsiz(H,u)
%MMGETSIZ Get FontSize in Specified Units. (MM)
% MMGETSIZ(H,'Units') returns the font size associated with the axes, text,
% or uicontrol object having handle H in the units specified by 'Units'.
% 'Units' is one of: 'points', 'normalized', 'pixels', 'inches', 'centimeters'.
%
% MMGETSIZ does the "right thing", i.e., it: (1) saves the current units,
% (2) sets the units to those requested, (3) gets the font size, then
% (4) restores the original units.
%
% MMGETSIZ forces an unavoidable axes redraw for axes and text objects in
% MATLAB versions 5.0, 5.1, 5.2

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if ~ischar(u), error('Units Must be a Valid String.'), end
if ~ishandle(H), error('H is Not a Valid Handle.'), end
switch get(H,'Type')
case {'axes' 'text' 'uicontrol'}
   fu=get(H,'FontUnits');
   set(H,'FontUnits',u)
   s=get(H,'FontSize');
   set(H,'FontUnits',fu)
otherwise
   error('Object Must be an Axes, Text, or UIcontrol Object.')
end
