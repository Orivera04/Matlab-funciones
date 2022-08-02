function [c,varargout] = bisection(f,a,b,delta)

% Computes the root of a function f by bisectioning.
%
% Computes the root of a continuous function f in the interval [a,b] by
% bisectioning.
% 
% For this algorithm the function values of endpoints must differ in sign.
% 
% Usage: [c,fc,err] = bisection(f,a,b,delta)
% 
% Input arguments:
%     f function 
%     a left endpoint
%     b right endpoint
%     delta error tolerance
% Output arguments:
%     c solution
% Optional Output arguments:
%     fc function value of solution
%     err error estimate
%
% Source:
% Numerical Mathematics By Alfio. Quarteroni, Riccardo. Sacco, Fausto. Saleri
% 	
% By Alfio. Quarteroni, Riccardo. Sacco, Fausto. Saleri
% Published 2000
% Springer
% 654 pages
% ISBN 0387989595
% 
% Example usage:
% Find the root of cos in [0,2] with error tolerance 0.0001
% 
% [x,fx,err]=bisection(@cos,0,2,0.0001)
% x =
%     1.5707
% fx =
%    5.6581e-05
% err =
%    6.1035e-05


disp(nargchk(4,4,nargin))       % Allow 4 inputs
disp(nargoutchk(1,3,nargout))   % Allow 1 to 3 outputs

fa=feval(f,a);
fb=feval(f,b);

if fa*fb>0
    error('MATLAB:incorrectValue',...
        'function values of endpoints must differ in sign');
end

% number of iterations required to obtain an error smaller than delta
maxIt=round((log(b-a)-log(delta))/log(2)); 
k=0;
while k<maxIt && b-a>delta
    k=k+1;
    c=(a+b)/2;
    fc=feval(f,c);
    if fc==0
        a=c;
        b=c;
    elseif fa*fc<0
        b=c;
        fb=fc;
    elseif fb*fc<0
        a=c;
        fa=fc;
    else
        error('MATLAB:incorrectValue','function f has to be continuous');
    end
end
c=(a+b)/2;

if nargout>=2
    varargout(1)={feval(f,c)};
end
if nargout>=3
    varargout(2)={abs(b-a)/2};
end


end
