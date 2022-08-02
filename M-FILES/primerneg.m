function [m, j] = primerneg(d)

% Implementation of the Bland's rule applied to the array d.
% Output parameters:
% m - first negative number in the array d
% j - index of the entry m.
% This function is called from within the following functions:
% simplex2p, dsimplex, addconstr, simplex and cpa. 


ind = find(d < 0);
if ~isempty(ind)
   j = ind(1);
   m = d(j);
else
   m = [];
   j = [];
end

