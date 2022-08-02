function [PEV,X,Xg]= pevgrid(smod,Values,Natural,varargin);
% MODEL/PEVGRID evaluate Prediction Error Variance for model over grid
%
% PEV = evalpev(m,Values,Natural)
%   m is the model. InitStore must be called on m before this function
%   Values cell array defining grid e.g. Values = {-1:.1:1,0,-1:.1:1}
%   Natural==1 if Values is in natural units
% 
% If y data is available
%     PEV = x'* s*inv(X'*X) * x
% otherwise PEV = x'* inv(X'*X) * x
% ndgrid is used to define grid. The shape of PEV is the same as the grid shape returned 
% by ndgrid.
% 
% See also LINEARMOD/EVALPEV,NDGRID

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:03:51 $

m= model(smod);

if nargin<=2
   Natural=1;
end
xc= Values;
if Natural
   for i=1:length(xc);
      % do the coding on each entry individually as this is 
      % computationally much cheaper
      xc{i}= code(m,xc{i}(:),i);
   end
end

if length(xc)>1
   % Generate N-D grid for evaluation
   [X{1:length(xc)}]=ndgrid(xc{:});
else
   X=xc;
end
% Change into NxNg table 
Xg= zeros(prod(size(X{1})),length(X));

len=zeros(1,length(X));
for i=1:length(X)
   Xg(:,i)= X{i}(:);
   len(i)= length(Values{i});
end

PEV= evalpev(smod,Xg,0,varargin{:});

if nargout>1
    if length(xc)>1
        % X grids should be in natural units
        [X{1:length(xc)}]=ndgrid(Values{:});
    else
        X= Values;
    end
end   

% reshape table
if length(len)>1
   PEV= reshape(PEV,len);
end

