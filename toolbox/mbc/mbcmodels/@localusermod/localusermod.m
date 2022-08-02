function u= localusermod(param)
% USERLOCAL userdefined local model
% 
%    L3 = localusermod(param)
%
%      Parents - model
%              - localmod
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.4 $  $Date: 2004/02/09 07:43:57 $


u.version=3;
if nargin==0
   param= xregusermod;
end
if isa(param,'localusermod')
   u=param;
   return
end   
if isa(param,'struct')
	param.version= u.version;
	[u,LocMod,m]= i_Update(param);
	
else
	if isa(param,'xregmodel')
		u.userdefined = param;
	else
		u.userdefined= xregusermod('name',param);
	end
	nf= nfactors(u.userdefined);
   m = xregmodel('nfactors',nf);
   LocMod= localmod;
end

u=class(u,'localusermod',LocMod,m);

if numfeats(u)==0
   np= numParams(u.userdefined);
   u=AddFeat(u,zeros(np,nfactors(u)),1:np);
end
   


function [u,LocMod,m]= i_Update(u);

if ~isfield(u,'localmod')
	LocMod= localmod(Vals,Types);
else
	LocMod= localmod(u.localmod);
	u= mv_rmfield(u,'localmod');
end
if ~isfield(u,'model')
	m = model;
else
	m = model(u.model);
	u= mv_rmfield(u,'model');
end
