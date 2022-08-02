% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%																													
% (ch2p9): Creating Transfer Functions
% Vector Method, Polynomial Form: 
% A transfer function can be expressed as a numerator polynomial divided by a 
% denominator polynomial, i.e. F(s) = N(s)/D(s). The numerator, N(s), is 
% represented by a row vector, numf, that contains the coefficients of N(s). 
% Similarly, the denominator, D(s), is represented by a row vector, denf, that 
% contains the coefficients of D(s). We form F(s) with the command, 
% F = tf(numf,denf). F is called a linear time-invariant (LTI) object. This object,
% or transfer function, can be used as an entity in other operations, such as 
% addition or multiplication. We demonstrate with F(s) = 150(s^2+2s+7)/[s(s^2+5s+4)]. 
% Notice after executing the tf command, MATLAB prints the transfer function. 
%
% Vector Method, Factored Form: 
% We also can create LTI transfer functions if the numerator and denominator are
% expressed in factored form. We do this by using row vectors containing the roots of 
% the numerator and denominator. Thus G(s) = K*N(s)/D(s) can be expressed as an LTI 
% object using the command, G = zpk(numg,deng,K), where numg is a row vector containing 
% the roots of N(s) and deng is a row vector containing the roots of D(s). The expression 
% zpk stands for zeros (roots of the numerator), poles (roots of the denominator), 
% and gain, K. We demonstrate with G(s) = 20(s+2)(s+4)/[(s+7)(s+8)(s+9)]. Notice after 
% executing the zpk command, MATLAB prints the transfer function.
%
% Rational Expression in s Method, Polynomial Form (Requires Control System Toolbox 4.2):
% This method allows you to type the transfer function as you normally would write it.
% The statement s = tf('s') must precede the transfer function if you wish to create an
% LTI transfer function in polynomial form equivalent to using G=tf(numg,deng).
%
% Rational Expression in s Method, Factored Form (Requires Control System Toolbox 4.2):
% This method allows you to type the transfer function as you normally would write it.
% The statement s = zpk('s') must precede the transfer function if you wish to create an
% LTI transfer function in factored form equivalent to using G = zpk(numg,deng,K). 
%
% For both rational expression methods the transfer function can be typed in any form 
% regardless of whether s = tf('s') or s = zpk('s') is used. The difference is in the 
% created LTI transfer function. We use the same examples above to demonstrate 
% the rational expression in s methods.


'(ch2p9)'                           % Display label.
'Vector Method, Polynomial Form'    % Display label.
numf=150*[1 2 7]                    % Store 150(s^2+2s+7) in numf and 
                                    % display.		
denf=[1 5 4 0]                      % Store s(s+1)(s+4) in denf and
                                    % display.		
'F(s)'                              % Display label.
F=tf(numf,denf)                     % Form F(s) and display.
clear                               % Clear previous variables from workspace.
'Vector Method, Factored Form'      % Display label.
numg=[-2 -4]                        % Store (s+2)(s+4) in numg and 
                                    % display.
deng=[-7 -8 -9]                     % Store (s+7)(s+8)(s+9) in deng and 
                                    % display.
K=20                                % Define K.
'G(s)'                              % Display label.
G=zpk(numg,deng,K)                  % Form G(s) and display.
clear                               % Clear previous variables from workspace.
'Rational Expression Method, Polynomial Form'        
                                    % Display label.
s=tf('s')                           % Define 's' as an LTI object in polynomial form.
F=150*(s^2+2*s+7)/[s*(s^2+5*s+4)]   % Form F(s) as an LTI transfer function in 
                                    % polynomial form.
G=20*(s+2)*(s+4)/[(s+7)*(s+8)*(s+9)]
                                    % Form G(s) as an LTI transfer function in 
                                    % polynomial form.
clear                               % Clear previous variables from workspace.
'Rational Expression Method, Factored Form'        
                                    % Display label.
s=zpk('s')                          % Define 's' as an LTI object in factored form.
F=150*(s^2+2*s+7)/[s*(s^2+5*s+4)]   % Form F(s) as an LTI transfer function in 
                                    % factored form.
G=20*(s+2)*(s+4)/[(s+7)*(s+8)*(s+9)]
                                    % Form G(s) as an LTI transfer function in 
                                    % factored form.
