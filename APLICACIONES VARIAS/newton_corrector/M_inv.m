function M= M_inv(n,s)
% Usage: used to generate the M matrix for predictor-corrector
%        input: n: number of y' you used
%               s: start value, default is from "0"
%        output: M^(-1) matrix
%///// Generate the main matrix M \\\\\\%
a=[0:(n-1)]+s;
M=ones(n,1);
for i0=1:(n-1)
  M=[M a'.^i0];
end
%\\\\\ Generate the main matrix M //////%
M=inv(M);