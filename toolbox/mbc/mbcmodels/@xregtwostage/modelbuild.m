function [new_sys,EvM]=modelbuild(m,parent,name,DO_PEV)
% TWOSTAGE/MODELBUILD - BUILD UP THE STRUCTURE OF THE SIMULINK MODEL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.3 $  $Date: 2004/02/09 08:00:00 $

if nargin < 4
   DO_PEV = 1;
end

NO_PEV = 0;

sname=[parent, '/',name];
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

% Start by creating a new_sys as a subsytem of parentsys
new_sys= add_block([BI,'SubSystem'],sname,...
   'Open','On');
set_param(new_sys,'position',[15 20 105 55]);

% Add an Inport to the subsystem.
Inport= add_block([BI,'Inport'],[sname,'/X']);
InPos= [15,150,40,165];
set_param(Inport,'position',InPos);

% Add a CODE block to the diagram
CodePos=InPos+[50 -5 80 5];
if ~isempty(get(m,'code'));
   CODE=1;
   CodeBlk= codebuild(m,sname,'Code');	%OVERLOADED METHOD: @MODEL
   set_param(CodeBlk,'position',CodePos);
else
   CODE=0;
end

% Add a demux block to the figure to split N,L,A,E from Spk
Dmx1= add_block([BI,'Demux'],[sname,'/Dmx1']);
DmPos=CodePos+[90 0 40 0];
nLocal = num2str(nlfactors(m));
set_param(Dmx1,'position',DmPos,...
   'outputs',[ '[ ' nLocal '  -1]' ],...
   'backgroundcolor','black');

% Add a new global model subsystem for each global model.
% OVERLOADED MODELBUILD: @MODEL & @LOCALMOD
global_models=globalmodels(m);
mpt= ceil(length(global_models)/2);
% global_models(mpt) is in the middle...i.e. Posmpt= CodePos+[180 0 180 0]
GbMdPos=CodePos+[180 -45*(length(global_models)-mpt) 180 -45*(length(global_models)-mpt)];
for i=1:length(global_models)
   [GbMd{i},EvM]=modelbuild(global_models{i},sname,['RF',num2str(i)],DO_PEV);
   set_param(GbMd{i},'position',GbMdPos);
   GbMdPos=GbMdPos+[0 50 0 50];
end

% Add the datum model.
DtmPos= GbMdPos;
DtmMod=datummodel(m);
if ~isnumeric(DtmMod)
   DATUM=1;
   [Dtm, EvM]= modelbuild(DtmMod,sname,'Datum',NO_PEV);
   set_param(Dtm,'position',DtmPos);
else
   DATUM=0;
end

% Add a mux block to mux the response features.
Mx1= add_block([BI,'mux'],[sname,'/Mx1']);
MxPos=[GbMdPos(3)+140, GbMdPos(2)-(length(global_models))*50-19,...
      GbMdPos(3)+145, GbMdPos(4)-50+9];
set_param(Mx1,'position',MxPos,...
   'inputs',num2str(length(global_models)),...
   'displayoption','bar');

% Make a call to the local simReconstruct method.
local_model=get(m,'local');
mtrxPos = Centre2LTRB(get_param(Mx1,'outport') + [100 0],100,40);
mtrx= simReconstruct(local_model, sname);
set_param(mtrx,'position',mtrxPos);

% Add the local model evaluation block
centre = get_param(mtrx,'outport');
% Note Reconstruct block has two outports
LmodPos = Centre2LTRB(centre(1,:)+[150 20],100,60);
% OVERLOADED MODELBUILD
[Lmod,LOCALDATUM] = modelbuild(local_model, sname, 'Local Model', DO_PEV);
set_param(Lmod,'position',LmodPos);

% Add an output block.
out1= add_block([BI,'OutPort'],[sname,'/Y']);
centre = get_param(Lmod,'outport');
centre = centre(1,:) + [50 0];
set_param(out1,'position',Centre2LTRB(centre,20,20));

% Add a mux block for the Jacobian Matrix and add the 
% matrix multiplication blocks
if DO_PEV
   Mx2 = add_block([BI 'mux'], [sname '/Mx2']);
   [centre,width,height] = LTRB2Centre(MxPos);
   centre(2) = ceil(centre(2)+ height + 101);
   set_param(Mx2,'position',Centre2LTRB(centre,width,height),...
      'inputs',num2str(length(global_models)),...
      'displayoption','bar');
   centre = get_param(Mx2,'outport');
   Jt = add_block(['Models2/Matrix Functions/mvTransposeMatrixSFn'],...
      [sname '/transpose']);
   centre(1) = centre(1) + 300;
   set_param(Jt, 'position', Centre2LTRB(centre,30,30),'linkstatus','none');
   Jmh = add_block(['Models2/Matrix Functions/mvMultiplyMatrixSFn'],...
      [sname '/timesh']);
   centre = centre + [0 -50];
   set_param(Jmh, 'position',Centre2LTRB(centre,30,30),'linkstatus','none');
   JmhJR = add_block(['Models2/Matrix Functions/mvMultiplyMatrixSFn'],...
      [sname '/timesJR']);
   centre = centre + [100 25];
   set_param(JmhJR, 'position',Centre2LTRB(centre,30,90),'linkstatus','none');   
   JRout = add_block([BI 'OutPort'],[sname '/sqrt(PEV)']);
   centre = get_param(JmhJR,'outport') + [50 0];
   set_param(JRout,'position',Centre2LTRB(centre,20,20));
else
   % Add terminator block for reconstruct
   centre = get_param(mtrx,'outport');
   centre = centre(2,:) + [30 0];
   term = add_block([BI 'Terminator'],[sname '/term']);
   set_param(term,'position',Centre2LTRB(centre,20,20));
end

% ---------------------------------------------------
% CONNECT THE BLOCKS
% ---------------------------------------------------
len=length(global_models);
% X to CODE
if CODE
   add_line(sname,'X/1','Code/1');
   add_line(sname,'Code/1','Dmx1/1');
else
   add_line(sname,'X/1','Dmx1/1');
end

% add a line from Dmx1 port 2 to same height + 50 
add_line(sname,[...
      DmPos(3)+5,DmPos(4);...
      DmPos(3)+60, DmPos(4)-5]);
% Dmx1 port 2 to RF's + Datum
for i=1:length(global_models)
   PortPos=get_param(GbMd{i},'Inport');
   add_line(sname,[...
         DmPos(3)+60, DmPos(4)-5;...         
         DmPos(3)+60, PortPos(2);...
         GbMdPos(1), PortPos(2)]);
end
if DATUM
	% Round added to make points R12 compatable
	add_line(sname,round([...
			DmPos(3)+60, DmPos(4)-5;...
			DmPos(3)+60, 3+GbMdPos(2)+(GbMdPos(4)-GbMdPos(2))/2;...
			GbMdPos(1)-5,3+GbMdPos(2)+(GbMdPos(4)-GbMdPos(2))/2]));
end      

% get the handle to the local model block
Ports= get_param(Lmod,'porthandles');
LmodPos= get_param(Ports.Inport(2),'position');

BtmPos= GbMdPos+[0 50 0 50];
% Dmx1 port 1 to Local Model
% Round added to make points R12 compatable
add_line(sname,round([...
   DmPos(3)+5,DmPos(2)+(DmPos(4)-DmPos(2))/2;...
   DmPos(3)+30,DmPos(2)+(DmPos(4)-DmPos(2))/2;...
   [DmPos(3)+30 BtmPos(2)];...
   [LmodPos(1)-10 BtmPos(2)];...
   LmodPos-[10 0];...
   LmodPos;...
]));


% RF's to MX1
for i=1:length(global_models)
   add_line(sname,['RF',num2str(i),'/1'],['Mx1/',num2str(i)]);
end


% Mx1 to mtrx
add_line(sname,'Mx1/1','Reconstruct/1');

% mtrx to Lmod/1
LmodPos= get_param(Ports.Inport(1),'position');
mtrxPos= get_param(mtrx,'outport');
add_line(sname,'Reconstruct/1','Local Model/1');

if DATUM
   dtmPos= get_param(Dtm,'outport');
   dtmPos = dtmPos(1,:);
   % Datum to Local model /2
   if LOCALDATUM
      LmodPos= get_param(Ports.Inport(3),'position');
      add_line(sname,[...
            dtmPos;...
            [LmodPos(1)-20 dtmPos(2)];...
            [LmodPos(1)-20 LmodPos(2)];...
            LmodPos;...
         ]);
   end
end

% Lmod to out1
add_line(sname,'Local Model/1','Y/1');

% PEV specific connections
if DO_PEV
   % RF's to Jacobian Mux
   EndPoints = get_param(Mx2,'inport');
   for i = 1:length(global_models)
	   start = get_param(GbMd{i},'outport');
	   % Start at the second port
	   start = start(2,:);
	   finish = EndPoints(i,:);
	   point1 = start + [110-10*i 0];
	   point2 = [point1(1) finish(2)];
	   add_line(sname,[start;point1;point2;finish]);
   end
   % Jacobian Mux to transpose
   add_line(sname,'Mx2/1','transpose/1');
   % Reconstruct h to timesh
   start = mtrxPos(2,:);
   finish = get_param(Jmh,'inport');
   finish = finish(2,:);
   point1 = start + [10 0];
   point2 = [point1(1) finish(2)];
   add_line(sname,[start;point1;point2;finish]);
   % Local Model to timesh
   start = get_param(Lmod,'outport');
   finish = get_param(Jmh,'inport');
   finish = finish(1,:);
   start = start(2,:);
   point1 = start + [30 0];
   point2 = [point1(1) finish(2) - 50];
   point3 = [finish(1) - 30 point2(2)];
   point4 = [point3(1) finish(2)];
   add_line(sname,[start;point1;point2;point3;point4;finish]);   
   % transpose to timesJR
   add_line(sname,'transpose/1','timesJR/2');
   % timesh to timesJR
   add_line(sname,'timesh/1','timesJR/1');
   % timesJR to sqrt(PEV)
   add_line(sname,'timesJR/1','sqrt(PEV)/1');
   % Matrix size parameters
   NumMP = size(m,1);
   NumRF = length(global_models);
   % Set transpose matrix size
   set_param(Jt,'parameters',['[' num2str([NumMP NumRF]) ']']);
   % Set timesh matrix sizes
   set_param(Jmh,'parameters',['[' num2str([1 NumRF]) '],[' num2str([NumRF NumRF]) ']']);
   % Set timesJR matrix sizes
   set_param(JmhJR,'parameters',['[' num2str([1 NumRF]) '],[' num2str([NumRF NumMP]) ']']);
   % Get twostage R matrix
   FirstRow = 0;
   % Get correct part of R matrix
   for i = 1:NumRF
      NumLP = numParams(global_models{i});
      LastRow = NumLP + FirstRow;
      VarName = ['R(' num2str(FirstRow+1) ':' num2str(LastRow) ',:)'];
      set_param(GbMd{i},'R',VarName,...
         's0',['[1 ' num2str(NumLP) ']'],...
         's1',['[' num2str([NumLP NumMP]) ']']);
      FirstRow = LastRow;
   end
else
   % Add link between h and term block here
   add_line(sname,'Reconstruct/2','term/1');
end

% Close the subsystem
pause(0.0)
set_param(new_sys,'open','off');
