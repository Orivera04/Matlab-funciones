%%NAME
%%  elineip  - linear interpolation of a vector 
%%
%%SYNOPSIS
%%  yi=elineip(x,y,xi)
%%
%%PARAMETER(S)
%%  x             sample x vector
%%  y             sample y vector
%%  xi            x vector for interpolation
%%  yi            interpolated y vector
%%
% written by Stefan Mueller stefan.mueller@fgan.de (C) 2003
function yi=elineip(x,y,xi)
   if (nargin ~= 3)
    eusage('yi= elineip(x,y,xi)');
  end

  n=length(x);
  [sv sp]=sort([x xi]);
  idx(sp)=cumsum(sp<n);
  idx=idx(n+1:n+length(xi));
  in=1:n-1;
  inp=in+1;
  dy=y(inp)-y(in);
  dx=x(inp)-x(in);
  nz=find(dx);
  m=dx-dx;
  m(nz)=dy(nz)./dx(nz);
  yi=(xi-x(idx)).*m(idx)+y(idx);
