function [x1,y1]=convert(xspan,yspan,jj)

%    N.B every time you finish one step you will hear a small beep
x=0:.0001:.2;
y=sin(2*pi*1000*x);
%    xspan is the absolute length of the x-axis on the plot
%    yspan is the absolute length of the y-axis on the plot
%    jj is the number of data points to be extracted from the image. The
%    total number of points to be taken is jj+6
%  1- Read the figure image into matlab from matlab work space useing
%    z=imread('filename,format')[see help imread] and show image using imshow(z)then just type
%    the [x1,y1]=convert in the work space and enter.

%  2- set x axis conversion factor. Use ginput to set three reference
%    points on the x-axis. The first is at the axis intersection. The
%    second is at the x-axis maximum point. The third is at the x-axis zero
%    point. If there is no zero point, take this point exactly as the first
%    point and add to x1 in the final step the x-axis plot starting
%    (minimum value)
[xx,yy]=ginput(3);
sound(y)
%  3- Set the y-axis conversion factor in exactly the same way you set
%    the x-axis but now you have to take the same three reference points on
%    the y-axis
[xxx,yyy]=ginput(3);
sound(y)
% 4- Take as many data points on the graph in the image as you chose.
%    The number of the data points you can take is set in the jj variable
%    in the m file call command.
[x,y]=ginput(jj);
sound(y)
% 5- Convert the pixel number to actual graph numbers
x1=((x-xx(3))*xspan)/(xx(2)-xx(1));
y1=((y-yyy(3))*yspan)/(yyy(2)-yyy(1));
% 6- Now you can plot your exctracted data
plot(x1,y1)
%  Now you have your new data as x1,y1 in matlab work space. Do with them
%  as you please
%  Thank you

