function [cout,H,CS] = mbccontourf(ax,varargin)
%MBCCONTOURF  Filled contour plot.
%
% Similar to "contourf", but with an additional first
% parameter, which must be the handle to the parent axes

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $


fig = get(ax,'parent');


error(nargchk(1,5,nargin));

% Check for empty arguments.
for i = 1:nargin-1
  if isempty(varargin{i})
    error ('Invalid Argument - Input matrix is empty');
  end
end

% Trim off the last arg if it's a string (line_spec).
nin = nargin-1;
if isstr(varargin{end})
  [lin,col,mark,msg] = colstyle(varargin{end});
  if ~isempty(msg), error(msg); end
  nin = nin - 1;
else
  lin = '';
  col = '';
end

if (nin == 4),
   [x,y,z,nv] = deal(varargin{1:4});
   if (size(y,1)==1), y=y'; end;
   if (size(x,2)==1), x=x'; end;
   [mz,nz] = size(z);
elseif (nin == 3),
  [x,y,z] = deal(varargin{1:3});
  nv = [];
  if (size(y,1)==1), y=y'; end;
  if (size(x,2)==1), x=x'; end;
  [mz,nz] = size(z);
elseif (nin == 2),
  [z,nv] = deal(varargin{1:2});
  [mz,nz] = size(z);
  x = 1:nz;
  y = (1:mz)';
elseif (nin == 1),
  z = varargin{1};
  [mz,nz] = size(z);
  x = 1:nz;
  y = (1:mz)';
  nv = [];
end

if nin <= 2,
    [mc,nc] = size(varargin{1});
    lims = [1 nc 1 mc];
else
    lims = [min(varargin{1}(:)),max(varargin{1}(:)), ...
            min(varargin{2}(:)),max(varargin{2}(:))];
end

i = find(isfinite(z));
minz = min(z(i));
maxz = max(z(i));

% Generate default contour levels if they aren't specified 
if length(nv) <= 1
  if isempty(nv)
    CS=contourc([minz maxz ; minz maxz]);
  else
    CS=contourc([minz maxz ; minz maxz],nv);
  end

  % Find the levels
  ii = 1;
  nv = minz; % Include minz so that the contours are totally filled 
  while (ii < size(CS,2)),
    nv=[nv CS(1,ii)];
    ii = ii + CS(2,ii) + 1;
  end
end

% Don't fill contours below the lowest level specified in nv.
% To fill all contours, specify a value of nv lower than the
% minimum of the surface. 
draw_min=0;
if any(nv <= minz),
  draw_min=1;
end

% Get the unique levels
nv = sort([minz nv(:)']);
zi = [1, find(diff(nv))+1];
nv = nv(zi);

% Surround the matrix by a very low region to get closed contours, and
% replace any NaN with low numbers as well.

zz=[ repmat(NaN,1,nz+2) ; repmat(NaN,mz,1) z repmat(NaN,mz,1) ; repmat(NaN,1,nz+2)];
kk=find(isnan(zz(:)));
zz(kk)=minz-1e4*(maxz-minz)+zeros(size(kk));

xx = [2*x(:,1)-x(:,2), x, 2*x(:,nz)-x(:,nz-1)];
yy = [2*y(1,:)-y(2,:); y; 2*y(mz,:)-y(mz-1,:)];
if (min(size(yy))==1),
  [CS,msg]=contours(xx,yy,zz,nv);
else
  [CS,msg]=contours(xx([ 1 1:mz mz],:),yy(:,[1 1:nz nz]),zz,nv);
end;
if ~isempty(msg), error(msg); end

% Find the indices of the curves in the c matrix, and get the
% area of closed curves in order to draw patches correctly. 
ii = 1;
ncurves = 0;
I = [];
Area=[];
while (ii < size(CS,2)),
  nl=CS(2,ii);
  ncurves = ncurves + 1;
  I(ncurves) = ii;
  xp=CS(1,ii+(1:nl));  % First patch
  yp=CS(2,ii+(1:nl));
  Area(ncurves)=sum( diff(xp).*(yp(1:nl-1)+yp(2:nl))/2 );
  ii = ii + nl + 1;
end

view(ax,2);
set(ax,'box','on');
set(ax,'xlim',lims(1:2),'ylim',lims(3:4))

% Plot patches in order of decreasing size. This makes sure that
% all the levels get drawn, not matter if we are going up a hill or
% down into a hole. When going down we shift levels though, you can
% tell whether we are going up or down by checking the sign of the
% area (since curves are oriented so that the high side is always
% the same side). Lowest curve is largest and encloses higher data
% always.

H=[];
[FA,IA]=sort(-abs(Area));
if ~isstr(get(ax,'color')),
  bg = get(ax,'color');
else
  bg = get(fig,'color');
end
if isempty(col)
  edgec = get(fig,'defaultsurfaceedgecolor');
else
  edgec = col;
end
if isempty(lin)
  edgestyle = get(fig,'defaultpatchlinestyle');
else
  edgestyle = lin;
end

% Tolerance for edge comparison
xtol = 0.1*(lims(2)-lims(1))/size(z,2);
ytol = 0.1*(lims(4)-lims(3))/size(z,1);

if nargout>0
  cout = [];
end
for jj=IA,
  nl=CS(2,I(jj));
  lev=CS(1,I(jj));
  if (lev ~= minz | draw_min ),
    xp=CS(1,I(jj)+(1:nl));  
    yp=CS(2,I(jj)+(1:nl));
    clev = lev;           % color for filled region above this level
    if (sign(Area(jj)) ~=sign(Area(IA(1))) ),
      kk=find(nv==lev);
      kk0 = 1 + sum(nv<=minz) * (~draw_min);
      if (kk > kk0)
        clev=nv(kk-1);    % in valley, use color for lower level
      elseif (kk == kk0)
        clev=NaN;
      else 
        clev=NaN;         % missing data section
        lev=NaN;
      end
    end

    if (isfinite(clev)),
      H=[H;patch(xp,yp,clev,'parent',ax,'facecolor','flat','edgecolor',edgec, ...
              'linestyle',edgestyle,'userdata',lev)];
    else
      H=[H;patch(xp,yp,clev,'parent',ax,'facecolor',bg,'edgecolor',edgec, ...
              'linestyle',edgestyle,'userdata',CS(1,I(jj)))];
    end
    
    if nargout>0
      % Ignore contours that lie along a boundary
      
      % Get +1 along lower boundary, -1 along upper, 0 in middle
      tx = (abs(xp - lims(1)) < xtol ) - (abs(xp - lims(2)) < xtol);
      ty = (abs(yp - lims(3)) < ytol ) - (abs(yp - lims(4)) < ytol);

      % Locate points with a boundary contour segment leading up to them
      bcf = find((tx & [0 ~diff(tx)]) | (ty & [0 ~diff(ty)]));

      if (~isempty(bcf))
         % Get a logical vector that has 0 inserted before each such location
         wuns = true(1,length(xp) + length(bcf));
         wuns(bcf + (0:(length(bcf)-1))) = 0;

         % Create new arrays so that NaN breaks each boundary contour segment
         xp1 = NaN * wuns;
         yp1 = xp1;
         xp1(wuns) = xp;
         yp1(wuns) = yp;

         % Remove unnecessary elements
         if (length(xp1) > 2)
            % Blank out segments consisting of a single point
            tx = ([1 isnan(xp1(1:end-1))] & [isnan(xp1(2:end)) 1]);
            xp1(tx) = NaN;
            
            % Remove consecutive NaNs or NaNs on either end
            tx = isnan(xp1) & [isnan(xp1(2:end)) 1];
            xp1(tx) = [];
            yp1(tx) = [];
            if (length(xp1)>2 & isnan(xp1(1)))
               xp1 = xp1(2:end);
               yp1 = yp1(2:end);
            end
            
            % No empty contours allowed
            if (length(xp1) == 0)
               xp1 = NaN;
               yp1 = NaN;
            end
         end

         % Update the contour segments and their length
         xp = xp1;
         yp = yp1;
         nl = length(xp);
      end

      cout = [cout,[lev xp;nl yp]];
    end
  end
end

numPatches = length(H);
if numPatches>1
  for i=1:numPatches
    set(H(i), 'faceoffsetfactor', 0, 'faceoffsetbias', (1e-3)+(numPatches-i)/(numPatches-1)/30); 
  end
end


