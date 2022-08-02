% Script p10_3_1.m; broken extremals & conjugate points for min
% surface area connecting two circular loops; (see Pbs. 3.3.4 
% and 3.3.5); r=cosh(x*cosha-a)/cosh(a) ==> r(0)=1; one-param.
% family of curves (parameter=a);                  7/95, 3/30/02 
%
a=0.4; c=cosh(a); 
for i=1:45, x6(i)=(i-1)/30; r6(i)=cosh(c*x6(i)-a)/c; end
a=0.8; c=cosh(a);
for i=1:30, x5(i)=(i-1)/20; r5(i)=cosh(c*x5(i)-a)/c; end
a=1.2; c=cosh(a); s=sinh(a); for i=1:27, x0(i)=(i-1)/18; 
    y=x0(i)*c-a; r0(i)=cosh(y)/c; d0(i)=cosh(y)*s-sinh(y)*c*...
    (x0(i)*s-1); end
a=1.5; c=cosh(a); s=sinh(a); for i=1:24, x1(i)=(i-1)/21; 
    y=x1(i)*c-a; r1(i)=cosh(y)/c; d1(i)=cosh(y)*s-sinh(y)*c*...
    (x1(i)*s-1); end
a=2.0; c=cosh(a); s=sinh(a);
for i=1:25, x2(i)=(i-1)/32; y=x2(i)*c-a; r2(i)=cosh(y)/c; 
    d2(i)=cosh(y)*s-sinh(y)*c*(x2(i)*s-1); end
a=3.0; c=cosh(a); s=sinh(a);
for i=1:23, x3(i)=(i-1)/60; y=x3(i)*c-a; r3(i)=cosh(y)/c;
    d3(i)=cosh(y)*s-sinh(y)*c*(x3(i)*s-1); end
a=4.0; c=cosh(a); s=sinh(a); 
for i=1:20, x4(i)=(i-1)/108; y=x4(i)*c-a; r4(i)=cosh(y)/c; 
    d4(i)=cosh(y)*s-sinh(y)*c*(x4(i)*s-1); end
%
% Broken extremals (flat areas within each disk):
xb=[0:.1:1.2 1.27]; yb=[0 .05 .10 .16 .22 .293 .377 .461 ...
   .576 .719 .874 1.04 1.23 1.40]; 
%
figure(1); clf; plot(x0,r0,x1,r1,x2,r2,x3,r3,x4,r4,x5,r5,x6,r6);
hold on; plot(1.3251,1,'o',1.0427,.6334,'o',.7168,.3331,'o', ...
 .3411,.1092,'o',.1579,.0385,'o'); plot(xb,yb,'--'); hold off
grid; axis([0 1.4 0 1.4]); axis('square'); xlabel('x') 
ylabel('r'); text(.7,.23,'o Conjugate Points')
text(.7,.17,'- - Locus of Beginnings')
text(.7,.11,'     of Broken Extremals')
text(.35,.97,'a=0.4'); text(.35,.82,'0.8'); text(.3,.73,'1.2')
text(.265,.63,'1.5'); text(.23,.53,'2.0'); text(.15,.3,'3.0')
text(.08,.18,'4.0')
