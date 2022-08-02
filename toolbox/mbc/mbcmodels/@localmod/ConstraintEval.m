function sname = ConstraintEval(m,parentsys,des)
%CONSTRAINTEVAL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:38:30 $

bname='Constraints';
loop=1;
while loop
   if isempty(find_system(parentsys,'SearchDepth',1,'Name',bname))
      loop=0;
   else
      bname=['Constraints(' num2str(loop) ')'];
      loop=loop+1;
   end
end

BI = 'built-in/';
load_system('constraints');
% First create block as subsystem
sname = [parentsys '/' bname];
sys = add_block([BI 'Subsystem'],sname);

% Add an inport
in = add_block([BI 'Inport'],[sname '/Factors'],...
   'position',Centre2LTRB([20 100],20,20));
centre = get_param(in,'outport') + [100 0];

% Get a Bounds constraint block
const = add_block('constraints/Bound constraint',[sname '/Constraint1'],...
   'position',Centre2LTRB(centre,80,40),'linkstatus','none');
add_line(sname,'Factors/1','Constraint1/1');

% Add a ground and status outport
centre = centre + [80 -60];
add_block([BI 'Ground'],[sname '/gnd'],...
   'position',Centre2LTRB(centre,20,20));
add_block([BI 'Outport'],[sname '/Status'],...
   'position',Centre2LTRB(centre+[40 0],20,20));
add_line(sname,'gnd/1','Status/1');

% Add distances outport
centre = get_param(const,'outport') + [50 0];
add_block([BI 'Outport'],[sname '/Distances'],...
   'position',Centre2LTRB(centre,20,20));
add_line(sname,'Constraint1/1','Distances/1');

% Set bounds on constraint block
set_param(const,'B',['[' sprintf('%.20f ',(gettarget(m))) ']']);

close_system('constraints');