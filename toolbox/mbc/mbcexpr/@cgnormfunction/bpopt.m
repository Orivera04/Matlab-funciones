function [om,OK, msg]=bpopt(LT, sf)
%BPOPT
% NormFunction/bpopt
% creates an optimMgr for optimising the breakpoints of LT
% [om, OK, msg] = bpopt(LT, sf)
% [LT, cost, OK, msg, varargout] = run(om, LT, [], var, expr)
% varargout contains the spline data that we develop

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.6.2.3 $  $Date: 2004/02/09 07:14:32 $

if ~isfill(LT)
   OK = 0;
   msg = 'The table is empty or incomplete.';
   om = [];
   return
end

tablename = getname(LT);
   
om= contextimplementation(xregoptmgr,LT,@i_bpopt,[],['OptBP_' tablename],@bpopt);

eq = get(sf,'model');

if isempty(eq)
   om = [];
   OK = 0;
   msg = 'This subfeature has no model associated with it.';
   return
end

% get the variables in the table 
[tableVariables , problemVar, otherVariables]= getvariables(LT,eq);

% add a flag to say if we are in an abnormal case or not 
% eventually make this nonguisettable
if problemVar 
   % if the table variables are not in the model, or if there are more than the 
   % expected number of input variables to the model
   abnormalflag = 1;
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
   Norm = LT.Xexpr;
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
   om= AddOption(om,['Set_' otherVariables(i).getname],omi,'xregoptmgr', otherVariables(i).getname);
end   




if abnormalflag 
   Nx = get(LT, 'x');
   % get the pointers in the model
   mvars = eq.getptrs; 
   if isempty(tableVariables)     
      OK = 0;
      msg = ['There are no common variables feeding into ' Nx.getname '. '];
      return
   elseif ~isequal(intersect(double(tableVariables), double(mvars)), double(tableVariables)) 
      OK = 0;
      msg = ['There are variables in the table that are not in the model. '];
      return  
   else
      vars = '';
      for i = 1:length(tableVariables)-1
         vars = [vars tableVariables(i).getname '|'];  
      end
      
      vars = [vars tableVariables(end).getname];
      
      om= AddOption(om,'xVariable',tableVariables(1).getname, vars, ['Main variable in ' Nx.getname]);      
   end
   % don't allow reordering or non fixed breakpoints in abnormal case
   om= AddOption(om,'OptBPOrder',0, 'boolean', 'Reorder deleted breakpoints', false);
   om= AddOption(om,'FixEndPoints',1, 'boolean', 'Fix endpoints', false);
else
   om= AddOption(om,'OptBPOrder',0, 'boolean', 'Reorder deleted breakpoints'); 
   om= AddOption(om,'FixEndPoints',1, 'boolean', 'Fix endpoints',false);
end   

%non-guisettable option to update the history or not (set to zero when an intermediate step)
om= AddOption(om,'UpdateBPHistory',1, 'boolean', [],false);
om= AddOption(om,'AbnormalFlag',abnormalflag, 'boolean', [], false);
OK = 1;
msg = '';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [LT,cost,OK, msg, varargout] = i_bpopt(LT,om,x0, sf)


%
%   The method proceeds as follows: firstly evaluate the model over the chosen grid and then use this grid and surface
% to generate a spline approximation to the surface. To determine whether the current choice of breakpoints is any 
% good we need to create a lookup table based on the new breakpoints that approximates the model. To do this evaluate 
% the spline at the new breakpoint positions and use the resulting matrix as the values matrix in the lookup table.
% The optimising function then evaluates the lookup table over the chosen grid and subtracts this from the model values
% at these values seeking to minimise the difference.
%
optbporder = get(om, 'OptBPOrder');


if optbporder
   % call the total BP opt routine that reorders breakpoints
   [LT, cost, OK, msg, V, Xk] = BP_totalopt(LT,om, sf);
else
   % call the basic BP opt routine
   [LT, cost, OK, msg, V, Xk] = BP_opt(LT,om, sf);
end

if nargout >3
   varargout{1} = V;
   varargout{2} = Xk;
end   


 




