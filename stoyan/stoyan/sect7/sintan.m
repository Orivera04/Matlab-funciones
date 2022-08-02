% © Gergo Lajos 1998; program a Grafika c. reszhez 
x=linspace(0,2*pi,50);
y=sin(x);
z=cos(x);
u=tan(x);
w=cot(x);
subplot(2,2,1);
plot(x,y),axis([0 2*pi -1 1]),title('sin(x)')
subplot(2,2,2)
plot(x,z),axis([0 2*pi -1 1]),title('cos(x)')
subplot(2,2,3)
plot(x,u),axis([0 2*pi -20 20]),title('tan(x)')
subplot(2,2,4)
plot(x,w),axis([0 2*pi -20 20]),title('cot(x)')