x = linspace(eps,5);
h=plot(x, erf(x), 'k-', x, erfc(x), 'k.-', x, erfcx(x), 'k.', x, ...
       min(1,1./(sqrt(pi).*x)),'k--');
set(gca,'fontsize',14);
legend(h, 'erf', 'erfc', 'erfcx','1/(\pi^{1/2}x)');