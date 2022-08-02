function new_sys=codebuild(m,parent,name);
% MODEL/CODEBUILD builds coding SIMULINK blocks
% 
% This builds up the code part of the 
% model evaluation process.
%
%      |----------|      |----------|       |----------|
% X--->|  Code    |----->|   Eval   |------>|   YInv   |----> Y
%      |----------|      |----------|       |----------|

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:51:31 $

% Check parent is a string representation of block
if isnumeric(parent)
    parent = [ get_param(parent, 'parent') '/' get_param(parent, 'name') ];
end
old_sys=parent;
BI = 'built-in/';
c=get(m,'code');
NUM_MODELS=size(c,2);
% Create a Model
% new_system([old_sys,'/Code']);
if nargin<2
   name='Code';
end
sys=[old_sys,'/',name];
new_sys=add_block('built-in/SubSystem',[old_sys,'/',name]);
set_param(new_sys,'position',[200 120 280 170]);%,...   'Name',name

% Add a Constant input (maybe it should be an In1 block?
Xin = add_block([BI,'Inport'],[sys,'/XIn']);
posX= get_param(Xin,'position');
set_param(Xin,'position',posX+[0 70 0 70]);

% Add a demux block with N inputs
Dmx= add_block([BI,'Demux'],[sys,'/demux']);
posDmx=posX+[100 -10 85 145];
set_param(Dmx,'outputs',num2str(NUM_MODELS),...
   'position',posDmx,...
   'BackGroundColor','black');

% Add N math function blocks
Gdef= ~cellfun('isempty',{c.g});
mF=zeros(1,NUM_MODELS);
if any(Gdef)
   NOG=0;
   for i=find(Gdef)
      mF(i) = add_block([BI,'Math'],[sys,'/G',num2str(i)]);
      set_param(mF(i),'position',posX+[190 (i-1)*45 210 (i-1)*45]);
   end
else
   NOG=1;
end


% Add a Mux block with 4 Outputs
Mx= add_block([BI,'mux'],[sys,'/mux']);
posMx=posDmx+[200 0 200 0];
set_param(Mx,'inputs',num2str(NUM_MODELS),...
   'position',posMx,...
   'DisplayOption','Bar');

% Add a sum block
Sm= add_block([BI,'sum'],[sys,'/sum']);
set_param(Sm,'position',posX+[350 70 350 70],...
   'iconshape','round',...
   'inputs','-+|');

% Add a Gain block
Gb = add_block([BI,'gain'],[sys,'/gain']);
set_param(Gb,'position',posX+[400 70 400 70]);

% Add a Constant MidPoint block
Mid = add_block([BI,'Constant'],[sys,'/Mid']);
set_param(Mid,'position',posX+[350 20 350 20],...
   'orientation','down');

% Add an ouput block
out1= add_block([BI,'Outport'],[sys,'/out1']);
set_param(out1,'position',posX+[450 70 450 70],...
   'name','XCoded');



% ---------- Connect the blocks up --------------------
% Connect DEMUX the blocks
add_line(sys,'XIn/1','demux/1');
for i = find(Gdef)
   add_line(sys,['demux/',num2str(i)],['G',num2str(i),'/1']);
   % Connect MUX the blocks
   add_line(sys,['G',num2str(i),'/1'],['mux/',num2str(i)]);
end
ind= setdiff([1:NUM_MODELS],[find(Gdef)]);
for i=ind
   add_line(sys,['demux/',num2str(i)],['mux/',num2str(i)]);
end

% Connect the mux to the sum
add_line(sys,'mux/1','sum/2');

% connect the Mid to the sum
add_line(sys,'Mid/1','sum/1');

% Connect the sum to the Gain
add_line(sys,'sum/1','gain/1');

% Connect the Gain to the output port
add_line(sys,'gain/1','XCoded/1');

% ---------------- Set up other parameters...
% Set the coding info
mF=SimSetCode(m,mF,Mid,Gb);
