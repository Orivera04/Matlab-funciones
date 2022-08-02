function [sys_out,sname,GbMd]=mv2sl(m,DO_PEV,parentsys)
% MODEL/MVSL build a SIMULINK version of model 
% 
% This function will build a simulink version of the dialup
% facility.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.7.4.3 $  $Date: 2004/02/09 07:52:36 $



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

% Add some Inports to the subsystem.
InPos= repmat([15,80,40,95],length(inputs),1);

bname = validmlname(myinfo.Name);
bname = getUniqueBlockName(bname, parentsys);	
% Start by creating a new_sys as a subsytem of parentsys
sname=[parentsys, '/',bname];
new_sys= add_block([BI,'SubSystem'],sname,...
    'Open','On');
new_sysPos= [15 20 150 15+size(inputs,1)*25];
set_param(new_sys,'position',new_sysPos);
for i=1:length(inputs)
    InPos(i,:)= InPos(i,:)+(i-1)*[0 40 0 40];
    inport(i)= add_block([BI,'Inport'],[sname,'/',inputs{i}]);
    set_param(inport(i),'position',InPos(i,:));
end
InPos= InPos(ceil(size(InPos,1)/2),:);

% get the outputs of the Inports
ports= get_param(inport,'porthandles');
if ~iscell(ports)
    ports = {ports};
end
mxPos(1:2)= get_param(ports{1}.Outport,'position')+[20 -20];
mxPos(3:4)= get_param(ports{end}.Outport,'position')+[25 +20];
% mux the inport signals together
mux1= add_block([BI,'mux'],[sname,'/Mx1']);
set_param(mux1,'position',mxPos,...
    'inputs',num2str(length(inport)),...
    'displayoption','bar');
mxport= get_param(mux1,'porthandles');
newPos(1:2)= get_param(mxport.Outport,'position')+[20 -30];
newPos(3:4)= newPos(1:2)+[100 60];
% build the model using overloaded methods
modelName=class(m);
GbMd=modelbuild(m,sname,modelName,DO_PEV);
set_param(GbMd,'position',newPos);
% Add an output block.
out1= add_block([BI,'OutPort'],[sname,'/',bname]);
outPos= get_param(GbMd,'outport');
if size(outPos,1) > 1
    outPos= outPos(1,:)+[20 -8];
else
    outPos= outPos+[20 -8];
end
outPos(3:4)= outPos(1:2)+[25 16];
set_param(out1,'position',outPos);

if DO_PEV
    % Now add the dot product Block for PEV calculation
    outP= get_param(GbMd,'outport');
    DotPos= outP(2,:) + [100 -10];
    DotPos(3:4)= DotPos(1:2)+[30 40];
    DotP= add_block('Simulink3/Math/Dot Product',[sname,'/Dot Product']);
    set_param(DotP,'position',DotPos);
    
    % finally add the PEV outport
    outP= get_param(DotP,'outport');
    outPos2(1:2)= outP+[80 -10];
    outPos2(3:4)= outPos2(1:2)+[25 20];
    PevOut= add_block([BI,'OutPort'],[sname,'/PEV']);
    set_param(PevOut,'position',outPos2);
end

% ---------------------------------------------------
% CONNECT THE BLOCKS
% ---------------------------------------------------
% connect the inports to the Mux Block
for i=1:length(inport)
    blkname= get_param(inport(i),'name');
    add_line(sname,[blkname,'/1'],['Mx1/',num2str(i)]);
end
% now connect the mux block to the model block
add_line(sname,'Mx1/1',[modelName,'/1']);

% connect model to output
add_line(sname,[modelName,'/1'],[bname,'/1']);

% Close the subsystem
pause(0.0)
set_param(new_sys,'open','off');

if DO_PEV
    % connect model output 2 to dot product
    add_line(sname,[modelName,'/2'],'Dot Product/1');
    DotPort= get_param(DotP,'inport');
    add_line(sname,[...
            DotPort(1,:)-[20 0];...
            [DotPort(1,1)-20 DotPort(2,2)];...
            DotPort(2,:)]);
    
    
    % connect the dot product to the outport
    add_line(sname,'Dot Product/1','PEV/1');
    % Get the PEV R matrix and save in a mat file
    % Note simulink cannot deal with sparse matricies so convert to full
    R = full(var(m));
    % Save the Jacobian in the block's userdata and add an appropriate mask
    % initialisation command. Ensure that the userdata is persisted across
    % saves.
    set_param(new_sys, 'UserData', R);
    set_param(new_sys, 'MaskInitialization', 'R = get_param(gcb, ''userdata'');');
    set_param(new_sys, 'UserDataPersistent', 'on');
end

%close down main libraries
close_system('simulink3');
close_system('models2');

if nargout>0
    sys_out=new_sys;
end

save_system(parentsys,'','breaklinks');
set_param(parentsys,'open','on',...
    'BrowserLookUnderMasks','on');

