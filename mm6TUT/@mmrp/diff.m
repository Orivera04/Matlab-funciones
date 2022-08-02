function s=diff(r)
%DIFF Differentiate Rational Polynomial Object. (MM)

% D.C. Hanselman, University of Maine, Orono ME 04469
% 3/27/98
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

[a,b]=polyder(r.n,r.d);
s=mmrp(a,b,r.v);
