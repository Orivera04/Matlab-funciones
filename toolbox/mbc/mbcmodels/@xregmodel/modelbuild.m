function [new_sys,EvM,JcbM]=modelbuild(m,parent,name,DO_PEV, trueModel)
% MODEL/MODELBUILD build SIMULINK blocks for model
% 
% This is an m-file that will build a 'dialup' for a global
% parameter model.
%
% MODELBUILD(MODEL,PARENT,NAME,NOCODE)
% 
% model  - a global model
% parent - the name of the parent model
% name   - the name of the subsystem.
% nocode - 1 if you wish to supress coding.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:52:31 $

if nargin > 4
	% This allows a derived class to be downcast to a model and then call modelbuild
	% but still pass the actual model
	m = trueModel;
end
if nargin < 4 
   DO_PEV = 1;
end
BI = 'built-in/';
loop=1;
while loop
   if isempty(find_system(parent,'SearchDepth',1,'Name',name))
      loop=0;
   else
      name=[name,'(' num2str(loop) ')'];
      loop=loop+1;
   end
end

sys=[parent,'/',name];

% build the subsystem
new_sys= add_block([BI,'SubSystem'],sys,...
   'open','on');

% LOCALDATUM is a flag that will let the build process know
% if the local model requires a datum input or not.
LOCALDATUM=0;

% Add an Inport to the subsystem.
Inport= add_block([BI,'Inport'],[sys,'/X']);
InPos= [15,150,40,165];
set_param(Inport,'position',InPos);
CodePos=InPos+[50 -5 80 5];

% Add a CODE block to the diagram only if there is coding, and 
% we have not implemented coding before...
if ~isempty(get(m,'code'))
   CODE =1;
   CodeBlk= codebuild(m,sys,'Code');
   set_param(CodeBlk,'position',CodePos);
else
   CODE=0;
end

% Add the Appropriate Eval block
EvMPos=CodePos+[90 0 130 0];
% Polymorphic evalbuild...implemented each model level.
EvM= evalbuild(m,sys);	
set_param(EvM,'position',EvMPos);
EvMname= get_param(EvM,'name');
simSetEvalParam(m, new_sys);

% Ensure that JcbM output is created even if DO_PEV is 0
JcbM = [];

ports= get_param(EvM,'inport');
if size(ports,1)>1
   % need to add a demux block
   DEMUX=1;
   MxPos(1:2)= ports(1,:)-[15 5];
   MxPos(3:4)= ports(2,:)-[10 -5];
   DMx1= add_block([BI,'Demux'],[sys,'/DMx1']);
   set_param(DMx1,'position',MxPos,...
      'outputs',num2str(size(ports,1)));
else
   DEMUX=0;
end
% Set the Yinv function
% from Eval to prod/1
EvMoutport = get_param(EvM,'outport');
EvMoutport = EvMoutport(1,:);
YinvPos = Centre2LTRB(EvMoutport+[70 0], 70, 30);
%YinvPos=EvMPos+[130 0 110 0];
if ~isempty(get(m,'yinv'))
   YINV=1;
   Ynv=YinvBuild(m,sys);
   set_param(Ynv,'position',YinvPos);
else
   YINV=0;
end


% Add an Outport to the subsystem.
OutPos=InPos+[400 0 400 0];
Outport= add_block([BI,'Outport'],[sys,'/Y']);
set_param(Outport,'position',OutPos);

% Now do the PEV + Jacobian stuff if needed...
if DO_PEV
   % Polymorphic Jacobbuild...implemented each model level.
   JcbPos= EvMPos + [0 120 0 120];
   JcbM= jacobbuild(m,sys);	
   set_param(JcbM,'position',JcbPos);
   Jcbname= get_param(JcbM,'name');
   
   
   % add the YinvDiff block
   YinvdiffPos=YinvPos+[0 60 0 60];
   Yinvdiff= YinvDiffBuild(m,sys);
   set_param(Yinvdiff,'position',YinvdiffPos);
   % set the correct function.
   
   % add a product block
   prodPos(1:2)= [YinvdiffPos(3)+50 YinvdiffPos(2)-17];
   prodPos(3:4)= [prodPos(1)+50 JcbPos(4)+17];
   prod = add_block([BI,'Product'],[sys,'/Prod']);
   set_param(prod,'position',prodPos);
   
   % add a matrix multiplication block
   mprodPos(1:2)= get_param(prod,'outport')+[50 -15];
   mprodPos(3:4)= [100+mprodPos(1) prodPos(4)-15];
   mprod= add_block('models2/Matrix Functions/mvMultiplyMatrixSFn',...
      [sys,'/matrix prod']);
   set_param(mprod,'position',mprodPos,'linkstatus','none');
   % add a constant block
   RcPos(1:2)= [prodPos(1) prodPos(4)+20];
   RcPos(3:4)= [prodPos(3) 60+prodPos(4)];
   Rc = add_block([BI,'Constant'],[sys,'/Rc']);
   set_param(Rc,'position',RcPos,...
      'value','R(:)');
   
   % add a second outport.
   OutPos2(1:2)= get_param(mprod,'outport')+[30 -10];
   OutPos2(3:4)= OutPos2(1:2)+[20 20];
   Outport2= add_block([BI,'Outport'],[sys,'/sqrt(PEV)']);
   set_param(Outport2,'position',OutPos2);
   
   % now add all the Jacobian parameters to the mask
   simSetJacobParam(m,new_sys);
end

% -------------------------------------------------
% CONNECTING BLOCKS
% -------------------------------------------------
if CODE
   % x1 to Code
   add_line(sys,'X/1','Code/1');
   if DEMUX
      % from  Code to DEMUX
      add_line(sys,'Code/1','DMx1/1');
      for i=1:size(ports,1)
         % do this as many times as input ports in the Eval block
         add_line(sys,['DMx1/',num2str(i)],[EvMname,'/',num2str(i)]);
      end
   else % no DEMUX
      % straight from Code to Eval
      add_line(sys,'Code/1',[EvMname,'/1']);
      if DO_PEV
         % xcoded to jacob
         CodePort= get_param(CodeBlk,'outport');
         jPort= get_param(JcbM,'inport');
		 % Get first port because rbf's have 2 input ports
		 jPort = jPort(1,:);
         add_line(sys,[...
               CodePort+[10 0];...
               [CodePort(1)+10 jPort(2)];...
               jPort]);
      end
   end
else % NO CODE
   if DEMUX
      add_line(sys,'X/1','DMx1/1');
      for i=1:size(ports,1)
         add_line(sys,['DMx1/',num2str(i)],[EvMname,'/',num2str(i)]);
      end
   else % no DEMUX & NO CODE
      add_line(sys,'X/1',[EvMname,'/1']);
      if DO_PEV
         % xcoded to jacob
         inPort= get_param(Inport,'outport');
         jPort= get_param(JcbM,'inport');
		 % Get first port because rbf's have 2 input ports
		 jPort = jPort(1,:);
         add_line(sys,[...
               inPort+[10 0];...
               [inPort(1)+10 jPort(2)];...
               jPort]);
      end
   end
end

if YINV
   add_line(sys,[EvMname,'/1'],'Yinv/1');
   add_line(sys,'Yinv/1','Y/1');
else
   add_line(sys,[EvMname,'/1'],'Y/1');
end

if DO_PEV
   % from Eval to prod/1
   evPort= get_param(EvM,'outport');
   % Get first port because RBF's have 2 output ports on eval
   evPort = evPort(1,:);
   prodPort= get_param(Yinvdiff,'inport');
   add_line(sys,[...
         evPort+[10 0];...
         [evPort(1)+10 prodPort(2)];...
         prodPort]);
   
   % from Yinvdif to Prod/1
   add_line(sys,'Yinvdiff/1','Prod/1');
   
   % from jacob to prod/2
   add_line(sys,[Jcbname,'/1'],'Prod/2');
   
   % from prod to matrix prod/1
   add_line(sys,'Prod/1','matrix prod/1');
   
   % from matrix prod to sqrt(PEV)
   add_line(sys,'matrix prod/1','sqrt(PEV)/1');
   
   % from Rc to matrix prod/2
   rcPort= get_param(Rc,'outport');
   mprodPort= get_param(mprod,'inport');
   mprodPort= mprodPort(2,:);
   add_line(sys,[...
         rcPort;...
         [mprodPort(1)-10,rcPort(2)];...
         [mprodPort(1)-10, mprodPort(2)];...
         mprodPort]);
end

% Close the subsystem
pause(0.0);
set_param(new_sys,'open','off');