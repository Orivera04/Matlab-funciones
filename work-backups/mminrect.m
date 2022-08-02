function y=mminrect(p,r)
%MMINRECT True when Point is Inside Position Rectangle. (MM)
% Y=MMINRECT(P,RECT) is TRUE when the x-y coordinates in P=[x y]
% are within rectangles defined by the M-by-4 matrix 
% RECT=[left bottom width height;...
%       left bottom width height;...
%       ...]
% Y(i)=1 when P is within RECT(i,:) and 0 otherwise.
% It is assumed that P and RECT are described by the same units.
%
% When P=get(gcf,'CurrentPoint') and RECT is composed of objects
% in gcf, MMINRECT returns the objects the mouse is over.

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 11/5/96, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

y=	p(1)>=r(:,1) & ...
   p(1)<=r(:,1)+r(:,3) & ...
   p(2)>=r(:,2) & ...
   p(2)<=r(:,2)+r(:,4);

