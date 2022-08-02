function out=discrep(obj)
%DISCREP  discrepancy of point set
%
% VAL=QDISCREP(OBJ)  returns the discrepancy value for the
% point set.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:55:59 $

nf=nfactors(obj);
np=npoints(obj);
lims=limits(obj)';
fs=fullset(obj);
if ~isempty(fs)
   % The discrepancy mex function must operate over a hybercubic region 
   % that ranges from 1..N
   fs=1+np*(fs-repmat(lims(1,:),np,1))./repmat(lims(2,:)-lims(1,:),np,1);
   
   out=mx_discrepancy(fs,100+20*nf,floor(0.2*np));
else
   out=[];
end