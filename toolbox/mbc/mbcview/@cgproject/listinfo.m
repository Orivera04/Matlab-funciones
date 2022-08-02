function [nds,cheaders,vals,numcol,colsize,recurse]=listinfo(T,tpfilter);
%LISTINFO  return headers and values for node in a list
%
%   [NDs,HDRs,VALs,NUMCOLs,COLSIZEs,DOCHILDREN]=listinfo(ND,tpfilter)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.2 $  $Date: 2004/02/09 08:28:20 $

nds=[];
cheaders={};
vals={};
numcol=false(0);
recurse=1;
colsize=[];