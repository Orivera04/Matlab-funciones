%LTSROB	Loop transfer function for reduced-order-observer based tracking system.
%       LTSROB is a script that calculates a state-space description
%       of the loop transfer function for a reduced-order-observer based
%	tracking system.  Such a tracking system can be designed using 
%	the functions DTS and ROO.
%
%  INPUTS:
%
%  phi,gamma          ZOH equivalent plant model.
%  Cm                 Measurement matrix: ym[k] = Cm x[k]
%  c                  Output matrix: y[k] = c x[k]
%  F,G,H,K,P          Reduced-order observer matrices
%  phia,gammaa        State space matrices for additional dynamics
%  L1,L2              Feedback gains for cascade of plant and additional
%                     dynamics.
%
%  OUTPUTS:
%
%  phi_L,gamma_L,c_L  State-space description of loop transfer function.
%
%  To find stability margins, use SM(phi_L,gamma_L,c_L).

%  R.J. Vaccaro  11/94,11/98

[nn_4,nn_1]=size(Cm);
nn_2=length(F);
nn_3=length(phia);
Lb1=L1/P;
Lb_11=Lb1(:,1:nn_4);
Lb_12=Lb1(:,nn_4+1:nn_1);
phi_L=[phi zeros(nn_1,nn_2+nn_3);...
(G-H*(Lb_11+Lb_12*K))*Cm F-H*Lb_12 -H*L2;...
  gammaa*c zeros(nn_3,nn_2) phia];
gamma_L=[gamma;zeros(nn_2+nn_3,length(gamma(1,:)))];
c_L= [(Lb_11+Lb_12*K)*Cm Lb_12 L2];
clear nn_1 nn_4 Lb1 Lb_11 Lb_12 nn_2 nn_3
sm(phi_L,gamma_L,c_L)