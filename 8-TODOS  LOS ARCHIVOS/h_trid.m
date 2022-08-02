function mat=h_trid(A)
%  H_TRID(A) uses Householder method to form a tridiagonal matrix from A.
%  Must have a SQUARE SYMMETRIC matrix as the input.
%  Example:   >>B=[0 1 1;1 2 1;1 1 1];   
%             >>h_trid(B)
%             ans =
%                         0   -1.4142    0
%                   -1.4142    2.5000    0.5000
%                         0    0.5000    0.5000
[M N]=size(A);
if M~=N | ~all(all(A==A'))  %This just screens matricies that can't work.
   disp('Matrix must be square symmetric only, see help.');
   return
end

format short;
lngth=length(A);  v=zeros(1,lngth)';  I=eye(lngth);  Aold=A;  

for jj=1:lngth-2  % Build each vector j and run the whole procedure.
    v(1:jj)=0;
    v(jj+1)=sqrt(.5*(1+abs(Aold(jj+1,jj))/(ss(Aold,jj)+2*eps)));
    ii=jj+2:lngth;
    v(ii)=Aold(ii,jj)*sign(Aold(jj+1,jj))/(2*v(jj+1)*ss(Aold,jj)+2*eps);
    P=I-2*v*v';
    Anew=P*Aold*P;
    Aold=Anew;
end
Anew(:)=Anew*10^14;  Anew(:)=round(Anew);  Anew(:)=Anew/10^14;
mat=Anew;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function anss=ss(A,jj)
% Subfunction for h_trid.
for ii=jj+1:length(A);
a(ii)=A(ii,jj).^2;
end
anss=sqrt(sum(a));