% This is an M-file intended to plot a space curve together with
% several instances of the Frenet Frame, represented by the 
% normal in red and the unit binormal in green. The
% parameter num determines the number of frames plotted; the
% parameter len determines the length of the frame vectors.

function  z = curveframeplot(curve, parameter, start, fin, num, len)

newcurve=subs(curve, parameter, 't');
t= start:.01*(fin-start):fin;
x = eval(vectorize(newcurve(1)));
y = eval(vectorize(newcurve(2)));
w = eval(vectorize(newcurve(3)));
plot3(x,y,w)
hold on

unitvec = @(u) u/sqrt(u*transpose(u));
curvevel=diff(curve);
curvetan=unitvec(curvevel);
curvenorm=unitvec(diff(curvetan));
curvebin=cross(curvetan,curvenorm);

t1=start:(fin-start)/num:fin;
newcurve1=subs(curve,parameter,'t1');
norm1=subs(curvenorm,parameter,'t1');
bin1=subs(curvebin,parameter,'t1');
x1 = eval(vectorize(newcurve1(1)));
y1 = eval(vectorize(newcurve1(2)));
w1 =eval(vectorize(newcurve1(3)));
xnorm = eval(vectorize(newcurve1(1)+len*norm1(1)));
ynorm = eval(vectorize(newcurve1(2)+len*norm1(2)));
wnorm=eval(vectorize(newcurve1(3)+len*norm1(3)));
xbin = eval(vectorize(newcurve1(1)+len*bin1(1)));
ybin = eval(vectorize(newcurve1(2)+len*bin1(2)));
wbin =eval(vectorize(newcurve1(3)+len*bin1(3)));

for n=1:length(t1)
   plot3([x1(n),xnorm(n)],[y1(n),ynorm(n)],[w1(n),wnorm(n)],'red')
   plot3([x1(n),xbin(n)],[y1(n),ybin(n)],[w1(n),wbin(n)],'green')
end
hold off

