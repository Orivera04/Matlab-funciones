function handle = drawmap(map,range,s)

% DRAWMAP - Draw a map using a rectangular grid projection.
% handle = drawmap(map[,range,s])
%
% Draws that portion of 'map' which lies within the 
% geographical area specified by 'range', where 
% 'map' is an [N,2] matrix of contiguous (elon,nlat) 
% pairs separated by "pen-up" indicators (i.e., the 
% pair "NaN NaN").  Units for (elon,nlat) are east 
% longitude degrees and north latitude degrees, 
% respectively.  Parameter 'range' is a 1x4 vector 
% whose format is like the Matlab 'axis' parameter 
% with x range referring to east longitude degrees 
% and y range to north latitude degrees.  Parameter 
% 's' specifies the line type for the plot.  The 
% output of the function is a handle to the resulting 
% plot. 
%
% Other usage modes: 
%  1) drawmap(map)
%       displays the full map using a solid line type. 
%  2) drawmap(map,range)
%       displays the specified range using a solid line type. 
%  3) drawmap(map,s)
%       displays the full map using the specified line type. 
%
% P.G. Bonanni
% 2/7/95


% Default map range
elon = map(:,1);
nlat = map(:,2);
elon(isnan(elon)) = [];
nlat(isnan(nlat)) = [];
range0 = [min(elon),max(elon),min(nlat),max(nlat)];

% Default line type
s0 = '-';

if nargin==1
  range = range0;
  s = s0;
elseif nargin==2
  if isstr(range)
    s = range;
    range = range0;
  else
    s = s0;
  end
end

% Get map
elon = map(:,1);
nlat = map(:,2);

% Mask out hidden regions of map
mask = (elon < range(1)) | (elon > range(2)) | ...
       (nlat < range(3)) | (nlat > range(4));
n = sum(mask);
map(mask,:) = ones(n,2) * NaN;

% Get modified map
elon = map(:,1);
nlat = map(:,2);

% Plot in-range portion
h = plot(elon,nlat,s);
axis(range);
axis('image');
set(gca,'Box','on');

% Label plot
xlabel ('East Longitude (deg)');
ylabel ('North Latitude (deg)');

% Return plot handle, if required
if nargout, handle=h; end
