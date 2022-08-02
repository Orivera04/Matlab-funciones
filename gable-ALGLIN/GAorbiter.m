function GAo(deg, sec)
% GAorbiter(d,s): Rotate the views in all subwindows simultaneously
%  The arguments are optional.  
%   d: the number of total degrees (default 360)
%   s: The number of seconds to rotate before stopping (default 10)
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
if nargin==0
  deg = 360;
end
[az el] = view;
if nargin < 2
  sec = 10;
end
n = 100;
iaz = az;

sp = get(gcf,'Children');
for j=1:length(sp)
  subplot(sp(j))
  axis vis3d
end

i = 0;
iang = deg/sec/10;
  tic
for i=1:2
  for j=1:length(sp)
    subplot(sp(j))
    view([az+i*iang el])
  end
  drawnow
end
s = toc ;
ts = s;
n = floor(sec*2/s) ;
if n <= 2
  n = 3;
end
ang = (deg-2*iang)/(n -2);
  tic
az = az + 2*iang - 2*ang;
for i=3:n
  for j=1:length(sp)
    subplot(sp(j))
    view([az+i*ang el])
  end
  drawnow
end
  s = toc ;
%  ts = ts + s
%  az+n*ang-iaz
