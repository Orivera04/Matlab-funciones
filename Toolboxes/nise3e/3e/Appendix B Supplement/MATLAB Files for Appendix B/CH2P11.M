% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%																													
% (ch2p11):LTI models can also be converted between polynomial and factored forms.
% MATLAB commands tf and zpk are also used for the conversion between
% LTI models. If a transfer function,  Fzpk(s), is expressed as factors in the 
% numerator and denominator, then tf(Fzpk) converts Fzpk(s) to a transfer function
% expressed as coefficients in the numerator and denominator. Similarly, if a 
% transfer function,  Ftf(s) is expressed as coefficients in the numerator and 
% denominator, then zpk(Ftf) converts Ftf(s) to a transfer function expressed as 
% factors in the numerator and denominator. The following example demonstrates
% the concepts.

'(ch2p11)'                          % Display label.
'Fzpk1(s)'                          % Display label.
Fzpk1=zpk([-2 -4],[0 -3 -5],10)     % Form Fzpk1(s)=
                                    % 10(s+2)(s+4)/[s(s+3)(s+5)].
'Ftf1'                              % Display label.
Ftf1=tf(Fzpk1)                      % Convert Fzpk1(s) to 
                                    % coefficients form.
'Ftf2'                              % Display label.
Ftf2=tf([10 40 60],[1 4 5 7])       % Form Ftf2(s)= 
                                    % (10s^2+40s+60)/(s^3+4s^2+5s+7).
'Fzpk2'                             % Display label.
Fzpk2=zpk(Ftf2)                     % Convert Ftf2(s) to 
                                    % factored form.
