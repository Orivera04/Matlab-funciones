
function [m, r] = rep4(x)

% Given a nonnegative number x, function rep4 computes an integer m
% and a real number r, where 0.25 <= r < 1, such that x = (4^m)*r.

if x == 0
   m = 0;
   r = 0;
   return
end
u = log10(x)/log10(4);
if u < 0
   m = floor(u)
else
   m = ceil(u);
end
r = x/4^m;

