

function u = Housv(x)

% Householder unit vector u from the vector x.


m = max(abs(x));
if m == 0
   error('Vector x cannot be a zero vector')
else
   u=x/m;
end
if ( u(1) == 0 )
   su = 1;
else
   su = sign(u(1));
end
u(1) = u(1)+ su*norm(u);
u = u/norm(u);
u = u(:);

