function [LT,cost, OK, msg, varargout] = ab_BP_opt(LT,om,sf)
%AB_BP_OPT
%
%  Initiates optimisation routine for the breakpoints feeding into a
%  lookuptwo object.
%
%  The method proceeds as follows: firstly evaluate the model over the
%  chosen grid and then use this grid and surface to generate a spline
%  approximation to the surface. To determine whether the current choice of
%  breakpoints is any  good we need to create a lookup table based on the
%  new breakpoints that approximates the model. To do this evaluate  the
%  spline at the new breakpoint positions and use the resulting matrix as
%  the values matrix in the lookup table. The optimising function then
%  evaluates the lookup table over the chosen grid and subtracts this from
%  the model values at these values seeking to minimise the difference.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.3 $  $Date: 2004/04/04 03:27:33 $

% Get some function handles form the cgmathsobject library

cgm = cgmathsobject;

linear1fH = gethandle(cgm,'linear1');
linear2fH = gethandle(cgm,'linear2');
extinterp2fH = gethandle(cgm,'extinterp2');


% BP optimiser for two normalisers N1 and N2. eq should be list of expressions
% which we want to compare to, W their relative weightings, Range the range of
% values to optimise between as a 2 by 2 matrix.
% n1 and n2 should define the mesh fineness.

infoflag = get(om, 'UpdateBPHistory');

N1 = LT.Xexpr;
N2 = LT.Yexpr;

% (1) average all variables


% (2) Determine values of x and y that correspond to the chosen grid

X = N1.get('x');
Y = N2.get('x');

eq = get(sf,'model');
% are all the variables in the table also in the equation?
[var , problemVar, otherVariables]= getvariables(LT,eq);

[saveothervar, OK, msg] = setVariables(LT, otherVariables,om);

if ~OK
    resetVariables(LT, otherVariables,saveval);
    cost = Inf;
    return
end

% set the table variables
[savetablevar, OK, msg] = setVariables(LT, var,om);

if ~isequal(OK,1)
    resetVariables(LT, [otherVariables var],[saveothervar savetablevar]);
    cost = Inf;
    return
end

% determine the ones to use on the x and y
xstr = get(om, 'xVariable');
ystr = get(om, 'yVariable');
for i = 1:length(var)
    if strcmp(var(i).getname, xstr)
        x = var(i);
    elseif  strcmp(var(i).getname, ystr)
        y = var(i);
    else % if it is not to be used as either x or y, use the setpoint
        var(i).info = var(i).set('value', var(i).get('setpoint'));
        % I don't set this back again....
    end
end

mainvar = [x y];




xrev = x.eval;
yrev = y.eval;

% (3) set up comparison matrix
M = evalAveOtherVariables(eq.info,mainvar);


% (4) Compute approximation

[Xg,Yg] = ndgrid(xrev,yrev);

x.info = x.set('value',Xg(:));
y.info = y.set('value',Yg(:));

Xk = X.i_eval;
Yk = Y.i_eval;

% Problem here is that since the input to the tables could be subfeatures, the ranges in x and y may not translate to
% a 'nice' grid for our optimisation, for example if out x and y are both chosen to vary between 0 and 1, but the
% inputs to the table are x and x*y, then only the lower triangular region will be exercised. Thus we can't use previous
% splining techniques so instead we come from the approach of triangularisation. Xk  and Yk give us the coordinates of the
% points we're looking at in the x-y plane so we first form the delaunay triangularisation on these points...

TRI = delaunay(Xk,Yk);

% Next we get rid of any singular triangles, namely those that are straight lines.

TRI = tri_restrict(LT, Xk,Yk,TRI);

n = max(N1.get('values'))+1;
m = max(N2.get('values'))+1;

% (5) set up x-y grid
x.info = x.set('value',xrev);
y.info = y.set('value',yrev);

% (6) create virtual lookup table and construct optimisation parameters

BP1 = N1.get('breakpoints');
BP2 = N2.get('breakpoints');

BPI1 = linspace(BP1(1),BP1(end),50);
BPI2 = linspace(BP2(1),BP2(end),50);

% Now we want to create the analogy to the spline surface we use in the normal case.
% Here we use a lookup table we a much finer grain, it will have breakpoints BPI1 and BPI2, and values field VAL.
% tri_surf cooks up this matrix.

VAL = zeros(length(BPI2), length(BPI1));
for i = 1:length(BPI1)
    for j = 1:length(BPI2)
        VAL(j,i) = tri_surf(LT, Xk,Yk,M(:),TRI,BPI1(i),BPI2(j));
    end
end

if nargout>3
    varargout{1} = BPI1;
    varargout{2} = BPI2;
    varargout{3} = VAL;
end

Val = feval(linear2fH,BPI2,BPI1,VAL,BP2,BP1);

p = cglookuptwo('vp',Val,N1,N2);


% (8) OPTIMISE: Slightly different from the standard case, in that we don't do Jupp t-form here.
% probably could though.

BPLx = N1.get('bplocks'); % get locks
BPLy = N2.get('bplocks');

if flag == 1
    BPLx([1;end]) = 1; % set endpoints to locked if they are to be treated as fixed.
    BPLy([1;end]) = 1;
end

BPcx = BP1(BPLx==1); % get fixed values
BPcy = BP2(BPLy==1);

Z1 = BP1(BPLx == 0); % get moving values
Z2 = BP2(BPLy == 0);

Bex = BP1(end); % get end values
Bix = BP1(1);

Bey = BP2(end);
Biy = BP2(1);

Z1 = (Z1-Bix)/(Bex-Bix); % T'form everything to [0,1];
Z2 = (Z2-Biy)/(Bey-Biy);

Z = [Z1(:);Z2(:)]; % form vector to optimise
l1 = length(Z1);
l2 = length(Z2);

Vx = N1.get('values'); % get values fields
Vy = N2.get('values');

S = [m,n];

% now start optimisation

if flag == 2

    [Zout,R1,R2,exit] = lsqnonlin('ab_BValopt',Z,[],[],[],Vx,Vy,...
        p,Xk(:),Yk(:),S,M,l1,l2,BPI1,BPI2,VAL,BPcx,BPLx,BPcy,BPLy,Bex,Bix,Bey,Biy,linear1fH,linear2fH,extinterp2fH);
else
    L = [zeros(l1,1);zeros(l2,1)];
    U = [ones(l1,1);ones(l2,1)];

    [Zout,R1,R2,exit] = lsqnonlin(@i_cost,Z,L,U,[],Vx,Vy,...
        p,Xk(:),Yk(:),S,M,l1,l2,BPI1,BPI2,VAL,BPcx,BPLx,BPcy,BPLy,Bex,Bix,Bey,Biy,linear1fH,linear2fH,extinterp2fH);
end

% (9) Extract new breakpoint values and officially set them

BP1(BPLx==1) = BPcx;
BP2(BPLy==1) = BPcy;
BP1(BPLx==0) = Bix+(Bex-Bix)*(sort(Zout(1:l1)));
BP2(BPLy==0) = Biy+(Bey-Biy)*(sort(Zout(l1+1:l1+l2)));

% kill off any created tables

N1.info = N1.UpdateFlist(p,0);
N2.info = N2.UpdateFlist(p,0);

if infoflag == 1
    N1.info = N1.set('breakpoints',{BP1(:),'Optimized'});
    N2.info = N2.set('breakpoints',{BP2(:),'Optimized'});
else
    N1.info = N1.setBPunofficial(BP1(:));
    N2.info = N2.setBPunofficial(BP2(:));
end

% (10) free created pointers, reset values

freeptr(p);

resetVariables(LT, [otherVariables var],[saveothervar savetablevar]);
cost = Inf;
OK = 1;
msg = '';
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Zout = i_cost(Z,Vx,Vy,p,xin,yin,S,M,l1,l2,BX,BY,VAL,...
    BPcx,BPLx,BPcy,BPLy,Bex,Bix,Bey,Biy,linear1fH, linear2fH,extinterp2fH)

% OUT = AB_BPVALOPT((Z,Vx,Vy,X,Y,Xk,Yk,cs,S,M,Idx,Idy,VAL,ZLx,ZLy,Bex,Bix,Bey,Biy)
% Breakpoint optimisation function for two normalisers in the non invertable case
% to be used with lsqnonlin. Arguments are as follows:
%
%               Z - current transformed (to [0,1]) breakpoint values,
%               Vx - values field of x normaliser,
%               Vy - Ditto for y,
%               xin - values feeding into x normaliser,
%               yin - values feeding into y normaliser,
%               S - size of values matrix for the table,
%               M - cell of comparison matrices,
%               l1 - number of variable breakpoints in x normaliser,
%               l2 - number of variable breakpoints in y normaliser,
%               BX - x points linearly spaced across x BP range.
%               BY - y points linearly spaced across y BP range.
%               VAL - Approximation surface to model
%               BPcx - values of locked x BP's,
%               BPLx - pattern of locked x BP's,
%               BPcy - values of locked y BP's,
%               BPLy - pattern of locked x BP's,
%               Bex - value of x endpoint,
%               Bix - value of x starting point,
%               Bey - value of y endpoint,
%               Biy - value of y starting point,
%

% (1) Untangle inputs

BP1(BPLx==1) = BPcx; % untransform the breakpoints
BP2(BPLy==1) = BPcy;
BP1(BPLx==0) = Bix+(Bex-Bix)*(sort(Z(1:l1)));
BP2(BPLy==0) = Biy+(Bey-Biy)*(sort(Z(l1+1:l1+l2)));

% (2) Compute and set new values field for virtual table

m = S(1);
n = S(2);

BPI1 = feval(linear1fH,Vx,BP1,0:n-1); % find interpolated breakpoints
BPI2 = feval(linear1fH,Vy,BP2,0:m-1);

V = feval(linear2fH,BY,BX,VAL,BPI2,BPI1); % find values matrix that should accompany the new BP's

E = feval(extinterp2fH,BPI1,BPI2,V,xin,yin); % find approximation to model

opt = M(:)-E(:); % cost function

Zout = opt;
