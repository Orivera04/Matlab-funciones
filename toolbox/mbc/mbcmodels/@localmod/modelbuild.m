function [new_sys,LOCALDATUM]=modelbuild(m,parent,name,DO_PEV)
% LOCALMOD/MODELBUILD simulink model build for localmods
% 
% [new_sys,LOCALDATUM]=modelbuild(m,parent,name)
%  This is an m-file that will build a 'dialup' for a global
%  parameter model.
%
% model  - a global model
% parent - the name of the parent model
% name   - the name of the subsystem.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.3 $  $Date: 2004/02/09 07:39:23 $

% First build the subsystem
BI = 'built-in/';
name = getUniqueBlockName(name, parent);
sys=[parent,'/',name];
new_sys= add_block([BI,'SubSystem'],sys,...
   'open','on');

% get some info re: model
xin= xinfo(m);
yin= yinfo(m);

if length(xin.Names) > 1
    Xname = 'X';
else
    Xname = xin.Names{1};
end

% LOCALDATUM is a flag that will let the build process know
% if the local model requires a datum input or not.
LOCALDATUM=DatumType(m);

centre = [30 50];
if LOCALDATUM~=0
   % Add an Inport to the subsystem. (P)
	%   InPos= [15,120,40,130];
	% Add a parameter inport P
   Inport(1)= add_block([BI,'Inport'],[sys,'/Param']);
   set_param(Inport,'position',Centre2LTRB(centre,20,20));
   % Add a third inport (X)
   Inport(3)= add_block([BI,'Inport'],[sys,'/',Xname]);
   centre = centre + [0 40];
   set_param(Inport(3),'position',Centre2LTRB(centre,20,20));
   % add a datum block
   centre = centre + [0 40];   
   Inport(2)= add_block([BI,'Inport'],[sys,'/datum']);
   set_param(Inport(2),'position',Centre2LTRB(centre,20,20));
   % Add a sum block (x-datum)
   smBlk= add_block([BI,'Sum'],[sys,'/Sum']);
   centre = centre + [80 -40];
   set_param(smBlk,'inputs','|+-',...
      'position',Centre2LTRB(centre,20,20),...
      'iconshape','round');
   % Setup centre for eval block
else
   Inport= add_block([BI,'Inport'],[sys,'/Param']);
   set_param(Inport,'position',Centre2LTRB(centre,20,20));
   % Add a second inport (X)
   Inport(2)= add_block([BI,'Inport'],[sys,'/',Xname]);
   centre = centre + [0 40];
   set_param(Inport(2),'position',Centre2LTRB(centre,20,20));
   % Setup centre for eval block
end

LT = get_param(Inport(1),'outport')+[200 -20];
% Add the Appropriate Eval block
% Polymorphic evalbuild...implemented localmod and model level.
EvM= evalbuild(m,sys);
simSetEvalParam(m, new_sys);

% How many input ports - determines size of block
ports = get_param(EvM,'ports');
set_param(EvM,'position',[LT LT+[80 40*ports(1)]]);
EvMname= get_param(EvM,'name');

% Set the Yinv function
centre =get_param(EvM,'outport') + [130 0];
if ~isempty(get(m,'yinv'))
   YINV=1;
   Ynv=YinvBuild(m,sys);
   set_param(Ynv,'position',Centre2LTRB(centre,80,30));
else
   YINV=0;
end


% Add an outport to the subsystem.
centre= get_param(EvM,'outport')+ [230 0];
Name= yin.Name;
if iscell(Name)
   Name= Name{1};
end
Outport= add_block([BI,'Outport'],[sys,'/',Name]);
set_param(Outport,'position',Centre2LTRB(centre,20,20));

if DO_PEV
   % Polymorphic Jacob build to add correct Jacobian block
   Jac = jacobbuild(m,sys);
   centre = get_param(EvM,'outport') + [-40 180];
   set_param(Jac,'position',Centre2LTRB(centre,80,60));
   Jacname = get_param(Jac,'name');
   
   % add the YinvDiff block
   centre = centre + [120 -40];
   Yinvdiff= YinvDiffBuild(m,sys);
   set_param(Yinvdiff,'position',Centre2LTRB(centre,80,30));
   
   % add a product block
   centre = centre + [100 20];
   prod = add_block([BI,'Product'],[sys,'/Prod']);
   set_param(prod,'position',Centre2LTRB(centre,40,80));
   
   % add the outport
   centre = get_param(prod,'outport') + [60 0];
   Jacout = add_block([BI,'Outport'],[sys,'/Jy']);
   set_param(Jacout,'position',Centre2LTRB(centre,20,20));

   % now add all the Jacobian parameters to the mask
   simSetJacobParam(m,new_sys);
end

% -------------------------------------------------
% CONNECTING BLOCKS
% -------------------------------------------------
if LOCALDATUM~=0
   % X -DATUM
   Suminport= get_param(smBlk,'inport');
   Dtoutport= get_param(Inport(2),'outport');
   add_line(sys,[Xname,'/1'],'Sum/1');
   add_line(sys,[Dtoutport;...
         [Suminport(2,1),Dtoutport(2)];...
         Suminport(2,:)]);
end
% Get the number of inports the eval block has
numPorts= get_param(EvM,'ports');
EvInport= get_param(EvM,'Inport');
if DO_PEV
   JacInport = get_param(Jac,'inport');	
end

if LOCALDATUM~=0 & numPorts(1) == 3
   % from Datum to Eval inport 1
   %add_line(sys,'datum/1',[EvMname,'/1']);
   add_line(sys,[[Suminport(2,1),Dtoutport(2)];...
         EvInport(3,:)]);
   if DO_PEV
      % Add line from Eval Datum to Jacob Datum
      start = EvInport(3,:) + [-60 0];
      finish = JacInport(3,:);
      point1 = [start(1) finish(2)];
      add_line(sys,[start;point1;finish]);
   end
end
% from Param to Inport 1
add_line(sys,'Param/1',[EvMname,'/1']);

if LOCALDATUM ~=0
   % add line from sum straight to eval
   add_line(sys,['Sum/1'],[EvMname,'/2']);
else % no datum and no code
   add_line(sys,[Xname,'/1'],[EvMname,'/2']);
end

if DO_PEV
   % Add line from Params to Jacob
   start = EvInport(1,:) + [-40 0];
   finish = JacInport(1,:);
   point1 = [start(1) finish(2)];
   add_line(sys,[start;point1;finish]);
   % Add line from X to Jacob
   start = EvInport(2,:) + [-50 0];
   finish = JacInport(2,:);
   point1 = [start(1) finish(2)];
   add_line(sys,[start;point1;finish]);
   % Add line from Eval output to yinvdiff
   start = get_param(EvM,'outport') + [0 0];
   finish = get_param(Yinvdiff,'inport');
   point1 = [start(1) finish(2)];
   add_line(sys,[start;point1;finish]);
   % Add line from Jacob to product
   add_line(sys,[Jacname '/1'],'Prod/2');
   % Add line from YinvDiff to Prod
   add_line(sys,'Yinvdiff/1','Prod/1');
   % Output of Prod to Jy
   add_line(sys,'Prod/1','Jy/1');
end

if YINV
   % from Eval to Yinv
   add_line(sys,[EvMname,'/1'],'Yinv/1');
   % from Yinv to output
   add_line(sys,'Yinv/1',[Name,'/1']);
else
   % from Eval to output directly
   add_line(sys,[EvMname,'/1'],[Name,'/1']);
end

% Close the subsystem
pause(0.0);
set_param(new_sys,'open','off');
