% Script f05_05.m; continuous min integral-square terminal 
% control of hovering helicopter; code designed so that it
% does not have products of very large numbers with very 
% small numbers;                               2/94, 4/3/02

xo=[0 0 0 -10]'; tf=4; N=50;
A=[-.0257 .013 -.322 0; 1.26 -1.765 0 0; 0 1 0 0; 1 0 0 0];
B=[.086 -7.41 0 0]'; 
[T,ev]=eig(A); s=diag(ev); b=T\B; mo=T\xo; 
for i=1:4, for j=1:4,
    if s(i)+s(j)~=0,
      M1(i,j)=-b(i)/(s(i)+s(j)); 
    else M1(i,j)=0; end
end; end
M2(:,2)=M1(:,2); M1(:,2)=M1(:,2)*exp(s(2)*tf);
k=[1 3 4]; for i=1:3,
 M2(:,k(i))=M1(:,k(i))*exp(-s(k(i))*tf); 
 M3(k(i),k(i))=exp(-s(k(i))*tf);  M4(k(i),k(i))=1; 
end
M2(1,1)=b(1)*tf; M3(2,2)=1; M4(2,2)=exp(s(2)*tf);
M=[M1 M3;M2 M4]; ca=M\[mo;zeros(4,1)]; c=ca([1:4]); a=ca([5:8]);
t=[0:tf/N:tf]; L=M1; L(:,2)=M2(:,2); 
Q=[ones(size(t)); exp(s(2)*(tf*ones(size(t))-t)); 
    exp(-s(3)*t); exp(-s(4)*t)];  
u=real(c.'*Q); m=L*diag(c)*Q; m(1,:)=m(1,:)+b(1)*c(1)*t; 
m=m+diag(a)*[ones(size(t)); exp(s(2)*t); exp(-s(3)*...
   (tf*ones(size(t))-t)); exp(-s(4)*(tf*ones(size(t))-t))]; 
x=real(T*m); 

figure(1); clf; subplot(211), plot(t,x(4,:)); grid
axis([0 4 -10 0]); text(.75,-4,'Position y (ft)') 
subplot(212), plot(t,[x(3,:);u]); grid
xlabel('Time (sec)'); text(.5,10,'Cyclic Pitch (deci-in)')
text(1.7,-16,'Pitch Angle (crad)')
%print -deps2 f05_05
