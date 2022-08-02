Base=0.07; %meters
Height=0.1; %meters
BaseHeight=0.02; %meters
WebT=0.01; %meters
Shear=25; %shear
Ix=tbeam(Base,Height,BaseHeight,WebT,'n','Ix');
CentY=tbeam(Base,Height,BaseHeight,WebT,'n','centY');
x=linspace(0,Base,50);
y=linspace(0,Height,50);
[X,Y]=meshgrid(x,y);
ShearStress=zeros(size(X));
BaseArea=find(Y>=Height-BaseHeight);
BaseAreaT=Base;
BaseAreaQ=abs((Y+Height)/2-CentY).*(Height-Y)*Base;
ShearStress(BaseArea)=Shear*BaseAreaQ(BaseArea)/(Ix*BaseAreaT);
WebArea=find(X>(Base-WebT)/2 &X<(Base+WebT)/2 & Y<Height-BaseHeight);
WebAreaT=WebT;
WebAreaQ=abs((Y/2)-CentY).*Y*Base;
ShearStress(WebArea)=Shear*WebAreaQ(WebArea)/(Ix*WebAreaT);
invalid=find((X<(Base-WebT)/2 | X>(Base+WebT)/2) & (Y<Height-BaseHeight));
ShearStress(invalid)=nan;
mesh(X,Y,ShearStress)
