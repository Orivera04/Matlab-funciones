function s= mv_rmfield(r,fname);
% MV_RMFIELD alternative, efficient, rmfield
%
% s= mv_rmfield(r,fname);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:49:08 $

fns= fieldnames(r);
if isa(fname,'char')
	% find indices to fields
	ind= strcmp(fname,fns);
else
	ind= ismember(fns,fname);
end
% convert to cell
c= struct2cell(r);
sc= size(c);
sc(1)= sc(1)- sum(ind);
% delete field names
fns(ind)= [];
% and rows
c(ind,:)=[];
% reshape cell 
c= reshape(c,sc);
% convert back struct
s= cell2struct(c,fns);