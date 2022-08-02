function z=mmpoly(varargin)
%MMPOLY Make Real Polynomials from Root Locations and Polynomials. (MM)
% This function combines POLY, MMPADD, and CONV. MMPOLY features:
% 1)Root locations can be entered as separate input arguments. e.g.,
%   MMPOLY(-1,-2,-3)=POLY([-1;-2;-3])=(x+1)(x+2)(x+3)
%
% 2)Input arguments can be COLUMN vectors of ROOTS. e.g.,
%   MMPOLY(-1,[-2;-3],-4)=POLY([-1;-2;-3;-4]) = (x+1)(x+2)(x+3)(x+4)
%
% 3)Input arguments can be ROW vectors of POLYNOMIALS. e.g.,
%   MMPOLY(0,-1,[1 2 2])=POLY([0;-1;ROOTS([1 2 2])]) = x(x+1)(x^2+2x+2)
%
% 4)The output is always a REAL polynomial. Complex conjugate
%   roots are added if they do not appear in the input. e.g.,
%   MMPOLY(0,-1+j*2)=POLY([0;-1+j*2;-1-j*2]) = x^3+2x^2+5x
%
% 5)Polynomials can be added to make other polynomials. e.g.,
%   MMPOLY(-1,'+',[1 2 2],'-',-1,-2) = (x+1)+(x^2+2x+2)-(x+1)(x+2)
%
% See also MMPADD, MMPSIM, MMPSCALE, MMPSHIFT, MMP2STR, POLY, CONV.

% Calls: mmpadd mmpsim

% D.C. Hanselman, University of Maine, Orono ME,  04469
% 5/1/96, revised 7/7/96, v5: 5/8/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

tol=100*sqrt(eps);
z=0;psign=1;x=[];xf=1;
for i=1:nargin
   si=varargin{i};
   [r,c]=size(si);
   if ischar(si),               % +/- sign
      y=x(find(imag(x)));
      for n=1:length(y)
         if isempty(find(abs(y-conj(y(n)))<=tol*abs(y(n))))
            x=[x;conj(y(n))];
         end
      end
      z=mmpadd(z,psign*xf*real(poly(x)));
      psign=2*(si=='+')-1;x=[];xf=1;
   elseif c>1,                 % polynomial
      si=mmpsim(si);xf=xf*si(1);si=roots(si);x=[x;si];
   else                        % roots
      x=[x;si];
   end
end
y=x(find(imag(x)));
for n=1:length(y)
   if isempty(find(abs(y-conj(y(n)))<=tol*abs(y(n))))
      x=[x;conj(y(n))];
   end
end
z=mmpsim(mmpadd(z,psign*xf*real(poly(x))));
