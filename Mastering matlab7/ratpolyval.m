function out=ratpolyval(num,den,x)
%RATPOLYVAL Evaluate Rational Polynomial.
% RATPOLYVAL(Num,Den,X) evaluates the rational polynomial, whose
% numeraotr and denominator coefficients are given by the vectors
% Num and Den respectively, at the points given in X.

if ~isnumeric(num) || ~isnumeric(den)
   error('Num and Den Must be Numeric Vectors.')
end
num=reshape(num,1,[]); % make num into a row vector
den=reshape(den,1,[]); % make den into a row vector

out=polyval(num,x)./polyval(den,x);