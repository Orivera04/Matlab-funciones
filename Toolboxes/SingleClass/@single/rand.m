%Uniformly distributed random numbers.
%
%	Leutenegger Marcel © 17.2.2005
%
function o=rand(varargin)
if nargin < 2 & isempty(varargin{1})
   o=single(rand);
else
   for n=1:nargin
      varargin{n}=double(varargin{n});
   end
   o=single(rand(varargin{:}));
end
