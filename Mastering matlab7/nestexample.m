function fhandle=nestexample(num,den)
%NESTEXAMPLE Example Nested Function.
%  NESTEXAMPLE(Num,Den) returns a function handle to a function that can
%  be used to evaluate a rational polynomial. Num and Den are vectors
%  containing the numerator and denominator polynomial coefficients.
%
%  For example, ratpoly=nestexample([1 2],[1 2 3]) returns a function
%  handle that facilitates evaluation of the rational polynomial
%
%     x + 2
%  ------------
%  x^2 + 2x + 3

if ~isnumeric(num) || ~isnumeric(den)
   error('Num and Den Must be Numeric Vectors.')
end
num=reshape(num,1,[]); % make num into a row vector
den=reshape(den,1,[]); % make den into a row vector

fhandle=@nested_ratpoly;

   function out=nested_ratpoly(x)
   % Nested function that evaluates a rational polynomial, where the
   % numerator and denominator coefficients are shared with the primary
   % function workspace

   out=polyval(num,x)./polyval(den,x);
end
end