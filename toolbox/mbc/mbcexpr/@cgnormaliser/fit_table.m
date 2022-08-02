function T = fit_table(N,ud)
%FIT_TABLE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.4 $  $Date: 2004/02/09 07:13:51 $

% T = FIT_TABLE(T,ud) returns table data to fill out the comparison plot in the breakpoint editor
% ud is the userdata of the breakpoint editor. Should be used after return_data has run. The reason for splitting them up
% is that we need to find new table values each time we edit the table, whereas we need to evaluate the 
% model only when the input variables change, which should happen less often. We're in here because a normaliser is the current primary 
% table, but this means that we could have a second table as secondary or not. We'll interrogate the userdata
% and then emulate either the lookupone or lookuptwo return_data method accordingly.


if ud.Data.Number == 1
    T = i_one(N,ud); % one normaliser - use lookupone method
else
    T = i_two(N,ud); % two normalisers - use lookuptwo method
end

% we'll use subfunctions here to avoid a lot of indented text - if it proves a problem, then 
% it should be easy to rearrange. 

return

%%%%%%%%%%%%%%%%%%%%%%%%%
% i_one                 %
%%%%%%%%%%%%%%%%%%%%%%%%%

function T = i_one(N,ud)

BP = N.Breakpoints;
Xinput = N.Xexpr;
V = N.Values;

BPfull = eval(cgmathsobject,'linear1',V(:),BP(:),[0:V(end)]');

L = cglookupone;
L = set(L,'matrix',[BPfull,zeros(size(BPfull))]);
L = setname(L, 'tempLookupone');
L = setX(L,Xinput);

T = fit_table(L,ud);

return

%%%%%%%%%%%%%%%%%%%%%%%%%
% i_two                 %
%%%%%%%%%%%%%%%%%%%%%%%%%

function T = i_two(N,ud)

% If we're here then there are two tables in the breakpoint editor, so we need to find the second one.
% This will be stored in the second table pane data

yNormaliser = ud.TablePane(2).Data.Table; % this is a xregpointer to a normaliser, whereas N is a normaliser.

% We now construct a new lookuptwo and two new normalisers so that we have minimal impact on the expression
% list.

BPx = N.Breakpoints;
Vx = N.Values;
Xinput = N.Xexpr;

NewXNormaliser = cgnormaliser;
NewXNormaliser = set(NewXNormaliser,'matrix',[BPx,Vx]);
NewXNormaliser = setX(NewXNormaliser,Xinput);
ptrx = xregpointer(NewXNormaliser);

BPy = yNormaliser.get('breakpoints');
Vy = yNormaliser.get('values');
Yinput = yNormaliser.get('x');

NewYNormaliser = cgnormaliser;
NewYNormaliser = set(NewYNormaliser,'matrix',[BPy,Vy]);
NewYNormaliser = setX(NewYNormaliser,Yinput);
ptry = xregpointer(NewYNormaliser);

L = cglookuptwo;
ptr = xregpointer(L);
L = setX(L,ptr,ptrx);
L = setY(L,ptr,ptry);

try 
   T = fit_table(L,ud);
catch
   T = [];
end
freeptr([ptrx;ptry;ptr]);

return

