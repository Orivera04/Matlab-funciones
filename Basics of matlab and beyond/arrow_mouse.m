function h = arrow_mouse( aspect, tail, head );
% function h = arrow_mouse( aspect, tail, head );
%
% Use mouse to place an arrow on your linear, loglog, or semilog plot.
% Optional args:   aspect    >1 = wider    <1 = narrower
%                  tail = [x y]  
%                  head = [x y]
%
% Examples:  h = arrow_mouse;                      % draw normal arrow with mouse
%            h = arrow_mouse( .75, [0 1], [5 9] ); % narrow arrow at specific place
%            h = arrow_mouse( 1.5 );               % draw wide arrow with mouse
%
%            h is the graphics handle for the arrow

% get the endpoints
if nargin~=3,
  % get coords
  sprintf('click on TAIL then HEAD of arrow')
  [x,y] = ginput(2);
  sprintf('tail=[%e %e];', x(1),  y(1))
  sprintf('head=[%e %e];', x(2),  y(2))
else
 x(1)=tail(1);
 y(1)=tail(2);
 x(2)=head(1);
 y(2)=head(2);
end

% build arrow prototype (from [0,0] to [1,0])
if nargin==0 | nargin==2,
  aspect=1;
end
d=.075;
s=1.2*pi/4; % 1/2 angle at the point of the arrow
q=.8;
p=max(.27,d/sin(s/2));
q=max(q,1-p*cos(s/2));
ax=[0,0,q,1-p*cos(s/2),1,1-p*cos(s/2),q,0];
ay=[-d/2,d/2,d/2,p*sin(s/2),0,-p*sin(s/2),-d/2,-d/2]*aspect;

% move endpoints to linear scale
% and find aspect ratio of plot

ys = get(gca,'yscale');
ylim = get(gca,'ylim');
if ys(1:3)=='log',
  yy = log10(y);
  ylim = log10(ylim);
else
  yy = y;
end
dy = diff(yy);

xs = get(gca,'xscale');
xlim = get(gca,'xlim');
if xs(1:3)=='log',
  xx = log10(x);
  xlim = log10(xlim);
else
  xx = x;
end
dx = diff(xx);

%correct prototype for length
ay=ay/sqrt(dy*dy+dx*dx);

% adjust prototype to square aspect
aspect = diff(ylim)/diff(xlim);
dy = dy/aspect;

% scale and shift prototype
r = dx + i*dy;              % complex representation of arrow at origin
m=abs(r);                   % length
a=angle(r);                 % angle
T = [cos(a),sin(a);-sin(a),cos(a)]; % rotation matrix
ar = [ax(:) ay(:)]*T;       % rotate prototype
ar(:,2)=ar(:,2)*aspect;     % correct destination aspect
nxy = ones(8,1)*[xx(1) yy(1)] + m*ar; %shift to tail point, scale to final size

% move back to log or semilog co-ordinates if necessary
if xs(1:3)=='log',
 x = 10.^nxy(:,1);
else
 x = nxy(:,1);
end
if ys(1:3)=='log',
 y = 10.^nxy(:,2);
else
 y = nxy(:,2);
end

% draw the arrow, black with narrow white edge
if aspect<1,
  h=patch(x,y,'w','linewidth',0.2,'edgecolor','w');
else
  h=patch(x,y,'k','linewidth',0.2,'edgecolor','w');
end
