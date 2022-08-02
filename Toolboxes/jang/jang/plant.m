function out = plant(y, u);

%out = y*u/(1+y^2)-sin(u);	% no good
%out = 0.8*sin(2*y)+1.2*u;	% fine
out = y*u/(1+y^2)-tan(u);	% fine
