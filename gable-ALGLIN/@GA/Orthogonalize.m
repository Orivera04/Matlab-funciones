function N = Orthogonalize(normal,basis,CLsize)
%Orthogonalize(n,b,s): Gives a basis orthogonal to the normal.
%First argument is the normal vector, second is the basis matrix
%third is the size of a GA (optional).
if nargin<3
    CLsize=8;
end
N=[];  
ni=normal;   
Imax=size(basis,2);
for i=Imax:-1:1
    Ii=inverse(ni);
    for j = 1:i
	m = GAproduct(GAouter(GA(basis(1:CLsize,j)),ni),Ii);
	R(1:CLsize,j) = m.m;
    end
    T=R(1:CLsize,1);
    ni=GA(T)
    v=norm(ni);
    if v == 0
	M = T;
    else
	M = (1/v)*T;
    end
    N=[N,M];
    basis=basis(1:CLsize,2:size(basis,2));
end
