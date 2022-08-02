
A=[1 2;0 1]
p=cuadri;
v1=A*p(:,1);
v2=A*p(:,2);
v3=A*p(:,3);
v4=A*p(:,4);
v5=A*p(:,5);
C=cat(2,v1,v2,v3,v4,v5)
subplot(1,2,1)
plot(p(1,:),p(2,:));
axis([0 8 0 3])
subplot(1,2,2)
plot(C(1,:),C(2,:))
axis([0 8 0 3])