function u=fshift(x,varargin)
% u=fshift(x,varargin)
% This function shifts arguments to produce
% a nonsingular integrand called by quadl
N=length(varargin); fname=varargin{N};
c=varargin{N-1}; type=varargin{N-2};
a=c(1); b=c(2); c1=(b+a)/2; c2=(b-a)/2;

switch type
  case 1, t=a+x.^2; case 2, t=b-x.^2;
  case 3, t=c1+c2*cos(x);
end

if N>3, u=feval(fname,t,varargin{1:N-3});
else, u=feval(fname,t); end