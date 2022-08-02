%This Worksheet simulates finding the nonlinear regression exponential model
%without data linearization
function varargout = mtl_reg_sim_nonlinearwithout()
%Input arrays X and Y.  Also give a reasonable initial value of (b).
X=[0.5,1,3,5,7,9];
Y=[1.648,2.71,20.08,148.4,1096,8103];
%For a reasonable initial guess of (b), use the solution from the Nonlinear
%Model with Data linearization worksheet. For convergence, use an initial
%guess (b) close to the values of (b) obtained by using data linearization.
initial_value_b=0.1;
% End of input
clc

disp(sprintf('Nonlinear Regression without Data Linearization'))
disp(sprintf('©2007 Autar Kaw'))
disp(sprintf('University of South Florida'))
disp(sprintf('United States of America'))
disp(sprintf('kaw@eng.usf.edu'))

disp(sprintf('\n\nNOTE: This worksheet demonstrates the use of Matlab to illustrate'))
disp(sprintf('the procedure to regress a given data set to a nonlinear exponential model without'))
disp(sprintf('data linearization, that is, y=a*exp(b*x)'))
%--------------------------------------------------------------------------
disp(sprintf('\n\n**************************** Introduction ******************************'))

disp(sprintf('Using the sum of the square of residuals, Sr and minimizing with respect '))
disp(sprintf('to (a) and (b) will give two simultaneous nonlinear equations.'))
disp(sprintf('Fortunately, the two simultaneous linear equations can be reduced to'))
disp(sprintf('one nonlinear equation in (b).  Once solved, (a) can be found directly.'))
disp(sprintf('\nThe input arrays X and Y:'))
X
Y
%--------- Exponential-----------------
disp(sprintf('\n\n**************************** Exponential  ******************************'))


disp(sprintf('Given (x1,y1),(x2,y2),...(xn,yn), best fit y=a*exp(b*x) to the data.'))

n=length(X);
Z=zeros(1,n);
%Finding the value of (b) first.  See the function eqn
b_value=fzero(@(b) f(b,X,Y,n),initial_value_b);

%Call fzero with a one-argument anonymous function that captures that value of (a) and calls myfun with two arguments:
%Calculating the value of (a)
sum_yex=0;
sum_e2x=0;
for i=1:n
   sum_yex=sum_yex+Y(i)*exp(b_value*X(i));
   sum_e2x=sum_e2x+exp(2*b_value*X(i));
end
a_value=sum_yex/sum_e2x;
% Writing out the values of (a) and (b)
a_value
b_value
disp(sprintf('\nThe model without data linearization is described as\n                 y=%5g',a_value))
disp(sprintf('\b*exp(%5g',b_value))

disp(sprintf('\b*x)                     (4)'))


%Plotting the graph of x*exp(b*x) and the data points.
xp=(0:0.001:max(X));
yp=zeros(1,length(xp));
for i=1:length(xp)
yp(i)=a_value*exp(b_value*xp(i));
end
plot(xp,yp)
title('Exponential Model without Data linearization, y vs. x')
xlabel('x')
ylabel('y=a*exp(b*x)')
hold on
plot(X,Y,'bo','MarkerFaceColor','b')
hold off
end
% This is the function where you set up the left hand side of the equation f(b)=0
% Using fzero the root of the equation is found
function eqn1 = f(b,X,Y,n)
sum_yxex=0;
sum_yex=0;
sum_ex2=0;
sum_xex2=0;
for i=1:n
    sum_yxex=sum_yxex+Y(i)*X(i)*exp(b*X(i));
    sum_yex=sum_yex+Y(i)*exp(b*X(i));
    sum_ex2=sum_ex2+exp(2*b*X(i));
    sum_xex2=sum_xex2+X(i)*exp(2*b*X(i));
end
eqn1 = sum_yxex-sum_yex/sum_ex2*sum_xex2;
end
