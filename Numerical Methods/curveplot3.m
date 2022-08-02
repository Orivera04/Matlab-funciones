%This is an mfile  intended to reproduce the effect of parametric plot. The complete call is
% curveplot(curve,parameter,start,end,mesh)

function  z = curveplot3 (curve,parameter,  start, fin)

newcurve=subs(curve,parameter , 't');

 t= start:.01*(fin-start):fin;

x = eval(vectorize(newcurve(1)));

y = eval(vectorize(newcurve(2)));

w=eval(vectorize(newcurve(3)));

plot3(x,y,w)




