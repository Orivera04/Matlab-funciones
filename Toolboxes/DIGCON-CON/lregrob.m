%LREGROB Loop transfer function for reduced-order-observer-based regulator.
%	 LREGROB is a script that calculates a state-space description
%	 of the loop transfer function for a reduced-order-observer-based 
%	 regulator.  The function ROO can be used to design the observer.
%
%  INPUTS:
%
%  phi,gamma          ZOH equivalent plant model.
%  Cm                 Measurement matrix.
%  L                  Feedback gains.
%  F,G,H,K,P          Reduced-order observer matrices.
%
%  OUTPUTS:
%
%  phi_L,gamma_L,c_L  State-space description of loop transfer function.
%
%  To find stability margins, use SM(phi_L,gamma_L,c_L).

%  R.J. Vaccaro  11/94,11/98

[mm_,nn_]=size(Cm);
Lb_s=L/P;
Lb1_s=Lb_s(:,1:mm_);
Lb2_s=Lb_s(:,mm_+1:nn_);
phi_L = [phi zeros(nn_,nn_-mm_);(G-H*(Lb2_s*K+Lb1_s))*Cm F-H*Lb2_s];
c_L = [(Lb1_s+Lb2_s*K)*Cm Lb2_s];
[nn_,pp_]=size(gamma);
gamma_L = [gamma;zeros(nn_-mm_,pp_)];
clear nn_ mm_ pp_ Lb_s Lb1_s Lb2_s
sm(phi_L,gamma_L,c_L)