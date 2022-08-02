% % Mfile name
%   mtl_inp_sim_lagrange.m

% Language: Matlab 7.4.0 (R2007a)
% Revised: 
%   July 7, 2008

% Authors:
%   Nathan Collier, Luke Snyder, Autar Kaw
%   University of South Florida
%   kaw@eng.usf.edu
%   Website: http://numericalmethods.eng.usf.edu
       
% Purpose
%   To illustrate the Lagrangian method of interpolation using Matlab.

% Keywords
%   Interpolation
%   Lagrange method of interpolation

% Clearing all data, variable names, and files from any other source and
% clearing the command window after each sucesive run of the program.
clc
clf
clear all

% Inputs:
%    This is the only place in the program where the user makes the changes
%    based on their wishes.

% Enter arrays of x and y data and the value of x at which y is desired.

    % Array of x-data
    x=[10 0 20 15 30 22.5];
    
    % Array of y-data
    y=[227.04 0 517.35 362.78 901.67 602.97];
    
    % Value of x at which y is desired
    xdesired = 16;
    
% *************************************************************************

disp(sprintf('\n\nLagrange Method of Interpolation'))
disp(sprintf('\nUniversity of South Florida'))
disp(sprintf('United States of America'))
disp(sprintf('kaw@eng.usf.edu'))
disp(sprintf('\nNOTE: This worksheet utilizes Matlab to illustrate the concepts'))
disp(sprintf('of the Lagrange method of interpolation.'))

disp(sprintf('\n**************************Introduction***************************'))

disp(sprintf('\nThe following simulation uses Matlab to illustrate the Lagrange method'))
disp(sprintf('of interpolation.  Given n data points of y vs x,  it is required to'))
disp(sprintf('find the value of y at a particular value of x using first, second, or'))
disp(sprintf('third order interpolation.  It is necessary to first pick the needed data'))
disp(sprintf('points and use those specific points to interpolate the data.  This'))
disp(sprintf('method differs from the Direct Method of interpolation and the Newton'))
disp(sprintf('Divided Difference Method with the use of a "weight" function to '))
disp(sprintf('approximate the value of y at the x values that bracket the "xdesired"'))
disp(sprintf('term.  The result is then the summation of these weight functions multiplied'))
disp(sprintf('by the known value of y at the corresponding value of x.'))

disp(sprintf('\n\n***************************Input Data******************************'))
fprintf('\n');
disp('x array of data:')
x
disp('y array of data:')
y
disp(sprintf('The value of x at which y is desired, xdesired = %g',xdesired))

disp(sprintf('\n***************************Simulation******************************'))    

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

% The following considers the x and y data and selects the two closest points to xdesired
% that also bracket it.
n = numel(x);
comp = abs(x-xdesired);
c=min(comp);

for i=1:n
    if comp(i)==c; 
    ci=i;    
    end
end

% The following sequence of if statements determines if the value examined
% in the x array is greater than or less than the value "xdesired".  Once
% this is determined, the remaining lines find the necessary points around
% the "xdesired" variable.

if x(ci) < xdesired
    q=1;
    for i=1:n
        if x(i) > xdesired
            ne(q)=x(i);
            q=q+1;
        end
    end
    b=min(ne);
    
    for i=1:n
        if x(i)==b
            bi=i;
        end
    end
end

if x(ci) > xdesired
    q=1;
    for i=1:n
        if x(i) < xdesired
            ne(q)=x(i);
            q=q+1;
        end
    end
    b=max(ne);
    
    for i=1:n
        if x(i)==b
            bi=i;
        end
    end
end

% If more than two values are needed, the following selects the subsequent values and puts
% them into a matrix, preserving the orginal data order.
for i = 1:n
    A(i,2)=i;
    A(i,1)=comp(i);
end
A=sortrows(A,1);
for i=1:n
    A(i,3)=i;
end
A=sortrows(A,2);
d=A(1:n,3);
if d(bi)~=2
    temp=d(bi);
    d(bi)=1;
    for i=1:n
        if i ~= bi & i ~= ci & d(i) <= temp
            d(i)=d(i)+1;
        end
        d(ci)=1;
    end
end

%%%%%%%%% LINEAR INTERPOLATION %%%%%%%%%

% Pick two data points
datapoints=2;
p=1;
for i=1:n
    if d(i) <= datapoints
        xdata(p)=x(i);
        ydata(p)=y(i);
        p=p+1;
    end
end

% Setting up the Lagrangian polynomial
z=sym('z');
L0=(z-xdata(2))/(xdata(1)-xdata(2));
L01 = subs(L0,z,xdesired);
L1=(z-xdata(1))/(xdata(2)-xdata(1));
L11 = subs(L1,z,xdesired);
fl=L0*ydata(1)+L1*ydata(2);
fxdesired=subs(fl,z,xdesired);
fprev=fxdesired;

% Displaying the outputs:
disp(sprintf('\nLINEAR INTERPOLATION:'))
disp(sprintf('\nx data chosen: x1 = %g, x2 = %g',xdata(1),xdata(2)))
disp(sprintf('\ny data chosen: y1 = %g, y2 = %g',ydata(1),ydata(2)))

% Displaying the values for the Lagrangian polynomial.
disp(sprintf('\nLagrange weight function values, L0 = %g, L1 = %g',L01,L11))

% Using concactenation to properly display the final function inside the
% command window.
fprintf('\n');
str1 = ['Final function, f(x) = ',num2str(L01),'(',num2str(ydata(1)),')'];
if L11 > 0
    str2 = [' + ',num2str(L11),'(',num2str(ydata(2)),')'];
else
    str2 = [' ',num2str(L11),'(',num2str(ydata(2)),')'];
end

% Putting all the strings together.
finalstr = [str1,str2];
disp(finalstr);

% Displaying the final value of f(x) at xdesired.
disp(sprintf('\nThe value of f(x) at xdesired, f(%g) = %g',xdesired,fxdesired));

% Plotting the results:
z1 = min(xdata):0.1:max(xdata);
fz = subs(fl,z,z1);

% Creating the first plot for Linear Lagrange Interpolation.
axis on
figure(1)
subplot(2,1,1)
plot(z1,fz)
title('Linear Interpolation (Data Points Used)','Fontweight','bold')
ylabel('f(x)','Fontweight','bold');
xlabel('x data','Fontweight','bold');
hold on
plot(xdata,ydata,'ro','MarkerSize',8','MarkerFaceColor',[1,0,0])
plot(xdesired,fxdesired,'kx','Linewidth',2,'MarkerSize',12')
hold off

axis on
subplot(2,1,2)
plot(z1,fz)
title('Linear Interpolation (Full Data Set)','Fontweight','bold')
ylabel('f(x)','Fontweight','bold');
xlabel('x data','Fontweight','bold');
hold on
plot(x,y,'ro','MarkerSize',8','MarkerFaceColor',[1,0,0])
plot(xdesired,fxdesired,'kx','Linewidth',2,'MarkerSize',12')
ylabel('f(x)','Fontweight','bold')
xlim([min(x) max(x)])
ylim([min(y) max(y)])
hold off


%%%%%%%%% QUADRATIC INTERPOLATION %%%%%%%%%

% Pick three data points
datapoints=3;
p=1;
for i=1:n
    if d(i) <= datapoints
        xdata(p)=x(i);
        ydata(p)=y(i);
        p=p+1;
    end
end

% Setting up the Lagrangian polynomial
z=sym('z');
L0=((z-xdata(2))*(z-xdata(3)))/((xdata(1)-xdata(2))*(xdata(1)-xdata(3)));
L01 = subs(L0,z,xdesired);
L1=((z-xdata(1))*(z-xdata(3)))/((xdata(2)-xdata(1))*(xdata(2)-xdata(3)));
L11 = subs(L1,z,xdesired);
L2=((z-xdata(1))*(z-xdata(2)))/((xdata(3)-xdata(1))*(xdata(3)-xdata(2)));
L21 = subs(L2,z,xdesired);
fq=L0*ydata(1)+L1*ydata(2)+L2*ydata(3);
fxdesired=subs(fq,z,xdesired);

fnew=fxdesired;
ea=abs((fnew-fprev)/fnew*100);
if ea >= 5
    sd=0;
else
    sd=floor(2-log10(abs(ea)/0.5));
end

% Displaying the outputs:
disp('---------------------------------------------------------------------')
disp(sprintf('\nQUADRATIC INTERPOLATION:'))
disp(sprintf('\nx data chosen: x1 = %g, x2 = %g, x3 = %g',xdata(1),xdata(2),xdata(3)))
disp(sprintf('\ny data chosen: y1 = %g, y2 = %g, y3 = %g',ydata(1),ydata(2),ydata(3)))

% Displaying the values for the Lagrangian polynomial.
disp(sprintf('\nLagrangian weight function values, L0 = %g, L1 = %g, L2 = %g',L01,L11,L21))

% Using concactenation to properly display the final function inside the
% command window.
fprintf('\n');
str1 = ['Final function, f(x) = ',num2str(L01),'(',num2str(ydata(1)),')'];
if L11 > 0
    str2 = [' + ',num2str(L11),'(',num2str(ydata(2)),')'];
else
    str2 = [' ',num2str(L11),'(',num2str(ydata(2)),')'];
end

if L21 > 0
    str3 = [' + ',num2str(L21),'(',num2str(ydata(3)),')'];
else
    str3 = [' ',num2str(L21),'(',num2str(ydata(3)),')'];
end

% Putting all the strings together.
finalstr = [str1,str2,str3];
disp(finalstr);

% Displaying the final value of f(x) at xdesired.
disp(sprintf('\nThe value of f(x) at xdesired is, f(%g = %g',xdesired,fxdesired));
    
% Calculating the absolute relative approximate error and significant
% digits.
disp(sprintf('\nAbsolute Relative Approximate Error, abrae = %g',ea))
disp(sprintf('\nNumber of significant digits at least correct, sig_dig = %g',sd))

% Setting up the parameters for plotting.
z1 = min(xdata):0.1:max(xdata);
fz = subs(fq,z1,z);

% Displaying the graphs for Quadratic interpolation.
axis on
figure(2)
subplot(2,1,1)
plot(z1,fz);
title('Quadratic Interpolation (Data Points Used)','Fontweight','bold')
ylabel('f(x)','Fontweight','bold');
xlabel('x data','Fontweight','bold');
hold on
plot(xdata,ydata,'ro','MarkerSize',8','MarkerFaceColor',[1,0,0])
plot(xdesired,fxdesired,'kx','Linewidth',2,'MarkerSize',12')
hold off

% Creating the second plot for Quadratic Interpolation.
axis on
subplot(2,1,2)
plot(z1,fz);
title('Quadratic Interpolation (Full data set)','Fontweight','bold')
hold on
plot(x,y,'ro','MarkerSize',8','MarkerFaceColor',[1,0,0])
plot(xdesired,fxdesired,'kx','Linewidth',2,'MarkerSize',12')
ylabel('f(x)','Fontweight','bold');
xlabel('x data','Fontweight','bold');
xlim([min(x) max(x)])
ylim([min(y) max(y)])
fprev=fnew;


%%%%%%%%% CUBIC INTERPOLATION %%%%%%%%%

% Pick four data points
datapoints=4;
p=1;
for i=1:n
    if d(i) <= datapoints
        xdata(p)=x(i);
        ydata(p)=y(i);
        p=p+1;
    end
end

% Calculating coefficients of Newton's Divided difference polynomial
z=sym('z');
L0=((z-xdata(2))*(z-xdata(3))*(z-xdata(4)))/((xdata(1)-xdata(2))*(xdata(1)-xdata(3))*(xdata(1)-xdata(4)));
L01 = subs(L0,z,xdesired);
L1=((z-xdata(1))*(z-xdata(3))*(z-xdata(4)))/((xdata(2)-xdata(1))*(xdata(2)-xdata(3))*(xdata(2)-xdata(4)));
L11 = subs(L1,z,xdesired);
L2=((z-xdata(1))*(z-xdata(2))*(z-xdata(4)))/((xdata(3)-xdata(1))*(xdata(3)-xdata(2))*(xdata(3)-xdata(4)));
L21 = subs(L2,z,xdesired);
L3=((z-xdata(1))*(z-xdata(2))*(z-xdata(3)))/((xdata(4)-xdata(1))*(xdata(4)-xdata(2))*(xdata(4)-xdata(3)));
L31 = subs(L3,z,xdesired);

% Calculating the final value for the Lagrangian polynomial at "xdesired".
fc=L0*ydata(1)+L1*ydata(2)+L2*ydata(3)+L3*ydata(4);
fxdesired=subs(fc,z,xdesired);

fnew=fxdesired;
ea=abs((fnew-fprev)/fnew*100);

% Calculating the correct number of significant digits to be taken based on
% the absolute relative approximate error.
if ea >= 5
    sd1=0;
else
    sd1=floor(2-log10(abs(ea)/0.5));
end

% Displaying the outputs:
disp('---------------------------------------------------------------------')
disp(sprintf('\nCUBIC INTERPOLATION:'))
disp(sprintf('\nx data chosen: x1 = %g, x2 = %g, x3 = %g, x4 = %g',xdata(1),xdata(2),xdata(3),xdata(4)))
disp(sprintf('\ny data chosen: y1 = %g, y2 = %g, y3 = %g, y4 = %g',ydata(1),ydata(2),ydata(3),ydata(4)))

% Displaying the values for the Lagrangian polynomial.
disp(sprintf('\nLagrangian weight function values, L0 = %g, L1 = %g, L2 = %g, L3 = %g',L01,L11,L21,L31))

% Using concactenation to properly display the final function inside the
% command window.
fprintf('\n');
str1 = ['Final function, f(x) = ',num2str(L01),'(',num2str(ydata(1)),')'];
if L11 > 0
    str2 = [' + ',num2str(L11),'(',num2str(ydata(2)),')'];
else
    str2 = [' ',num2str(L11),'(',num2str(ydata(2)),')'];
end

if L21 > 0
    str3 = [' + ',num2str(L21),'(',num2str(ydata(3)),')'];
else
    str3 = [' ',num2str(L21),'(',num2str(ydata(3)),')'];
end

if L31 > 0
    str4 = [' + ',num2str(L31),'(',num2str(ydata(4)),')'];
else
    str4 = [' ',num2str(L31),'(',num2str(ydata(4)),')'];
end

% Putting all the strings together.
finalstr = [str1,str2,str3,str4];
disp(finalstr);

% Displaying the value of f(x) at xdesired.
disp(sprintf('\nThe value of f(x) at xdesired is, f(%g) = %g',xdesired,fxdesired));

% Displaying the number of significant digits that can be taken and
% absolute relative approximate error.
disp(sprintf('\nAbsolute relative approximate error, abrae = %g%%',ea))
disp(sprintf('\nNumber of significant digits that can be taken, sig_dig = %g',sd1))
 
% Setting up the parameters for plotting.
z1 = min(xdata):0.1:max(xdata);
fz = subs(fc,z1,z);

axis on
figure(3)
subplot(2,1,1)
plot(z1,fz)
title('Cubic Interpolation (Data Points Used)','Fontweight','bold')
ylabel('f(x)','Fontweight','bold');
xlabel('x data','Fontweight','bold');
hold on
plot(xdata,ydata,'ro','MarkerSize',8','MarkerFaceColor',[1,0,0])
plot(xdesired,fxdesired,'kx','Linewidth',2,'MarkerSize',12')
hold off

% Setting up the position of plot number 6.
axis on
subplot(2,1,2)
plot(z1,fz)
title('Cubic Interpolation (Full Data Set)','Fontweight','bold')
hold on
plot(x,y,'ro','MarkerSize',8','MarkerFaceColor',[1,0,0])
plot(xdesired,fxdesired,'kx','Linewidth',2,'MarkerSize',12')
ylabel('f(x)','Fontweight','bold');
xlabel('x data','Fontweight','bold');
xlim([min(x) max(x)])
ylim([min(y) max(y)])
hold off

end
