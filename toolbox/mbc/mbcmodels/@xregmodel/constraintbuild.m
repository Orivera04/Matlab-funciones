function [sys,sname] = constraintbuild(m,parentsys,md)
%CONSTRAINTBUILD

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:51:36 $

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
sys= add_block([BI,'SubSystem'],sname,'Open','On');

%----------------------------------------
% Generate sub-system components and link
%----------------------------------------

% Add an Inport to the subsystem.
in = add_block([BI,'Inport'],[sname,'/X']);
% Generate inport name for constraints block
dc_in_name = 'X/1';
% Position inport
centre = [30 50];
inPos = Centre2LTRB(centre,20,20);
set_param(in,'position',inPos);

% If necassary add code block
if ~isempty(get(m,'code'))
   CodeBlk= codebuild(m,sname,'Code');
   centre = centre + [80 0];
   set_param(CodeBlk,'position',Centre2LTRB(centre,80,40));
   add_line(sname,'X/1','Code/1');
   dc_in_name = 'Code/1';
end

% Add global constraints based on modeldev object
tp=mdevtestplan(md);
des_const = ConstraintEval(m,sname,Design(tp));
centre = centre + [150 0];
set_param(des_const,'position',Centre2LTRB(centre,100,60));
add_line(sname,dc_in_name,'Constraints/1');

% Get position of global constraints outports
des_const_out = get_param(des_const,'outport');

% Add Terminator
term = add_block([BI 'Terminator'],[sname '/Term']);
centre = des_const_out(1,:) + [40 0];
set_param(term,'position',Centre2LTRB(centre,20,20));
add_line(sname,'Constraints/1','Term/1');

% Add outport
out = add_block([BI 'Outport'],[sname '/C']);
centre = des_const_out(2,:) + [80 0];
set_param(out,'position',Centre2LTRB(centre,20,20));
add_line(sname,'Constraints/2','C/1');

% Close the subsystem
pause(0.0);
set_param(sys,'open','off');
