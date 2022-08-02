% Script f06_12.m; RRL for helicopter;    2/92, 4/4/02
%
A=[-.0257 .0130 -.322;1.260 -1.765 0;0 1 0];
B=[.0860 -7.41 0]'; C=[1 0 0]; N=[0 0 0]'; R=1; Ts=.1; 
Q1=[1e-8 1 3 10 30 100 300 1000 3000 10000];
for i=1:10, Q=C'*Q1(i)*C;
 [Ad,Bd]=c2d(A,B,Ts); k=lqrd(A,B,Q,R,Ts); 
 p(:,i)=eig(Ad-Bd*k);
end
for i=1:91, xc(i)=cos(pi*i/180); yc(i)=sin(pi*i/180); 
end
%
figure(1); clf; plot(real(p),imag(p),'x'); grid
axis([0 1 0 1]); axis('square'); hold on
plot(xc,yc); hold off; xlabel('Real(z)')
ylabel('Imag(z)')
text(.58,.4,'Q/R=10^4'); text(.7,.29,'10^3')
text(.74,.2,'10^2'); text(.83,.13,'10')
text(.28,.04,'10^4'); text(.53,.04,'10^3')
text(.66,.04,'10^2'); text(.76,.04,'10')
%print -deps2 \book_do\figures\f06_12
