	function [f1,f2,f3,f4,f5]=dvdpcn(u,s,dt,t,flg)                             
	% Subroutine for Pb. 8.4.01a; DVDP for max range
	% with gravity w. spec. yf;
	% s=[v x y]'; u=gamma;  t in units of tf, v in 
	% g*tf, (x,y) in g*(tf)^2;		4/29/97
	%				          
	yf=.1; sy=1e3; 
	v=s(1); x=s(2); y=s(3); c=cos(u); si=sin(u);
	dl=dt*(v+.5*si*dt);
	if flg==1,
	 f1=[v+si*dt; x+c*dl; y+si*dl];            % f1 = f
	elseif flg==2,
	 f1=[x; y-yf];               	         % f1 = Phi
	 f2=[0 1 0; 0 0 1];                     % f2 = Phis
	 f3=zeros(6,3);                        % f3 = Phiss
	elseif flg==3,
	 f1=[1 0 0; dt*c 1 0; dt*si 0 1];         % f1 = fs
	 f2=dt*[c; -v*si+dt*(.5-si^2); v*c+dt*si*c];           
	     				          % f2 = fu
	 f3=zeros(9,3);				 % f3 = fss
	 f4=[0 0 0; -dt*si 0 0; dt*c 0 0];       % f4 = fsu
	 f5=dt*[-si; -v*c-dt*2*si*c; -v*si+dt*(c^2-si^2)];
						 % f5 = fuu
	end

