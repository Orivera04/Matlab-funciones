% EX13_3.M Solve Laplace's equation in 2D with the conditions
%   bx1=f(0,y)=0; bx2=f(a,y)=0; by1=f(x,0)=0; by2=f(x,b)=100
%  The dimensions are a=16, b=9.
clear                      % Clear variables and
clf                        %  figures
%
a=16;                      % Dimensions of the region
b=9; 
V0 = 100;                  % Constant potential at y=b (top)
%
% Solve for Fourier coefficients - symbolic solution
%
Nmax = 19;                 % Compute 1, ..., Nmax terms
sinhb='sinh(m*pi*b/a)';
for m=1:1:Nmax;       
   fn='V0*sin(m*pi*x/a)';
   intx=int(fn,'x',0,'a'); % Symbolic integral
   am=symdiv(intx,'a/2');
   am=symdiv(am,sinhb);
   am=eval(am);
   A(m)=numeric(am);       % Convert to numbers
end
%
% Plot the results
%
dx=0.5;                    % Increments
dy=0.5;
[x,y]=meshgrid(0:dx:a,0:dy:b);  
fxy=zeros(size(x));
for m=1:2:Nmax;            % Odd components  1,3,5, ..., Nmax 
   fxy=fxy + A(m)*sin(m*pi*x/a).*sinh(m*pi*y/a);
end
surf(x,y,fxy)              % 3D view
axis([0 16 0 9 0 120])     % Set axes
title('Solution of the Laplace 2D equation')
pause
%
% Contour view
%
figure(2)                  % New figure
[Dx,Dy]=gradient(fxy,dx,dy);
v=0:10:100;                % Define equipotentials
c=contour(x,y,fxy,v);
vc=[10 50 90];             % Label a few equipotentials
clabel(c,vc);
hold on
xlabel('x')
ylabel('y')
title('Potential')
grid
