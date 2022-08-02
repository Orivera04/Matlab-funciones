t=-2:.1:2;
x=100*t;
y=-9.8/2*t.^2+20;
for i=1:length(t)
plot(-200,0)
hold on
plot(200,25)
plot(x(i),y(i),'o')
plot(x(1:i),y(1:i),'.')
pause(.05)

%===para Hacer GIF===
Image = getframe;
P = frame2im(Image);
number = num2str(i);
extension = '.bmp';
filename = [number,extension];
imwrite(P,eval('filename'), 'bmp');
hold off
end
