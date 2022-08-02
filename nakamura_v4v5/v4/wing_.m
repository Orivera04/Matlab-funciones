% wing_ generates a wing data used in plane_
% (originally named wing_2d)
% Example:   [x,y,z]=wing_; mesh(x,y,z)
% See Figure B.3
function [zw,xw,yw] = wing_
x=0:0.1:1;
n=length(x);
for k=1:30

for i=2:n-1
x(i)=0.5*x(i-1)+0.4*x(i+1);
end
end
for i=2:n
x(n+i-1)=x(n-i+1);
end
y=0.2969*sqrt(x) - 0.126*x - 0.3516*x.^2  + ...
      0.2843 * x.^3 - 0.1015*x.^4;
for i=n+1:length(y)
y(i)=-y(i);
end
%axis([-0.5, 1.5 ,-1 1])
%plot(x,y)
jmax=15;
for j=1:jmax
for i=1:2*n-1

xw(i,j)=x(i);
yw(i,j)=y(i);
zw(i,j)=0.3*(j-1);
end

end
yw(:,jmax)=zeros(size(yw(:,jmax)));
zw(:,jmax)=zw(:,jmax-1);

%mesh(zw,xw,yw)
%axis([0,2,0,2,-1,1])








