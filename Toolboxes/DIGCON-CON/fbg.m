function L=fbg(A,B,p,q);
%FBG	Feedback gain matrices.
%
% FUNCTION CALLS (2):
%
% (1) L = fbg(A,B,p);
%
% This calculates a matrix L such that the eigenvalues of A-B*L are
% those specified in the vector p.  Any complex eigenvalues in the 
% vector p must appear in consecutive complex-conjugate pairs.
% The numbers in the vector p must be distinct (see below for repeated roots).
%
% (2) L = fbg(A,B,p,q);
%
% This form allows the user to specify repeated eigenvalues by indicating
% the desired multiplicity in the vector q.  For example, to have a single
% eigenvalue at -2, another at -3 with multiplicity 3, and  complex conjugate 
% eigenvalues at -1+j, -1-j with multiplicity 2,  set p=[-2 -3 -1+j -1-j], 
% and q=[1 3 2 2].  The multiplicity of any eigenvalue cannot be greater
% than the number of columns of B.

%  R.J. Vaccaro 11/93
%__________________________________________________________________________

if (nargin==3)
	q=ones(1,length(p));
end
[n,m]=size(B);
I=eye(n);
npp=length(p);
cvv=[imag(p)==0];
np=npp-sum(~cvv)/2;
i=1;
while i<npp
  if i <= np
  if ~cvv(i)  
	cvv(i+1)=[];
	p(i+1)=[];
	q(i+1)=[];
  end
  end
  i=i+1;
end
if n <= m
  d1=[];d2=[];
  for i=1:np
    if cvv(i)
      d1=[d1 p(i)];
      if i<np
        d2=[d2 0];
      end
    else
      d1=[d1 real(p(i)) real(p(i))];
      if i<np
        d2=[d2 imag(p(i)) 0];
      else
        d2=[d2 imag(p(i))];
      end
    end
  end
  if n > 1
    L=B\(A-(diag(d1)+diag(d2,1)-diag(d2,-1)));
    return
  else
    L=B\(A-d1);
    return
  end
end
sq=sum(q);
AT=[];ATT=[];X=[];X1=[];Y=[];Y1=[];
cv=[];Xb=[];
for i=1:np
cv=[cv cvv(i)*ones(1,q(i))];
end
for i=1:np
	T=null([(p(i)*I-A) B]);
	TT=orth(T(1:n,:));
	AT=[AT T];
	ATT=[ATT TT];
        X(:,i)=TT(:,1:q(i));
	if q(i)==1 & i>1
          %In=find(diag(imag(X)'*imag(X))>0)
          cvt=cv(1:i);In=find(cvt==0);
          c=cond([X conj(X(:,In))]);
	  for j=2:m
	    Y=[X(:,1:i-1) TT(:,j)];
            cc=cond([Y conj(Y(:,In))]) ;
            if cc<c
              c=cc;
	      X(:,i)=TT(:,j);
            end
          end
        end
end
  Xt=X;
cd=1.e15;
if m==n  %can calculate L to get orthogonal eigenvectors
  Ab=zeros(n,n);
  for i=1:np
    Ab(i,i)=real(p(i));
    if ~cv(i)
	Ab(i,i+1)=-imag(p(i));
 	Ab(i+1,i)=imag(p(i));
	Ab(i+1,i+1)=real(p(i));
    end
   end
  L=B\(A-Ab);
  return
end
if m>1
    for k = 1:5,
	X2=[];
	kk=0;
	for i=1:np
	    Pr = ATT(:,(i-1)*m+1:i*m); Pr = Pr*Pr';
	for j=1:q(i)
	    kk=kk+1;
	    S = [ Xt(:,1:kk-1) Xt(:,kk+1:sq) ]; S = [ S conj(S) ];
	    if ~cv(kk)
		S=[S conj(Xt(:,kk))];
	    end
	%    if (n==2 & np==1)
		%S=conj(Xt);
	    %end
	    [Us,Ss,Vs] = svd(S);
            Xt(:,kk) = Pr*Us(:,n); Xt(:,kk) = Xt(:,kk)/norm(Xt(:,kk));
	    if ~cv(kk)
		X2=[X2 conj(Xt(:,kk))];
	    end
	end
	end
	c=cond([Xt X2]);
	if c<cd
	     Xtf=Xt;
	     cd=c;
	end
    end
    else
	Xtf=X;
end
kkk=0;
X1=[];X2=[];
for i=1:np
	for j=1:q(i)
		kkk=kkk+1;
		if cv(kkk)
		    x=real(Xtf(:,kkk));y=imag(Xtf(:,kkk));
	  	    if norm(x) > norm(y)
			Xtf(:,kkk)=x/norm(x);
		    else
			Xtf(:,kkk)=y/norm(y);
		    end
		end
		a=AT(1:n,(i-1)*m+1:i*m)\Xtf(:,kkk);
		t=AT(n+1:n+m,(i-1)*m+1:i*m)*a;
		x=imag(t);
		Xb=[Xb real(t)];
		if ~cv(kkk)
		    X2=[X2 x];
		    X1=[X1 imag(Xtf(:,kkk))];
		    Xtf(:,kkk)=real(Xtf(:,kkk));
		end
	end
end
L=[Xb X2]/[Xtf X1];
return

%_____________________ END OF FBG.M ____________________________
