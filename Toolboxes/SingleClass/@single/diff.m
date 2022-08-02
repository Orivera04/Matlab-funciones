%Difference and approximate derivative.
%
%    Leutenegger Marcel © 17.2.2005
%
function o=diff(varargin)
if nargin > 1
   varargin{2}=double(varargin{2});
end
if isa(varargin{1},'single')
   varargin{1}=double(varargin{1});
   o=single(diff(varargin{:}));
else
   o=diff(varargin{:});
end
