function v=jarrett(f,x1,x2,tol)
% Finds a root of f(x) = 0 using Jarrett's method.
%
% Example call: v=jarrett(f,x1,x2,tol)
% Finds root in range x1 to x2 of the user defined function f using tolerance tol.
%
gamma=.5;d=1;
while abs(d) >tol
  f2=feval(f,x2);f1=feval(f,x1);
  df=(f2-f1)/(x2-x1); x3=x2-f2/df; d=x2-x3;
  if f1*f2 >0 
    x2=x1; f2=gamma*f1;
  end 
  x2=x3;
end
v=x2;
