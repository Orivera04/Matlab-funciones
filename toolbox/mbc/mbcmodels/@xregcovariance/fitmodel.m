function [c,Wc]= fitmodel(c,varargin);
% COVMODEL/FITMODEL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:46:16 $

% fit covariance model
Wp= double(c);

if ~isempty(c.wfunc)
   [nw,bnds]= feval(c.wfunc,c);
end

if ~isempty(c.cfunc)
   [nw,bnds2]= feval(c.cfunc,c);
   bnds= [bnds;bnds2];
end


% run lsqnonlin
options= optimset('display','off',...
   'Tolfun',1e-6,...
   'LargeScale','on');

[Wp,resnorm,r,exitflag,output] = ...
   lsqnonlin(c.costFunc,Wp,bnds(:,1),bnds(:,2),options,c,varargin{:});

[e,c,Wc]= feval(c.costFunc,Wp,c,varargin{:});

