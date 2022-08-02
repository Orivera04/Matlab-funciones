%% A simple quadratic polynomial model in 1-d, compared to polyfit
x = -10:10;
y = 3*x.^2 + 2*x + 1;

P1 = polyfit(x,y,2);
Pn = polyfitn(x,y,2);

% The differences should be near eps
P1 - Pn.Coefficients

%% Evaluate the above regression model at some set of points
polyvaln(Pn,0:.1:1)

%% Fit a 1-d model to cos(x). We only need the even order terms.
x = -2:.1:2;
y = cos(x);
p = polyfitn(x,y,'constant x^2 x^4 x^6')

if exist('sympoly') == 2
  % Conversion to a sympoly. If nothing else, its a nice way to display the model.
  polyn2sympoly(p)
end
if exist('sym') == 2
  % Conversion to a symbolic toolbox form. Its also nice.
  polyn2sym(p)
end

%% A surface model in 2-d, with all terms up to third (cubic) order

% Use lots of data.
n = 1000;
x = rand(n,2);
y = exp(sum(x,2)) + randn(n,1)/100;

% Note the parameter statistics
p = polyfitn(x,y,3)

if exist('sympoly') == 2
  polyn2sympoly(p)
end
if exist('sym') == 2
  polyn2sym(p)
end

% Evaluate on a grid and plot:
[xg,yg]=meshgrid(0:.05:1);
zg = polyvaln(p,[xg(:),yg(:)]);
surf(xg,yg,reshape(zg,size(xg)))
hold on
plot3(x(:,1),x(:,2),y,'o')
hold off

%% A linear model, but with no constant term in 4-dimensions
%   w(u,v,x,y) = a1*u + a2*v + a3*x + a4*y
% All the coefficients should be approximately 1.0 in
% this truncated Taylor series model.
uv = (rand(100,4)-.5)/10;
w = sin(sum(uv,2));
p = polyfitn(uv,w,'u, v, x, y');
if exist('sympoly') == 2
  polyn2sympoly(p)
end
if exist('sym') == 2
  polyn2sym(p)
end

%% A model in 5-d, with all terms up to fourth (quartic) order

% Use LOTS of data.
n = 10000;
x = rand(n,5);
y = sin(sum(x,2)) + randn(n,1)/100;
p = polyfitn(x,y,4)

if exist('sympoly') == 2
  polyn2sympoly(p)
end
if exist('sym') == 2
  polyn2sym(p)
end

%% A model with various exponents, not all positive integers.

% Note: with only 1 variable, x & y may be row or column vectors.
x = 1:10;
y = 3 + 2./x + sqrt(x) + randn(size(x))/100;
p = polyfitn(x,y,'constant x^-1 x^0.5');
if exist('sympoly') == 2
  polyn2sympoly(p)
end
if exist('sym') == 2
  polyn2sym(p)
end

xi = 1:.1:10;
yi = polyvaln(p,xi);
plot(x,y,'ro',xi,yi,'b-')

