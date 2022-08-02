function y=mmpa(x,t)
%MMPA Principal Angle. (MM)
% MMPA(X) or MMPA(X,'rad') returns the principal angles associated with
% the elements of X. That is, it maps the values in X to the range
% -pi <= MMPA(X) < pi.
%
% MMPA(X,'deg') maps X in degrees to the range -180 <= MMPA(X,'deg') < 180.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 4/3/99
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==1, t='r'; end

switch lower(t(1))
case 'r'
   y=mod(x+pi,2*pi)-pi;
case 'd'
   y=mod(x+180,360)-180;
otherwise
   error('Unknown Second Argument.')
end
