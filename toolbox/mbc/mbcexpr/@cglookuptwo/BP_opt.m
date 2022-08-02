function [LT, cost, OK, msg, varargout] = BP_opt(LT,om, sf)
%BP_OPT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.3 $  $Date: 2004/02/09 07:11:15 $

%  Called by bpopt. 
%   The method proceeds as follows: firstly evaluate the model over the chosen grid and then use this grid and surface
% to generate a spline approximation to the surface. To determine whether the current choice of breakpoints is any 
% good we need to create a lookup table based on the new breakpoints that approximates the model. To do this evaluate 
% the spline at the new breakpoint positions and use the resulting matrix as the values matrix in the lookup table.
% The optimising function then evaluates the lookup table over the chosen grid and subtracts this from the model values
% at these values seeking to minimise the difference.
%

cgm = cgmathsobject; % Create a cgmathsobject for use in calling the mathematical functions we'll need
juppfH = gethandle(cgm,'jupp'); % Get handle to Jupp function
invjuppfH = gethandle(cgm,'invjupp'); % Get handle to invJupp function
linear1fH = gethandle(cgm,'linear1');
linear2fH = gethandle(cgm,'linear2');
valspline2fH = gethandle(cgm,'valspline2');
makspline2fH = gethandle(cgm,'makspline2');
juppfilterfH = gethandle(cgm,'juppfilter');

endpointflag = get(om, 'FixEndPoints');
infoflag = get(om, 'UpdateBPHistory');

% (1) Initialise
N1 = LT.Xexpr;
N2 = LT.Yexpr;


% (2) Determine values of x and y that correspond to the chosen grid

X = N1.get('x');
Y = N2.get('x');

eq =get(sf, 'model');
% are all the variables in the table also in the equation? 
[var , problemVar, otherVariables]= getvariables(LT,eq);

[saveothervar, OK, msg] = setVariables(LT, otherVariables,om);

if ~OK
   resetVariables(LT, otherVariables,saveothervar);
   return
end
   
[savetablevar, OK, msg] = setVariables(LT, var,om);

if ~OK
   resetVariables(LT, [otherVariables var],[saveothervar savetablevar]);
   return
end


% (3) set up comparison matrix
Xk = X.eval;
Yk = Y.eval;

    
M = evalAveOtherVariables(eq.info,var);  
cs = feval(makspline2fH,Xk,Yk,M);

% cs is now a cell containing spline data
% M is a cell each entry of which gives us a comparison matrix for the
% optimisation.


% If we have a varargout, then we're exporting the spline info as well

if nargout>3
    varargout{1} = cs;
    varargout{2} = Xk;
    varargout{3} = Yk;
    varargout{4} = M;
end

anynan = find(isnan(M));
anyinfin = find(isinf(M));
if ~isempty(anynan)
    OK = 0;
    msg = 'NaN encountered';
    cost = Inf;
    resetVariables(LT, [otherVariables var],[saveothervar savetablevar]);
    return;
elseif ~isempty(anyinfin)
     OK = 0;
     msg = 'Inf encountered';
     cost = Inf;
     resetVariables(LT, [otherVariables var],[saveothervar savetablevar]);
     return
end

% (4) Compute approximation spline

n = max(N1.get('values'))+1;
m = max(N2.get('values'))+1;

% (5) set up x-y grid

% (6) create virtual lookup table and construct optimisation parameters
% this step is mainly to compute the starting error.
BP1 = N1.get('breakpoints');
BP2 = N2.get('breakpoints');


BPI1 = N1.invert((0:n-1)');
BPI2 = N2.invert((0:m-1)');

VAL = feval(valspline2fH,Xk,Yk,M,cs,BPI1,BPI2);
p = cglookuptwo('VirtualTable',VAL',N1,N2);


% (7) OPTIMISE: now the fun really starts. One of the problems that we face is that the breakpoints have to be increasing
% and we need a nice way to enforce this. The way we've chosen is to use the JUPP transformation a la Mapview knot 
% optimisation.

Bex = BP1(end);
Bix = BP1(1); % Top and bottom x breakpoints.

Bey = BP2(end);
Biy = BP2(1); % Top and Bottom y breakpoints

Vx = N1.get('values'); % values field of N1.
Vy = N2.get('values'); % values field of N2.

BPLx = N1.get('bplocks'); % Locked x breakpoints
BPLy = N2.get('bplocks');

% If all the BP's are locked we get an error later in lsqnonlin
% Return now with a message 
if (all(BPLx) && all(BPLy) )
    OK = 0;
    msg = 'All the breakpoints are locked';
    cost = Inf;
    resetVariables(LT, [otherVariables var],[saveothervar savetablevar]);
    return
end

if endpointflag == 1
    BPLx([1;end]) = 1; % if we are doing fixed endpoints then lock them.
    BPLy([1;end]) = 1;
end

Zt1 = (BP1-Bix)/(Bex-Bix); % Transform everything to [0,1]
Zt2 = (BP2-Biy)/(Bey-Biy);

indx = (1:length(Zt1))'; % index vector
indy = (1:length(Zt2))';

Z1L = Zt1(BPLx == 1); % T'formed values of locked BP's
Z2L = Zt2(BPLy == 1);

Idx = indx(BPLx == 1); %indices of locked BP's
Idy = indy(BPLy == 1);

if BPLx(1)==0
    Z1L = [2*Zt1(1)-Zt1(end);Z1L]; % if we're varying the endpoints, we need to set up 'anchors' for the Jupp process
                                   % that need to be well outside the region of interest.
    Idx = [0;Idx];
end
if BPLx(end) == 0
    Z1L = [Z1L;2*Zt1(end)-Zt1(1)];
    Idx = [Idx;length(Zt1)+1];
end

Zjx = [];

for i = 2:length(Z1L) % now 'juppise' all the breakpoints between successive locked breakpoints.
    if Idx(i-1)+1<=Idx(i)-1
        Zjx = [Zjx;feval(juppfH,Zt1(Idx(i-1)+1:Idx(i)-1),Z1L(i-1),Z1L(i))];
    end
end

if BPLy(1)==0
    Z2L = [2*Zt2(1)-Zt2(end);Z2L];
    Idy = [0;Idy];
end
if BPLy(end) == 0
    Z2L = [Z2L;2*Zt2(end)-Zt2(1)];
    Idy = [Idy;length(Zt2)+1];
end

Zjy = [];

for i = 2:length(Z2L)
    if Idy(i-1)+1<=Idy(i)-1
        Zjy = [Zjy;feval(juppfH,Zt2(Idy(i-1)+1:Idy(i)-1),Z2L(i-1),Z2L(i))];
    end
end

S = [m n];

Z = [Zjx(:);Zjy(:)];

wn=warning;
warning off;

% Launch optimisation

if endpointflag == 0 
    Zout = lsqnonlin(@i_cost,Z,[],[],[],Vx,Vy,...
        Xk,Yk,cs,S,M,Idx,Idy,Z1L,Z2L,Bex,Bix,Bey,Biy,...
        invjuppfH,linear1fH,linear2fH,valspline2fH,juppfilterfH);
else
    L = repmat(sqrt(eps) , size(Z) );
    Zout = lsqnonlin(@i_cost,Z(:),L,[],[],Vx,Vy,...
        Xk,Yk,cs,S,M,Idx,Idy,Z1L,Z2L,Bex,Bix,Bey,Biy,...
        invjuppfH,linear1fH,linear2fH,valspline2fH,juppfilterfH);
end

warning(wn);

% (8) Extract new breakpoint values and officially set them

% invert Jupp process
l1 = Idx(end)-length(Idx);
l2 = Idy(end)-length(Idy);

if Idx(1) == 0
    Znx = [];
    Zny = [];
    l1 = l1+1;
    l2 = l2+1;
else
    Znx = Z1L(1);
    Zny = Z2L(1);
end
count = 0;

Zx = Zout(1:l1);
Zy = Zout(l1+1:l1+l2);

for i = 2:length(Idx)
    ztemp = [];
    if Idx(i-1)+1<=Idx(i)-1
        ztemp = feval(invjuppfH,Zx(count+1:count+Idx(i)-Idx(i-1)-1),Z1L(i-1),Z1L(i));
        count = count+Idx(i)-Idx(i-1)-1;
    end
    
    Znx = [Znx;ztemp(:);Z1L(i)];
end

count = 0;

for i = 2:length(Idy)
    ztemp = [];
    if Idy(i-1)+1<=Idy(i)-1
        ztemp = feval(invjuppfH,Zy(count+1:count+Idy(i)-Idy(i-1)-1),Z2L(i-1),Z2L(i));
        count = count+Idy(i)-Idy(i-1)-1;
    end
    
    Zny = [Zny;ztemp(:);Z2L(i)];
end

if Idx(1)==0
    Znx = Znx(1:end-1);
    Zny = Zny(1:end-1);
end
% Transform back to the range of BP's we expect in the table

BP1 = Bix+(Bex-Bix)*(Znx);
BP2 = Biy+(Bey-Biy)*(Zny);


%  Remove created lookuptwos from normaliser flists.
N1.info = N1.UpdateFlist(p,0);
N2.info = N2.UpdateFlist(p,0);

% Set the normaliser breakpoints.
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cost function 
function Zout = i_cost(Z,Vx,Vy,X,Y,cs,S,M,Idx,Idy,...
   ZLx,ZLy,Bex,Bix,Bey,Biy,invjuppfH,linear1fH,linear2fH,valspline2fH,juppfilterfH)

% OUT = BPVALOPT((Z,Vx,Vy,X,Y,Xk,Yk,cs,S,M,W,Idx,Idy,VAL,ZLx,ZLy,Bex,Bix,Bey,Biy)
% Breakpoint optimisation function for two normalisers to be used with lsqnonlin. Arguments are as follows:
%
%               Z - current Jupped breakpoint values,
%               Vx - values field of x normaliser,
%               Vy - Ditto for y,
%               X - X values being used in optimisation,
%               Y - Y values being used in optimisation,
%               cs - spline data,
%               S - size of values matrix for the table,
%               M - cell of comparison matrices,
%               Idx - Indices of locked x breakpoints,
%               Idy - Indices of locked y breakpoints,
%               ZLx - Scaled value of locked x breakpoints,
%               ZLy - Scaled value of locked y breakpoints,
%               Bex - value of x endpoint,
%               Bix - value of x starting point,
%               Bey - value of y endpoint,
%               Biy - value of y starting point,
%

% (1) Untangle inputs

l1 = Idx(end)-length(Idx); % Number of variable breakpoints for x normaliser
l2 = Idy(end)-length(Idy); % ditto for y

if Idx(1)==0 % if endpoints are not locked, set Znx to empty and plan for another moving BP. 
   Znx = []; 
   l1 = l1+1; 
   l2 = l2+1; 
   Zny = []; 
else % Otherwise set Znx to be the first breakpoint
   Znx = ZLx(1);
   Zny = ZLy(1);
end
count = 0;
penx = 1;
peny = 1;

Zx = Z(1:l1); % elements of Z that relate to x normaliser
Zy = Z(l1+1:l1+l2); % Ditto for y.

for i = 2:length(Idx) % run through locked BP's. insert the relevant elements of Z between them
                      % inverting the Jupp process whilst doing so.  
   ztemp = [];
   if Idx(i-1)+1<=Idx(i)-1
      ztemp = feval(invjuppfH,Zx(count+1:count+Idx(i)-Idx(i-1)-1),ZLx(i-1),ZLx(i));
      count = count+Idx(i)-Idx(i-1)-1;
   end
   Znx = [Znx;ztemp;ZLx(i)];
end
count = 0;

for i = 2:length(Idy) % do same for y normaliser
   ztemp = [];
   if Idy(i-1)+1<=Idy(i)-1
      ztemp = feval(invjuppfH,Zy(count+1:count+Idy(i)-Idy(i-1)-1),ZLy(i-1),ZLy(i));
      count = count+Idy(i)-Idy(i-1)-1;
   end
   Zny = [Zny;ztemp;ZLy(i)];
end
if Idx(1)==0
   Znx = Znx(1:end-1);
   Zny = Zny(1:end-1);
end

BP1 = Bix+(Bex-Bix)*(Znx); % transform Z values form [0,1] back to BP range.
BP2 = Biy+(Bey-Biy)*(Zny);

% Problem we now face is that although what follows is designed to prevent coalescing BP's, the user 
% may have forced and locked some BP's to be repeated, in which case the following lines computing penx and peny 
% will be a source of eternal infinities the like of which will confuse and confound our poor optimiser and lead to 
% an ever present hour glass marking time until a reboot. So to prevent this undesirable state of affairs and return
% things to arrowlike sanity we will attempt to strip out the naughty BP's before computing penx and peny. Why not smack
% it with a unique and be done you say, it is left as an exercise to the reader to work out why this frankly stinks - but 
% as a hint, what if the optimiser puts one BP on top of another, a unique would not allow us to penalise this.

if Idx(1) == 0
    Idx(1) = [];    Idy(1) = [];
    Idx(end) = [];  Idy(end) = [];
    Znx = feval(juppfilterfH,Znx,Idx);
    Zny = feval(juppfilterfH,Zny,Idy);
    penx = penx*(1-.1*sum(log((length(Znx)+1)/2*diff([-1;Znx;2])))); % create penalty function for coalescing x BP's
    peny = peny*(1-.1*sum(log((length(Zny)+1)/2*diff([-1;Zny;2])))); % create penalty function for coalescing y BP's
else
    Znx = feval(juppfilterfH,Znx,Idx);
    Zny = feval(juppfilterfH,Zny,Idy);
    penx = penx*(1-.1*sum(log((Idx(end)+1)/2*diff([-1;Znx;2])))); % create penalty function for coalescing x BP's
    peny = peny*(1-.1*sum(log((Idy(end)+1)/2*diff([-1;Zny;2])))); % create penalty function for coalescing y BP's
end


% (2) Compute and set new values field for virtual table
 
m = S(1);
n = S(2);
BPI1 = feval(linear1fH,Vx,BP1,0:n-1); % find the interpolated BP values.
BPI2 = feval(linear1fH,Vy,BP2,0:m-1);

VAL = feval(valspline2fH,X,Y,M,cs,BPI1(:),BPI2(:)); % Find the values matrix to use with the new BP's
E = feval(linear2fH,BPI1,BPI2,VAL,X,Y); % evaluate the new lookuptable over the grid, E is our estimate
                                          % to the model

% (3) cost function

opt = M-E; % Like the man says, our cost function


Zout = opt*penx*peny; % incorporate the penalty functions

 




