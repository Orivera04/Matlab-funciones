%% Rose Curve
clear all
close all

% p and q must be integers

p=5; q=1;

% Check for period
if mod(p,2)==1 & mod(q,2)==1 
    lb=pi*q;
else
    lb=2*pi*q;
end

theta=linspace(0,lb,lb*1000);

r=cos(p/q*theta);

x=r.*cos(theta);
y=r.*sin(theta);

comet(x,y)
plot(x,y)
xlabel('x-axis')
ylabel('y-axis')
title('The Rose Curve')
axis equal
axis tight
shg
%% Method 2
clear all
close all

theta=linspace(0,2*pi,1000);

R=7;
r=1;
x=(R-r./cos(-R.*theta./r)-r).*cos(pi+R.*theta./r).*cos(pi+R.*theta./r+theta);
y=(R-r./cos(-R.*theta./r)-r).*cos(pi+R.*theta./r).*sin(pi+R.*theta./r+theta);
comet(x,y)
plot(x,y)
xlabel('x-axis')
ylabel('y-axis')
title('The Rose Curve')
axis equal
axis tight
shg
