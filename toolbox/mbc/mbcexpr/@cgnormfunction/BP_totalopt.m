function [LT, cost, OK, msg,varargout] = BP_totalopt(LT,om, sf)
%BP_TOTALOPT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:14:23 $

% A routine to optimise both BP and VAlues fields. It 
% will 1) Fill out the Normalisers
%      2) Optimise over a rough grid (3 times # BP)
%      3) Choose values
%      4) Optimise over a finer mesh based on this new values pattern.


% get the information from the optmgr
endpointflag = get(om, 'FixEndPoints');

N = LT.Xexpr;

% 1. Fill the normalisers

info.BPL = N.get('bplocks');
info.length = length(N.get('values'));
if any(info.BPL)
   OK = 0;
   msg = 'Cannot optimize the order of the breakpoints when locked breakpoints are present.';
   cost = Inf;
   if nargout >3
      varargout{1} = [];
      varargout{2} = [];
   end
   return
end
Val = N.get('values');
n = max(N.get('values'));
BPnew = N.invert([0:n]');
N.info = N.setBPunofficial(BPnew);
N.info = N.setVunofficial([0:n]');
N.info = N.set('bplocks',zeros(size(BPnew)));

eq =get(sf, 'equation');
% are all the variables in the table also in the equation? 
[var , problemVar, otherVariables]= getvariables(LT,eq);

saveval = setVariables(LT, otherVariables,om);

x = var(1);

lx = length(N.get('breakpoints'));

for i = 1
   range(i,1:2) = get(om, ['Set_' var(i).getname '.Range']);
   ngrid(i) =  get(om, ['Set_' var(i).getname '.NGridPts']);  
   if range(i,1) >= range(i,2)
      OK = 0;
      msg = ['Min_' var(i).getname ' must be strictly less than ' 'Max_' var(i).getname];
      cost = Inf;
      resetVariables(LT, otherVariables,saveothervar);
      if nargout >3
         varargout{1} = [];
         varargout{2} = [];
      end   
      return
   end   
end   

% change the grid size in the optmgr, and don't update the history in this
% intermediate step
for i = 1:length(var)
   set(om, ['Set_' var(i).getname '.NGridPts'], 4*lx(i));
end   


om = set(om, 'UpdateBPHistory', 0);

[LT,cost, OK, msg, V,Xk] = BP_opt(LT, om, sf);

if ~isequal(OK, 1)
   return
end   
stuff = i_spline_stuff(N,V,Xk,var,eq,range,ngrid(1),info);

om = set(om, ['Set_' var(1).getname '.NGridPts'], ngrid(1));
om = set(om, 'UpdateBPHistory', 1);

[LT,cost, OK, msg] = BP_opt(LT, om, sf);

if nargout >3
   varargout{1} = V;
   varargout{2} = Xk;
end   

   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_spline_stuff                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function out = i_spline_stuff(N,V,Xk,x,eq,Range,ngridptsx,info)

% Set up the comparison stuff

cgm = cgmathsobject; % Set up cgmathsobject to allow us to access it's private library

out = [];

X = N.get('x');

xval = x.eval;

xdata = linspace(Range(1,1),Range(1,2),ngridptsx);

x.info = x.set('value',xdata);

xrev = x.eval;


% (3) set up comparison matrix
M = evalAveOtherVariables(eq.info,x);


Rx = X.eval;

% Get the best value field

Store = [];

BP_full = N.get('breakpoints');
nl = length(BP_full);
k = info.length;
St = [];

for j = 1:(prod(nl-k+1:nl-2)/prod(1:k-2));
   bc = eval(cgm,'bin_count',j,nl-2,k-2);
   I = find(bc);
   new_val = [0;I;nl-1];
   new_BP = BP_full(new_val+1);
   
   Vx = new_val;
   BP1 = new_BP;
   n = max(Vx);
  
   BPI1 = eval(cgm,'linear1',Vx,BP1,0:n-1);

   VAL = eval(cgm,'linear1',Xk,V,BPI1(:));
   
   % (3) cost function
   
   opt = [];
   E = eval(cgm,'linear1',BPI1,VAL,Rx);
   
   
   opt = M(:)-E(:);

   Q = sum(opt.*opt);
   
   St(j) = Q;
  
end
[As,Is] = sort(St(:));

q = Is(1);

% Find best combination of the values fields

l1 = info.length;

BP_full1 = N.get('breakpoints');
ngridptsx = length(BP_full1);

bc1 = eval(cgm,'bin_count',q,ngridptsx-2,l1-2);
I = find(bc1);
Vx = [0;I;ngridptsx-1];
BP1 = BP_full1(Vx+1);

N(1).info = N(1).setBPunofficial(BP1(:));
N(1).info = N(1).setVunofficial(Vx(:));
N(1).info = N(1).set('bplocks',zeros(size(BP1)));

