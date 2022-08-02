% EX5_12.M Verify Example 5.12 using dsolve
%  Dx1=x1+x2; Dx2=x2;  In result x=x1, y=x2.
% (This requires Symbolic Math Toolbox)
fprintf('Solution of system of Example 5.12 x=x1,y=x2 \n')
[x,y]=dsolve('Dx=x+y','Dy=y')
fprintf('Strike a key to continue \n')
pause
fprintf('Solve system with initial conditions \n')
[x,y]=dsolve('Dx=x+y','Dy=y','x(0)=1,y(0)=0')
%
% Experiment a bit with other possibilities 
%  for initial conditions or another system