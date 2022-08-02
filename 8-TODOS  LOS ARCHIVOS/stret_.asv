% function stret_(n,L,ds0,ds1) distributes points with 
% stretching function.  calls function delta_. Listado L9.9
% Copyright S. Nakamura, 1995
function s=stret_(n,L,ds0,ds1)      
A=sqrt(ds1/ds0);
B=L/(n-1)/sqrt(ds0*ds1);
if (B<1.0), fprintf('B is less than 1'),pause; end
DL= delta_(B) ;
if DL==0, reutrn, end
for I=1:n   
         X=DL*(I-1)/(n-1) - .5*DL;
         U=.5*(1+tanh(X)/tanh(DL/2.));
         s(I)=U*L/( A + (1.-A)*U);
end


