
%CLASSICALFRACTALS.M: Plots the following 3 Classical Fractals:-
%                     [1] Koch Curve
%                     [2] Sierpinski Gasket
%                     [3] Sierpinski Carpet
%
% "n" is the Number of Iterations.
% The typical range for n (for screen resolution 800*600) is as follows:-
% (i)  For Koch Curve n<7.
% (ii) For Sierpinski Gasket n<8.
% (iii)For Sierpinski Carpet n<5.
% To properly display results for higher values of n, use higher screen
% resolutions. Be patient for higher values of n.
%
% Usage: Type "classicalfractals" at Matlab command prompt to get started.
%
% Copyright (c) 2000 by Salman Durrani (dsalman@wol.net.pk).

function ClassicalFractals
K=[];
K = menu('Choose a Fractal','Koch Curve','Sierpinski Gasket','Sierpinski Carpet');
choice1=isempty(K);
if choice1==0
   prompt={'Enter Number of iterations n'};
   def={'3'};
   dlgTitle='Input for Classical Fractals function';
   lineNo=1;
   ans=inputdlg(prompt,dlgTitle,lineNo,def);
   choice=isempty(ans);
   if (choice==0)
      n=ceil(abs(str2num(char(ans(1)))));
      if K==1
         cfkoch(n)
      elseif K==2
         cfsierp(n)
      else
         cfcarpet(n)
      end  
   end
end

%-----------------------------------------------------
% Function to generate Koch Curve
function cfkoch(n)
s=get(0,'ScreenSize');
set(gcf,'Position',[0 0 s(3) s(4)-70],'Color',[0 0 0])
if (n==0)
   x=[0;1];
   y=[0;0];
   line(x,y,'Color','w');
   good_axis
   set(gcf,'Name','Koch Curve: Initiator (n=0)')
else
   levelcontrol=10^n;
   L=levelcontrol/(3^n);  
   l=ceil(L);
   kline(0,0,levelcontrol,0,l);
   good_axis
   if(n==1)
      set(gcf,'Name','Koch Curve: Generator (n=1)')
   else
      N=num2str(n);
      NN=strcat('Koch Curve',' n=',N);
      set(gcf,'Name',NN)
   end
   
end
%-----------------------------------------------------
function kline(x1,y1,x5,y5,limit)   
length=sqrt((x5-x1)^2+(y5-y1)^2); 
if(length>limit)
   x2=(2*x1+x5)/3;
   y2=(2*y1+y5)/3;
   x3=(x1+x5)/2-(y5-y1)/(2.0*sqrt(3.0));
   y3=(y1+y5)/2+(x5-x1)/(2.0*sqrt(3.0));
   x4=(2*x5+x1)/3;
   y4=(2*y5+y1)/3;
   % recursive calls
   kline(x1,y1,x2,y2,limit);
   kline(x2,y2,x3,y3,limit);
   kline(x3,y3,x4,y4,limit);
   kline(x4,y4,x5,y5,limit);
else 
   plotline(x1,y1,x5,y5); 
end
%------------------------------------------------------
% Function to generate Sierpinski Gasket
function cfsierp(n)
s=get(0,'ScreenSize');
set(gcf,'Position',[0 0 s(3) s(4)-70],'Color',[0 0 0]);
if (n==0)
   plotfilltri(0,0,1,0,0.5,0.866)
   good_axis
   set(gcf,'Name','Sierpinski Gasket: Initiator (n=0)')
else
   levelcontrol=5^n;
   L=(levelcontrol/(2^n));  
   l=ceil(L);
   slinec(0,0,levelcontrol,0,(levelcontrol/2),levelcontrol*sin(pi/3),l);
   good_axis
   if(n==1)
      set(gcf,'Name','Sierpinski Gasket: Generator (n=1)')
   else
      N=num2str(n);
      NN=strcat('Sierpinski Gasket',' n=',N);
      set(gcf,'Name',NN)
   end
end
%-----------------------------------------------
function slinec(x1,y1,x2,y2,x3,y3,limit)
side1=sqrt((x1-x2)^2+(y1-y2)^2);
side2=sqrt((x1-x3)^2+(y1-y3)^2);
side3=sqrt((x3-x2)^2+(y3-y2)^2);
if(side1>limit | side2>limit |side3>limit  )
   x6=(x1+x2)/2;
   y6=(y1+y2)/2;
   x5=(x2+x3)/2;
   y5=(y2+y3)/2;
   x4=(x1+x3)/2;
   y4=(y1+y3)/2;
   % recursive calls
   slinec(x1,y1,x4,y4,x6,y6,limit)
   slinec(x2,y2,x6,y6,x5,y5,limit)
   slinec(x3,y3,x4,y4,x5,y5,limit)
else
   plotfilltri(x1,y1,x2,y2,x3,y3);
end
%------------------------------------------------
% Function to generate Sierpinski Carpet
function cfcarpet(n)
s=get(0,'ScreenSize');
set(gcf,'Position',[0 0 s(3) s(4)-70],'Color',[0.75 0.75 0.75])
if (n==0)
   x=[0,1,1,0];
   y=[0,0,1,1];
   patch(x,y,'k');
   good_axis
   set(gcf,'Name','Sierpinski Carpet: Initiator (n=0)')
else
   levelcontrol=10^n;
   L=(levelcontrol/(3^n));  
   l=ceil(L);
   carp(0,0,levelcontrol,0,levelcontrol,levelcontrol,0,levelcontrol,l)
   good_axis;
   if(n==1)
      set(gcf,'Name','Sierpinski Carpet: Generator (n=1)')
   else
      N=num2str(n);
      NN=strcat('Sierpinski Carpet',' n=',N);
      set(gcf,'Name',NN)
   end
end
%--------------------------------------------------
function carp(x1,y1,x4,y4,x16,y16,x13,y13,limit)
if(abs(x1-x4)>limit|abs(x16-x4)>limit|abs(x16-x13)>limit|abs(x13-x1)>limit|...
      abs(y1-y4)>limit|abs(y16-y4)>limit|abs(y16-y13)>limit|abs(y13-y1)>limit)
   
   a=abs((x4-x1)/3);
   b=abs((y13-y1)/3);
   
   x2=x1+a;    y2=y1;                   
   x3=x1+2*a;  y3=y1;
   x5=x1;      y5=y1+b; 
   x6=x1+a;    y6=y1+b;
   x7=x1+2*a;  y7=y1+b;
   x8=x4;      y8=y1+b; 
   x9=x1;      y9=y1+2*b;
   x10=x1+a;   y10=y1+2*b;
   x11=x1+2*a; y11=y1+2*b; 
   x12=x4;     y12=y1+2*b; 
   x14=x1+a;   y14=y13;
   x15=x1+2*a; y15=y13;
   % recursive calls
   carp(x1,y1,x2,y2,x6,y6,x5,y5,limit);
   carp(x2,y2,x3,y3,x7,y7,x6,y6,limit);
   carp(x3,y3,x4,y4,x8,y8,x7,y7,limit);
   carp(x5,y5,x6,y6,x10,y10,x9,y9,limit);
   carp(x7,y7,x8,y8,x12,y12,x11,y11,limit);
   carp(x9,y9,x10,y10,x14,y14,x13,y13,limit);
   carp(x10,y10,x11,y11,x15,y15,x14,y14,limit);
   carp(x11,y11,x12,y12,x16,y16,x15,y15,limit);
else
   fillrec(x1,y1,x4,y4,x16,y16,x13,y13);
end
%---------------------------------------------------------
function fillrec(a1,b1,a2,b2,a3,b3,a4,b4)
X=[a1,a2,a3,a4];
Y=[b1,b2,b3,b4];
fill(X,Y,[0 0 0]);
hold on;
%----------------------------------------------------------
function plotfilltri(a1,b1,a2,b2,a3,b3)
X=[a1,a2,a3];
Y=[b1,b2,b3];
fill(X,Y,[1 0 0]);
hold on;
%----------------------------------------------------------
function plotline(a1,b1,a2,b2)
x=[a1;a2];
y=[b1;b2];
line(x,y,'Color','w');
%----------------------------------------------------------
function good_axis
axis equal
set(gca,'Visible','off')