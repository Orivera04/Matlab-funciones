function [nds,cheaders,vals,numcol,colsize,recurse]=listinfo(T,tpfilter);
%LISTINFO  return headers and values for node in a list
%
%   [NDs,HDRs,VALs,NUMCOLs,COLSIZEs,DOCHILDREN]=listinfo(ND,tpfilter)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.6.2.2 $  $Date: 2004/02/09 08:23:31 $

if matchtype(typeobject(T),tpfilter)
   nds=address(T);
   cheaders={'Type','Alias','Minimum','Maximum','Set Point', 'Formula'}; 
   vals=listvals(T);
   numcol=[false false true true true false];
   colsize=[75 110 60 60 60 200];
else
   nds=[];
   cheaders={};
   vals={};
   numcol=false(0);
   colsize=[];
end
recurse=1;
