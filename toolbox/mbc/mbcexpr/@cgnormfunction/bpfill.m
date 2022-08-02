function [om,OK, msg]=bpfill(LT, sf)
%BPFILL
% NormFunction/bpfill
% creates an optimMgr for filling the breakpoints of LT
% These use the 'initialisation routines' that use curvature and errors
% [om, OK, msg] = bpfill(LT, sf)
% [LT, cost, OK, msg] = run(om, LT, [],sf)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


% $Revision: 1.4.2.3 $ $Date: 2004/02/09 07:14:30 $ 

if ~isfill(LT)
   OK = 0;
   msg = 'The table is empty or incomplete.';
   om = [];
   return
end

tablename = getname(LT);
   
om= contextimplementation(xregoptmgr,LT,@i_bpfill,[],['FillBP_' tablename],@bpfill);

om= AddOption(om,'FillMethod','ShareAveCurv','ShareAveCurv|ReduceError', 'Fill method');%flag for autospacing/initialising

eq = get(sf, 'model');

if isempty(eq)
   om = [];
   OK = 0;
   msg = 'This subfeature has no model associated with it.';
   return
end

% are all the variables in the table also in the equation? 
[tableVariables , problemVar, otherVariables]= getvariables(LT,eq);

if problemVar
   om = [];
   OK = 0;
   msg = problemVar;
   return
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
   om= AddOption(om,['Range_' tableVariables(i).getname],[varmin(i) varmax(i)],{'range',[-Inf,Inf]}, ['Range ' tableVariables(i).getname]);
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

OK = 1;
msg = '';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
function [LT,cost,OK, msg] = i_bpfill(LT,om,x0, sf)

method = get(om, 'FillMethod');
switch method
case 'ShareAveCurv'
   [LT,cost,OK, msg] = BPinit_curv(LT,om, sf);
case 'ReduceError'   
   [LT,cost,OK, msg] = BPinit_err(LT,om, sf);
otherwise
   msgbox('Not an initialization option.');
   OK = 0;
   return
end   
 




