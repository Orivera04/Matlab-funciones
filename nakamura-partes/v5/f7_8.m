% f7_8
% Copyright S. Nakamura, 1995
set(gcf, 'NumberTitle','off','Name', 'Figure 7.8')

clear, clf
subplot(221)
x=[-2.5:0.1:2.5];
y=x;
y1=-0.1*(x+1).*(5-x);
plot(x,y,x,y1)
hold on
xs=2;ysd=-3;
for KK=1:6
ys=-0.1*(xs+1).*(5-xs);
plot([xs,xs],[ysd,ys],'-.')
ysd=ys; plot([xs,ys],[ysd,ys],'-.')
xs=ys;
end
title('Convergent: -1<g`<0')
text(2.2,-2+0.1,'IG')
text(-2.5, 1.7,'IG: initial guess')
xlabel('X'), ylabel('Y')
axis([-3,3,-2,2])
text(-2.0279,   1.0423, 'y=g(x)')
text(0.6872,   0.4507, 'y=x')

%===========================
subplot(224)
x=[0.02:0.1:10];
y=x;
y1=-3 + 4*sqrt(x).*(1+0.1*x);
axis([-0.5,10,-2,12])
plot(x,y,x,y1)
hold on
xs=1.5;ysd=-3;
for KK=1:6
ys=-3 + 4*sqrt(xs)*(1+0.1*xs);
plot([xs,xs],[ysd,ys],'-.')
ysd=ys; plot([xs,ys],[ysd,ys],'-.')
xs=ys;
end
title('Divergent: 1<g`')
text(1.9,-2+0.4,'IG')
xlabel('X'), ylabel('Y')

axis([-0,10,-2,12])
%disp 'Locate  y=g(x) by mouse; curve (magenta)'
text(3.5393,   8.0284, 'y=g(x)')
%disp 'Locate  y=x by mouse; straight line (yellow)'        
text(6.7978,   5.7447, 'y=x')

%===========================
subplot(223)
x=[-2.5:0.5:2.5];
y=x;
y1=-0.2*(x+2).*(7-x)+2;
plot(x,y,x,y1)
hold on
xs=-1;ysd=-3;
for KK=1:10
ys=-0.2*(xs+2).*(7-xs)+2;plot([xs,xs],[ysd,ys],'-.')
ysd=ys; plot([xs,ys],[ysd,ys],'-.')
xs=ys;
end
title('Divergent: g`<-1')
text(-1+0.2,-3+0.3,'IG')
xlabel('X'), ylabel('Y')

axis([-4,2,-3,3])
text(-2.0894,   2.4043,  'y=g(x)')
text(-2.6927,  -2.6170,  'y=x')

%===========================
subplot(222)
x=[0.02:0.1:4];
y=x;
y1=1+0.1*x.^2;
axis([-0.5,4,-2,3]); plot(x,y,x,y1)
hold on
xs=3.7;ysd=-3;
for KK=1:6
ys=1+0.1*xs.^2;
plot([xs,xs],[ysd,ys],'-.')
ysd=ys; plot([xs,ys],[ysd,ys],'-.')
xs=ys;
end
title('Convergent: 0<g`<1')
text(3.5,-2+0.3,'IG')
xlabel('X'), ylabel('Y')

axis([-0,4,-2,3])
text(2.1798,    1.1338, 'y=g(x)')
text(0.3146,   -0.0986, 'y=x')

%print sucSubsti.ps 
