%ALREGOB Loop transfer function for analog observer-based regulator.
%	ALREGOB is a script that calculates a state-space description
%	of the loop transfer function for an observer-based regulator.
%
%  INPUTS:
%
%  A,B,C              Plant model.
%  K                  Feedback gains.
%  G                  Observer gains.
%
%  OUTPUTS:
%
%  A_L,B_L,C_L  State-space description of loop transfer function.
%
%  To find stability margins, use ASM(A_L,B_L,C_L).

%  R.J. Vaccaro  4/03

[nn_,mm_]=size(A);
A_L = [A zeros(nn_,mm_);G*C A-G*C-B*K];
[nn_,mm_]=size(B);
B_L=[B;zeros(nn_,mm_)];
C_L=[zeros(mm_,nn_) K];
clear nn_ mm_
asm(A_L,B_L,C_L)
