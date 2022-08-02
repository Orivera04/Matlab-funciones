function g=freqresp(a,b,c,d,iu,s)
%FREQRESP Low level frequency response function.
%
%	G=FREQRESP(A,B,C,D,IU,S)
%	G=FREQRESP(NUM,DEN,S)

%	Clay M. Thompson 7-10-90
%	Copyright (c) 1986-93 by the MathWorks, Inc.

if (nargin==3)
  % It is in transfer function form.  Do directly, using Horner's method
  % of polynomial evaluation at the frequency points, for each row in
  % the numerator.  Then divide by the denominator.
  [ny,nx] = size(a);
  s=c(:);
  for i=1:ny
    g(:,i) = polyval(a(i,:),s);
  end
  g = polyval(b,s)*ones(1,ny).\g;
else
  % It is in state space form.  Reduce to Hessenberg form then directly 
  % evaluate frequency response.
  [ny,nu] = size(d);
  [nx,na] = size(a);
  nw = max(size(s));

  % Balance A
  [t,a] = balance(a);
  b = t \ b;
  c = c * t;
  
  % Reduce A to Hessenburg form
  [p,a] = hess(a);

  % Apply similarity transformations from Hessenberg
  % reduction to B and C:
  if nx>0,
    b = p' * b(:,iu);
    c = c * p;
    d = d(:,iu);
    g = ltifr(a,b,s(:));
    g = (c * g + diag(d) * ones(ny,nw)).';
  else
    d = d(:,iu);
    g = (diag(d) * ones(ny,nw)).';
  end
end
