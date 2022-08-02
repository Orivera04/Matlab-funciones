function S = FourierS(x),
% FourierS  Fourier Sine Integral.
%   Y = FourierC(X) is the Fourier Sine Integral for each element of X,
%   where X must be real. The Fourier Sine Integral is defined as:
%
%   FourierS(x) =  integral from 0 to x of sin(pi/2 * t.^2) dt.
%
%   Based upon formula given in Numerical Recipes in Fortran,
%   page 248-249.
%
%   See also FourierC, ERF, ERFC, ERFCX, ERFINV.
S = zeros(size(x));
nn = find(abs(x)<3);
mmp = find(x>=3);
mmn = find(x<=-3);

%Create polynomial for x<3
    for n=0:50,
        p((4*n+3)+1)=((pi/2).^(2*n+1))./( (4*n+3)*factorial(2*n+1) ) * (-1).^n;
    end;
    p=fliplr(p);
   
    S(nn) = polyval(p,x(nn));

%Approximation for x>3

    S(mmp) = 0.5 - cos(pi/2*x(mmp).^2)./(x(mmp).*pi);
   
%Approximation for x<-3

    S(mmn) = -0.5 - cos(pi/2*x(mmn).^2)./(x(mmn).*pi);