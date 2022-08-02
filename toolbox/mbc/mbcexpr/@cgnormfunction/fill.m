function [om,OK, msg] = fill(LT, expr)
%FILL Creates an optimMgr for filling the normfunction table
%
% [om, OK, msg] = fill(NF, expr);
%
% [LT, cost, O] = run(om, NF, x0, expr);
%
% The normalisers must not be abnormal. 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.4.2.3 $  $Date: 2004/02/09 07:14:39 $

OK = 0;
om = [];
msg = '';

if ~isfill(LT)
    msg = 'The table is empty or incomplete.';
    return
end

if isempty(expr)
    msg = 'The expression input is empty.';
    return
end

tablename = getname(LT);

om = contextimplementation( xregoptmgr, LT, @i_NFfill, [], ['Fill_' tablename], @fill);

% are all the variables in the table also in the expr? 
[tableVariables, problemVar, otherVariables] = getvariables(LT, expr);

if problemVar
    om = [];
    msg = problemVar;
    return
end   

ovarmin = zeros( length(otherVariables) );
ovarmax = zeros( length(otherVariables) );
numavepts = ones( length(otherVariables) );

for i = 1:length(otherVariables)
    setpoint = otherVariables(i).get('setpoint');
    if ~isempty(setpoint)
        ovarmin(i) = setpoint;
        ovarmax(i) = setpoint;
    else % use the underlying values
        ovarmin(i) = min(otherVariables(i).eval);
        ovarmax(i) = max(otherVariables(i).eval);
    end
end

for i = 1:length(otherVariables)
    omi =  omlinspace(otherVariables(i).info, ovarmin(i), ovarmax(i), numavepts(i));
    om = AddOption(om,['Set_' otherVariables(i).getname],omi,'xregoptmgr', otherVariables(i).getname);
end   

OK = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [LT,cost,OK, msg] = i_NFfill(LT,om,x0,expr)
% Fills the values array of the LookupOne object LT with values 
% coming from the expression expr tablefill will determine where 
% the breakpoints of LT are and then will evaluate eq at these 
% points. These values will then be used in the values array for LT.

cost = Inf;
OK = 0;
msg = '';

% get pointers to the variables feeding into the LT
[var, problem, otherVariables] = getvariables(LT,expr);
if problem
    msg = problem;
    return
end   


% get the ranges on the otherVariables not in the table, and set their values 
[saveothervar, success, msg] = setVariables(LT, otherVariables,om);

if ~success
    resetVariables(LT, otherVariables,saveothervar);
    return
end
msg = ''; % ignore any message from setVariables

XStart = var.eval;
Norm = LT.Xexpr; % get the normaliser
NormExpr = Norm.get('x');
NormVals = Norm.get('values');

n = max(NormVals);  % this will tell us the size the values array needs to be.


% compute the breakpoints (fixed and variable)
BP = invert(Norm.info, (0:n) )';

% make the breakpoints into a value expression
BPVal = cgvalue('BPVal',BP); 

% solve XExpr = BPVal for var  
[junk, varExpr,problem, PtrsCreated] = solve(NormExpr.info, BPVal, var);
if problem
    msg = 'Error inverting the input. Try optimising the table values instead.';
    i_exit(LT, [BPVal, PtrsCreated],  [var, otherVariables], [{XStart}, saveothervar]);
    return
end   

newvalues = varExpr.eval;
% if XStart and newvalues are not either both column or both row vectors, flip newvalues
if (size(XStart,1) > 1  && isequal(size(newvalues,1),1)) || (isequal(size(XStart,1),1) && size(newvalues,1) > 1) 
    newvalues = newvalues';
end

var.info = var.set('value',newvalues);


M = evalAveOtherVariables(expr.info, var);


if any(isnan(M))
    msg = 'Table filling failed because either the model or other parts of the strategy could not be evaluated.  Check that the model returns finite values, and that all other tables are initialised and contain finite values.';
    i_exit(LT, [BPVal, PtrsCreated],  [var, otherVariables], [{XStart}, saveothervar]);
    return;
elseif   any(isinf(M))   
    M(isinf(M)) = 1;
elseif ~isreal(M)
    msg = 'The model returned some complex numbers -- filling those entries with zero.';
    M(find(imag(M))) = 0;
else
    OK =1;
end

% if we have any locked values we need to kep them
oldVals = get(LT, 'values');
valLocks = logical(get(LT, 'vlocks'));
M(valLocks) = oldVals(valLocks);

% set the table values to the be the values in M
LT  = set(LT, 'values', {M(:), 'Filled.'});

i_exit(LT, [BPVal, PtrsCreated],  [var, otherVariables], [{XStart}, saveothervar]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_exit(LT, PtrsCreated, var, savevar)

% reset variables
resetVariables(LT, var, savevar);

% free pointers 
freeptr(PtrsCreated);




