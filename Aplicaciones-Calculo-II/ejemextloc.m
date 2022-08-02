	xx=0:0.01:35; y=sin(xx) + cos(xx ./3); 
	plot(xx,y); grid; hold on;
	[b,a]=lmax(y,2)
	 plot(xx(a),y(a),'r+')%	see also LMIN, MAX, MIN