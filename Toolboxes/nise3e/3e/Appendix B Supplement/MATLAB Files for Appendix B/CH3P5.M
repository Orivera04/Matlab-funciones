% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% (ch3p5): State-space representations can be converted to transfer functions 
% represented by a numerator and a denominator using [num,den] = ss2tf(A,B,C,D,iu), 
% where iu is the input number for multiple-input systems. For single-input, 
% single-output systems iu = 1. For an LTI state-space system, Tss, the conversion 
% can be implemented using Ttf = tf(Tss) to yield the transfer function in polynomial 
% form or Tzpk = zpk(Tss) to yield the transfer function in factored form. For example, 
% the transfer function represented by the matrices described in (ch3p3) 
% can be found as follows:

'(ch3p5)'                           % Display label.
       'Non LTI'                    % Display label.
A=[0 1 0;0 0 1;-9 -8 -7];           % Represent A.
B=[7;8;9];                          % Represent B.
C=[2 3 4];                          % Represent C.
D=0;                                % Represent D.
'Ttf(s)'                            % Display label.
[num,den]=ss2tf(A,B,C,D,1)          % Convert state-space 
                                    % representation to a 
                                    % transfer function represented as
                                    % a numerator and denominator in 
                                    % polynomial form, G(s)=num/den, 
                                    % and display num and den.
      'LTI'                         % Display label.
Tss=ss(A,B,C,D)                     % Form LTI state-space model.
'Polynomial form, Ttf(s)'           % Display label.
Ttf=tf(Tss)                         % Transform from state space to 
                                    % transfer function in polynomial 
                                    % form.
'Factored form, Tzpk(s)'            % Display label.
Tzpk=zpk(Tss)                       % Transform from state space to
                                    % transfer function in factored
                                    % form.
