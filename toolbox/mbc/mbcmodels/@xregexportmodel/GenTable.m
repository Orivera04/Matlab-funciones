function  [Y,X,y,Xg]= GenTable(m,x,varargin)
% EXPORTMODEL/GENTABLE generate an N-D table of model evaluations
%
% [Y,X,y,Xg]= GenTable(m,x,varargin)
%   x is a cell array of values for 
%   
%   Y   N-D array of model evaluations
%   X   N-D array of evaluation points
%   y   vector model evaluation 
%   Xg  nxNf array of evaluation points

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:47:12 $


xn=x;

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

y= EvalModel(m,Xg);

if length(size(X{1}))>1
   Y= reshape(y,size(X{1}));
end
