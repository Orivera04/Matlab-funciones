%Sort in ascending order.
%
%    Leutenegger Marcel © 17.2.2005
%
function [o,p]=sort(varargin)
if nargin > 1
   varargin{2}=double(varargin{2});
end
if isa(varargin{1},'single')
   varargin{1}=double(varargin{1});
   if nargout > 1
      [o,p]=sort(varargin{:});
      p=single(p);
   else
      o=sort(varargin{:});
   end
   o=single(o);
else
   if nargout > 1
      [o,p]=sort(varargin{:});
   else
      o=sort(varargin{:});
   end
end
