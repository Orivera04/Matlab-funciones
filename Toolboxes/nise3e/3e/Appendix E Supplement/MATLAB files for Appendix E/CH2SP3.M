% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% ch2sp3     MATLAB's Symbolic Math Toolbox may be used to simplify the input 
% of complicated transfer functions as follows: Initially, input the transfer 
% function, G(s) = numg/deng, via symbolic math statements. Then, convert 
% G(s) to an LTI transfer function object. This conversion is done in two steps. 
% The first step uses the command [numg,deng]=numden(G) to extract the symbolic 
% numerator and denominator of G. The second step converts, separately, the 
% numerator and denominator to vectors using the command sym2poly(S), where S 
% is a symbolic polynomial. The last step consists of forming the LTI transfer 
% function object using the vector representation of the transfer function's 
% numerator and denominator. As an example, we form the LTI object, 
% G(s) = [54(s+27)(s^3+52s^2+37s+73)]/
% [s(s^4+872s^3+437s^2+89s+65)(s^2+79s+36)] making use of MATLAB's Symbolic 
% Math Toolbox for simplicity and readability.

'(ch2sp3)'                    % Display label.
syms s                        % Construct symbolic object for 
                              % frequency variable 's'.
G=54*(s+27)*(s^3+52*s^2+37*s+73)...
/(s*(s^4+872*s^3+437*s^2+89*s+65)*(s^2+79*s+36));
                              % Form symbolic G(s).
'Symbolic G(s)'               % Display label.
pretty(G)                     % Pretty print symbolic G(s).
[numg,deng]=numden(G);        % Extract symbolic numerator and denominator.
numg=sym2poly(numg);          % Form vector for numerator of G(s).
deng=sym2poly(deng);          % Form vector for denominator of G(s).
'LTI G(s) in Polynomial Form' % Display label.
Gtf=tf(numg,deng)             % Form and display LTI object for G(s) in
                              % polynomial form.
'LTI G(s) in Factored Form'   % Display label.						 
Gzpk=zpk(Gtf)                 % Convert G(s) to factored form.
