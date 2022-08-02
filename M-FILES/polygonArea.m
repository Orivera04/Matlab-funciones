function area = polygonArea(varargin)
%POLYGONAREA compute area of a polygon
%
%   A = polygonArea(POINTS)
%   Compute area of a polygon defined by POINTS. POINTS is a
%   [N*2] array of double.
%   
%   Points are assumed to be oriented. depending on points orientation,
%   resutl can be negative.
%
%   See also :
%   polygonCentroid, drawPolygon
%
%   ---------
%
%   author : David Legland 
%   INRA - TPV URPOI - BIA IMASTE
%   created the 05/05/2004.
%

%   HISTORY
%   25/04/2005 : add support for multiple polygons


% test multiple polygons
if nargin>0
    var = varargin{1};
    if iscell(var)
        area = zeros(length(var), 1);
        for i=1:length(var)
            area(i) = polygonArea(var{i}, varargin{2:end});
        end
        return;
    end
end

if nargin==1
    var = varargin{1};
    px = var(:,1);
    py = var(:,2);
elseif nargin==2
    px = varargin{1};
    py = varargin{2};
end

% algo recupere sur le site de P. Bourke
sum = 0;
N = length(px);
for i=1:N-1
    sum = sum + px(i)*py(i+1) - px(i+1)*py(i);
end
area = (sum + px(N)*py(1) - px(1)*py(N))/2;
    
