function y=mmsinc(x)
%MMSINC Sin(x)/x Function (MM).
% MMSINC(X) returns an array the same size as X whose elements
% are the the unnormalized sinc function of X, i.e.,
%        y = sin(x)/x    if x ~= 0
%          = 1           if x == 0

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 8/3/99
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

y=ones(size(x));
i=find(x);
y(i)=sin(x(i))./(x(i));
