%  LTSSF	Loop transfer function for full-state-feedback tracking system.
%	LTSSF is a script that calculates a state-space description
%	of the loop transfer function for a state-feedback tracking system.
%	Such a tracking system can be designed using the function DTS.
%
%  INPUTS:
%
%  phi,gamma,c        ZOH equivalent plant model.
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

mm_=length(phi);
nn_=length(phia);
phi_L = [phi zeros(mm_,nn_);gammaa*c phia];
c_L=[L1 L2];
[nn_,mm_]=size(gammaa);
gamma_L=[gamma;zeros(nn_,mm_)];
clear nn_ mm_ 
sm(phi_L,gamma_L,c_L)