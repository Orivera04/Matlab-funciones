 function [intg] = polyintg(poly,c);
% POLYINTG : Integrate a polynomial
%
%function [intg] = polyintg(poly);
%function [intg] = polyintg(poly,c);
%
% Simple integration a polynomial (with no denominator)
% Optional : c = constant of integration, Default value = zero.
%
% See also : polyder
if nargin == 1, c = 0; end;
intg = [poly./(length(poly):-1:1) c];
