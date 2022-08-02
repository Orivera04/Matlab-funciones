function [xin,yin,Ind]=Inside(X,Y,xi,yi)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find those points (xi,yi) who are inside the polygone
% defined by the vectors (x,y).
% Syntax: [xin,yin,Ind]=Inside(X,Y,xi,yi)
% cd C:\MATLAB6p5\work
% Ind is the index of (xi,yi) that are inside the polygone
%
% Example:
% 
% %--- create polygone (x,y)
% phi=linspace(0,2*pi,50);
% X=(1+0.2*sin(6*phi)).*cos(phi);
% Y=(1+0.2*sin(6*phi)).*sin(phi);
% %--- random points (xi,yi)
% Nr=20;
% xi=randn(1,Nr);yi=randn(1,Nr);
% [xin,yin,Ind]=Inside(X,Y,xi,yi);
% %--- plot
% plot(X,Y,X,Y,'.',xi,yi,'ro',xin,yin,'b.');axis equal;
%
% Written by: Dr. Per A. Sundqvist 2004-11-17


%refine polygone
X(end+1)=X(1);Y(end+1)=Y(1);
ii=linspace(1,length(X),300);
x=spline(1:length(X),X,ii);
y=spline(1:length(X),Y,ii);
%find normal to each point
xp=diff(x);yp=diff(y);
xpp=diff(xp);ypp=diff(yp);
Crp1=cross([xp(1:end-1);yp(1:end-1);0*xp(1:end-1)],[xpp;ypp;0*xpp]);
s0=sign(sum(sqrt(xp(1:end-1).^2+yp(1:end-1).^2).*Crp1(3,:)));
Crp1=s0*abs(Crp1);
Crp2=cross([xp(1:end-1);yp(1:end-1);0*xp(1:end-1)],Crp1);
norm=Crp2./(ones(3,1)*sqrt(dot(Crp2,Crp2)));
%Find closest point on (x,y) to (xi,yi) 
Dx2=(x(:)*ones(1,length(xi))-ones(length(x),1)*xi(:)').^2;
Dy2=(y(:)*ones(1,length(xi))-ones(length(x),1)*yi(:)').^2;
[nons,CInd]=sort(Dx2+Dy2);
CInd=CInd(1,:); %find closest point on circumference
CInd(find(CInd==length(xi)))=length(xi)-1;  %No end-index
Dxic=xi-x(CInd);        %vector to closest point on boundary
Dyic=yi-y(CInd);
dotpr=dot([Dxic;Dyic;0*Dxic],norm(:,CInd));
Ind0=find(dotpr<0);  %Elements that are inside the polygone

xin=xi(Ind0);
yin=yi(Ind0);
Ind=Ind0;

