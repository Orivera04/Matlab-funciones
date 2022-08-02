%Singular value decomposition.
%
%    Leutenegger Marcel © 17.2.2005
%
function [u,s,v]=svd(varargin)
if nargin > 1
   varargin{2}=double(varargin{2});
end
if isa(varargin{1},'single')
   varargin{1}=double(varargin{1});
   if nargout > 1
      [u,s,v]=svd(varargin{:});
      u=single(u);
      s=single(s);
      v=single(v);
   else
      u=single(svd(varargin{:}));
   end
else
   if nargout > 1
      [u,s,v]=svd(varargin{:});
   else
      u=svd(varargin{:});
   end
end
