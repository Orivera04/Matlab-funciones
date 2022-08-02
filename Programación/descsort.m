
function [b, j] = descsort(a)

% Function descsort sorts, in the descending order, a real array a.
% Second output parameter j holds a permutation used to obtain
% array b from the array a.

[b ,j] = sort(-a);
b = -b;
 

