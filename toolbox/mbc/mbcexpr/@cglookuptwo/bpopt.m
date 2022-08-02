function [om,OK, msg]=bpopt(LT, sf)
%BPOPT
% LookUpTwo/bpopt
% creates an optimMgr for optimising the breakpoints of LT
% [om, OK] = bpopt(LT)
% [LT, cost, OK, varargout] = run(om, LT, [], var, expr, range)
% varargout contains the spline data that we develop

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.6.2.3 $  $Date: 2004/02/09 07:11:26 $

if ~isfill(LT)
   OK = 0;
   msg='The table is empty or incomplete.';
   om = [];
   return
end

tablename = getname(LT);
   
om= contextimplementation(xregoptmgr,LT,@i_bpopt,[],['OptBP_' tablename],@bpopt);

Nx = get(LT, 'x');
Ny = get(LT, 'y');
BPx = Nx.get('breakpoints');
BPy = Ny.get('breakpoints');

eq = get(sf, 'model');

if isempty(eq)
   om = [];
   OK = 0;
   msg = 'This subfeature has no model associated with it.';
   return
end

% are all the variables in the table also in the equation? 
[tableVariables , problemVar, otherVariables]= getvariables(LT,eq);

if ~isequal(problemVar,0) 
   if isempty(tableVariables) % cannot determine table variables
      OK = 0;
      msg = problemVar;
      om = [];
      return
   else % continue, but in abnormal case
      abnormalflag = 1;
   end
else
   abnormalflag = 0;
end   


for i =1:length(tableVariables)
   range = tableVariables(i).get('range');
   if ~isempty(range)
      varmin(i) = range(1);
      varmax(i) = range(2);
   else % use the underlying values
      varmin(i) = min(tableVariables(i).eval);
      varmax(i) = max(tableVariables(i).eval);
   end
   Norm = get(LT, 'x');
   BP = Norm.get('BreakPoints');
   numgridpts(i) = 3*length(BP);
end

for i = 1:length(tableVariables)
   omi =  omlinspace(tableVariables(i).info, varmin(i), varmax(i), numgridpts(i));
   om= AddOption(om,['Set_' tableVariables(i).getname],omi,'xregoptmgr',tableVariables(i).getname);
end   

for i =1 :length(otherVariables)
   setpoint = otherVariables(i).get('setpoint');
   if ~isempty(setpoint)
      ovarmin(i) = setpoint;
      ovarmax(i) = setpoint;
   else % use the underlying values
      ovarmin(i) = min(otherVariables(i).eval);
      ovarmax(i) = max(otherVariables(i).eval);
   end   
   numavepts(i) = 1;  
end

for i = 1:length(otherVariables)
   omi =  omlinspace(otherVariables(i).info, ovarmin(i), ovarmax(i), numavepts(i));
   om= AddOption(om,['Set_' otherVariables(i).getname],omi,'xregoptmgr',otherVariables(i).getname);
end   



%non-guisettable option to update the history or not (set to zero when an intermediate step)
om= AddOption(om,'UpdateBPHistory',1, 'boolean', [],false);

if abnormalflag 
   xvars = Nx.getvariables(eq);
   % model variables
   mvars = eq.getptrs; 
    
   if isempty(xvars)
      OK = 0;
      msg = ['There are no common variables feeding into ' Nx.getname '. '];
      return
   elseif ~isequal(intersect(double(xvars), double(mvars)), double(xvars)) 
      OK = 0;
      msg = ['There are variables in the table that are not in the model. '];
      return  
   end
   xvarstr = '';
   for i = 1:length(xvars)-1
      xvarstr = [xvarstr xvars(i).getname '|'];  
   end
   xvarstr = [xvarstr xvars(end).getname];
      
   yvars = Ny.getvariables(eq);
   
   if isempty(yvars)
      OK = 0;
      msg = ['There are no common variables feeding into ' Ny.getname '. '];
      return
   elseif ~isequal(intersect(double(yvars), double(mvars)), double(yvars)) 
      OK = 0;
      msg = ['There are variables in the table that are not in the model. '];
      return  
   end
   
   yvarstr = '';
   for i = 1:length(yvars)-1
      yvarstr = [yvarstr yvars(i).getname '|'];  
   end
   yvarstr = [yvarstr yvars(end).getname];
      
   om= AddOption(om,'xVariable',xvars(1).getname, xvarstr,['Main Variable in ' Nx.getname]);
   om= AddOption(om,'yVariable',yvars(1).getname, yvarstr,['Main Variable in ' Ny.getname]);
   
   % don't allow reordering or non-fixed endpoints in the abnormal case
   om= AddOption(om,'OptBPOrder',0, 'boolean', 'Reorder Deleted Breakpoints', false);
   om= AddOption(om,'FixEndPoints',1, 'boolean', 'Fixed Endpoints',false);
else
   om= AddOption(om,'OptBPOrder',0, 'boolean', 'Reorder Deleted Breakpoints');
   om= AddOption(om,'FixEndPoints',1, 'boolean', 'Fixed Endpoints',false);
end   

% add a flag to say if we are in an abnormal case or not 
% eventually make this nonguisettable
om= AddOption(om,'AbnormalFlag',abnormalflag, 'boolean', [], false);

OK = 1;
msg = '';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [LT,cost,OK, msg, varargout] = i_bpopt(LT,om,x0,sf)


%
%   The method proceeds as follows: firstly evaluate the model over the chosen grid and then use this grid and surface
% to generate a spline approximation to the surface. To determine whether the current choice of breakpoints is any 
% good we need to create a lookup table based on the new breakpoints that approximates the model. To do this evaluate 
% the spline at the new breakpoint positions and use the resulting matrix as the values matrix in the lookup table.
% The optimising function then evaluates the lookup table over the chosen grid and subtracts this from the model values
% at these values seeking to minimise the difference.
%
optbporder = get(om, 'OptBPOrder');
abnormalflag = get(om, 'AbnormalFlag');

if optbporder
   % call the total BP opt routine that reorders breakpoints
   [LT, cost, OK, msg] = BP_totalopt(LT,om, sf);
else
   if ~abnormalflag 
      % call the basic BP opt routine
      [LT, cost, OK, msg] = BP_opt(LT,om, sf);
   else
      try
         % call the BP opt routine for when we have subfeatures feeding into normalisers
         [LT, cost, OK, msg] = ab_BP_opt(LT,om, sf);
      catch
         cost = Inf;
         OK = 0;
         msg = 'Undetermined error occurred.';
      end
   end   
end




