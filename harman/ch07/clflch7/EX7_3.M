% EX7_3.M Least-squares curve fit with a line using
%  \ operator and polyfit. The results are displayed
%  and plotted.
x=[0 1 2 3 5];          % Define the data points
y=[0 1.4 2.2 3.5 4.4];
A1=[1 1 1 1 1 ]';       % Least squares matrix
A=[A1 x'];
Als=A'*A;
bls=A'*y';
% Compute least squares fit 
Xlsq1=Als\bls;
Xlsq2=polyfit(x,y,1);
f1=polyval(Xlsq2,x);
error=y-f1;
disp('       x        y         f1        y-f1')
table=[x' y' f1' error'];
disp(table)
fprintf('Strike a key for the plot\n')
pause
% Plot
clf
plot(x,y,'o',x,f1,'-')
axis([-1 6 -1 6])
title('Least Squares line Figure 7.3')
xlabel('x')
ylabel('y')
%
% Modify the script to allow input of the data points and the
%  order of the least squares polynomial 