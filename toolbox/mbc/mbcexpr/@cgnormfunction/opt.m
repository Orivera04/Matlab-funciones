function [om,OK, msg]= opt(LT, sf)
%OPT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.3 $  $Date: 2004/02/09 07:15:02 $

% NormFunction/opt
% creates an optimMgr for optimising the lookuptwo table 
% Compares the output of the strategy with the model, and moves the 
% table values around as free parameters to reduce the error.
% [om, OK, msg] = opt(LT, sf)
% [om, OK, msg] = opt(LT, sf)
% [LT, cost, OK, msg] = run(LT, om, [], var, sf,p)
% sf is a subfeature
% p is a pointer to the table

if ~isfill(LT)
   OK = 0;
   msg = 'The table is empty or incomplete.';
   om = [];
   return
end

tablename = getname(LT);
   
om= contextimplementation(xregoptmgr,LT,@i_opt,[],['Opt_' tablename],@opt);

mod = get(sf, 'model');
eq  = get(sf, 'equation');

if isempty(mod)
   OK = 0;
   msg = 'The subfeature has no model.';
   om = [];
   return
end
if isempty(eq)
   OK = 0;
   msg = 'The subfeature has no strategy.';
   om = [];
   return
end

% are all the variables in the table also in the equation? 
[tableVariables, problemVar, otherVariables]= getvariables(LT,mod);

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
   om = AddOption(om,['Set_' tableVariables(i).getname],omi,'xregoptmgr');
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
   om= AddOption(om,['Set_' otherVariables(i).getname],omi,'xregoptmgr');
end   

% add a flag to say if we are in an abnormal case or not 
% eventually make this nonguisettable
if problemVar 
   % if the table variables are not in the model, or if there are more than the 
   % expected number of input variables to the model
   abnormalflag = 1;
else
   abnormalflag = 0;
end

if abnormalflag 
   Nx = get(LT, 'x');
   mvars = mod.getptrs; 
   if isempty(tableVariables)     
      OK = 0;
      msg = sprintf('There are no common variables feeding into %s.', Nx.getname);
      return
   elseif ~isequal(intersect(double(tableVariables), double(mvars)), double(tableVariables)) 
      OK = 0;
      msg = 'There are variables in the table that are not in the model. ';
      return  
   else
      vars = '';
      for i = 1:length(tableVariables)-1
         vars = [vars tableVariables(i).getname '|'];  
      end
      
      vars = [vars tableVariables(end).getname];
      
      om= AddOption(om,'xVariable',tableVariables(1).getname, vars, ['Main variable in ' Nx.getname]);
   end
end   

om= AddOption(om,'AbnormalFlag',abnormalflag, 'boolean', [], false);
OK = 1;
msg = '';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [LT,cost,OK, msg] = i_opt(LT,om,x0,sf,p)

if isempty(sf) || isfeature(sf);
   OK = 0;
   msg ='Need a subfeature input';
end   

if isempty(p)
   OK = 0;
   msg = 'Need a pointer input to the table';
end   
   
% flag for the abnormal case
abnormalflag = get(om, 'AbnormalFlag');

eq = get(sf, 'equation');
mod = get(sf, 'model');

[var, problem, otherVariables] = getvariables(LT, mod);

[saveothervar, OK, msg] = setVariables(LT, otherVariables,om);

if ~OK
   resetVariables(LT, otherVariables,saveothervar);
   return
end

% grid the input variables with the given values
[savetablevar, OK, msg] = setVariables(LT, var,om);

if ~OK
   i_exit([otherVariables var],[saveothervar savetablevar]);
   return
end

if abnormalflag 
% get variables to use in the table if there was a choice
   xstr = get(om, 'xVariable');
   for i = 1:length(var)
      if strcmp(var(i).getname, xstr)
         xvar = var(i);
      else % if it is not to be used as x, average it
         var(i).info = var(i).set('value', mean(var(i).eval));
         % I don't set this back again....
      end   
   end      
   mainvar = xvar;
else
   xvar = var(1);
   mainvar = var;
end   

% values of the model
M = evalAveOtherVariables(mod.info, mainvar);

if any(isnan(M))
     OK = 0;
     msg = 'A Nan encountered.';
     cost = Inf;
     i_exit([otherVariables var],[saveothervar savetablevar]);
     return;
elseif   any(isinf(M)) 
     cost = Inf;
     OK = 0;
     M(isinf(M)) = 1;
     msg = 'An Inf encountered.';
elseif ~isreal(M)
   cost = Inf;
   OK = 0;
   msg = 'The model returned some complex numbers -- filling those entries with zero.';
   M(find(imag(M))) = 0;
else
   cost = Inf;
   OK = 1;
   msg = '';
end

Val = get(LT,'values');
L = get(LT,'vlocks');
if ~any(L);
   %i_cost(Val,p,M,eq, var);
   Z = lsqnonlin(@i_cost,Val,[],[],[],p,M,eq,mainvar);
elseif all(L)
   i_exit(var,savetablevar);
   return
else
   Z = Val(L==0);
   LZ = Val(L==1);
   Ind = (1:length(Val))';
   lind = Ind(L==1);
   uind = Ind(L==0);
   i_costlock(Z,p,M,eq,var,LZ,lind,uind);
   Z = lsqnonlin(@i_costlock,Z,[],[],[],p,M,eq,mainvar,LZ,lind,uind);
end


% officially set the values
Values = p.get('values');
LT = set(LT, 'values', {Values, 'Optimized.'});
i_exit([otherVariables var],[saveothervar savetablevar]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_exit(var, savevar)

% set the values of the variables back again
for i = 1:length(var)
   var(i).info = var(i).set('value',savevar{i});
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out = i_cost(Z,p,M,eq,var)

p.info = p.setVunofficial(Z);

% value of the equation
E = evalAveOtherVariables(eq.info, var);

out = M(:) - E(:);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out = i_costlock(Z,p,M,eq,var,LZ,lind,uind)

K = [lind LZ; uind Z];

K = sortrows(K,1);

Z = K(:,2);

p.info = p.setVunofficial(Z);

out = M - evalAveOtherVariables(eq.info, var);



