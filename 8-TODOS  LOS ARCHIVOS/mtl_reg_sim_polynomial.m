%This Worksheet simulates the polynomial regression model. It also helps
%you to find the optimum order of polynomial to use.
clc
%The following are the inputs to the model
%Enter values for X:
X=[80,40,-40,-120,-200,-280,-340];
%Enter values for Y:
Y=[6.47e-6,6.24e-6,5.72e-6,5.09e-6,4.3e-6,3.33e-6,2.45e-6];
%Enter the order of polynomial regression model:
order_poly=1;
%Enter the lowest order (low_order =>1) of polynomial to check for optimum order:
low_order=1;
%Enter the highest order (hi_order <=n-2) of polynomial to check for optimum order:
hi_order=5;
disp(sprintf('Polynomial Regression Model'))
disp(sprintf('©2007 Fabian Farelo, Autar Kaw'))
disp(sprintf('University of South Florida'))
disp(sprintf('United States of America'))
disp(sprintf('kaw@eng.usf.edu'))

disp(sprintf('\n\nNOTE: This worksheet demonstrates the use of Matlab to illustrate'))
disp(sprintf('the procedure to regress a given data set to a nonlinear polynomial model'))
%--------------------------------------------------------------------------
disp(sprintf('\n\n**************************** Introduction ******************************'))
disp(sprintf('Given n data points (x1, y1), (x2, y2), . .  .  , (xn, yn), least squares'))
disp(sprintf('method can be used to regress the data to a mth order polynomial.'))
disp(sprintf('\n        y=a0+a1*x+a2*x^2+.....+am*x^m, m<n                               (1)\n'))
disp(sprintf('The residual at each data point is given by'))
disp(sprintf('        Ei=yi-a0-ai*xi........-am*xi^m                                              (2)\n'))
disp(sprintf('The sum of the square of the residuals is given by'))
disp(sprintf('        Sr=sum(Ei^2, i=1:n)                                                           (3)\n'))
disp(sprintf('To find the constants of the polynomial regression model, we put the'))
disp(sprintf('derivatives with respect to ai to zero, that is,'))
disp(sprintf('d(Sr)/d(a0) =sum[2*(yi-a0-ai*xi........-am*xi^m, i=1:n)(-1)]=0        (4.a)\n'))
disp(sprintf('d(Sr)/d(a1) =sum[2*(yi-a0-ai*xi........-am*xi^m, i=1:n)(-xi)]=0        (4.b)'))
disp(sprintf(' .      .        .       .        .        .       .        .     .'))
disp(sprintf(' .      .        .       .        .        .       .        .     .'))
disp(sprintf('d(Sr)/d(am) =sum[2*(yi-a0-ai*xi........-am*xi^m, i=1:n)(-xi^m)]=0   (4.m)\n'))
disp(sprintf('Setting those equations in matrix form gives'))
disp(sprintf('|      n               sum(xi)    .....    sum(xi^m)  | |a0| = |    sum(yi)     |'))
disp(sprintf('|  sum(xi)         sum(xi^2)  .....   sum(xi^m+1)| |a1| = |   sum(xi*yi)  |'))
disp(sprintf('|     . . .               . . .      . . .         . . .      | |...|  = |    .........     |'))
disp(sprintf('| sum(xi^m)  sum(xi^m+1)  .....   sum(xi^2m) | |am| = |sum(xi^m*yi)|'))
disp(sprintf('\nThe above simultaneous linear equations are solved\nfor the (m+1) constants a0, a1,.  .  ., am'))
disp(sprintf('\n\n**************** Polynomial model simulation  ************************'))
disp(sprintf('NOTE:This is the input data that can be modified by the user at the top of the M-File.'))
disp(sprintf('The order of the polynomial can also be selected by the user. Once the values are entered,'))
disp(sprintf('Matlab will generate a polynomial regression model for the given data set.'))

X=X'
Y=Y'
lx=length(X);
ly=length(Y);
if (lx)<(ly)
   disp(sprintf('The number of elements for the input arrays X and Y must be the same'))
else
    if (lx)>(ly)
    disp(sprintf('The number of elements for the input arrays X and Y must be the same'))    
    else
    disp(sprintf('Using the matrix form above, we have the coefficient matrix "M"'))
%Creating the matrix size according to the order of polynomial model
M=zeros(order_poly+1);
%Determining each value of the first row of matrix "M"
M(1,1)=length(X);
for i=2:order_poly+1
    for j=1:length(X)
    M(1,i)=M(1,i)+X(j)^(i-1);
end
end
%Calculating the remaining values of the coefficient matrix
for i=1:order_poly+1
       for k=2:order_poly+1
       for j=1:length(X)
           
           M(k,i)=M(k,i)+X(j)^(i+k-2);
       
       end
       end
end
format short g
M
disp(sprintf('Now, the right hand side vector "C"'))
%Creating the vector size according to the order of the polynomial model
C=zeros(order_poly+1,1);
%Finding each value of "C"
for i=1:length(X)
    C(1,1)=C(1,1)+Y(i);
end
for i=2:order_poly+1
    for j=1:length(X)
        C(i,1)=C(i,1)+(X(j)^(i-1))*Y(j);
    end
end
format short g
C
%Merging the arrays "M" and "C" to use Matlab to reduce it
E=horzcat(M,C);
a=rref(E);
%Selecting the last columm with the coefficient values
a=a(:,order_poly+2);
format short g
disp(sprintf('Solving the system of simultaneous linear equations M*a=C,\nfor (a) we get'))
a
disp(sprintf('This array contains the coefficients of the model as'))
disp(sprintf('a=[a0, a1,.....,am])'))
disp(sprintf('The plot shows the data points as well as the polynomial regression model.'))

%------- Plot --------

xp=(min(X):0.001:max(X));
yp=zeros(1,length(xp));
for i=1:length(xp)
    yp(i)=a(1);
    for j=1:order_poly
    yp(i)=yp(i)+a(j+1)*xp(i)^(j);
    end
end
plot(xp,yp)
title(['Polynomial Regression of order ',num2str(order_poly)])
xlabel('x')
ylabel('y = a_0+a_1*x+a_2*x^2+.....+a_m*x^m')
hold on
plot(X,Y,'bo','MarkerFaceColor','b')
hold off
end
end
 %------------------------------   
disp(sprintf('\n\n******************* Optimum Order************************')) 
disp(sprintf('In this section the user can determine the optimum order of the polynomial'))
disp(sprintf('model by plotting the variance defined as  \n        Sr/(n-(m+1)) ')) 
disp(sprintf('as a function of m, where n is the number of data points, Sr is the sum of '))
disp(sprintf('the square of residuals and m is the order of the polynomial. The optimum order'))
disp(sprintf('is considered as to be the one where the value of the variance Sr/[n-(m+1)] is'))
disp(sprintf('minimum or where its value is significantly decreasing.'))
disp(sprintf('\nIn the following procedure, an mth order polynomial regression model is '))
disp(sprintf('calculated for each order specified in the Low_order to Hi_order range. Matlab'))
disp(sprintf('then returns the variance of each model. The worksheet does not choose the '))
disp(sprintf('order of the optimum polynomial for regression for you. Look at the plot of the'))
disp(sprintf('variance as a function of the order of the polynomial. The optimum polynomial'))
disp(sprintf('is one after which there is no statistical significant decrease in the variance.'))
disp(sprintf('\nMany a times, the variance may show signs of decreasing and then increasing'))
disp(sprintf('as a function of the order of the polynomial regression model. Such increases '))
disp(sprintf('in the variance are normal as the variance is calculated as the ratio between'))
disp(sprintf('the sum of the squares of the residuals and the difference between the number'))
disp(sprintf('of data points and number of constants of the polynomial model. Both the numerator'))
disp(sprintf('and denominator decrease as the order of the polynomial is increased. However,'))
disp(sprintf('as the order of the polynomial increases, the coefficient matrix in the calculation '))
disp(sprintf('of the constants of the model becomes more ill-conditioned. This ill-conditioning '))
disp(sprintf('of the coefficient matrix results in fewer significant digits that can be trusted to be'))
disp(sprintf('correct in the coefficients of the polynomial model, and hence artificially amplify'))
disp(sprintf('the value of the variance.'))

%Doing the polynomial regression and storing the Sr values
Sr=zeros(low_order,hi_order);
for order_poly=low_order:hi_order
M=zeros(order_poly+1);
M(1,1)=length(X);
% n=length(X)
for i=2:order_poly+1
    for j=1:length(X)
    M(1,i)=M(1,i)+X(j)^(i-1);
end
end
for i=1:order_poly+1
       for k=2:order_poly+1
       for j=1:length(X)
           M(k,i)=M(k,i)+X(j)^(i+k-2);
       end
       end
end
C=zeros(order_poly+1,1);
for i=1:length(X)
    C(1,1)=C(1,1)+Y(i);
end
for i=2:order_poly+1
    for j=1:length(X)
        C(i,1)=C(i,1)+(X(j)^(i-1))*Y(j);
    end
end
E=horzcat(M,C);
a=rref(E);
a=a(:,order_poly+2);


for i=1:length(X)
    summ=0;
        for j=1:order_poly
        summ=summ+a(j+1)*X(i)^(j);
        end
    Sr(order_poly)=Sr(order_poly)+(Y(i)-(a(1)+summ))^2;
end    
end
variance=zeros(low_order,hi_order);
for i=low_order:hi_order
variance(i)=Sr(i)/(length(X)-(i+1));
end

%______________________________________________________
%Ploting the results
pl=(1:5);
figure
plot(pl,Sr2,'LineWidth',2)
axis([0 6 0 max(Sr2)])
title('Variance vs Order of Polynomial')
xlabel('Order of Polynomial, m')
ylabel('Sr\div[n-(m+1)]')


disp(sprintf('\nThe variance for each polynomial model of order m in the low_order to hi_order range is:'))
variance
