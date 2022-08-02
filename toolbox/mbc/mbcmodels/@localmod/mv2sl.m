function [sys_out,parentsys,sys]=mv2sl(m,DO_PEV,parentsys)
% LOCALMOD/MVSL build a SIMULINK version of model 
% 
% This function will build a simulink version of the dialup
% facility.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:39:26 $

% open up required libraries
load_system('simulink3');
load_system('models2');

% get info about inputs and outputs
mxinfo= xinfo(m);
myinfo= yinfo(m);
inputs = mxinfo.Names;
for i = 1:length(inputs)
    inputs{i} = validmlname(inputs{i});
end

set_param(parentsys,'ModelBrowserVisibility','on');
BI = 'built-in/';

bname = getUniqueBlockName('Local Model', parentsys);	
% Start by creating sys as a subsytem of parentsys
sname = [parentsys, '/',bname];
sys = add_block([BI,'SubSystem'],sname);
newPos = [20 20 120 80];
set_param(sys, 'position', newPos);

% build the model using overloaded methods
modelName = class(m);
GbMd = modelbuild(m, sname, modelName, DO_PEV);
% Get the positions and names of the input ports
inBlks = find_system(GbMd,  'SearchDepth', 1, 'LookUnderMasks', 'all', 'blocktype', 'Inport');
% Set size of global model based on num inputs
set_param(GbMd, 'position', [150 20 250 50*length(inBlks)+20]);
inPos = get_param(GbMd, 'inport');

% Add a set of constants to the subsystem.
Const = add_block([BI,'Constant'],[sname,'/Coeffs']);
ConstPos = [15 inPos(1, 2)-10 35 inPos(1, 2)+10];
coeffs = ['[' sprintf('%.20g ',double(m)) ']'];
set_param(Const, 'position', ConstPos, 'value', coeffs);

% Add a CODE block to the diagram only if there is coding, and 
% we have not implemented coding before...
if ~isempty(get(m,'code'))
   CODE =1;
   CodePos = [50 inPos(2, 2)-20 120 inPos(2, 2)+20];
   CodeBlk= codebuild(m,sname,'Code');
   set_param(CodeBlk,'position',CodePos);
else
   CODE=0;
end

% Add inports for all remaining localmod inputs
for i = 2:length(inBlks)
    % Add an Inport to the subsystem.
    Inport(i-1) = add_block([BI,'Inport'],[sname '/' get_param(inBlks(i), 'name')]);
    set_param(Inport(i-1), 'position', [15 inPos(i, 2)-10  35 inPos(i, 2)+10]);
end

% Add outports
outBlks = find_system(GbMd, 'SearchDepth', 1, 'LookUnderMasks', 'all', 'BlockType', 'Outport');
outPos = get_param(GbMd, 'outport');
for i = 1:length(outBlks)
    outport(i) = add_block([BI 'Outport'], [sname '/' get_param(outBlks(i), 'name')]);
    pos = [outPos(i, :) + [20 -10] outPos(i, :) + [40 10]];
    set_param(outport(i), 'position', pos);
end

% ---------------------------------------------------
% CONNECT THE BLOCKS
% ---------------------------------------------------
% Connect the coefficients to the model
add_line(sname, 'Coeffs/1', [modelName '/1']);

if CODE
    add_line(sname, 'Code/1', [modelName '/2']);
    add_line(sname, [get_param(inBlks(2), 'name'), '/1'], 'Code/1');
end

for i = 3:length(inBlks)
    add_line(sname, [get_param(inBlks(i), 'name'), '/1'], [modelName '/' num2str(i)]);
end

for i = 1:length(outBlks)
    add_line(sname, [modelName '/' num2str(i)], [get_param(outBlks(i), 'name') '/1']);
end
%close down main libraries
close_system('simulink3');
close_system('models2');

if nargout>0
    sys_out = sys;
end

save_system(parentsys,'','breaklinks');
set_param(parentsys,'open','on',...
    'BrowserLookUnderMasks','on');

