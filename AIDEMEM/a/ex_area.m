subplot(1,2,1);
x = linspace(-3*pi, 3*pi, 500); 
y = [sin(x)' sin(2*x)' cos(x)']; 
area(x, y); colormap(gray)
subplot(1,2,2);
fill(x,y(:,1),'r',x,y(:,2),'b',x,y(:,3),'y');
