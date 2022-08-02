function asm(A,B,L)
%ASM Analog Stability margins.
%	ASM(A,B,L) computes and prints the upper and lower gain margins,
%	as well as the phase margin(s) for the loop transfer function
%	described by the state-space matrices (A,B,L).
%	The maximum margins the function searches for are -30db lower gain 
%	margin, 30db upper gain margin, and 120 degree phase margin.

%  R.J. Vaccaro 4/03

augm(A,B,L);
fprintf('\n')
algm(A,B,L);
fprintf('\n')
aphm(A,B,L);
return
