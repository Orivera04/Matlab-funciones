function C = FourierC(X),
% FourierC  Fourier Cosine Integral.
%   Y = FourierC(X) is the Fourier Cosine Integral for each element of X,
%   where X must be real. The Fourier Cosine Integral is defined as:
%
%   FourierC(x) =  integral from 0 to x of cos(pi/2 * t.^2) dt.
%
%   Based upon formula given in Numerical Recipes in Fortran,
%   page 248-249.
%
%   See also FourierS, ERF, ERFC, ERFCX, ERFINV.
C = zeros(size(x));
nn = find(abs(x)<3);
mmp = find(x>=3);
mmn = find(x<=-3);

%Create polynomial for x<3
    for n=0:50,
        p((4*n+1)+1)=((pi/2).^(2*n))./( (4*n+1)*factorial(2*n) ) * (-1).^n;
    end;
    p=fliplr(p);
   
    C(nn) = polyval(p,x(nn));

%Approximation for x>3

    C(mmp) = 0.5+sin(pi/2*x(mmp).^2)./(x(mmp).*pi);
   
%Approximation for x<-3

    C(mmn) = -0.5 + sin(pi/2*x(mmn).^2)./(x(mmn).*pi);


