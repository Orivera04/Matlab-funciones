%LTSOB	Loop transfer function for an observer based tracking system.
%       LTSOB is a script that calculates a state-space description
%       of the loop transfer function for an observer based
%	tracking system.  Such a tracking system can be designed using 
%	the functions DTS and FBG.
%
%  INPUTS:
%
%  phi,gamma          ZOH equivalent plant model.
%  c		      Output matrix, y[k]=c*x[k]
%  K                  Observer gains matrix
%  phia,gammaa        State space matrices for additional dynamics
%  L1,L2              Feedback gains for cascade of plant and additional
%                     dynamics.
%
%  OUTPUTS:
%
%  phi_L,gamma_L,c_L  State-space description of loop transfer function.
%
%  To find stability margins, use SM(phi_L,gamma_L,c_L).

%  R.J. Vaccaro  12/97,11/98

[nn_1,nn_2]=size(gamma);
nn_3=length(phia);
phi_L=[phi zeros(nn_1,nn_1+nn_3);...
K*c phi-K*c-gamma*L1 -gamma*L2;...
  gammaa*c zeros(nn_3,nn_1) phia];
gamma_L=[gamma;zeros(nn_1+nn_3,length(gamma(1,:)))];
c_L= [zeros(nn_2,nn_1) L1 L2];
clear nn_1 nn_2 nn_3
sm(phi_L,gamma_L,c_L)