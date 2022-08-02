function [LT, cost, OK, msg, varargout] = BP_opt(LT,om, sf)
%BP_OPT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.2 $  $Date: 2004/02/09 07:13:38 $

% called by bpopt.
% If nargout>3, then varargout contains the spline data that we develop. 
%
%   The method proceeds as follows: firstly evaluate the model over the chosen grid and then use this grid and graph
% to generate a spline approximation to the graph. To determine whether the current choice of breakpoints is any 
% good we need to create a lookup table based on the new breakpoints that approximates the model. To do this evaluate 
% the spline at the new breakpoint positions and use the resulting matrix as the values matrix in the lookup table.
% The optimising function then evaluates the lookup table over the chosen grid and subtracts this from the model values
% at these values seeking to minimise the difference.

mod = get(sf, 'model');

% are all the variables in the table also in the equation? 
[var , problemVar, otherVariables]= getvariables(LT,mod);

[saveothervar, OK, msg] = setVariables(LT, otherVariables,om);

if ~OK
   if nargout > 3
      varargout{1} = [];
      varargout{2} = [];
      cost = Inf;
   end
   resetVariables(LT, otherVariables,saveothervar);
   return
end

% (1) initialise stuff
BP = LT.Breakpoints;   

Xexpr = LT.Xexpr;


endpointflag = get(om, 'FixEndPoints');
infoflag = get(om, 'UpdateBPHistory');


% (2) Determine values of x and y that correspond to the chosen grid
[savetablevar, OK, msg] = setVariables(LT, var,om);

if ~OK
   if nargout > 3
      varargout{1} = [];
      varargout{2} = [];
   end
   cost = Inf;
   resetVariables(LT, [otherVariables var],[saveothervar savetablevar]);
   return
end


abnormalflag = get(om, 'abnormalflag');
if abnormalflag 
   % get variables to use in the table if there was a choice
   xstr = get(om, 'xVariable');
   for i = 1:length(var)
      if strcmp(var(i).getname, xstr)
         xvar = var(i);
      else % if it is not to be used as x, use the set point 
         var(i).info = var(i).set('value', var(i).get('setpoint'));
         % I don't set this back again....
      end   
   end      
   mainvar = xvar;
else
   x = var(1);
   mainvar = x;
end   

% (3) sets up the comparison matrix

M = evalAveOtherVariables(mod.info,mainvar);

% (4) Compute approximation spline

Xk = Xexpr.eval; % values being fed into normaliser

if nargout > 3
   varargout{1} = M(:);
   varargout{2} = Xk;
end

n = max(LT.Values)+1;


BPI1 = invert(LT, [0:n-1]'); % find interpolated BP's

VAL = eval(cgmathsobject,'linear1',Xk,M(:),BPI1);

E = eval(cgmathsobject,'linear1',BPI1,VAL,Xk); % Approximation to the model based on these BP's

Z1 = BP;

S = size(VAL);

opt = [];

opt = M(:)-E(:); % starting error


Vx = LT.Values; % Values array of normaliser

Rx = Xexpr.eval; % X inputs to normaliser

BPLx = LT.BPLocks; % locked breakpoints

if endpointflag == 1
   BPLx([1;end]) = 1; % Lock endpoints if needed
end

BPcx = BP(BPLx==1); % values of locked breakpoints

Z = BP(BPLx == 0); % values of variables breakpoints

Bex = BP(end); % largest breakpoint
Bix = BP(1); % minimum BP

Zt1 = (BP-Bix)/(Bex-Bix); % Transform BP's to [0,1]

indx = [1:length(Zt1)]'; 

Z1 = Zt1(BPLx == 0); % transformed values of variable BP's

Z1L = Zt1(BPLx == 1); % transformed values of locked BP's

Idx = indx(BPLx == 1);% index of locked BP's

if BPLx(1)==0 % if bottom is not locked, then add it to the locked transformed BP's
   Z1L = [Zt1(1);Z1L];
   Idx = [0;Idx];
end
if BPLx(end) == 0 % ditto top
   Z1L = [Z1L;Zt1(end)];
   Idx = [Idx;length(Zt1)];
end

if BPLx(1)==0 % if bottom is not locked, then add it to the locked transformed BP's
   Z1L = [Zt1(end);Z1L];
   Idx = [1;Idx];
end
if BPLx(end) == 0 % ditto top
   Z1L = [Z1L;Zt1(end)];
   Idx = [Idx;length(Zt1)];
end

Zjx = []; 

for i = 2:length(Z1L)
   if Idx(i-1)+1<=Idx(i)-1
      Zjx = [Zjx;eval(cgmathsobject,'jupp',Zt1(Idx(i-1)+1:Idx(i)-1),Z1L(i-1),Z1L(i))]; % perform Jupp t'form on BP values 
                                                                  % between sucessive locked BP's
   end
end

l1 = length(Zjx); % length of Zjx, our completely t'formed bp-values which we will commence to optimise

wn=warning;
warning off;


linear1fH = gethandle(cgmathsobject,'linear1');
invjuppfH = gethandle(cgmathsobject,'invjupp');
juppfilterfH = gethandle(cgmathsobject,'juppfilter');

L = sqrt(eps)*ones(length(Z),1);
[Zout,R1,R2,exit] = lsqnonlin(@i_cost,Zjx,L,[],[],Vx,Rx,...
      M(:),Xk,S,M(:),Idx,Z1L,Bex,Bix,linear1fH,invjuppfH,juppfilterfH);

warning(wn);

Znx = Z1L(1); 
count = 0;

for i = 2:length(Idx)
   ztemp = [];
   if Idx(i-1)+1<=Idx(i)-1
      ztemp = feval(invjuppfH,Zout(count+1:count+Idx(i)-Idx(i-1)-1),Z1L(i-1),Z1L(i)); % undo Jupp process
      count = count+Idx(i)-Idx(i-1)-1;
   end
   Znx = [Znx;ztemp;Z1L(i)];
end

BP = Bix+(Bex-Bix)*(Znx); % transform back to physical range

% clean up 

if infoflag == 1
   LT = set(LT,'breakpoints',{BP(:),'Optimized'});
else
   LT = setBPunofficial(LT, BP(:));
end

resetVariables(LT, [otherVariables var],[saveothervar savetablevar]);
cost = Inf;
OK = 1;
msg = '';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cost function
function Zout = i_cost(Z,Vx,Rx,V,Xk,S,M,Idx,ZLx,Bex,Bix,linear1fH,invjuppfH,juppfilterfH)

%adapted from mfiles/BreakpointAnalysis/Optimisation/BPValopt1 
% OUT = BPVALOPT1(Z,Vx,RX,XkS,M,Idx,ct,BPcx,ZLxBex,Bix)
% Breakpoint optimisation function for one normaliser to be used with lsqnonlin. Arguments are as follows:
%
%               Z - current Jupped breakpoint values,
%               Vx - values field of x normaliser,
%               Rx - X values being used in optimisation,
%               V - 
%               Xk - 
%               S - size of values matrix for the table,
%               M - cell of comparison matrices,
%               Idx - Indices of locked x breakpoints,
%               ZLx - Scaled value of locked x breakpoints,
%               Bex - value of x endpoint,
%               Bix - value of x starting point,
%

% Undo Jupp transform

Znx = ZLx(1);
count = 0;
penx = 1;

for i = 2:length(Idx)
   ztemp = [];
   if Idx(i-1)+1<=Idx(i)-1
      ztemp = feval(invjuppfH,Z(count+1:count+Idx(i)-Idx(i-1)-1),ZLx(i-1),ZLx(i));
      count = count+Idx(i)-Idx(i-1)-1;
   end
   Znx = [Znx;ztemp;ZLx(i)];
end
count = 0;
BP1 = Bix+(Bex-Bix)*(Znx); % undo t'form to [0,1]

% Problem we now face is that although what follows is designed to prevent coalescing BP's, the user 
% may have forced and locked some BP's to be repeated, in which case the following lines computing penx and peny 
% will be a source of eternal infinities the like of which will confuse and confound our poor optimiser and lead to 
% an ever present hour glass marking time until a reboot. So to prevent this undesirable state of affairs and return
% things to arrowlike sanity we will attempt to strip out the naughty BP's before computing penx and peny. Why not smack
% it with a unique and be done you say, it is left as an exercise to the reader to work out why this frankly stinks - but 
% as a hint, what if the optimiser puts one BP on top of another, a unique would not allow us to penalise this.

if Idx(1) == 0
    Idx(1) = [];
    Idx(end) = [];
    Znx = feval(juppfilterfH,Znx,Idx);
    penx = penx*(1-0.1*sum(log((length(Znx)+1)/2*diff([-1;Znx;2]))));
else
    Znx = feval(juppfilterfH,Znx,Idx);
    penx = penx*(1-0.1*sum(log((Idx(end)+1)/2*diff([-1;Znx;2]))));
end

n = max(Vx); 
BPI1 = feval(linear1fH,Vx,BP1,[0:n]); % find interpolated BP's
VAL = feval(linear1fH,Xk,V,BPI1); % get values field corrsponding to these new BP's

opt = [];

E = feval(linear1fH,BPI1,VAL,Rx); % approximation to model based on these new BP's


opt = M-E(:); % error estimate


Zout = opt*penx;

return
