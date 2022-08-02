% EX5_14.M Verify Example 5.14 using dsolve
%  Dx1=x1+exp(t); Dx2=-x1 +3*x2;  In result x=x1, y=x2.
% (This requires Symbolic Math Toolbox)
fprintf('Solution of system of Example 5.14 x=x1,y=x2 \n')
[x,y]=dsolve('Dx=x+exp(t)','Dy=-x+3*y+1')
fprintf('Strike a key to continue \n')
pause
fprintf('Solve system with initial conditions \n')
[x,y]=dsolve('Dx=x+exp(t)','Dy=-x+3*y+1','x(0)=2,y(0)=1')
%
% Experiment a bit with other possibilities 
%  for initial conditions or another systemformat compact