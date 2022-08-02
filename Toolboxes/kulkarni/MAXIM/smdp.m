function [I,g]= smdp(pc,x)
%[I,g]= smdp(pc,x)
% finds the optimal average cost policy for the function 'pc'.
% f = [f(i,a)], where f(i,a) = P(action = a|state = i).
 % A = number of actions.
 % S = number of states.
 % pc(x,a) = the function file producing the sojourn time matrix if a = -2,  
 %cost matrix if a = -1, and transition matrix P(a) for 1 \le a \le K. 
C=feval(pc,x,-1);
t=size(C);
S = t(1);
A = t(2);
%W = eval([pc '(-2)']);
W=feval(pc,x,-2);
P=[];
for a = 1:A
%PP=eval([pc '(' int2str(a) ')']);
PP=feval(pc,x,a);
P =[ P PP'-eye(S)];
end;
P(S, :) = W(:)';
B = zeros(1,S)';
B(S) =1;
c=C(:);
XLB = zeros(1,S*A)';
X = lp_solver(P,B,c,'min');
Y = reshape(X, S, A)
f= (Y > 0.00000001);
[YY I] = max(f');
ss = sum(Y');
for i = 1:S
if ss(i) < 10^(-10)
I(i) = -1;
end;
end;
g = c'*X;
