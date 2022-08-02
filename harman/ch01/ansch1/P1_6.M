% P1_6.M Plot an ellipse and add text
t=0:0.1:2*pi  % Look at t values 
x=3*sin(t);
y=2*cos(t);
plot(x,y)
% Write the text in the center - adjust the text positioning
text(-0.9,0.0,'This is an ellipse')
%
% Note the t values and the approximation to 2*pi
%