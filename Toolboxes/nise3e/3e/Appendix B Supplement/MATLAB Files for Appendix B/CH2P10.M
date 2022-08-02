% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%																													
% (ch210): Transfer function numerator and denominator vectors can be converted
% between polynomial form containing the coefficients and factored form containing
% the roots. The MATLAB function, tf2zp(numtf,dentf), converts the numerator and 
% denominator from coefficients to roots. The results are in the form of column 
% vectors. We demonstrate this with  F(s) = (10s^2+40s+60)/(s^3+4s^2+5s+7). 
% The MATLAB function, zp2tf(numzp,denzp,K), converts the numerator and denominator 
% from roots to coefficients. The arguments numzp and denzp must be column vectors. 
% In the demonstration below apostrophes signify transpose. We demonstrate the 
% conversion from roots to coefficients with G(s) = 10(s+2)(s+4)/[s(s+3)(s+5)].

'(ch2p10)'                          % Display label.
'Coefficients for F(s)'             % Display label.
numftf=[10 40 60]                   % Form numerator of F(s) = 
                                    % (10s^2+40s+60)/(s^3+4s^2+5s+7). 
denftf=[1 4 5 7]                    % Form denominator of
                                    % F(s) = 
                                    % (10s^2+40s+60)/(s^3+4s^2+5s+7).
'Roots for F(s)'                    % Display label.
[numfzp,denfzp]=tf2zp(numftf,denftf)	
                                    % Convert F(s) to factored form.
'Roots for G(s)'                    % Display label.
numgzp=[-2 -4]                      % Form numerator of 
K=10                                % G(s) = 10(s+2)(s+4)/[s(s+3)(s+5)].
dengzp=[0 -3 -5]                    % Form denominator of
                                    % G(s) = 10(s+2)(s+4)/[s(s+3)(s+5)].
'Coefficients for G(s)'             % Display label.
[numgtf,dengtf]=zp2tf(numgzp',dengzp',K)	
                                    % Convert G(s) to polynomial form.
