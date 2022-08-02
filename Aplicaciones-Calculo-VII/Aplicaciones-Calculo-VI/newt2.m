function root=newt2(f,xr,n)
% NEWT2(f,xr,n) finds roots of function f near guess xr with n iterations.
% May find more than one root, even if guess is way off.  The function f 
% must be an inline object.
% EXAMPLE:    >>f=inline('cos(x+3).^3+(x-1).^2');
%             >>newt2(f,32,10)   % Note how far 32 is from either root!        
%             ans = 
%                0.01246254122870
%                1.27535795100410

% NEWT2 works by finding the tangent line to f at xr, then generating an
% initial vector of 25 lines at different angles to the tangent line.  
% At the x intercept of each line (including the initial guess) the above  
% process is repeated to give the Newton-Raphson method 25^2 initial guesses.   
% Since all of this is vectorized, the process is fast.  May work when the 
% initial guess is outside the range of fzero, for example compare :
% >>fzero(f,32)   for f as above.
% Author:  Matt Fig,  Montana State University  
% Contanct:  popkenai@yahoo.com   please write me with your opinion!!
if f(xr) == 0, root = xr; return, end
warning off MATLAB:divideByZero
iter = 0;  max = n;  est = 1e-13;  ea = ones(1,25^2);
theta = pi./[ -45 -40 -35 -30 -25 -20 -15 -10 -5 -4 -3 ...
              pi/(atan(1/(((f(xr+10*eps)-f(xr-10*eps))./(20*eps))+eps)))...
              inf 2 3 4 5 10 15 20 25 30 35 40 45 ];   
xr = xr-(1-tan(theta).*((f(xr+10*eps)-f(xr-10*eps))./(20*eps))).*...
     f(xr)./(tan(theta)+((f(xr+10*eps)-f(xr-10*eps))./(20*eps)));
[xr,theta] = meshgrid(xr,theta);
xr = reshape(xr-(1-tan(theta).*((f(xr+10*eps)-f(xr-10*eps))./(20*eps))).*...
     f(xr)./(tan(theta)+((f(xr+10*eps)-f(xr-10*eps))./(20*eps))),1,25^2);
xrold=xr;
while iter <= max
    xrold(:) = xr;   iter = iter+1;
    xr(:) = xr-f(xr)./((f(xr+10*eps)-f(xr-10*eps))/(20*eps));
end
ea(:) = abs((xr-xrold)./(xr+eps)*100);
xr(:)=(10^13)*xr;  xr(:)=round(xr);  xr(:)=xr/(10^13);
root = unique(real(xr(find(ea <= est | abs(f(xr)) < eps)))');