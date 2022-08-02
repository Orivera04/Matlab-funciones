function int = filonmod(func,case,k,l,u,n)
% Implements filon's integration.
%
% Example call: int = filon(func,case,k,l,u,n)
% If case = 1, integrates cos(kx)*f(x) from l to u using n divisions.
% If case ~= 1, integrates sin(kx)*f(x) from l to u using n divisions.
% User defined function func defines f(x).
%
if (n/2)~=floor(n/2)
  disp('n must be even'); break
else
  h=(u-l)/n;
  q=k*h;q2=q*q;q3=q*q2;
  a=(q2+q*sin(2*q)/2-2*(sin(q))^2)/q3;
  b=2*(q*(1+(cos(q))^2)-sin(2*q))/q3;
  d=4*(sin(q)-q*cos(q))/q3;
  x=[l:h:u]; y=feval(func,x);
  yodd=y(2:2:n); yeven=y(3:2:n-1);
  if case==1
    c=cos(k*x);
    codd=c(2:2:n); co=codd*yodd';
    ceven=c(3:2:n-1);
    ce=(y(1)*c(1)+y(n+1)*c(n+1))/2; ce=ce+ceven*yeven';
    int=h*(a*(y(n+1)*sin(k*u)-y(1)*sin(k*l))+b*ce+d*co);
  else
    s=sin(k*x);
    sodd=s(2:2:n); so=sodd*yodd';
    seven=s(3:2:n-1);
    se=(y(1)*s(1)+y(n+1)*s(n+1))/2; se=se+seven*yeven';
    int=h*(-a*(y(n+1)*cos(k*u)-y(1)*cos(k*l))+b*se+d*so);
  end
end
