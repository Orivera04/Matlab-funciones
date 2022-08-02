% CLPLOT2.M Plot an input as 'fn(x.,y.)'. Function must be input as 
%  a string with matrix variables. Input plot limits in x and y.
%  Example:  'x.^2+y.^2+x.*y+2*x+1'
clear                  % Clear variables and
clf                    %  figures 
fn=input('Function to minimize -a string using matrices f(x.,y.)=')
% Plot the function using the limits input
x0=input('Input the plot limits [xmim xmax ymim ymax]= ')
x=[x0(1):.1:x0(2)];    % Create x and y points
y=[x0(3):.1:x0(4)];
%
% Use a mesh
X=x0(1):1:x0(2);
Y=x0(3):1:x0(4);
[x,y]=meshgrid(X,Y);    % Form matrices for x and y
fgrid=eval(fn);         % Form a grid of function values	
surfc(x,y,fgrid)        % Plot surface 	
xlabel('x')
ylabel('y')
