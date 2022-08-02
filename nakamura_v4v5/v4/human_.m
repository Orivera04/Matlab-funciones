% function human_ draws a sketch of a human.
% angles of body joints may be controlled by input.
% See Figures 2.33, and 2.34, and 2.36; also FM2_5.
% Copyright S. Nakamura, 1995
function y =  human_(p1,p2, Body,   ... 
Rarm1,Rarm2,Larm1,Larm2, ...
Rleg1,Rleg2,Lleg1,Lleg2  )
% See script of kids_.m for examples. 
x0=p1(1);
y0=p1(2);
x1=p2(1);
y1=p2(2);
c = (x1-x0)/2;  d = (y1 - y0)/2;
f = (x1+x0)/2;  g = (y1 + y0)/2;
M = [c,-d; d,c]/3; F = [f,g]';
  thb = Body/180*pi;% body angle
  thrh1=Rarm1/180*pi;% right arm theta-1
  thrh2=Rarm2/180*pi;% right arm theta-2
  thlh1=Larm1/180*pi;% left arm theta-1
  thlh2=Larm2/180*pi;% left arm theta-2
  thrg1=Rleg1/180*pi;% right leg theta-1
  thrg2=Rleg2/180*pi;% right leg theta-2
  thlg1=Lleg1/180*pi;% left leg theta-1
  thlg2=Lleg2/180*pi;% left leg theta-2
  t = 0:0.25:6.3;
% body
  b1=[0,0]';
  b2=b1 + 1.5*[sin(thb), cos(thb)]';
  b3=b1 + 2*[sin(thb), cos(thb)]';
  b=[b1,b2,b3];
  [m,n]=size(b); w=ones(1,n); b = M*b+[f*w;g*w]; 
  plot(b(1,:), b(2,:))

% head
  b4=b3+1.*[sin(thb), cos(thb)]';
  xHd= 1.*cos(t)+b4(1);
  yHd= 1.*sin(t)+b4(2);
  b = [xHd; yHd];
  w=ones(1,n);
  [m,n]=size(b); w=ones(1,n); b = M*b+[f*w;g*w]; 
  plot(b(1,:), b(2,:))

%right arm/hand
  rh1=b2;
  rh2=rh1 + 1.5*[cos(thrh1), sin(thrh1)]';
  rh3=rh2 + 1.5*[cos(thrh2), sin(thrh2)]';
  rh4=rh3 + 0.2*[cos(thrh2), sin(thrh2)]';
  b=[rh1,rh2,rh3];

 w=ones(1,n);
  [m,n]=size(b); w=ones(1,n); b = M*b+[f*w;g*w]; 
  plot(b(1,:), b(2,:))
  xrp= 0.2*cos(t)+rh4(1);
  yrp= 0.2*sin(t)+rh4(2);
  b=[xrp;yrp];
  w=ones(1,n);
  [m,n]=size(b); w=ones(1,n); b = M*b+[f*w;g*w]; 
  plot(b(1,:), b(2,:))
%left arm/hand
  lh1=b2;
  lh2=lh1 + 1.5*[-cos(thlh1), sin(thlh1)]';
  lh3=lh2 + 1.5*[-cos(thlh2), sin(thlh2)]';
  lh4=lh3 + 0.2*[-cos(thlh2), sin(thlh2)]';
  b=[lh1,lh2,lh3];
w=ones(1,n);
  [m,n]=size(b); w=ones(1,n); b = M*b+[f*w;g*w] ;
  plot(b(1,:), b(2,:))
  xlp= 0.2*cos(t)+lh4(1);
  ylp= 0.2*sin(t)+lh4(2);
b = [xlp;ylp];
 w=ones(1,n);
  [m,n]=size(b); w=ones(1,n); b = M*b+[f*w;g*w] ;
  plot(b(1,:), b(2,:))
%right leg/foot
  rg1=b1;
  rg2=rg1 + 1*[cos(thrg1), -sin(thrg1)]';
  rg3=rg2 + 1.5*[cos(thrg2), -sin(thrg2)]';
  rg4=rg3 + 0.2*[cos(thrg2), -sin(thrg2)]';
  b=[rg1,rg2,rg3];
  w=ones(1,n);
  [m,n]=size(b); w=ones(1,n); b = M*b+[f*w;g*w]; 
  plot(b(1,:), b(2,:))
  xrf= 0.2*cos(t)+rg4(1);
  yrf= 0.2*sin(t)+rg4(2);
  b=[ xrf; yrf];
  w=ones(1,n);
  [m,n]=size(b); w=ones(1,n); b = M*b+[f*w;g*w]; 
  plot(b(1,:), b(2,:))
%left leg/foot
  lg1=b1;
  lg2=lg1 + 1.*[-cos(thlg1), -sin(thlg1)]';
  lg3=lg2 + 1.5*[-cos(thlg2), -sin(thlg2)]';
  lg4=lg3 + 0.2*[-cos(thlg2), -sin(thlg2)]';
  b=[lg1,lg2,lg3];
  w=ones(1,n);
  [m,n]=size(b); w=ones(1,n); b = M*b+[f*w;g*w]; 
  plot(b(1,:), b(2,:))
  xlf= 0.2*cos(t)+lg4(1);
  ylf= 0.2*sin(t)+lg4(2);
  b=[xlf;ylf];

  [m,n]=size(b); w=ones(1,n); b = M*b+[f*w;g*w] ;
  plot(b(1,:), b(2,:))






