% Script p8_7_8.m; conjugate points for min surface area 
% connecting two circular loops (see also Probs. 3.3.14 and 
% 10.3.1); r=cosh(x*cosha-a)/cosh(a) ==> r(0)=1; one-parameter
% family of curves (parameter=a);                7/95, 7/17/02
%
a=[.4 .8 1.2 1.5 2 3 4]; N=[45 30 27 24 25 23 20];
M=[30 20 18 21 32 60 108];
%
figure(1); clf; for i=1:7, c=cosh(a(i)); for j=1:N(i), 
 x(j)=(j-1)/M(i); r(j)=cosh(c*x(j)-a(i))/c; end
 plot(x,r); hold on; clear x r; end; grid; axis([0 1.4 0 1.4])
axis('square'); plot(1.3251,1,'ro',1.0427,.6334,'ro',.7168,.3331,...
 'ro',.3411,.1092,'ro',.1579,.0385,'ro',0,1,'ro'); hold off
xlabel('x'); ylabel('r'); text(.7,.23,'o Conjugate Points') 
text(.35,.97,'a=0.4'); text(.35,.82,'0.8'); text(.3,.73,'1.2')
text(.265,.63,'1.5'); text(.23,.53,'2.0'); text(.15,.3,'3.0')
text(.08,.18,'4.0')
