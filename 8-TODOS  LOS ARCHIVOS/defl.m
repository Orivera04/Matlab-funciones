
function B = defl(A,v1)

% Deflated matrix B from the matrix A with a known eigenvector v1.
% Functions used: Housv and Houspre.

n = length(v1);
v1 = Housv(v1);
C = Houspre(v1,A);
B = [];
for i=1:n
   B = [B Housmvp(v1,C(i,:))];
end
B = B(2:n,2:n);

function y = Housmvp(u,x)

% Product y = P*x, where P is the Householder transformation
% generated by the vector u, i.e., P = I - 2*u*u'/(u'*u).

u = u/norm(u);
y = x(:) - 2*(u(:)'*x(:))*u(:);
   
   


   

   

   