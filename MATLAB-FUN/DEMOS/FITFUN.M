function err = fitfun(lambda)
%FITFUN Used by FITDEMO.
%	FITFUN(lambda) returns the error between the data and the
%	values computed by the current function of lambda.
%	FITFUN assumes a function of the form
%
%	  y =  c(1)*exp(-lambda(1)*t) + ... + c(n)*exp(-lambda(n)*t)
%
%	with n linear parameters and n nonlinear parameters.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

global Data Plothandle

t = Data(:,1);
y = Data(:,2);
A = zeros(length(t),length(lambda));
for j = 1:length(lambda)
   A(:,j) = exp(-lambda(j)*t);
end
c = A\y;
z = A*c;
set(Plothandle,'ydata',z)
drawnow
err = norm(z-y);
