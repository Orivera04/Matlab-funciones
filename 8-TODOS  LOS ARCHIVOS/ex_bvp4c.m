odef = inline('x.*y + 1','x','y');
bcfun = inline('ya+yb-10.2501','ya','yb');
init.x = linspace(1, 2, 100);
c =10.2501;
init.y = c*ones(size(init.x));
s = bvp4c(odef, bcfun, init)
zz = inline(['1./2.*exp(1./2.*t.^2).*pi.^(1./2).*2.^(1./2).*'...
	    'erf(1./2.*2.^(1./2).*t)'], 't');
plot(s.x(1:5:end), s.y(1:5:end),'r+')
hold on
plot(s.x, zz(s.x))
h = legend('calculée','exacte',0)