function p=polymake(varargin)
%POLYMAKE Create Polynomial From Roots Locations and Polynomials.
% POLYMAKE returns a standard polynomial row vector created from input
% arguments. Input arguments can be any combination of root locations,
% polynomials, as well as addition and subtraction.
% Polynomials must be real valued, so roots must appear in complex
% conjugate pairs.
%
% 1)Root locations can be entered as separate input arguments, e.g.,
%    POLYMAKE(-1,-2,-3) = POLY([-1;-2;-3]) <==> (x+1)(x+2)(x+3)
%
% 2)Inputs can be column vectors of ROOTS, e.g.,
%   POLYMAKE(-1,[-2;-3],-4) = POLY([-1;-2;-3;-4]) <==> (x+1)(x+2)(x+3)(x+4)
%
% 3)Input arguments can be ROW vectors of POLYNOMIALS. e.g.,
%   POLYMAKE(0,-1,[1 2 2]) = POLY([0;-1;ROOTS([1 2 2])]) <==> x(x+1)(x^2+2x+2)
%
% 4)Polynomials can be added to create new polynomials, e.g.,
%   POLYMAKE(-1,'+',[1 2 2],'-',-2,-3) <==> (x+1) + (x^2+2x+2) - (x+2)(x+3)
%
% See also POLY, ROOTS, POLYDER, POLYINT, POLYFIT, POLYVAL

% D.C. Hanselman, University of Maine, Orono, ME 04469
% MasteringMatlab@yahoo.com
% Mastering MATLAB 7
% 2006-02-02

if nargin<1
   error('At Least One Input Argument Required.')
end
p=1; % polynomial storage

for k=1:nargin
   arg=varargin{k};
   switch class(arg)
   case {'single' 'double'}
      if numel(arg)==1 || iscolumn(arg)                    % root locations
         for kr=1:length(arg)
            p=conv(p,[1 -arg(kr)]);
         end
      elseif isrow(arg)                                        % polynomial
         p=conv(p,arg);
      else
         error('Numeric Input Must be a Scalar or Vector.')
      end
   case 'char'                                                     % + or -
      if strcmp(arg(1),'+')     % recursive call to get rest
         p=polytrim(polyadd(p,polymake(varargin{k+1:end})));
         return
      elseif strcmp(arg(1),'-') % recursive call to get rest
         p=polytrim(polyadd(p,-polymake(varargin{k+1:end})));
         return
      else
         error('''+'' or ''-'' expected.')
      end
   otherwise
      error('Single, Double, or Character Input Expected.')
   end
end
p=polytrim(p);
%--------------------------------------------------------------------------
function p=polyadd(a,b)
% add two polynomials
na=length(a);	% find lengths of a and b
nb=length(b);
p=[zeros(1,nb-na) a]+[zeros(1,na-nb) b];  % pad with zeros as necessary
%--------------------------------------------------------------------------
function p=polytrim(p)
% trim leading 0 coefficients from polynomial
% trim negligible coefficients including any spurious imaginary terms
tf=abs(p)<=eps*(10+max(abs(p)));                       % small coefficients
p(tf)=0;
tf=abs(imag(p))<=eps*(10+abs(real(p)));             % small imaginary parts
p(tf)=real(p(tf));
idx=find(abs(p)>0,1);
if isempty(idx)
   p=[];
else
   if any(abs(imag(p))>eps*(10+abs(real(p))))     % error if complex valued
      error('Polynomial Must be Real Valued.')
   end
   p=real(p(idx:end));
end
%--------------------------------------------------------------------------
function tf=iscolumn(x)
% true for column vector
% isvector exists in R14, but I want this to work pre R14
s=size(x);
tf= length(s)==2 && s(1)>1 && s(2)==1;
%--------------------------------------------------------------------------
function tf=isrow(x)
% true for row vector
s=size(x);
tf= length(s)==2 && s(1)==1 && s(2)>1;