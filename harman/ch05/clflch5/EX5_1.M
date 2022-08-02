% EX5_1.M  Solve Dy=1/(t-1) using Symbolic Math Toolbox
%  for Example 5.1 and 5.2
y=dsolve('Dy=1/(t-1)')
y1=dsolve('Dy=1/(t-1)','y(2)=-10')   % Initial values t=2
y2=dsolve('Dy=1/(t-1)','y(2)=0')
y3=dsolve('Dy=1/(t-1)','y(4)=8')     % Initial value t=4
%
%  Try help dsolve to understand the command
%  Also, add a few fprintf commands to explain the output
%
