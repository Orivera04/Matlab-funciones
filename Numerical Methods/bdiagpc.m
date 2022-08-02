function r = bdiagpc(nx,ny,ae,aw,as,an,ac,rac,w,d,r)
%   This preconditioner is block diagonal.
Adiag = zeros(nx-1);
for i = 1:nx-1
    Adiag(i,i) = ac;
    if i>1 
        Adiag(i,i-1) = -aw;
    end 
    if i<nx-1
        Adiag(i,i+1) =  -ae;
    end
end
for j = 2:ny
    r(2:nx,j) = Adiag\d(2:nx,j);
end