% function insect_(p1,p2) draws an insect figure.
% p1,p2:  Coordinates pairs 
%         for left and right of insect body 
% Example>> p1=[0,0]; p2=[0.5,0]; insect_(p1,p2)
%           axis([-0.25, 0.75 -0.5 0.5])
% Copyright S. Nakamura, 1995
function y = insect_(p1,p2)
hold on
x0 = p1(1); y0=p1(2);
x1 = p2(1); y1=p2(2);
c = (x1-x0)/2;  d = (y1 - y0)/2;
f = (x1+x0)/2;  g = (y1 + y0)/2; 
xwL = [-13  -18 -20 -20 -18 -13 -8 -6 0 0 -6 -13]/50;
ywL = [13 0 -10 -40 -47 -50 -45 -38 -17 -10 2 13]/50;
xx = c*xwL - d*ywL + f;
yy = d*xwL + c*ywL + g; 
xxb = -c*xwL - d*ywL + f;
yyb = -d*xwL + c*ywL + g;
plot(xx,yy); plot( xxb,yyb) 
xneck = [-13  0  13]/50;
yneck = [13  14  13]/50;
xx = c*xneck - d*yneck + f;
yy = d*xneck + c*yneck + g;
plot(xx,yy)
xhL = [ -13 -12.5 -10]/50;
yhL = [13 20 27]/50;
xx = c*xhL - d*yhL + f;
yy = d*xhL + c*yhL + g;  plot(xx,yy)
xx = -c*xhL - d*yhL + f;
yy = -d*xhL + c*yhL + g;  plot(xx,yy) 
xtop = [-5 0 7]/50;
ytop = [30 32 30]/50;
xx = c*xtop - d*ytop + f;
yy = d*xtop + c*ytop + g;  plot(xx,yy) 
t = 0:0.5:pi*2;
xeyeL =( -.08 + .03*cos(t))*2;
yeyeL =( .29 + .03*sin(t))*2;
xx = c*xeyeL - d*yeyeL + f;
yy = d*xeyeL + c*yeyeL + g;  plot(xx,yy) 
xeyeR = (.10 + .03*cos(t))*2;
yeyeR = (.30 + .03*sin(t))*2;
xx = c*xeyeR - d*yeyeR + f;
yy = d*xeyeR + c*yeyeR + g;  plot(xx,yy) 
%plot (xeyeR, yeyeR)
xantL=[-10 -15 -18 -21]/50;
yantL=[27 31 37 38]/50;
xx = c*xantL - d*yantL + f;
yy = d*xantL + c*yantL + g;  plot(xx,yy) 
xantR=[25 19 13]/50;
yantR=[41 39 27]/50;
xx = c*xantR - d*yantR + f;
yy = d*xantR + c*yantR + g;  plot(xx,yy) 
hold off



