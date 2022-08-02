function blk= slRecon(m,sname)
% localbspline/SLRECON -  adds the appropriate reconstruct block

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.2 $  $Date: 2004/02/09 07:38:27 $



blk = add_block(['Models2/Reconstruct/localBSplineRecon'],...
   [sname,'/Reconstruct']);
% break library link
set_param(blk,'linkstatus','none');

% Need to add the code block inside blk
codeBlk = find_system(blk, 'lookundermasks', 'all', 'name', 'Code');
codeBlkName = [ get_param(codeBlk, 'parent') '/' get_param(codeBlk, 'name') ];
localCode = codebuild(m, codeBlkName, 'knotCode');

% Wire up code to in and out ports
add_line(codeBlk, 'K/1', 'knotCode/1');
add_line(codeBlk, 'knotCode/1', 'Coded K/1');


