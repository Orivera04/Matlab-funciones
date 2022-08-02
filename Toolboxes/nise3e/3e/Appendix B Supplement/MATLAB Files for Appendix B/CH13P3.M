% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% (ch13p3): Creating Digital Transfer Functions Directly
% Vector Method, Polynomial Form: 
% A digital transfer transfer function can be expressed as a numerator polynomial 
% divided by a denominator polynomial, i.e. F(z) = N(z)/D(z). The numerator, N(z), is 
% represented by a vector, numf, that contains the coefficients of N(z). 
% Similarly, the denominator, D(z), is represented by a vector, denf, that 
% contains the coefficients of D(z). We form F(z) with the command, 
% F = tf(numf,denf,T), where T is the sampling interval. F is called a linear 
% time-invariant (LTI) object. This object, or transfer function, can be used as an 
% entity in other operations, such as addition or multiplication. We demonstrate with
% F(z) = 150(z^2+2z+7)/(z^2-0.3z+0.02).We use an unspecified sampling interval, T = []. 
% Notice after executing the tf command, MATLAB prints the transfer function.
%
% Vector Method, Factored Form: 
% We also can create digital LTI transfer functions if the numerator and denominator are
% expressed in factored form. We do this by using vectors containing the roots of 
% the numerator and denominator. Thus G(s) = K*N(z)/D(z) can be expressed as an LTI 
% object using the command, G = zpk(numg,deng,K,T), where numg is a vector containing 
% the roots of N(z), deng is a vector containing the roots of D(z), K is the gain, and T 
% is the sampling interval. The expression zpk stands for zeros (roots of the numerator), 
% poles (roots of the denominator), and gain, K. We demonstrate with 
% G(s) = 20(z+2)(z+4)/[(z-0.5)((z-0.7)(z-0.8)] and an unspecified sampling interval. 
% Notice after executing the zpk command, MATLAB prints the transfer function.
%
% Rational Expression in z Method, Polynomial Form (Requires Control System Toolbox 4.2):
% This method allows you to type the transfer function as you normally would write it.
% The statement z=tf('z') must preceed the transfer function if you wish to create a
% digital LTI transfer function in polynomial form equivalent to using G=tf(numg,deng,T).
%
% Rational Expression in z Method, Factored Form (Requires Control System Toolbox 4.2):
% This method allows you to type the transfer function as you normally would write it.
% The statement z = zpk('z') must precede the transfer function if you wish to create a
% digital LTI transfer function in factored form equivalent to using 
% G = zpk(numg,deng,K,T).
%
% For both rational expression methods the transfer function can be typed in any form 
% regardless of whether z = tf('z') or z = zpk('z') is used. The difference is in the 
% created digital LTI transfer function. We use the same examples above to demonstrate 
% the rational expression in z methods.



'(ch13p3)'                          % Display label.
'Vector Method, Polynomial Form'    % Display label.
numf=150*[1 2 7]                    % Store 150(z^2+2z+7) in numf and 
                                    % display.		
denf=[1 -0.3 0.02 ]                 % Store (z^2-0.3z+0.02) in denf and
                                    % display.
'F(z)'                              % Display label.
F=tf(numf,denf,[])                  % Form F(z) and display.
clear                               % Clear previous variables from workspace.
'Vector Method, Factored Form'      % Display label.
numg=[-2 -4]                        % Store (s+2)(s+4) in numg and 
                                    % display.
deng=[0.5 0.7 0.8]                  % Store (s-0.5)(s-0.7)(s-0.8) in deng and 
                                    % display.
K=20                                % Define K.
'G(z)'                              % Display label.
G=zpk(numg,deng,K,[])               % Form G(z) and display.
clear                               % Clear previous variables from workspace.
'Rational Expression Method, Polynomial Form'        
                                    % Display label.
z=tf('z')                           % Define z as an LTI object in polynomial form.
F=150*(z^2+2*z+7)/(z^2-0.3*z+0.02)  % Form F(z) as an LTI transfer function in 
                                    % polynomial form.
G=20*(z+2)*(z+4)/[(z-0.5)*(z-0.7)*(z-0.8)]
                                    % Form G(z) as an LTI transfer function in 
								            % polynomial form.
clear                               % Clear previous variables from workspace.
'Rational Expression Method, Factored Form'        
                                    % Display label.
z=zpk('z')                          % Define z as an LTI object in factored form.
F=150*(z^2+2*z+7)/(z^2-0.3*z+0.02)  % Form F(z) as an LTI transfer function in 
                                    % factored form.
G=20*(z+2)*(z+4)/[(z-0.5)*(z-0.7)*(z-0.8)]
                                    % Form G(z) as an LTI transfer function in 
								            % factored form.
