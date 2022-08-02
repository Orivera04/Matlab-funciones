clc
clear all

% Revised: 
% February 11, 2008
 
% Authors:
% Ana Catalina Torres, Dr. Autar Kaw      
 
% Purpose

%   To illustrate the differentiation of discrete functions using different
%   methods: forward divided difference method, differentiation of a second
%   order interpolated polynomial, and differentiation of a polynomial 
%   using all data points.
        
 
% Inputs
%    Clearing all data, variable names, and files from any other source and
%    clearing the command window after each succesive run of the program.

%    This is the only place in the program where the user makes changes to
%    the data

%       Data points, y vs. x

            X=[10,15,20,21,25];
            Y=[100,225,400,441,625];

%       Value of x at which f '(x) is desired, xv

            xv=11;

%--------------------------------------------------------------------------
disp(sprintf('                 Differentiation of Discrete Functions'))
disp(sprintf('                     Ana Catalina Torres, Autar Kaw'))
disp(sprintf('                       University of South Florida'))
disp(sprintf('                         United States of America'))
disp(sprintf('                             kaw@eng.usf.edu'))
%--------------------------------------------------------------------------
disp(sprintf('\n\n**************************** Introduction ******************************'))

disp(sprintf('\nThis worksheet demonstrates the use of Matlab to illustrate the '))
disp(sprintf('differentiation of discrete functions using:')) 
disp(sprintf('\n    a) Forward Divided Difference method.'))
disp(sprintf('\n    b) by differentiation of a second order interpolated polynomial, and'))
disp(sprintf('\n    c) by differentiation of a polynomial using all data points.'))
        

disp(sprintf('\n\n************************** Section 1: Input ****************************'))
format short g
disp(sprintf('\nThe following simulation finds the approximate value of the first ')) 
disp(sprintf('derivative of a discrete function using Forward Divided Difference.\n\nThe user inputs are'))
disp(sprintf('      a) Data points, y vs. x'))
X
Y
disp(sprintf('      b) Value of x at which the derivative is desired, xv'))
xv
disp(sprintf('All the information must be entered at the beginning of the M-File.'))
syms x

disp(sprintf('\n\n*********************** Section 2: Calculation **************************'))
disp(sprintf('\nAn internal loop estimates the solution of first derivate of a discrete'))
disp(sprintf('function at a point xv using Forward Divided Difference method.'))
disp(sprintf('\nn = number of data points'))
disp(sprintf('\nThe loop checks if the value at which the solution is desired is')) 
disp(sprintf('between x[1] and x[n]. If the value is between x[1] and x[n], then the ')) 
disp(sprintf('slope from the closest points that bracket the value is found. The value '))
disp(sprintf('of the slope is the value of the derivative at that point. '))

disp(sprintf('\nAn internal procedure also takes the three closest points to the given value to find'))
disp(sprintf('a second order polynomial and differentiates it to find the value of the\nderivative at x=xv'))
n = numel(X);

if ((X(1)<=xv) && (xv<=X(n)))
    for i=1:(n-1)
        if ((X(i)<=xv) && (xv<=X(i+1)))
            Av=(Y(i+1)-Y(i))/(X(i+1)-X(i));
        end
    end
else
    disp(sprintf('\nPoint where derivative was requested is outside the domain of X'))
end  

%   The next method takes the three closest points to the given value to
%   find a second order polynomial and differentiates it to find the value
%   of the derivative at x=xv

if ((X(1)<=xv) && (xv<=X(n)))
    if ((X(1)<=xv) && (xv<=X(2)))
        a=[X(1),X(2),X(3)];
        b=[Y(1),Y(2),Y(3)];
        SecDev=polyval(polyder(polyfit(a,b,2)),xv);
    elseif ((X(n-1)<=xv) && (xv<=X(n))) 
        a=[X(n-2),X(n-1),X(n)];
        b=[Y(n-2),Y(n-1),Y(n)];
        SecDev=polyval(polyder(polyfit(a,b,2)),xv);
    else
        for i=2:(n-2)
            if ((X(i)<=xv) && (xv<=X(i+1)))
                if abs(X(i+2)-xv)<=abs(xv-X(i-1))
                    a=[X(i),X(i+1),X(i+2)];
                    b=[Y(i),Y(i+1),Y(i+2)];
                    SecDev=polyval(polyder(polyfit(a,b,2)),xv);
                else
                    a=[X(i-1),X(i),X(i+1)];
                    b=[Y(i-1),Y(i),Y(i+1)];
                    SecDev=polyval(polyder(polyfit(a,b,2)),xv);
                end
            end
        end
    end
end  

disp(sprintf('\nAlso, all data points are going to be used to find a n-1 order polynomial.')) 
disp(sprintf('At the end, the polynomial is going to be differentiated and the value at')) 
disp(sprintf('which the derivative is wished to be found is going to be found.'))

DerivPoly=polyval(polyder(polyfit(X,Y,n-1)),xv);

disp(sprintf('\n\n********************* Section 3: Table of Values ************************'))

disp(sprintf('\nThe next table shows the approximate values of the derivative at the given')) 
disp(sprintf('point using Forward Divided Difference, second and "n-1"th order \npolynomials.\n'))
disp('    Straight Line  2nd Order  "n-1"th Order')
Results=[Av' SecDev' DerivPoly'];
disp(Results)

disp(sprintf('\n\n*************************** Section 4: Graphs ***************************'))

disp(sprintf('\nThe following graph show the discrete data, linear splines and the "n-1"th\norder polynomial')) 

set(0,'Units','pixels')
  scnsize=get(0,'ScreenSize');
  wid=round(scnsize(3));
  hei=round(0.9*scnsize(4));
  wind=[1, 1, wid, hei];
  figure('Position',wind)
 
a = X(1):X(n);
b = interp1(X,Y,a);
c = interp1(X,Y,a,'spline');
plot(X,Y,'ro',a,b,'b-.',a,c,'m--','LineWidth',1.5)
xlabel('x')
ylabel('f(x)')
legend('Data','Linear Splines', '"n-1"th Order Polynomial',0)
title({'Discrete data, Linear Splines and "n-1"th Order Polynomial'})

disp(sprintf('\n\n****************************** References *******************************'))

disp(sprintf('\nNumerical Differentiation of Discrete Functions. See')) 
disp(sprintf('http://numericalmethods.eng.usf.edu/mws/gen/02dif'))

disp(sprintf('\n\n****************************** Questions ********************************'))

disp(sprintf('\n1. The thermal expansion coefficient of steel is a function of temperature.'))
disp(sprintf('Find the rate of change of the thermal expansion coefficient as a function '))
disp(sprintf('of temperature at T=-200F. Is this rate of change at T=-200F more or less  '))
disp(sprintf('than at T=50F? Use Forward Divided Difference to answer this question.'))
disp(sprintf('\n\n2. The distance traveled by a rocket is given as a funtion of time'))
disp(sprintf('\n\n   t,s          0     10     16     20     30     40'))
disp(sprintf('\n   x,miles      0     16     28     39     30     53'))
disp(sprintf('\nFind the rocket velocity and acceleration at t=25s using numerical '))
disp(sprintf('\ndifferentiation. Use all three methods illustrated in the worksheet.'))

disp(sprintf('\n\n***************************** Conclusions ******************************'))
disp(sprintf('\nThe more data points taken to obtain the first derivative of a discrete '))
disp(sprintf('function, more accurate the approximate value is. However, the more data '))
disp(sprintf('points taken may result in oscillatory behavior generally observed with '))
disp(sprintf('higher order interpolation. See'))
disp(sprintf('http://numericalmethods.eng.usf.edu/mws/gen/05inp/mws_gen_inp_spe_\nhigherorder.pdf'))


disp(sprintf('\n\n------------------------------------------------------------------------'))
disp(sprintf('\nLegal Notice: The copyright for this application is owned by the ')) 
disp(sprintf('author(s). Neither Mathcad nor the author are responsible for any errors '))
disp(sprintf('contained within and are not liable for any damages resulting from the use '))
disp(sprintf('of this material. This application is intended for non-commercial, '))
disp(sprintf('non-profit use only. Contact the author for permission if you wish to use\nthis application for-profit activities.'))



