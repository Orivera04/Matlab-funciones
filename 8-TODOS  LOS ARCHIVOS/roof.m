function roof(arg1,arg2)
%
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
%               3D Roof using the Mandelbrot Fractals 
%               Written By Sridharan, Mithun Aiyswaryan
%               christian Albrechts Universität zu Kiel, Germany
%               Mail Your Comments At: s.mithun@indiatimes.com
%
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%               Help :
%               This program takes two arguments and computes the 
%               Mandelbrot sets using the provided values.
%               For the best viewing results, choose the arguments such that:
%
%               Argument 1 > 40     &             Argument 2 > 300     
%           
%               Note : The generation of fractals is  computationally 
%                      very intensive and it may take you a while before
%                      you observe the results on the screen!
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

dist1=-.25;
dist2=0;
l=2.5;
xaxis=linspace(dist1-sin(l)*10,dist1+sin(l)*10,arg2);
yaxis=linspace(dist1-sin(l)*10,dist1+sin(l)*10,arg2);
[xtrans,ytrans]=meshgrid(xaxis,yaxis);
t=zeros(arg2);
c=xtrans+i*ytrans;
for k=1:arg1;
t=t.^+c*(c+101);
tem=-(abs(t));
a = ( tem <-.5);
b = 1-a;
u = abs(c.*c);
d = b.*-.00002*(u);
end
e = d-1;
colormap(jet);
mesh(0.01*a+e);
