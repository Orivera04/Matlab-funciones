%Familia de funciones

x=0:0.1:10;
%y=(x-a)^2;
hold on;
for a=1:10;
    y=(x-a).^2;
    plot(x,y);
end
hold off