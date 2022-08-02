% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%																													
% (ch2p4): An F(s) in factored form can be represented in polynomial form. 
% Thus P3 = (s+2)(s+5)(s+6) can be transformed into a polynomial using poly(V), 
% where V is a row vector containing the roots of the polynomial and poly(V) 
% forms the coefficients of the polynomial.

'(ch2p4)'                            % Display label.
P3=poly([-2 -5 -6])                  % Store polynomial
                                     % (s+2)(s+5)(s+6) as P3 and 
                                     % display the coefficients          
