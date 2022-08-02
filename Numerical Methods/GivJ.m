

function J = GivJ(x1, x2)

% Givens plane rotation J = [c s;-s c]. Entries c and s
% are computed using numbers x1 and x2.

if x1 == 0 & x2 == 0
   J = eye(2);
   return
end
if abs(x2) >= abs(x1) 
   t = x1/x2;
   s = 1/sqrt(1+t^2);
   c = s*t;
else
   t = x2/x1;
   c = 1/sqrt(1+t^2);
   s = c*t;
end
J = [c s;-s c];

