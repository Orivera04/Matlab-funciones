function q = gauss2v(func,a,b,c,d,n)
% Implements  2 variable Gaussian integration.
%
% Example call: q = gauss2v(func,a,b,c,d,n)
% Integrates user defined 2 variable function func, see page 154.
% Range for first variable is a to b, and second variable, c to d
% using n divisions of each variable.
% n must be 2 or 4 or 8 or 16.
%
if ((n==2)|(n==4)|(n==8)|(n==16))
  co=zeros(8,4); t=zeros(8,4);
  co(1,1)=1;
  co(1:2,2)=[.6521451548; .3478548451];
  co(1:4,3)=[.3626837833; .3137066458; .2223810344; .1012285362];
  co(:,4)= [.1894506104; .1826034150; .1691565193; .1495959888; ...
            .1246289712;.0951585116; .0622535239; .0271524594];
  t(1,1)  = .5773502691;
  t(1:2,2)=[.3399810435; .8611363115];
  t(1:4,3)=[.1834346424; .5255324099; .7966664774; .9602898564];
  t(:,4)  =[.0950125098; .2816035507; .4580167776; .6178762444; ...
            .7554044084; .8656312023; .9445750230; .9894009350];
  j=1;
  while j<=4
    if 2^j==n;break;
    else
      j=j+1;
    end
  end
  s=0;
  for k=1:n/2
    x1=(t(k,j)*(b-a)+a+b)/2; x2=(-t(k,j)*(b-a)+a+b)/2;
    for p=1:n/2
      y1=(t(p,j)*(d-c)+d+c)/2; y2=(-t(p,j)*(d-c)+d+c)/2;
      z=feval(func,x1,y1)+feval(func,x1,y2)+feval(func,x2,y1);
      z=z+feval(func,x2,y2); s=s+co(k,j)*co(p,j)*z;
    end
  end
  q=(b-a)*(d-c)*s/4;
else
  disp('n must be equal to 2, 4, 8 or 16');break
end
