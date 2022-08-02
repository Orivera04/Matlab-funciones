function Blk = jacobbuild(m,sys)
%JACOBBUILD

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:48:13 $

coeffs = double(m);
% this will ensure the submodels coefficients are up to date with the xreghybridrbf
m = update(m,coeffs); 

BI = 'built-in/';
sname = [sys '/hybridRBFJacob'];

Blk = add_block([BI,'SubSystem'],sname,'open','off');

% Add two Inport to the subsystem.
inport1 = add_block([BI,'Inport'],[sname,'/X']);
InPos = [15,100,40,115];
set_param(inport1,'position',InPos);

inport2 = add_block([BI,'Inport'],[sname,'/Jin']);
InPos = [15,150,40,165];
set_param(inport2,'position',InPos);

% Draw linearBlock part
linearBlk = jacobbuild(m.linearmodpart, sname);
[c, w, h] = LTRB2Centre(get_param(linearBlk, 'position'));
set_param(linearBlk, 'position', Centre2LTRB([150 100], w, h));
linearBlkName = get_param(linearBlk, 'name');
% Explicitly set numterms to length(m.linearmodpart) and termsout to -1
vars = {'numterms' 'termsout'};
values{1} = size(m.linearmodpart, 1);
values{2} = -1;
AddVariablesToUserdata(linearBlk, vars, values);

% Draw rbfBlock part
rbfBlk = jacobbuild(m.rbfpart, sname);
[c, w, h] = LTRB2Centre(get_param(rbfBlk, 'position'));
set_param(rbfBlk, 'position', Centre2LTRB([150 200], w, h));
rbfBlkName = get_param(rbfBlk, 'name');

% Add a mux block
mux = add_block([BI 'Mux'], [sname '/Mux']);
set_param(mux, 'position', [250 100 260 200], 'inputs', '2');

% Add a vector selector Block
sel = add_block([BI 'Selector'], [sname '/Selector']);
set_param(sel, 'position', [280 130 340 170],...
	'elements', 'termsout', 'inputportwidth', 'numterms');

% Add outport
outport = add_block([BI,'Outport'],[sname,'/J']);
set_param(outport,'position', [370 140 390 160]);

% Now add some lines
add_line(sname, 'X/1', [linearBlkName '/1']);
add_line(sname, 'X/1', [rbfBlkName '/1']);
add_line(sname, 'Jin/1', [rbfBlkName '/2']);
add_line(sname, [linearBlkName '/1'], 'Mux/1');
add_line(sname, [rbfBlkName '/1'], 'Mux/2');
add_line(sname, 'Mux/1', 'Selector/1');
add_line(sname, 'Selector/1', 'J/1');

% Need to set the vector selectors in the jacob blocks to let everything through
linearSelector = find_system(linearBlk, 'name', 'Selector');
rbfSelector = find_system(rbfBlk, 'name', 'Selector');

set_param(linearSelector, 'elements', '-1', 'inputPortWidth', num2str(numParams(m.linearmodpart)));
set_param(rbfSelector, 'elements', '-1', 'inputPortWidth', num2str(numParams(m.rbfpart)));
