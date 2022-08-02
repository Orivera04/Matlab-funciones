%Familia de funciones

x=0:0.1:5;
%y=(x-a)2;
hold on;
for a=1:0.1:10;
    y=(x-a).^3;
    plot(x,y);
end
hold off