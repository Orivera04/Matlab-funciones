subplot(1,2,1)
u = linspace(0,5*pi);
[sn, cn, dn]=ellipj(u,0.5);
plot(u,[sn; cn; dn]);
subplot(1,2,2)
u = linspace(0,1);
[k,e]=ellipke(u);
plot(u, [k;e]);