i=0; %an index
for n=0:0.1:DR(720) %counting from zero to 180 deg by a small amount
	i=i+1;
	y(i)=sin(n);
	x(i)=n;
end
plot (x,y)
