% EX5_9.M Solve the system of equations
%	Dx1(t)= x1 + x2
%	Dx2(t)=4x1 + x2
% Use dsolve with x=x1 and y=x2; Initial [1 1]
xvec='Dx=x+y,Dy=4*x+y'     % Print the results
initc='x(0)=1,y(0)=1'
[x1,x2]=dsolve(xvec,initc)


