function enstates=getenablestates(obj,nf)
%GETENABLESTATES  Return enable states for CandidateSets
%
%  ENSTATES=GETENABLESTATES(OBJ,NFACTORS)  returns a cell array of on/off
%  values which are decided according to whether each candidate set supports
%  the specified number of factors.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:02:25 $

% retrieve nfactor limits information
nfinfo=get(obj,'nflimits');


enstates=cell(size(nfinfo,1),1);

for k=1:length(enstates)
   if nf>=nfinfo{k,1} & nf<=nfinfo{k,2} & (isempty(nfinfo{k,3}) | any(nfinfo{k,3}==nf))
      enstates{k}='on';
   else
      enstates{k}='off';
   end
end