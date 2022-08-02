%This is an mfile  intended to reproduce the effect of parametric plot. The complete call is
% curveplot(curve,parameter,start,fin,mesh)

function  z = curveplot2 (varargin)
curve=varargin{1};
parameter=varargin{2};
start=varargin{3};
fin=varargin{4};
newcurve=subs(curve,parameter , 't');

 t= start:.01*(fin-start):fin;

x = eval(vectorize(newcurve(1)));

y = eval(vectorize(newcurve(2)));
if length(varargin)== 4
   plot (x,y)
else
   plot(x,y,varargin{5})
end




