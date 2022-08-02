function y=pfun(fnct)
% PFUN.M function y=pfun('function')
%   Example call: y= pfun('x.^2+x.^3')
%    (Note the use of array element-by-element notation)
%   Output is a plot of 'function' with range of 0 to 10 
%
x=[0:0.1:10];
y=eval(fnct);
plot(x,y);
%
% Note:  An improvement would be to annotate the plot
%     and display the function being plotted. Modify the
%     function to allow input of another range of x.	