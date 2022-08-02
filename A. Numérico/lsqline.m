function c=lsqline(x,y)                         %last updated 1/19/96
%LSQLINE   This routine will construct the equation of the least
%          square line to a data set of ordered pairs and then graph the
%          line and the data set. A short menu of options is available,
%          including evaluating the equation of the line at points.
%
%          Use in the form:  ==> c=lsqline(x,y)  or  lsqline(x,y)  <==
%
%          Here x is vector containing the x-coordinates and y is a
%          vector containing the corresponding y-coordinates. On output,
%          c contains the coefficiencts of the least squares line:
%
%                         y = c(1)*x + c(2)
%
%  By: David R. Hill, MATH Department, Temple University
%      Philadelphia, Pa., 19122        Email: hill@math.temple.edu

%Uses routine mat2strh.

blk=setstr(219);
menu = ['Options:      <<Least Squares Line>>             ';
        '                                                 ';
        '1. Display the data set.                         ';
        '                                                 ';
        '2. Evaluate the least squares line at an x-value.';
        '                                                 ';
        '3. See the graph again.                          ';
        '                                                 ';
        '0. QUIT                                          '];
s0=' ';
s1='Your choice: ==>  ';
s2='Improper choice; try again!';
s3='Press ENTER to continue.';
[m,n]=size(x);x=reshape(x,m*n,1);
[m,n]=size(y);y=reshape(y,m*n,1);
if length(x)~=length(y)
   disp([[blk blk blk] ' Error: nummber of x and y values must be the same.'])
   return
end
c=polyfit(x,y,1);
xl=min(x);xh=max(x);
yl=c(1)*xl+c(2);yh=c(1)*xh+c(2);
xd=xh-xl;yd=max(y)-min(y);
figure
axis([xl-.1*xd,xh+.1*xd,min(y)-.1*yd,max(y)+.1*yd])
hold on
plot(x,y,'*w',[xl xh],[yl yh],'-c11')
title('LEAST SQUARES LINE')
xlabel('Click your mouse in the command window, then Press ENTER to continue')
hold off
pause
sig='N';
while sig=='N'
   clc,disp(menu),disp(s0)
   st=['The least squares model is:  '];
   st=[st ' y = ' mat2strh(c(1)) '*x + ' mat2strh(c(2))];
   disp(st)
   disp(s0)
   k=input(s1);
   if k==0,clc,disp('LSQLINE is over.'),return,end
   if k==3,figure(gcf),pause,end
   if k==1,disp([x y]),disp(s0),disp(s3),pause,end
   if k==2
      val = input('Enter x value: x = ');
      yval=c(1)*val+c(2);
      disp('The y-value is:  '),disp(yval)
      disp(s3),pause
   end
   if k~=1&k~=2&k~=3
      disp(s2),disp(s0),disp(s3),pause
   end
end

