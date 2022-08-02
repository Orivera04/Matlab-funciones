function approx=plotapp(func,rangelow,interval,rangeup)
% Plots a function and allows the user to approximate a particular root using the cursor.
%
% Example call: approx=plotapp(func,rangelow,interval,rangeup)
% Plots the user defined function func in the range rangelow to rangeup
% using a plotting step given by interval. Returns approximation to root.
% 
approx=[ ];
x=rangelow:interval:rangeup;
plot(x,feval(func,x));
hold on;
xlabel('x'); ylabel('f(x)');
title(' ** Place cursor close to root and click mouse ** ')
grid on;
%Use ginput to get approximation from graph using mouse 
approx=ginput(1);
fprintf('Approximate root is %8.2f\n',approx(1));
hold off
