%LREGOB Loop transfer function for observer-based regulator.
%	LREGOB is a script that calculates a state-space description
%	of the loop transfer function for an observer-based regulator.
%
%  INPUTS:
%
%  phi,gamma,c        ZOH equivalent plant model.
%  L                  Feedback gains.
%  K                  Observer gains.
%
%  OUTPUTS:
%
%  phi_L,gamma_L,c_L  State-space description of loop transfer function.
%
%  To find stability margins, use SM(phi_L,gamma_L,c_L).

%  R.J. Vaccaro  11/94,11/98

[nn_,mm_]=size(phi);
phi_L = [phi zeros(nn_,mm_);K*c phi-K*c-gamma*L];
[nn_,mm_]=size(gamma);
gamma_L=[gamma;zeros(nn_,mm_)];
c_L=[zeros(mm_,nn_) L];
clear nn_ mm_
sm(phi_L,gamma_L,c_L)
