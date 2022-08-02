function P=mmsetpos(Pin,h,u,hor,ver)
%MMSETPOS Set Position Relative to Another Object. (MM)
% MMSETPOS(P,H,'Units','Horizontal','Vertical') Modifies the position vector P
% as required relative to position rectangle of the object having handle H.
% 'Units' defines the units used and is one of:
%         'pixels', 'normalized', 'points', 'inches', 'cent'.
% 'Horizontal' is one of:
%    'left' - aligns the left edges of P and object H
%  'center' - centers P over object H
%   'right' - aligns the right edges of P and object H
%  'onleft' - places P to the left of object H
% 'onright' - places P to the right of object H
%    'none' - does not change the left edge of P.
%
% 'Vertical' is one of:
% 'bottom' - aligns the bottom edges of P and object H
% 'center' - centers P over object H
%    'top' - aligns the top edges of P and object H
%  'below' - places P under object H
%  'above' - places P over object H
%   'none' - does not change the bottom edge of P
% 
% The resulting position vector is modified as required to fit inside
% the parent of object H using MMFITPOS.
%
% See also MMFITPOS, MMGETPOS.

% Calls: mmgetpos mmfitpos

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 11/11/96, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin<5, ver='none'; end
if nargin<4, hor='none';end
Ph=mmgetpos(h,u);
P=Pin;

switch hor
case 'left',    P(1)=Ph(1);
case 'center',  P(1)=Ph(1)+(Ph(3)-P(3))/2;
case 'right',   P(1)=Ph(1)+Ph(3)-P(3);
case 'onleft',  P(1)=Ph(1)-P(3);
case 'onright', P(1)=Ph(1)+Ph(3);
case 'none'
otherwise,      error('Unknown Horizontal Alignment Chosen.')
end
switch ver
case 'bottom', P(2)=Ph(2);
case 'center', P(2)=Ph(2)+(Ph(4)-P(4))/2;
case 'top',    P(2)=Ph(2)+Ph(4)-P(4);
case 'below',  P(2)=Ph(2)-P(4);
case 'above',  P(2)=Ph(2)+Ph(4);
case 'none'
otherwise,     error('Unknown Vertical Alignment Chosen.')
end
if h==0, P=mmfitpos(P,0,u);
else,    P=mmfitpos(P,get(h,'Parent'),u);
end
