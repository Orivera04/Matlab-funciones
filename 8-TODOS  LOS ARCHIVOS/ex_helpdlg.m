[im map] = imread('ellipses.tif');
cs.WindowStyle='replace';
cs.Interpreter='tex';
h=msgbox('\bfNotre �diteur','Un message de','custom', im , map, ...
	 cs);
get(h,'type')
figure(h)