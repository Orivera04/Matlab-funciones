function L=lqfbg(phi,gamma,Q,R)
%LQFBG	Linear quadratic feedback gains.
%	L=lqfbg(phi,gamma,Q,R) calculates the optimal feedback gain
%	matrix L such that the feedback law u[k] = - L x[k] minimizes
%	the performance index
%
%	        J = Sum {x'[k]Qx[k] + u'[k]Ru[k]}
%
%	subject to the constraint equation
%
%	        x[k+1] = phi x[k] + gamma u[k].
%
%	The summation defining J goes from zero to infinity.

% R.J. Vaccaro   3/94

phit=inv(phi)';
phq=phit*Q;
H=[phi+gamma/R*gamma'*phq -gamma/R*gamma'*phit;
	-phit*Q phit];
[u,e]=eig(H);
n=length(H)/2;
X=[];Y=[];k=1;
while k <=2*n
  if abs(e(k,k)) < 1
    if imag(e(k,k))==0
	X=[X u(1:n,k)];
	Y=[Y e(k,k)*u(n+1:2*n,k)];
        k=k+1;
    else
    	X=[X real(u(1:n,k)) imag(u(1:n,k))];
	Y=[Y real(e(k,k)*u(n+1:2*n,k)) imag(e(k,k)*u(n+1:2*n,k))];
	k=k+2;
    end
  else
    k=k+1;
  end
end
L=R\gamma'*Y/X;

%____________________ END OF LQFBG.M ________________________________
