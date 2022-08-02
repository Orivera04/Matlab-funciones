%Onda cuadrada
x=[0,0.25,0.25,0.75,0.75,1];
X=x;
for i=1:3
X=cat(2,X,x+i);
end
X;
y=[1,1,-1,-1,1,1];
Y=repmat(y,1,4);
plot(X,Y,'r-');
axis([-4.5 4.5 -3 3]);
hold on;
X=-X;
plot(X,Y,'r-');
drawAxes(2, 'k');
