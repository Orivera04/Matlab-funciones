t=0:pi/8:2*pi;
k=length(t);
 y=sin(t);
 x=cos(t);
 z=zeros(1,k);
 z1=3*ones(1,k);
 plot3(x,y,z1);
 hold on;
 plot3(x,y,z);
 for i=1:k
clear x1 y1 z1;   
x1=cos((k-1)*pi/8)
y1=sin((k-1)*pi/8)
z1=0;
X=[x1,x1]; Y=[y1,y1]; Z=[z1,3];
plot3(X,Y,Z)
end
