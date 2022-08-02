%Write formatted data to file.
%
%	Leutenegger Marcel © 17.2.2005
%
function c=fprintf(f,varargin)
if ischar(f)
   n=1;
else
   n=2;
end
for n=n:nargin-1
   if isa(varargin{n},'single')
      varargin{n}=double(varargin{n});
   end
end
c=fprintf(f,varargin{:});
