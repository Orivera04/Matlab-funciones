function [X,Y,M] = return_data(N,ud)
%RETURN_DATA

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.4 $  $Date: 2004/02/09 07:14:13 $

% NORMALISER/RETURN_DATA:
% [X,Y,M] = RETURN_DATA(N,ud) returns data to fill out the comparison plot in the breakpoint editor
% ud is the userdata of the breakpoint editor. We're in here because a cgnormaliser is the current primary 
% table, but this means that we could have a second table as secondary or not. We'll interrogate the userdata
% and then emulate either the lookupone or lookuptwo return_data method accordingly.

if ud.Data.Number == 1
    [X,Y,M] = i_one(N,ud); % one cgnormaliser - use lookupone method
else
    [X,Y,M] = i_two(N,ud); % two cgnormalisers - use lookuptwo method
end

% we'll use subfunctions here to avoid a lot of indented text - if it proves a problem, then 
% it should be easy to rearrange. 

return

%%%%%%%%%%%%%%%%%%%%%%%%%
% i_one                 %
%%%%%%%%%%%%%%%%%%%%%%%%%

function [X,Y,M] = i_one(N,ud)

BP = N.Breakpoints;
Xinput = N.Xexpr;
V = N.Values;

BPfull = eval(cgmathsobject,'linear1',V(:),BP(:),[0:V(end)]');

L = cglookupone;
L = set(L,'matrix',[BPfull,zeros(size(BPfull))]);
L = setname(L, 'tempLookupOne');
L = setX(L,Xinput);

[X,Y,M] = return_data(L,ud);

return

%%%%%%%%%%%%%%%%%%%%%%%%%
% i_two                 %
%%%%%%%%%%%%%%%%%%%%%%%%%

function [X,Y,M] = i_two(N,ud)

% If we're here then there are two tables in the breakpoint editor, so we need to find the second one.
% This will be stored in the second table pane data

yNormaliser = ud.TablePane(2).Data.Table; % this is a xregpointer to a cgnormaliser, whereas N is a cgnormaliser.

% We now construct a new lookuptwo and two new cgnormalisers so that we have minimal impact on the expression
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
   [X,Y,M] = return_data(L,ud);
catch
   X = []; Y = []; M = [];
end
freeptr([ptrx;ptry;ptr]);

return
