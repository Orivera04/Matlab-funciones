function [F,G,H,K,P]=roo(phi,gamma,Cm,zr)
%ROO	Discrete-time reduced-order observer design.
%	[F,G,H,K,P]=roo(phi,gamma,Cm,zr) calculates the reduced-order
%	observer matrices F,G,H,K for the discrete-time system
%
%	      x[k+1] = phi x[k] + gamma u[k]
%	      ym[k]  = Cm x[k].
%
%	The vector zr contains the desired observer poles (eigenvalues
%	of F).  The matrix P is calculated such that the transformed
%	measurement matrix is	Cm * inv(P) = [ I  0 ].
%
%	Estimates xhat[k] of the state vector x[k] are produced from the
%	input sequence u[k] and the measurements ym[k] as follows:
%	                                                          _       _	
%	z[k+1] = F z[k] + G ym[k] + H u[k]   |                   |  ym[k]  |
%	 w[k]  = z[k] + K ym[k]              |  xhat[k] = inv(P)*|         |
%	                                     |                   |   w[k]  |
%	                                                          -       -
%	If at least half of the state variables are measured
%	(i.e. rows of Cm are greater than or equal to half the rows of gamma) 
%	and zr contains only real numbers, then the calculated F will be a
%	diagonal matrix.

% R.J. Vaccaro 10/93

[n,p]=size(gamma);
[m,n]=size(Cm);
[u,s,v]=svd(Cm);
v2=v(:,m+1:n);
P=[Cm;v2'];
phib=P*phi/P;
gammab=P*gamma;
phi11=phib(1:m,1:m);
phi12=phib(1:m,m+1:n);
phi21=phib(m+1:n,1:m);
phi22=phib(m+1:n,m+1:n);
gamma1=gammab(1:m,:);
gamma2=gammab(m+1:n,:);
if  m >= n/2 & rank(phi12)==n-m  %Use Case 1 Equations
  d1=[];d2=[];
  ct=0;
  for i=1:n-m
    if imag(zr(i))==0
      ct=0;
      d1=[d1 zr(i)];
      if i<n-m
        d2=[d2 0];
      end
    else
      ct=ct+1;
      if ct<2
        d1=[d1 real(zr(i)) real(zr(i))];
        if i<n-m-sum(~imag(zr)==0)/2
          d2=[d2 imag(zr(i)) 0];
        else
          d2=[d2 imag(zr(i))];
        end
      else
        ct=0;
      end
    end
  end
  if n-m>1
    F=diag(d1)+diag(d2,1)-diag(d2,-1);
    else
    F=d1;
  end
K=(phi22-F)/phi12;
else
K=fbg(phi22',phi12',zr);K=K';
F=phi22-K*phi12;
end
H=gamma2-K*gamma1;
G=phi21-K*phi11+F*K;

%_______________________ END OF ROO.M ______________________________

