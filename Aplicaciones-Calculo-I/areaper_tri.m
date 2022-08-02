function  [area,varargout] = areaper_tri(base,altura,varargin)
%varargin{1};
%varargin{2};

if length(varargin)==0
  area=base*altura/2;
  varargout{1}=[];
elseif length(varargin)==2
  area=base*altura/2;
  varargout{1}=base+varargin{1}+varargin{2};
else
 error('Falta un dato');   
end