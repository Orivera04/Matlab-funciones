subplot(1,2,1)
u = linspace(0,10); [sn, cn, dn]=ellipj(u,0.7);
plot(u,[sn; cn; dn]);
subplot(1,2,2)
m = linspace(0,1); [k,e]=ellipke(m);
plot(u, [k;e]);