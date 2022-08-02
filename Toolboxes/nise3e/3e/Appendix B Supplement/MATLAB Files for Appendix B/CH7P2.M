% Nise, N.S. 
% Control Systems Engineering, 3rd ed. 
% John Wiley & Sons, New York, NY, 10158-0012
%
% Control Systems Engineering Toolbox Version 3.0 
% Copyright © 2000 by John Wiley & Sons, Inc.
%
% (ch7p2) Example 7.6: We can use MATLAB to evaluate the gain, K, required to 
% meet a steady-state error specification. Let us look at Example 7.6 in the text.

'(ch7p2) Example 7.6'               % Display label.
numgdK=[1 5];                       % Define numerator of G(s)/K.
dengdK=poly([0 -6 -7 -8]);          % Define denominator of G(s)/K.
GdK=tf(numgdK,dengdK);              % Create G(s)/K
numgkv=conv([1 0],numgdK);          % Define numerator of sG(s)/K.
dengkv=dengdK;                      % Define denominator of sG(s)/K.
GKv=tf(numgkv,dengkv);              % Create  sG(s)/K.
GKv=minreal(GKv);                   % Cancel common 's' in numerator and 
                                    % denominator of sG(s)/K.
KvdK=dcgain(GKv)                    % Evaluate (Kv/K)=(numgkv/dengkv) for 
                                    % s=0.
ess=0.1                             % Enumerate steady-state error. 
K=1/(ess*KvdK)                      % Solve for K.
'Check Stability'                   % Display label.
T=feedback(K*GdK,1);                % Form T(s).
poles=pole(T)                       % Display closed-loop poles.
