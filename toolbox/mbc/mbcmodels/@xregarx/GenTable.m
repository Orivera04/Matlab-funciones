function  [Y,X,y,Xg]= GenTable(m,x,varargin)
%XREGARX/GENTABLE generate an N-D table of model evaluations
%
% [Y,X,y,Xg]= GenTable(m,x,varargin)
%   x is a cell array of values for 
%   
%   Y   N-D array of model evaluations
%   X   N-D array of evaluation points
%   y   vector model evaluation 
%   Xg  nxNf array of evaluation points

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:44:41 $

xn=x;
for i=1:length(x);
   % do the coding on each entry individually as this is 
   % computationally much cheaper
   x{i}= code(m,x{i}(:),i);
end

if length(x)>1
   % Generate N-D grid for evaluation
   [X{1:length(x)}]=ndgrid(x{:});
else
   X=x;
end
   
% Change into NxNg table 
Xg= zeros(prod(size(X{1})),length(X));
for i=1:length(X)
   Xg(:,i)= X{i}(:);
end

if nargout>1
   if length(x)>1
      % Generate N-D grid for evaluation
      [X{1:length(x)}]=ndgrid(xn{:});
   else
      X=xn;
   end
end

% CHANGED BIT OF CODE
y = repmat( NaN, size( X{1} ) );
Y = repmat( NaN, size( X{1} ) );
return
% CHANGED BIT OF CODE

y= eval(m,Xg);
if ~isempty(m.yinv)
   y= m.yinv(y);
end

if ~isreal(y)
   y(abs(imag(y))>1e-6)=NaN;
   y= real(y);
end

if length(size(X{1}))>1
   Y= reshape(y,size(X{1}));
end
