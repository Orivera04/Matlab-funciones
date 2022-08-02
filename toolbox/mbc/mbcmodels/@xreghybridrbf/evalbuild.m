function Blk = evalbuild(m,sys)
% xreghybridrbf evalbuild method adds an evaluation simulink block to
% a simulink implementation of a xreghybridrbf model

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:48:05 $

coeffs = double(m);
% this will ensure the submodels coefficients are up to date with the xreghybridrbf
m = update(m,coeffs); 

BI = 'built-in/';
sname = [sys '/hybridRBFEval'];

Blk = add_block([BI,'SubSystem'],sname,'open','off');

% Add an Inport to the subsystem.
Inport = add_block([BI,'Inport'],[sname,'/X']);
InPos = [15,150,40,165];
set_param(Inport,'position',InPos);

% Draw linearBlock part
linearBlk = evalbuild(m.linearmodpart, sname);
[c, w, h] = LTRB2Centre(get_param(linearBlk, 'position'));
set_param(linearBlk, 'position', Centre2LTRB([150 100], w, h));
linearBlkName = get_param(linearBlk, 'name');

% Draw rbfBlock part
rbfBlk = evalbuild(m.rbfpart, sname);
[c, w, h] = LTRB2Centre(get_param(rbfBlk, 'position'));
set_param(rbfBlk, 'position', Centre2LTRB([150 200], w, h));
rbfBlkName = get_param(rbfBlk, 'name');

% Addition block
addBlk = add_block([BI 'sum'], [sname '/sum']);
set_param(addBlk, 'position', [250 140 280 180]);

% Add two outports to the subsystem.
outportY = add_block([BI,'Outport'],[sname,'/Y']);
set_param(outportY,'position', [300 150 320 170]);

outportJ = add_block([BI,'Outport'],[sname,'/J']);
set_param(outportJ,'position', [300 200 320 220]);


% Now add some lines
add_line(sname, 'X/1', [linearBlkName '/1']);
add_line(sname, 'X/1', [rbfBlkName '/1']);
add_line(sname, [linearBlkName '/1'], 'sum/1');
add_line(sname, [rbfBlkName '/1'], 'sum/2');
add_line(sname, 'sum/1', 'Y/1');
add_line(sname, [rbfBlkName '/2'], 'J/1');

set_param(Blk, 'open', 'off')