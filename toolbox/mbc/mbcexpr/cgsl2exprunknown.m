function ptr = cgsl2exprunkown(b,blockname,prevblock,lines, PLIST)	
%CGSL2EXPRUNKNOWN - Catches the parse if a block is not identified
%
%  [ptr] = CGSL2EXPRUNKNOWN(blockHandle,blockName,prevBlock,Lines)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 07:17:43 $ 
ptr = [];
if strcmp(get_param(b,'blocktype'),'SubSystem')
    % decode subsytem block
    [handle,line] = cgsl2exprsrcblocks(prevblock);
    ptr = cgsl2exprgetprior(handle,'',b,line, PLIST);
else
    error('Failed to parse block "%s"', get_param(b, 'name'));
end