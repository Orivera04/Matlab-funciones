function [om,OK, msg]=fill(LT, expr)
%FILL Creates an optimMgr for filling the lookuptwo table 
%
% This is the old average/fill routine, and fills by solving the strategy for the table, then 
% setting the values of the table equal to the rhs at the breakpoints.
% [om, OK] = fill(LT, expr)
% Requires that the subfeature can be solved for the table!
% LT will have the same value as expr at the breakpoints
% expr should have been formed by solving the subfeature for the table. 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.4.2.3 $  $Date: 2004/02/09 07:11:33 $

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

om= contextimplementation(xregoptmgr,LT,@i_fill,[],['Fill_' tablename],@fill);


% are all the variables in the table also in the expr? 
[tableVariables , problemVar, otherVariables]= getvariables(LT,expr);

if problemVar
    om = [];
    msg = problemVar;
    return
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [LT,cost,OK,msg] = i_fill(LT,om,x0,expr)

OK = 0;
cost = Inf;
msg = '';

% get pointers to the variables feeding into the LT
[var, problem, otherVariables] = getvariables(LT,expr);
if problem~= 0
    msg = problem;
    return
end   

xvar = var(1);
yvar = var(2);
XStart = xvar.eval;
YStart = yvar.eval;

[saveothervar, success, msg] = setVariables(LT, otherVariables,om);

if ~success
    resetVariables(LT, otherVariables,saveothervar);
    return
end
msg = ''; % setVariables was successful, so ignore any message

% Get the normalisers (if they are already set up)
XNorm = LT.Xexpr.info;
YNorm = LT.Yexpr.info;
XNormVals = get(XNorm,'values');
YNormVals = get(YNorm,'values');

nx = max(XNormVals);  % this will tell us the size the values array needs to be.
ny = max(YNormVals);

XNormExpr = get(XNorm,'x'); % get Xexpr for the normaliser
YNormExpr = get(YNorm,'x');% get Yexpr for the normaliser


% get all breakpoints (including the interpolated ones)
BPx = invert(LT.Xexpr.info, [0:nx]);
BPy = invert(LT.Yexpr.info, [0:ny]);

% make the breakpoints into value expressions
BPxVal = cgvalue('BPxVal',BPx); 
BPyVal= cgvalue('BPyVal',BPy);


% solve XNormExpr = BPxVal for xvar 
[junk, xvarExpr,problem, xPtrsCreated] = solve(XNormExpr.info, BPxVal, xvar);
if problem~= 0
    msg = ['Error inverting one of the inputs. Try optimizing the table values instead.' ];
    freeptr([BPxVal BPyVal xPtrsCreated]);
    resetVariables(LT, [otherVariables var],[saveothervar {XStart} {YStart}]);
    return
end   

newxvalues = xvarExpr.eval;
% if XStart and newvalues are not either both column or both row vectors, flip newvalues
if (size(XStart,1) > 1  & isequal(size(newxvalues,1),1)) | (isequal(size(XStart,1),1)  & size(newxvalues,1) > 1) 
    newxvalues = newxvalues';
end
xvar.info = xvar.set('value',newxvalues);

% solve YNormExpr = BPyVal for yvar 
[junk, yvarExpr,problem, yPtrsCreated] = solve(YNormExpr.info, BPyVal, yvar);
if problem
    msg = ['Error inverting one of the inputs. Try optimizing the table values instead.' ];
    resetVariables(LT, [otherVariables var],[saveothervar {XStart} {YStart}]);
    freeptr([BPxVal BPyVal xPtrsCreated yPtrsCreated]);
    return
end   

newyvalues = yvarExpr.eval;
% if YStart and newyvalues are not either both column or both row vectors, flip newvalues
if (size(YStart,1) > 1  & isequal(size(newyvalues,1),1)) | (isequal(size(YStart,1),1)  & size(newyvalues,1) > 1) 
    newyvalues = newyvalues';
end

% set the variable y to produce the current breakpoints
yvar.info = yvar.set('value',newyvalues);



M = evalAveOtherVariables(expr.info, var);


if any(isnan(M))
    msg = 'Table filling failed because either the model or other parts of the strategy could not be evaluated.  Check that the model returns finite values, and that all other tables are initialised and contain finite values.';
    resetVariables(LT, [otherVariables var],[saveothervar {XStart} {YStart}]);
    freeptr([BPxVal BPyVal xPtrsCreated yPtrsCreated]);
    return;
elseif   any(isinf(M))   
    M(isinf(M)) = 1;
elseif ~isreal(M)
    msg = 'The model returned some complex numbers -- filling those entries with zero.';
    M(find(imag(M))) = 0;
else
    OK = 1;
end


% set the table values to the be the values in M
LT  = set(LT, 'values', {M', 'Filled'});

% reset variables
resetVariables(LT, [otherVariables var],[saveothervar {XStart} {YStart}]);
% free pointers 
freeptr([BPxVal BPyVal xPtrsCreated yPtrsCreated]);





