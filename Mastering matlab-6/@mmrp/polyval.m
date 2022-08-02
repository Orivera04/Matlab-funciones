function y=polyval(p,x)
%POLYVAL Evaluate Rational Polynomial Object.
% POLYVAL(P,X) evaluates the rational polynomial P at the
% values in X.

% D.C. Hanselman, University of Maine, Orono ME 04469
% 7/22/00
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if isnumeric(x)
   %y=p(x); % what we'd like to do, but can't
   S.type='()';
   S.subs={x};
   y=subsref(p,S); % must call subsref directly
else
   error('Second Input Argument Must be Numeric.')
end
