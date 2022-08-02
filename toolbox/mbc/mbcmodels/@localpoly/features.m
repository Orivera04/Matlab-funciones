function [Feats,Defaults,Values]= features(f);
% POLYNOM/FEATURES

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:40:22 $

%% order of the polynmial
p= order(f);

%% Display  e.g. f''(x)
%% Name e.g. D2
Feats= struct('Display',cell(1,0),...
    'Function',cell(1,0),...
    'delG',cell(1,0),...
    'Name',cell(1,0),...
    'IsDatum',cell(1,0));

%% set up features to be derivatives 1,2,...,order-1
%% note index=1 is left free
for i=1:p
    Feats(i).Display = ['f',repmat('''',1,i),'(x)'];
    Feats(i).Function= sprintf('eval(diff(f,%d),f.Values(i))',i);
    Feats(i).delG    = sprintf('hermiteX(f,f.Values(i),%d)',i);
    Feats(i).Name    = sprintf('D%1d',i);
    Feats(i).IsDatum = 0;
    Feats(i).index = i;
    Feats(i).IsLinear = 1;
end

if p>0
	Feats= [Feats features(f.localmod)];
else
	Feats= features(f.localmod);
end	
Feats(end).index= i+1;
Feats(end).IsLinear= 1;

if nargout==3
    Defaults=[1:p+1];
    Values= zeros(p+1,1);
end

