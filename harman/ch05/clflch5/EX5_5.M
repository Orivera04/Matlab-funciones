% EX5_5.M Find roots of equations in Example 5.5
fprintf('Check results of Example 5.5 \n')
p=[1 3 3 1 0 0]
r=roots(p)
p1=[1 2 5]
r1=roots(p1)
%
fprintf('Strike a key for symbolic solutions \n')
pause
%   Try symbolic solutions 
%
% Solve lam^2 +b*lam +c =0
%
lam=solve('l^2+b*l+c=0','l')
%
% Solve 5th order
roots5=solve('z^5+3*z^4+3*z^3+z^2=0')
%
yroot='y^2+2*y+5'
roots2=solve(yroot,'y')
%
% Add a few more displayed statements to explain results
%
% Try fifth order one
p5=[1 10 5 5 10 1]
r5=roots(p5)