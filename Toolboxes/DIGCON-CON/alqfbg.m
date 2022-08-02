function L=alqfbg(A,B,Q,R)
%ALQFBG	Analog Linear quadratic feedback gains.
%	L=alqfbg(A,B,Q,R) calculates the optimal feedback gain
%	matrix L such that the feedback law u(t) = - L x(t) minimizes
%	the performance index
%
%	        J = Integral_{zero}^{infinity} {x'(t)Qx(t) + u'(t)Ru(t)} dt
%
%	subject to the constraint equation
%           .
%	        x(t) = A x(t) + B u(t).
%
%	The summation defining J goes from zero to infinity.

% R.J. Vaccaro   4/03

H=[A -B/R*B';-Q -A'];
[u,e]=eig(H);
n=length(H)/2;
X=[];Y=[];k=1;
while k <=2*n
  if real(e(k,k)) < 0
    if imag(e(k,k))==0
	X=[X u(1:n,k)];
	Y=[Y u(n+1:2*n,k)];
        k=k+1;
    else
    	X=[X real(u(1:n,k)) imag(u(1:n,k))];
	Y=[Y real(u(n+1:2*n,k)) imag(u(n+1:2*n,k))];
	k=k+2;
    end
  else
    k=k+1;
  end
end
L=R\B'*Y/X;

%____________________ END OF ALQFBG.M ________________________________
