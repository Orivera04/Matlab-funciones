function u=localsurface(param)
% LOCALSURFACE userdefined local model
% 
%    L3 = localsurface(param)
%
%      Parents - model
%              - localmod
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.5 $  $Date: 2004/02/09 07:42:21 $

u.version=3;
if nargin==0
   param= xregcubic([3 3]);
end
if isa(param,'struct')
   param.version= u.version;
   u= param;
   if ~isfield(u,'localmod')
      LocMod= localmod(Vals,Types);
   else
      LocMod= localmod(u.localmod);
      u= mv_rmfield(u,'localmod');
   end
   if ~isfield(u,'xregmodel')
      m = xregmodel;
   else
      m = xregmodel(u.xregmodel);
      u= mv_rmfield(u,'xregmodel');
   end
else
   u.userdefined = param;
   m = xregmodel('nfactors',nfactors(param));
   LocMod= localmod;
end

u=class(u,'localsurface',LocMod,m);

if numfeats(u)==0
    np = numParams(u.userdefined);
    nf = nfactors(u);
    u = AddFeat(u,zeros(np,nf),1:np);
end
   
