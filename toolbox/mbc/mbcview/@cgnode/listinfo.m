function [nds,cheaders,vals,numcol,colsize,recurse]=listinfo(T,tpfilter);
%LISTINFO  return headers and values for node in a list
%
%   [NDs,HDRs,VALs, IsNum,COLSIZEs,DOCHILDREN]=listinfo(ND,tpfilter)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.2 $  $Date: 2004/02/09 08:25:07 $

if matchtype(typeobject(T),tpfilter)
   nds=address(T);
else
   nds=[];
end
cheaders={};
vals={};
numcol=false(0);
recurse=1;
colsize=[];
