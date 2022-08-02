function Y=tmp_sys(t,X); 
Y=zeros(3,1); 
x1=X(1); 
x2=X(2); 
x3=X(3); 
Y(1)=sin(x3)+4*cos(x2)+randn*(0)^0.5+rand/0.2886*(0)^0.5; 
Y(2)=2*sin(x1)+cos(x3)+randn*(0)^0.5+rand/0.2886*(0)^0.5; 
Y(3)=4*sin(x2)+2*cos(x1)+randn*(0)^0.5+rand/0.2886*(0)^0.5; 
