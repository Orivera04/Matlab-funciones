%Sum of elements.
%
%    Leutenegger Marcel © 4.12.2005
%
function o=sum(varargin)
o=builtin('sum',varargin{:});
if isa(varargin{1},'single')
   o=single(o);
end
