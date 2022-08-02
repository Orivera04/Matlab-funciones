% Topic      : Direct Method - Interpolation
% Simulation : Graphical Simulation of the Method
% Language   : Matlab r12
% Authors    : Nathan Collier, Autar Kaw
% Date       : 12 October
% Abstract   : This simulation illustrates the direct method of interpolation.  Given
%              n data points of y versus x, you are then required to find the value of
%              y at a particular value of x using first, second, and third order 
%              interpolation.  So one has to first pick the needed data points, and then
%              use those to interpolate data.
% 
clear all
% INPUTS: Enter the following

% Array of x-data
  x=[10 0 20 15 30 22.5];

% Array of y-data
  y=[227.04 0 517.35 362.78 901.67 602.97];

% Value of x at which y is desired
  xdesired = 16;
  
% SOLUTION

% This calculates window size to be used in figures
set(0,'Units','pixels') 
scnsize = get(0,'ScreenSize');
wid = round(scnsize(3));
hei = round(0.95*scnsize(4));
wind = [1, 1, wid, hei];

% The following considers the x and y data and selects the two closest points to xdesired
% that also bracket it.
n = numel(x);
comp = abs(x-xdesired);
c=min(comp);
for i=1:n
    if comp(i)==c; 
    ci=i;    
    end
end
if x(ci) < xdesired
    q=1;
    for i=1:n
        if x(i) > xdesired
            ne(q)=x(i);
            q=q+1;
        end
    end
    b=min(ne);
    for i=1:n
        if x(i)==b
            bi=i;
        end
    end
end
if x(ci) > xdesired
    q=1;
    for i=1:n
        if x(i) < xdesired
            ne(q)=x(i);
            q=q+1;
        end
    end
    b=max(ne);
    for i=1:n
        if x(i)==b
            bi=i;
        end
    end
end
% If more than two values are needed, the following selects the subsequent values and puts
% them into a matrix, preserving the orginal data order.
for i = 1:n
    A(i,2)=i;
    A(i,1)=comp(i);
end
A=sortrows(A,1);
for i=1:n
    A(i,3)=i;
end
A=sortrows(A,2);
d=A(1:n,3);
if d(bi)~=2
    temp=d(bi);
    d(bi)=1;
    for i=1:n
        if i ~= bi & i ~= ci & d(i) <= temp
            d(i)=d(i)+1;
        end
        d(ci)=1;
    end
end

%%%%%%%%% LINEAR INTERPOLATION %%%%%%%%%

% Pick two data points
datapoints=2;
p=1;
for i=1:n
    if d(i) <= datapoints
        xdata(p)=x(i);
        ydata(p)=y(i);
        p=p+1;
    end
end

%Setting up the equations to find coefficients of the linear interpolant
M=[1 xdata(1)
    1 xdata(2)];
Y=[ydata(1)
    ydata(2)];

%Coefficients of linear interpolant
A=inv(M)*Y;
z=sym('z');
a0=sym('a0');
a1=sym('a1');
fl = a0 + a1*z;
fl=subs(fl,a0,A(1));
fl=subs(fl,a1,A(2));
fxdesired=subs(fl,z,xdesired);
fprev=fxdesired;

figure('Position',wind)
title('Linear interpolation','Fontweight','bold','FontSize',14)
text(0,1,'Selected Data','Fontweight','bold')
axis off
text(0,0.96 ,['      ',num2str(xdata(1))])
text(0,0.94,['x = '])
text(0,0.92,['      ',num2str(xdata(2))])
text(0.1,0.96 ,['      ',num2str(ydata(1))])
text(0.1,0.94,['y = '])
text(0.1,0.92,['      ',num2str(ydata(2))])

fo='%1.4g';
pos=0.88;
text(0,pos,'Setting up the equations to find coefficients of the linear interpolant','Fontweight','bold')
text(0.05,pos-0.04,'1')
text(0.1,pos-0.04,[num2str(M(1,2),fo)])
text(0,pos-0.06,['M =      '])
text(0.05,pos-0.08,'1')
text(0.1,pos-0.08,[num2str(M(2,2),fo)])
text(0,pos-0.12,'M * A = y')
text(0,pos-0.16,'A = M^-^1 * y')

pos=pos-0.22;
text(0,pos,'Coefficients of interpolant','Fontweight','bold')
text(0,pos-0.04,['      ',num2str(A(1))])
text(0,pos-0.06,['A =      '])
text(0,pos-0.08,['      ',num2str(A(2))])

pos=pos-0.14;
text(0,pos,['f(x)=a0 + a1*x'])
text(0,pos-0.04,['f(x)=',num2str(A(1)), '+', num2str(A(2)),'*x'])
text(0,pos-0.08,['f(xdesired)=',num2str(fxdesired)])

figure('Position',wind)
axis on
subplot(2,1,1), ezplot(fl,[min(xdata),max(xdata)])
title('Linear interpolation','Fontweight','bold')
hold on
plot(xdata,ydata,'ro','MarkerSize',10','MarkerFaceColor',[1,0,0])
plot(xdesired,fxdesired,'kx','Linewidth',2,'MarkerSize',12')

axis on
subplot(2,1,2), ezplot(fl,[min(xdata),max(xdata)])
title('  ')
hold on
plot(x,y,'ro','MarkerSize',10','MarkerFaceColor',[1,0,0])
plot(xdesired,fxdesired,'kx','Linewidth',2,'MarkerSize',12')
xlim([min(x) max(x)])
ylim([min(y) max(y)])


%%%%%%%%% QUADRATIC INTERPOLATION %%%%%%%%%

% Pick three data points
datapoints=3;
p=1;
for i=1:n
    if d(i) <= datapoints
        xdata(p)=x(i);
        ydata(p)=y(i);
        p=p+1;
    end
end

%Setting up the equations to find coefficients of the quadratic interpolant
M=[1 xdata(1) xdata(1)^2
    1 xdata(2) xdata(2)^2
    1 xdata(3) xdata(3)^2];

Y=[ydata(1)
    ydata(2)
    ydata(3)];

%Coefficients of quadratic interpolant
A=inv(M)*Y;
z=sym('z');
a0=sym('a0');
a1=sym('a1');
a2=sym('a2');
fq = a0 + a1*z + a2*z^2;
fq=subs(fq,a0,A(1));
fq=subs(fq,a1,A(2));
fq=subs(fq,a2,A(3));
fxdesired=subs(fq,z,xdesired);

fnew=fxdesired;
ea=abs((fnew-fprev)/fnew*100);
if ea >= 5
    sd=0;
else
    sd=floor(2-log10(abs(ea)/0.5));
end


figure('Position',wind)
title('Quadratic interpolation','Fontweight','bold','FontSize',14)
text(0,1,'Selected Data','Fontweight','bold')
axis off
text(0,0.96 ,['      ',num2str(xdata(1))])
text(0,0.94,['x = '])
text(0,0.92,['      ',num2str(xdata(2))])
text(0,0.88,['      ',num2str(xdata(3))])
text(0.1,0.96 ,['      ',num2str(ydata(1))])
text(0.1,0.94,['y = '])
text(0.1,0.92,['      ',num2str(ydata(2))])
text(0.1,0.88,['      ',num2str(ydata(3))])

pos=0.84;
text(0,pos,'Setting up the equations to find coefficients of the quadratic interpolant','Fontweight','bold')
text(0.05,pos-0.04,['1'])
text(0.1,pos-0.04,[num2str(M(1,2),fo)])
text(0.15,pos-0.04,[num2str(M(1,3),fo)])
text(0,pos-0.06,['M =      '])
text(0.05,pos-0.08,['1'])
text(0.1,pos-0.08,[num2str(M(2,2),fo)])
text(0.15,pos-0.08,[num2str(M(2,3),fo)])
text(0.05,pos-0.12,['1'])
text(0.1,pos-0.12,[num2str(M(3,2),fo)])
text(0.15,pos-0.12,[num2str(M(3,3),fo)])
text(0,pos-0.16,'M * A = y')
text(0,pos-0.20,'A = M^-^1 * y')

pos=pos-0.26;
text(0,pos,'Coefficients of quadratic interpolant','Fontweight','bold')
text(0,pos-0.04,['      ',num2str(A(1))])
text(0,pos-0.06,['A =      '])
text(0,pos-0.08,['      ',num2str(A(2))])
text(0,pos-0.12,['      ',num2str(A(3))])

pos=pos-0.18;
text(0,pos,['f(x)=a0 + a1*x + a2*x^2'])
text(0,pos-0.04,['f(x)=',num2str(A(1)), '+', num2str(A(2)),'*x +',num2str(A(3)),'*x^2'])
text(0,pos-0.08,['f(xdesired)=',num2str(fxdesired)])

pos=pos-0.08-0.06;
text(0,pos,'Absolute relative approximate error and significant digits','Fontweight','bold')
text(0,pos-0.04,['ea = abs(( ',num2str(fnew),' - ',num2str(fprev),' )/ ',num2str(fnew),')*100 = ',num2str(ea), ' %'])
text(0,pos-0.08,['sigdig = ',num2str(sd)])

figure('Position',wind)
axis on
subplot(2,1,1), ezplot(fq,[min(xdata),max(xdata)])
title('Quadratic interpolation','Fontweight','bold')
hold on
plot(xdata,ydata,'ro','MarkerSize',10','MarkerFaceColor',[1,0,0])
plot(xdesired,fxdesired,'kx','Linewidth',2,'MarkerSize',12')

axis on
subplot(2,1,2), ezplot(fq,[min(xdata),max(xdata)])
title('  ')
hold on
plot(x,y,'ro','MarkerSize',10','MarkerFaceColor',[1,0,0])
plot(xdesired,fxdesired,'kx','Linewidth',2,'MarkerSize',12')
xlim([min(x) max(x)])
ylim([min(y) max(y)])
fprev=fnew;

%%%%%%%%% CUBIC INTERPOLATION %%%%%%%%%

% Pick four data points
datapoints=4;
p=1;
for i=1:n
    if d(i) <= datapoints
        xdata(p)=x(i);
        ydata(p)=y(i);
        p=p+1;
    end
end

%Setting up the equations to find coefficients of the quadratic interpolant
M=[1 xdata(1) xdata(1)^2 xdata(1)^3
    1 xdata(2) xdata(2)^2 xdata(2)^3
    1 xdata(3) xdata(3)^2 xdata(3)^3
    1 xdata(4) xdata(4)^2 xdata(4)^3];

Y=[ydata(1)
    ydata(2)
    ydata(3)
    ydata(4)];

%Coefficients of quadratic interpolant
A=inv(M)*Y;
z=sym('z');
a0=sym('a0');
a1=sym('a1');
a2=sym('a2');
a3=sym('a3');
fc = a0 + a1*z + a2*z^2+a3*z^3;
fc=subs(fc,a0,A(1));
fc=subs(fc,a1,A(2));
fc=subs(fc,a2,A(3));
fc=subs(fc,a3,A(4));
fxdesired=subs(fc,z,xdesired);

fnew=fxdesired;
ea=abs((fnew-fprev)/fnew*100);
if ea >= 5
    sd=0;
else
    sd=floor(2-log10(abs(ea)/0.5));
end

figure('Position',wind)
title('Cubic interpolation','Fontweight','bold','FontSize',14)
text(0,1,'Selected Data','Fontweight','bold')
axis off
text(0,0.96 ,['      ',num2str(xdata(1))])
text(0,0.94,['x = '])
text(0,0.92,['      ',num2str(xdata(2))])
text(0,0.88,['      ',num2str(xdata(3))])
text(0,0.84,['      ',num2str(xdata(4))])
text(0.1,0.96 ,['      ',num2str(ydata(1))])
text(0.1,0.94,['y = '])
text(0.1,0.92,['      ',num2str(ydata(2))])
text(0.1,0.88,['      ',num2str(ydata(3))])
text(0.1,0.84,['      ',num2str(ydata(4))])

pos=0.80;
text(0,pos,'Setting up the equations to find coefficients of the quadratic interpolant','Fontweight','bold')
text(0.05,pos-0.04,['1'])
text(0.1,pos-0.04,[num2str(M(1,2),fo)])
text(0.15,pos-0.04,[num2str(M(1,3),fo)])
text(0.2,pos-0.04,[num2str(M(1,4),fo)])
text(0,pos-0.06,['M =      '])
text(0.05,pos-0.08,['1'])
text(0.1,pos-0.08,[num2str(M(2,2),fo)])
text(0.15,pos-0.08,[num2str(M(2,3),fo)])
text(0.2,pos-0.08,[num2str(M(2,4),fo)])
text(0.05,pos-0.12,['1'])
text(0.1,pos-0.12,[num2str(M(3,2),fo)])
text(0.15,pos-0.12,[num2str(M(3,3),fo)])
text(0.2,pos-0.12,[num2str(M(3,4),fo)])
text(0.05,pos-0.16,['1'])
text(0.1,pos-0.16,[num2str(M(4,2),fo)])
text(0.15,pos-0.16,[num2str(M(4,3),fo)])
text(0.2,pos-0.16,[num2str(M(4,4),fo)])
text(0,pos-0.20,'M * A = y')
text(0,pos-0.24,'A = M^-^1 * y')

pos=pos-0.3;
text(0,pos,'Coefficients of quadratic interpolant','Fontweight','bold')
text(0,pos-0.04,['      ',num2str(A(1))])
text(0,pos-0.06,['A =      '])
text(0,pos-0.08,['      ',num2str(A(2))])
text(0,pos-0.12,['      ',num2str(A(3))])
text(0,pos-0.16,['      ',num2str(A(4))])

pos=pos-0.22;
text(0,pos,['f(x)=a0 + a1*x + a2*x^2 + a3*x^3'])
text(0,pos-0.04,['f(x)=',num2str(A(1)), '+', num2str(A(2)),'*x +',num2str(A(3)),'*x^2 +',num2str(A(3)),'*x^3'])
text(0,pos-0.08,['f(xdesired)=',num2str(fxdesired)])

pos=pos-0.08-0.06;
text(0,pos,'Absolute relative approximate error and significant digits','Fontweight','bold')
text(0,pos-0.04,['ea = abs(( ',num2str(fnew),' - ',num2str(fprev),' )/ ',num2str(fnew),')*100 = ',num2str(ea), ' %'])
text(0,pos-0.08,['sigdig = ',num2str(sd)])

figure('Position',wind)
axis on
subplot(2,1,1), ezplot(fc,[min(xdata),max(xdata)])
title('Cubic interpolation','Fontweight','bold')
hold on
plot(xdata,ydata,'ro','MarkerSize',10','MarkerFaceColor',[1,0,0])
plot(xdesired,fxdesired,'kx','Linewidth',2,'MarkerSize',12')

axis on
subplot(2,1,2), ezplot(fc,[min(xdata),max(xdata)])
title('  ')
hold on
plot(x,y,'ro','MarkerSize',10','MarkerFaceColor',[1,0,0])
plot(xdesired,fxdesired,'kx','Linewidth',2,'MarkerSize',12')
xlim([min(x) max(x)])
ylim([min(y) max(y)])