function sm(A,B,L)
%SM	Stability margins.
%	SM(A,B,L) computes and prints the upper and lower gain margins,
%	as well as the phase margin(s) for the loop transfer function
%	described by the state-space matrices (A,B,L).
%	The maximum margins the function searches for are -30db lower gain 
%	margin, 30db upper gain margin, and 120 degree phase margin.

%  R.J. Vaccaro 5/94

ugm(A,B,L);
fprintf('\n')
lgm(A,B,L);
fprintf('\n')
phm(A,B,L);
return
