function [y,varargout]=EvalModel(m,varargin);
% MODEL/EVALMODEL evalutate model (with coding and yinv)
% 
% [y,varargout]=EvalModel(m,x,varargin);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:51:04 $


% X could be a sweepset 

x=  double(varargin{1});
if size(x,2)~= nfactors(m)
	error('Invalid number of inputs to model')
end
	
% X Transformation
x = code(m,x);
S= varargin;
S{1}= x;
if nargin>2
   for i=2:nargin-1
      S{i}= double( varargin{i} );
   end
   % Evalation (polymorphic method)
end
if nargout>1
   [y,varargout{1:nargout-1}] = eval(m,S{:});
else
   y= eval(m,S{:});
end
if ~m.TransBS & ~isempty(m.yinv)
   % invert any y transformation
   y = yinv(m,y);
end

if ~isreal(y)
	y(abs(imag(y))>eps)= NaN;
	y =real(y);
end