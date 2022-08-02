function [y,varargout]=EvalModel(m,varargin);
% MODEL/EVALMODEL evalutate model (with coding and yinv)
% 
% [y,varargout]=EvalModel(m,x,varargin);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:44:40 $

% X could be a sweepset 
X= varargin{1};
x=  double(varargin{1});
if size(x,2)~= nfactors(m)
	error('Invalid number of inputs to model')
end
	
% X Transformation
x = code(m,x);
if isa(X,'sweepset') & size(X,1)~=size(X,3)
   X(:,:)=x;
   x= X;
end
S= varargin;
S{1}= x;
if nargin>2
   for i=2:nargin-1
      S{i}=  varargin{i} ;
   end
   % Evalation (polymorphic method)
end
if nargout>1
   [y,varargout{1:nargout-1}] = eval(m,S{:});
else
   y= eval(m,S{:});
end
if ~isTBS(m) & ~isempty(get(m,'yinv'))
   % invert any y transformation
   y = yinv(m,y);
end

if ~isreal(y)
	y(abs(imag(y))>eps)= NaN;
	y =real(y);
end
