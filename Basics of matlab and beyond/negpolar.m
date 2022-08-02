function negpolar(theta,rho,line_style,dbmin,offnums)

%NEGPOLAR Polar coordinate plot with 0 on the perimeter and negative values
%       going towards the centre.  (Intended for polar plots in
%       dB.)  
%
%       NEGPOLAR(THETA, RHO) makes a plot using polar coordinates of
%       the angle THETA, in radians, versus the radius RHO.
%
%       NEGPOLAR(THETA,RHO,S) uses the linestyle specified in string S.  See
%       PLOT for a description of legal linestyles.  The vector rho is
%       assumed to comprise values which are all less than zero.
%
%       NEGPOLAR(THETA,RHO,S,DBMIN) uses the value of DBMIN at the centre so
%       that the radial scale will go from DBMIN to 0, (DBMIN<0).  
%
%       NEGPOLAR(THETA,RHO,S,DBMIN,1) switches off the angle labels
%       around the outside.
%
%       See also
%       PLOT, LOGLOG, SEMILOGX, SEMILOGY.

%  Modification of polar.m by A. Knight, Nov. 1995

if nargin < 1
	error('Requires more input arguments.')
end
if nargin == 2 
  if isstr(rho)
    line_style = rho;
    rho = theta;
    [mr,nr] = size(rho);
    if mr == 1
      theta = 1:nr;
    else
      th = (1:mr)';
      theta = th(:,ones(1,nr));
    end
  else
    line_style = 'auto';
  end
elseif nargin == 1
  line_style = 'auto';
  rho = theta;
  [mr,nr] = size(rho);
  if mr == 1
    theta = 1:nr;
  else
    th = (1:mr)';
    theta = th(:,ones(1,nr));
  end
end
if nargin<5
  offnums = 0;
end
if isstr(theta) | isstr(rho)
  error('Input arguments must be numeric.');
end
if any(size(theta) ~= size(rho))
  error('THETA and RHO must be the same size.');
end

rho = abs(rho);
if exist('dbmin')
  ind = find(rho>-dbmin);
  rho(ind) = -dbmin*ones(size(ind));
end

% get hold state
cax = newplot;
next = lower(get(cax,'NextPlot'));
hold_state = ishold;

% get x-axis text color so grid is in same color
tc = get(cax,'xcolor');

% only do grids if hold is off
if ~hold_state
  
  % make a radial grid
  hold on;
  hhh=plot([0 max(theta(:))],[0 max(abs(rho(:)))]);
  if nargin==4
    set(cax,'ylim',[0 abs(dbmin)]);
  end
  v = [get(cax,'xlim') get(cax,'ylim')];
  ticks = length(get(cax,'ytick'));
  delete(hhh);
  % check radial limits and ticks
  rmin = 0;
  rmax = v(4);
  rticks = ticks-1;
  if rticks > 5 			% see if we can reduce the number
    if rem(rticks,2) == 0
      rticks = rticks/2;
    elseif rem(rticks,3) == 0
      rticks = rticks/3;
    end
  end
  
  % define a circle
  th = 0:pi/50:2*pi;
  xunit = cos(th);
  yunit = sin(th);
  
  rinc = (rmax-rmin)/rticks;
  for i=(rmin+rinc):rinc:rmax
    plot(xunit*i,yunit*i,':','color',tc);
    text(0,i+rinc/20,[num2str(i - rmax) 'dB'],'verticalalignment','top');
  end
  
  % plot spokes
  th = (1:6)*2*pi/12;
  cst = cos(th); snt = sin(th);
  cs = [-cst; cst];
  sn = [-snt; snt];
  plot(rmax*cs,rmax*sn,':','color',tc);
  
  if offnums~=1
    % annotate spokes in degrees
    rt = 1.1*rmax;
    for i = 1:max(size(th))
      text(rt*cst(i),rt*snt(i),int2str(i*30),'horizontalalignment','center');
      if i == max(size(th))
	loc = int2str(0);
      else
	loc = int2str(180+i*30);
      end
      text(-rt*cst(i),-rt*snt(i),loc,'horizontalalignment','center');
    end
  end
end
% set viewto 2-D
view(0,90);
% set axis limits
axis(rmax*[-1 1 -1 1]);
%  Need to get the right value of rmax:
v = [get(cax,'xlim') get(cax,'ylim')];
rmax = v(4);


% transform data to Cartesian coordinates.
xx = (rmax - rho).*cos(theta);
yy = (rmax - rho).*sin(theta);

% plot data on top of grid
if strcmp(line_style,'auto')
	plot(xx,yy)
else
	plot(xx,yy,line_style)
end
if ~hold_state
	axis('square');axis('off');
end

% reset hold state
if ~hold_state, set(cax,'NextPlot',next); end
