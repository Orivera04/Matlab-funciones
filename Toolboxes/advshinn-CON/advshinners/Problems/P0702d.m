 num=[8]; den=[conv([.1 1],[.1 1]) 0]; cnum=[1/.6 1]; cden=[1/.1 1];
 t=0:.1:10; 
 clf; hold off; sbplot(111);
 dn = poly_add(num,den); s1=step(num,dn,t);
 num=conv(num,cnum); den=conv(den,cden);
 dn=poly_add(num,den); s2=step(num,dn,t);
 plot(t,s1,'-',t,s2,'-'); grid; xlabel('Time'); ylabel('Amplitude');
 text(3.0,1.15,'Compensated'); text(0.75,1.35,'Uncompensated');
