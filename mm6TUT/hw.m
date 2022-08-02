function hw(arg)
%HW Shortcut for Helpwin. (MM)
% HW topic or HW('topic') is a shortcut for HELPWIN topic.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 6/14/00
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==0
   helpwin
else
	helpwin(arg)
end