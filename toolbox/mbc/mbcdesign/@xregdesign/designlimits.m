function lims=designlimits(des,cdd)
%DESIGNLIMITS  Return the limits on the current design
% 
%  LIMS=DESIGNLIMITS(D) returns a cell array of [min max] values
%  for each factor in the design D.  
%  LIMS=DESIGNLIMITS(D,'natural') returns the limits in natural
%  units.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:06:26 $

if nargin<2
   cdd=false;
elseif strcmp(lower(cdd),'natural')
   cdd=true;
else
   cdd=false;
end

% model region
L=gettarget(model(des));
% check that design points don't go outside this region
if ~isempty(des.design)
   L(:,1)=min(L(:,1),min(des.design,[],1)');
   L(:,2)=max(L(:,2),max(des.design,[],1)');
end

if cdd
   L=invcode(model(des),L')';
end

lims = cell(1, size(L, 1));
for k = 1:numel(lims)
    lims{k} = L(k,:);
end