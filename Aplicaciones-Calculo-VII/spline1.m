% % Mfile name
%   mtl_inp_sim_spline.m

% Language: Matlab 7.4.0 (R2007a)
% Revised: 
%   August 8, 2008

% Authors:
%   Nathan Collier, Luke Snyder, Autar Kaw
%   University of South Florida
%   kaw@eng.usf.edu
%   Website: http://numericalmethods.eng.usf.edu
       
% Purpose
%   To illustrate the concept of spline interpolation.

% Keywords
%   Polynomial Interpolation
%   Spline Interplolation

% Clearing all data, variable names, and files from any other source and
% clearing the command window after each sucessive run of the program.
clc
clf
clear all

% INPUTS: This is the only section in the program where the user can make
% changes to the program.

% Array of x-data
  x=[10 0 20 15 30 22.5];

% Array of y-data
  y=[227.04 0 517.35 362.78 901.67 602.97];

% Value of x at which y is desired
  xdesired = 21;

% *************************************************************************

disp(sprintf('\n\nSpline Interpolation'))
disp(sprintf('\nUniversity of South Florida'))
disp(sprintf('United States of America'))
disp(sprintf('kaw@eng.usf.edu'))
disp(sprintf('\nNOTE: This worksheet utilizes Matlab to demonstrate spline interpolation'))
disp(sprintf('as a means of approximation.'))

disp(sprintf('\n*****************************Introduction******************************'))

disp(sprintf('\nThis simulation illustrates the spline method of interpolation.  Given'))
disp(sprintf('n data points of y versus x, you are then required to find the value of y'))
disp(sprintf('at a particular value of x using first, second, and third order interpolation.'))
disp(sprintf('It is first necessary to pick the needed data points, and then use those to'))
disp(sprintf('interpolate the data.  Once these points are found, the data is interpolated'))
disp(sprintf('over the required points using spline interpolation and the value of f(x)'))
disp(sprintf('is found at a particular value of "xdesired" as determined by the user.'))

disp(sprintf('\n******************************Simulation*********************************'))    
 
% SOLUTION

% Determining whether or not "xdesired" is a valid point to ask for given
% the range of the x data.
high = max(x);
low = min(x);
if xdesired > high
    disp(sprintf('\nThe value entered for "xdesired" is too high. Please pick a smaller value'))
    disp(sprintf('that falls within the range of x data.'))
    break;
elseif xdesired < low
    disp(sprintf('\nThe value entered for "xdesired" is too low.  Please pick a larger value'))
    disp(sprintf('that falls within the range of x data.'))
    break;
else
    disp(sprintf('\nThe value for "xdesired" falls within the given range of xdata.  The'))
    disp(sprintf('simulation will now commence.'));


% The following functions sort the x and y arrays in ascending x order.  
xy=cat(1,x,y);
xy=xy';
xy=sortrows(xy,1);
for i = 1:numel(x)
    x(i)=xy(i,1);
    y(i)=xy(i,2);
end

% Displaying the newly sorted data in the command window.
disp(sprintf('\n\n***************************Input Data******************************'))
fprintf('\n');
disp('x array of data:')
x
disp('y array of data:')
y
disp(sprintf('The value of x at which y is desired, xdesired = %g',xdesired))

%%%%%%%% LINEAR SPLINE INTERPOLATION %%%%%%%%%
disp(sprintf('\nLINEAR SPLINE INTERPOLATION:'))


% Creating a symbolic variable 'z'.
z=sym('z');

% Displaying the equations for the spline in the command window.
disp(sprintf('Equations of the Linear Spline:'));

for i = 1:numel(x)-1
    m = (y(i+1)-y(i))/(x(i+1)-x(i));
    f = m*(z-x(i))+y(i);
    M = (-m*x(i) + y(i));
    
    % Using concactenation of strings to display the equations properly in
    % the command window.
    str1 = ['f(x)_',num2str(i),' = ',num2str(m),'x'];
    if M > 0
        str2 = [' + ',num2str(M)];
    else
        str2 = [' ',num2str(M)];
    end
    
    finalstr = [str1,str2];
    disp(finalstr);
    
end

axis off
figure(1)
for i = 1:length(x)-1
    m = (y(i+1)-y(i))/(x(i+1)-x(i));
    z=sym('z');
    f = m.*(z-x(i))+y(i);
    
    if xdesired < x(i+1) & xdesired >= x(i)
        fxldesired=subs(f,z,xdesired);
    end
    
    X = x(i):0.1:x(i+1);
    Y = subs(f,z,X);
   
     plot(X,Y);
     hold on
     Y = 0;
     X = 0;
end


hold on
plot(x,y,'ro','MarkerSize',8','MarkerFaceColor',[1,0,0])
plot(xdesired,fxldesired,'kx','Linewidth',2,'MarkerSize',12')
title('\bfLinear spline interpolation','FontSize',10)
xlabel('\bfx data');
ylabel('\bff(x)');

% Displaying the value of f(x) at xdesired in the figure.
text(0.1*(max(x)-min(x)),0.8*(max(y)-min(y)),['f(',num2str(xdesired),') = ',num2str(fxldesired)])
xlim([min(x) max(x)])
ylim([min(y) max(y)])
hold off 

%%%%%%%%% QUADRATIC SPLINE INTERPOLATION %%%%%%%%%
disp('---------------------------------------------------------------------')
disp(sprintf('\nQUADRATIC SPLINE INTERPOLATION:'));

% The following assembles the matrix needed to find the coefficients of the spline
% polynomials.
% Assembly of A
n=numel(x);
A=zeros(3*(n-1));
for i=1:n-1
    for j=0:1
        for k=0:2
            A(2*i-1+j+1,3*i-3+k+1)=x(i+j)^k;
        end
    end
end

for i=1:n-2
    for j=0:1
        for k=0:1
            A(2*(n-1)+i+1,3*i-2+k+j*3+1)=((-1)^j)*(2*x(i+1))^k;
        end
    end
end

A(1,3)=1;
% Assembly of Y
Y=zeros(3*(n-1),1);
for i=0:n-2
    for j=0:1
        Y(2*(i+1)+j)=y(i+j+1);
    end
end

% Calculation of C (Coefficient Matrix)
C=inv(A)*Y;

% The following prints the equations of the splines
disp(sprintf('\nEquations of the Quadratic Spline:'));

for i = 0:n-2
    f=C(3*i+1)+C(3*i+2)*z+C(3*i+3)*z^2;

    % Using concactenation of strings to display the equations properly in
    % the command window.
    str1 = ['f(x)_',num2str(i+1),' = ',num2str(C(3*i+1))];
    if C(3*i+2) > 0
        str2 = [' + ',num2str(C(3*i+2)),'x'];
    else
        str2 = [' ',num2str(C(3*i+2)),'x'];
    end
    
    if C(3*i+3) > 0
        str3 = [' + ',num2str(C(3*i+3)),'x^2'];
    else
        str3 = [' ',num2str(C(3*i+3)),'x^2'];
    end
    
    finalstr = [str1,str2,str3];
    disp(finalstr);
    
end

% The following plots the splines as well as finding the maximum and minimum y value
% These values are needed for plotting
figure(2)
title('\bfQuadratic spline interpolation','FontSize',10)
xlabel('\bfx data');
ylabel('\bff(x)');

for i=0:n-2
    
    f=C(3*i+1)+C(3*i+2).*z+C(3*i+3).*z.^2;
    
    if xdesired < x(i+2) & xdesired >= x(i+1)
        fxqdesired=subs(f,z,xdesired);
    end
    
    X = x(i+1):0.1:x(i+2);
    Y = subs(f,z,X);
    
    plot(X,Y)
    X = 0;
    Y = 0;
    hold on
end

plot(x,y,'ro','MarkerSize',8','MarkerFaceColor',[1,0,0])
plot(xdesired,fxqdesired,'kx','Linewidth',2,'MarkerSize',12')

% Displaying the value of f(x) at xdesired in the plot.
text(0.1*(max(x)-min(x)),0.8*(max(y)-min(y)),['f(',num2str(xdesired),') = ',num2str(fxqdesired)])
title('\bfQuadratic spline interpolation','FontSize',10);
xlabel('\bfx data')
ylabel('\bff(x)')
xlim([min(x) max(x)])
hold off

%%%%%%%%% CUBIC SPLINE INTERPOLATION %%%%%%%%%
disp('---------------------------------------------------------------------')
disp(sprintf('\nCUBIC SPLINE INTERPOLATION:'))
disp(sprintf('\nFor this simulation, the Matlab function "spline" is used to find'))
disp(sprintf('the coefficients for the interpolation so no equations are displayed.'))
disp(sprintf('The procedures for finding these coefficients are the same as in '))
disp(sprintf('previous cases.'));

ymax=max(y);
ymin=min(y);
    
xx=min(x):(max(x)-min(x))/1000:max(x);
yy=spline(x,y,xx);
axis on

figure(3)
hold on
plot(x,y,'ro','MarkerSize',8','MarkerFaceColor',[1,0,0])
plot(xx,yy,'b')
fxcdesired=spline(xx,yy,xdesired);

% Displaying the value of f(x) at xdesired in the plot.
text(0.1*(max(x)-min(x)),0.8*(max(y)-min(y)),['f(',num2str(xdesired),') = ',num2str(fxcdesired)])

plot(xdesired,fxcdesired,'kx','Linewidth',2,'MarkerSize',12')
title('\bfCubic spline interpolation','FontSize',10)
xlabel('\bfx data')
ylabel('\bff(x)')
xlim([min(x) max(x)])
tot=(max(yy)-min(yy))*0.05;
ylim([min(yy)-tot max(yy)+tot])
hold off

%%%%%%%%% SUMMARY %%%%%%%%%%%%
disp(sprintf('\n************************Summary of Results:*************************'))
disp('                Linear          Quadratic         Cubic')
disp('xdesired        Spline          Spline            Spline')
disp('---------------------------------------------------------------------');
disp(sprintf('%g              %g         %g           %g',xdesired,fxldesired,fxqdesired,fxcdesired))


end


