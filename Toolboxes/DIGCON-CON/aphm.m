function aphm(A,B,L);
%APHM   Analog Phase margin.
%       aphm(A,B,L) computes and prints the phase margin(s) for the
%       loop transfer function described by the state space matrices A,B,L.
%       The maximum margin the function searches for is 120 degrees.

%  R.J. Vaccaro 4/03

j=sqrt(-1);
PMmax=120;
[n,p]=size(B);
cf=pi/180;
for loop = 1:p
  bv=B(:,loop);
  t1=0;
  t2=16;
  skip=0;
  B(:,loop)=exp(-j*t2*cf)*bv;
  while skip==0 & max(real(eig(A-B*L)))<0
    if t2>PMmax
	skip=1;
	pm=t2;
    end
    t2=2*t2;
    B(:,loop)=exp(-j*t2*cf)*bv;
  end
  if skip==0
    while t2-t1 > 0.5
    	tt=(t1+t2)/2;
	B(:,loop)=exp(-j*tt*cf)*bv;
	if  max(real(eig(A-B*L)))>0
	  t2=tt;
	else
	  t1=tt;
	end
    end
    pm=tt;
  end
  phm(loop)=pm;
  fprintf('Phase margin for input #%g is %g degrees\n',loop,...
					round(phm(loop)));
  B(:,loop)=bv;
end
%
%  END OF APHM.M 
