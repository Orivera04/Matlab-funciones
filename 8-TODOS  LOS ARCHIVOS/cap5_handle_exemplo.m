echo on
% cap5_handle_exemplo
Hf =figure(1); 
Ha1=axes('Position',[0.1 0.1 0.35 0.8]);
Ha2=axes('Position',[0.55 0.1 0.35 0.8]);
axes(Ha1);
x=0:0.1:2*pi;
plot(x,sin(x))
axes(Ha2);
a=imread('NGJuly2002.jpg');
image(a)
