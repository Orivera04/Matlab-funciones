function     [X,Y] = biela(X1,Y1,d,n)
p1=[X1(1,1),Y1(1,1)];
p2=[X1(1,2),Y1(1,2)];
a=atan2(Y1(1,2)-Y1(1,1),X1(1,2)-X1(1,1));
b=pi/2-a;
for i=1:n
    p(i,:)=p2+d*[cos(-b+i*pi/n),sin(-b+i*pi/n)];
end
for i=1:n
    p(n+i,:)=p1+d*[cos(a+pi/2+i*pi/n),sin(a+pi/2+i*pi/n)];
end
p(2*n+1,:)=p(1,:);
X=p(:,1);
Y=p(:,2);
