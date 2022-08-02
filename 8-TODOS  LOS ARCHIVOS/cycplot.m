
function cycplot(s,a,e)

%function cycplot(s,a,e)
%
%To plot a Fourier transform as a three dimensional cyclic
%plot (see Bracewell "The Fourier Transform and its
%Applications," p363.
%           s = Fourier transform of something (the real part
%               is used)
%           a = azimuth of viewpoint
%           e = elevation of viewpoint
%
%                   Andrew Knight June 1991;

s = real(s);
[m,n] = size(s);
if min(m,n)>1
   error('s must be a vector.')
elseif m>1
   s = s';
end

xx = [1:n ; 1:n];
yy = [zeros(1:n) ; s];
theta = linspace(-pi/2,3*pi/2,n + 1);
theta = theta(1:n);
x3d = cos(theta);
y3d = sin(theta);
[Y,Z] = rota3d(x3d,y3d,yy(2,:),a,e);
[Yzero,Zzero] = rota3d(x3d,y3d,zeros(1:n),a,e);
YY = [Yzero ; Y];
ZZ = [Zzero ; Z];

%Axes:

xax = [1 -1 0 0];yax = [0 0 1 -1];zax = [0 0 0 0];
[Yax,Zax] = rota3d(xax,yax,zax,a,e);
Yax = reshape(Yax,2,2);
Zax = reshape(Zax,2,2);


%Base circle:
theta = linspace(0,2*pi,200);
xcirc = cos(theta);
ycirc = sin(theta);
zcirc = zeros(xcirc);
[Ycirc,Zcirc] = rota3d(xcirc,ycirc,zcirc,a,e);


M_ax = max(max(Zax,Yax));
m_ax = min(min(Zax,Yax));
M_circ = max(max(Zcirc,Ycirc));
m_circ = min(min(Zcirc,Ycirc));
M_ZY = max(max(Z,Y));
m_ZY = min(min(Z,Y));
M = max([M_ax,M_circ,M_ZY]);
m = min([m_ax,m_circ,m_ZY]);
axis([m M m M])
hold on

plot(Zax,Yax,'g-',...
     Zcirc,Ycirc,'b-',...
     ZZ,YY,'c12-',Z,Y,'c5o')

		 
hold off	  
