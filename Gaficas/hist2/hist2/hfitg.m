function [parout,chisq]=hfitg(x,n,miny,maxy)
global ndf;

hold off
if (nargin == 2)
  miny=min(min(x));
  maxy=max(max(x));
end
[ny,nx]=hpl(x,n,miny,maxy);
%par=[1,1,1000];
ind=find (x >= miny & x <= maxy);
par(1)=median(x(ind));
par(2)=std(x(ind));
par(3)=max(ny);
[parout,chisq]=chisq_min(par,nx,ny);
hold on
plot(nx,parout(3)*g(nx,parout(1),parout(2)),'r')
hold off
v=axis;


mean_value=['Mean: ',num2str(parout(1))];
std_value=['Sigma: ',num2str(parout(2))];
max_value=['Max: ',num2str(parout(3))];
chi2_value=['Chi2/ndf: ',num2str(chisq/(length(x)-3))];

xper=.27;yper=.05;
text(v(1)*xper+v(2)*(1-xper),v(3)*yper+v(4)*(1-yper),mean_value)
yper=yper+.05;
text(v(1)*xper+v(2)*(1-xper),v(3)*yper+v(4)*(1-yper),std_value)
yper=yper+.05;
text(v(1)*xper+v(2)*(1-xper),v(3)*yper+v(4)*(1-yper),max_value)
yper=yper+.05;
text(v(1)*xper+v(2)*(1-xper),v(3)*yper+v(4)*(1-yper),chi2_value)


xline=v(1)*(xper-.1)+v(2)*(.9-xper);
yline=v(3)*(yper-.05)+v(4)*(.95-yper);
%line([xline,xline],[v(4),yline])
%line([xline,v(2)],[yline,yline])
