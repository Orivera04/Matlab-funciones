%% Cosine k=1, a=1
theta=linspace(0,2*pi);
r=cos(theta);
polar(theta,r);


%% Sine k=1, a=1
clc
theta=linspace(0,2*pi);
r=sin(theta);
polar(theta,r);


%% Cosine k=2, a=1
theta=linspace(0,2*pi);
r=cos(2*theta);
polar(theta,r);


%% Cosine  k=3, a=1
theta=linspace(0,2*pi);
r=cos(3*theta);
polar(theta,r);



%% Cosine  k=4, a=1
theta=linspace(0,2*pi);
r=cos(4*theta);
polar(theta,r);


%% Cosine  k=5, a=1
theta=linspace(0,2*pi);
r=cos(5*theta);
polar(theta,r);


%% Sine k=5/6, a=1
clc
theta=linspace(0,12*pi,500);
r=sin(5/6*theta);
polar(theta,r);


%% Sine k=2, a=3
theta=linspace(0,2*pi);
r=3*sin(2*theta);
polar(theta,r);


%% Sine k=sqrt(5), a=1
theta=linspace(0,150*pi,1800);
r=sin(sqrt(5)*theta);
polar(theta,r);

%% Irrational Example
t=linspace(0,150*pi,9999);
x=sin(sqrt(5)*t).*cos(t);
y=sin(sqrt(5)*t).*sin(t);
comet(x,y);

plot(x,y)
xlabel('x-axis')
ylabel('y-axis')
title('The Rose Curve (Irrational)')
axis equal
axis tight
shg

%% Rational Example
t=linspace(0,pi,9999);
x=cos(9*t).*cos(t);
y=cos(9*t).*sin(t);
comet(x,y);

plot(x,y)
xlabel('x-axis')
ylabel('y-axis')
title('The Rose Curve (Rational)')
axis equal
axis tight
shg
