%Cumulative sum of elements.
%
%    Leutenegger Marcel © 17.2.2005
%
function o=cumsum(varargin)
if nargin > 1
   varargin{2}=double(varargin{2});
end
if isa(varargin{1},'single')
   varargin{1}=double(varargin{1});
   o=single(cumsum(varargin{:}));
else
   o=cumsum(varargin{:});
end
