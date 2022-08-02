
function k = isint(x);

% Check whether or not x is an integer number. 
% If it is, function isint returns 1 otherwise it returns 0.

if abs(x - round(x)) < realmin
   k = 1;
else
   k = 0;
end
