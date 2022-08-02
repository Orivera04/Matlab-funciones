function [E1,E0] = E_op_begin( n )
%E_op_begin: for the begining n points' fitting
% Usage:  input: n: number of y' you used
%        output: E:   y=E.y' , however, y0 will not be gotten.
 B=[];
% a=[1:(n-1)];
% for i0=1:n
%   B=[B (a'.^i0)/i0];
% end
% E=B*M_inv(n,0);

 a=[-(n-3)/2:(n-1)/2];
 for i0=1:n % This is for the power
   B=[B ( (a'.^i0) - (-(n-1)/2)^i0 )/i0];
 end
 E=B*M_inv(n,-(n-1)/2);
%// Renormalize \\
for i0=1:n-1
  E(i0,:)=E(i0,:)/sum(E(i0,:))*i0;
end
%\\ Renormalize //
E1=E(:,2:n);
E0=E(:,1);