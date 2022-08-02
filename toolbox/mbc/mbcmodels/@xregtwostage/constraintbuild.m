function [sys,sname] = constraintbuild(m,parentsys,md)
%CONSTRAINTBUILD

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:59:28 $

BI = 'built-in/';

bname = 'Constraint Block';
loop=1;
while loop
   if isempty(find_system(parentsys,'SearchDepth',1,'Name',bname))
      loop=0;
   else
      bname=['Constraint Block(' num2str(loop) ')'];
      loop=loop+1;
   end
end
sname = [parentsys '/' bname];
sys= add_block([BI,'SubSystem'],sname);

%----------------------------------------
% Generate sub-system components and link
%----------------------------------------

% Add an Inport to the subsystem.
in = add_block([BI,'Inport'],[sname,'/X']);
% Generate inport name for mux block
demux_in_name = 'X/1';
% Position inport
centre = [30 102];
inPos = Centre2LTRB(centre,20,20);
set_param(in,'position',inPos);

% If necassary add code block
if ~isempty(get(m,'code'))
   CodeBlk= codebuild(m,sname,'Code');
   centre = centre + [80 0];
   set_param(CodeBlk,'position',Centre2LTRB(centre,80,40));
   add_line(sname,'X/1','Code/1');
   demux_in_name = 'Code/1';
end

centre = centre + [80 0];
% Add a demux to separate local and global factors
nLocal = num2str(nlfactors(m));

demux = add_block([BI 'Demux'],[sname '/demux'],...
   'position',Centre2LTRB(centre,5,150),...
	'Outputs',[ '[' nLocal ' -1]' ],'backgroundcolor','black');

% Add line into demux
add_line(sname,demux_in_name,'demux/1');

% Get demux outport positions
demux_out = get_param(demux,'outport');

% Add mux to combine local and global constraints
mux = add_block([BI 'Mux'],[sname '/mux'],...
   'position',Centre2LTRB(centre+[200 0],5,150),...
	'Inputs','2','displayoption','bar');

% Add local model constraints and lines to demux/mux
L = get(m,'local');
l_const = constraintbuild(L,sname,md);
centre = demux_out(1,:) + [100 0];
set_param(l_const,'name','local constraint',...
   'position',Centre2LTRB(centre,80,50));
add_line(sname,'demux/1','local constraint/1');
add_line(sname,'local constraint/1','mux/1');

% Add global model constraints and lines to demux/mux
gm = globalmodels(m);
g_const = constraintbuild(gm{1},sname,md);
centre = demux_out(2,:) + [100 0];
set_param(g_const,'name','global constraint',...
   'position',Centre2LTRB(centre,80,50));
add_line(sname,'demux/2','global constraint/1');
add_line(sname,'global constraint/1','mux/2');

% Add an outport to the system
out = add_block([BI 'Outport'],[sname '/C']);
centre = get_param(mux,'outport') + [60 0];
set_param(out,'position',Centre2LTRB(centre,20,20));
add_line(sname,'mux/1','C/1');
