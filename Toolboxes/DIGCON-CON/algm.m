function algm(A,B,L);
%ALGM   Analog Lower gain  margin.
%       algm(A,B,L) computes and prints the lower gain margin(s) for the
%       loop transfer function described by the state space matrices A,B,L.
%       The maximum margin the function searches for is -30 dB.

%  R.J. Vaccaro 4/03

LGmin=1/31;
[n,p]=size(B);
for loop = 1:p
  bv=B(:,loop);
  t1=1;
  t2=1/2;
  skip=0;
  B(:,loop)=t2*bv;
  while skip==0 & max(real(eig(A-B*L)))<0
    if t2<LGmin
	skip=1;
	lg=t2;
    end
    t2=t2/2;
    B(:,loop)=t2*bv;
  end
  if skip==0
    while 20*log10(t1/t2)>0.001
    	tt=(t1+t2)/2;
	B(:,loop)=tt*bv;
	if  max(real(eig(A-B*L)))>0
	  t2=tt;
	else
	  t1=tt;
	end
    end
    lg=tt;
  end
  lgm(loop)=20*log10(lg);
  fprintf('Lower gain margin for input #%g is %g dB\n',loop,...
					round(100*lgm(loop))/100);
  B(:,loop)=bv;
end
%
%  END OF AbLGM.M 
