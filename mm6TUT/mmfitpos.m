function P=mmfitpos(Pin,h,u)
%MMFITPOS Fit Position Within Another Object. (MM)
% MMFITPOS(P,H,'Units') Modifies the position vector P as required to
% make it fit within the position rectangle of the object having handle H.
% 'Units' defines the units used and is one of:
%         'pixels', 'normalized', 'points', 'inches', 'cent'.
% 
% If H=0, P is modified to fit on the screen. If H points to a figure, P
% is modified to fit within the figure window. If the left and bottom of P
% cannot be moved enough to fit, the width and height are changed.
%
% See also MMGETPOS, MMSETPOS.

% Calls: mmgetpos

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 11/11/96, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin<3
   error('MMFITPOS(P,H,''Units'') Requires 3 Input Arguments.')
end
Ph=mmgetpos(h,u);

P=Pin;
if P(3)>Ph(3), P(3)=Ph(3); end
if P(4)>Ph(4), P(4)=Ph(4); end
if P(1)<Ph(1), P(1)=Ph(1); end
if P(2)<Ph(2), P(2)=Ph(2); end
if P(1)+P(3)>Ph(3), P(1)=Ph(3)-P(3); end
if P(2)+P(4)>Ph(4), P(2)=Ph(4)-P(4); end
