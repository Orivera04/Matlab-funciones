function [I,g]= dtmdp(pc,x)
%[I,g]= dtmdp(pc,x)
% finds the optimal average cost policy for the 
%problem described by the function 'pc'.
% f = [f(i,a)], where f(i,a) = P(action = a|state = i).
 % A = number of actions.
 % S = number of states.
% pc = the function file producing the transition and cost matrices.
%C=eval([pc '(-1)']);
C=feval(pc,x,-1);
t=size(C);
S = t(1);
A = t(2);
P=[];
for a = 1:A
%PP=eval([pc '(' int2str(a) ')']);
PP=feval(pc,x,a);
P =[ P PP'-eye(S)];
end;
P(S, :) = ones(1,S*A);
B = zeros(1,S)';
B(S) =1;
c=C(:);
X = lp_solver(P,B,c,'min');
Y = reshape(X, S,A)
f= (Y > 0.00000001);
[YY I] = max(f');
ss = sum(Y');
for i = 1:S
if ss(i) < 10^(-10)
I(i) = -1;
end;
end;
g = c'*X;
