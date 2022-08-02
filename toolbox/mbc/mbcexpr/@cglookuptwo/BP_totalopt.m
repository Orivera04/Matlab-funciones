function [LT, cost, OK, msg] = BP_totalopt(LT,om,sf)
%BP_TOTALOPT
%
% A routine to optimise both BP and VAlues fields. It 
% will 1) Fill out the Normalisers
%      2) Optimise over a rough grid (3 times # BP)
%      3) Choose values for the normalisers
%      4) Optimise over a finer mesh based on this new values pattern.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:11:16 $

% get the information from the optmgr
eq = get(sf,'model');

% are all the variables in the table also in the model 
[var , problemVar, otherVariables]= getvariables(LT,eq);

[saveothervar, OK, msg] = setVariables(LT, otherVariables,om);

if ~OK
   resetVariables(LT, otherVariables,saveothervar);
   cost = Inf;
   return
end

endpointflag = get(om, 'FixEndPoints');

N = [LT.Xexpr LT.Yexpr];
% 1. Fill the normalisers i.e. remove interpolated breakpoints

for i = 1:length(N)
   % info store the original locks and values
   info{i}.BPL = N(i).get('bplocks');
   info{i}.length = length(N(i).get('values'));
   if any(info{i}.BPL)
      OK = 0;
      msg = 'Cannot optimize the order of the breakpoints when locked breakpoints are present.';
      cost = Inf;
      return
   end
   Val = N(i).get('values');
   n = max(N(i).get('values'));
   BPnew = N(i).invert([0:n]');
   N(i).info = N(i).setBPunofficial(BPnew);
   N(i).info = N(i).setVunofficial([0:n]');
   N(i).info = N(i).set('bplocks',zeros(size(BPnew)));
end

abnormalflag = get(om, 'AbnormalFlag');
x = var(1);
y = var(2);

lx(1) = length(N(1).get('breakpoints'));
lx(2) = length(N(2).get('breakpoints'));


for i = 1:2
   range(i,1:2) = get(om, ['Set_' var(i).getname '.Range']);
   ngrid(i) =  get(om, ['Set_' var(i).getname '.NGridPts']);  
   if range(i,1) >= range(i,2)
      OK = 0;
      msg = ['Min_' var(i).getname ' must be strictly less than ' 'Max_' var(i).getname];
      cost = Inf;
      resetVariables(LT, otherVariables,saveothervar);
      return
   end   
end   

% change the grid size in the optmgr, and don't update the history in this
% intermediate step
for i = 1:2
   set(om, ['Set_' var(i).getname '.NGridPts'], 4*lx(i));
end   

om = set(om, 'UpdateBPHistory', 0);


if abnormalflag == 0
   % rough fit
   [LT,cost, OK, msg, cs,Xk,Yk,csVAL] = BP_opt(LT, om, sf);
   if ~OK
      resetVariables(LT, otherVariables,saveothervar);
      cost = Inf;
      return
   end
   stuff = i_spline_stuff(N,cs,Xk,Yk,csVAL,x,y,eq,range,ngrid(1),ngrid(2),info);
   om = set(om, 'UpdateBPHistory', 1);
   om = set(om, ['Set_' var(1).getname '.NGridPts'], ngrid(1));
   om = set(om, ['Set_' var(2).getname '.NGridPts'], ngrid(2));
   % more accurate fit
   [Z,cost,OK, msg] = BP_opt(LT, om,sf);  
   if ~OK
      resetVariables(LT, otherVariables,saveothervar);
      cost = Inf;
      return
   end
else
   % rough fit
   [Z,cost, OK, msg, BX,BY,VAL] = ab_BP_opt(LT, om, sf);
   stuff = i_ab_stuff(N,x,y,BX,BY,VAL,eq,range,ngrid(1),ngrid(2),info);
   om = set(om, 'UpdateBPHistory', 1);
   om = set(om, ['Set_' var(1).getname '.NGridPts'], ngrid(1));
   om = set(om, ['Set_' var(2).getname '.NGridPts'], ngrid(2));
   % more accurate fit
   [Z,cost, OK, msg] = ab_BP_opt(LT, om, sf);
   if ~OK
      resetVariables(LT, otherVariables,saveothervar);
      cost = Inf;
      return
   end
end


resetVariables(LT, otherVariables,saveothervar);
cost = Inf;
OK = 1;
msg = '';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_spline_stuff                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function out = i_spline_stuff(N,cs,Xk,Yk,V,x,y,eq,Range,ngridptsx,ngridptsy,info)


cgm = cgmathsobject;
h_bin_count = gethandle(cgm,'bin_count');
h_linear1 = gethandle(cgm, 'linear1');
h_valspline2 = gethandle(cgm, 'valspline2');
h_linear2 = gethandle(cgm, 'linear2');

% Set up the comparison stuff

out = [];

X = N(1).get('x');
Y = N(2).get('x');

xval = x.eval;
yval = y.eval;

xdata = linspace(Range(1,1),Range(1,2),ngridptsx);
ydata = linspace(Range(2,1),Range(2,2),ngridptsy);

x.info = x.set('value',xdata);
y.info = y.set('value',ydata);


% (3) set up comparison matrix
M = evalAveOtherVariables(eq.info,[x y]);


Rx = X.eval;

Cy = Y.eval;

% Get three best values fields

Store = [];

for i = 1:length(N);
   BP_full = N(i).get('breakpoints');
   nl = length(BP_full);
   k = info{i}.length;
   St = [];
   if i==1
      Vy = N(2).get('values');
      BP2 = N(2).get('breakpoints');
      m = max(Vy);
   else
      Vx = N(1).get('values');
      BP1 = N(1).get('breakpoints');
      n = max(Vx);
   end
   
   for j = 1:(prod(nl-k+1:nl-2)/prod(1:k-2));
      bc = feval(h_bin_count, j,nl-2,k-2);
      I = find(bc);
      new_val = [0;I;nl-1];
      new_BP = BP_full(new_val+1);
      
      if i ==1
         Vx = new_val;
         BP1 = new_BP;
         n = max(Vx);
      else
         Vy = new_val;
         BP2 = new_BP;
         m = max(Vy);
      end
      
      BPI1 = feval(h_linear1, Vx,BP1,0:n-1);
      BPI2 = feval(h_linear1, Vy,BP2,0:m-1);
            
      VAL = feval(h_valspline2, Xk,Yk,V,cs,BPI1(:),BPI2(:));
      
      % (3) cost function
      
      opt = [];
      E = feval(h_linear2, BPI1,BPI2,VAL,Rx,Cy);
      
      
      opt = M(:)-E(:);
     
      Q = trace(opt*opt');
      
      St(j) = Q;
   end
   [As,Is] = sort(St);
   
   if length(Is)>=3
      q{i} = Is(1:3);
   else 
      q{i} = Is;
   end
end

% Find best combination of the values fields
l1 = info{1}.length;
l2 = info{2}.length;
BP_full1 = N(1).get('breakpoints');
BP_full2 = N(2).get('breakpoints');
ngridptsx = length(BP_full1);
ngridptsy = length(BP_full2);

Fstore = [];

for i = 1:length(q{1});
   k1 = q{1}(i);
   bc1 = feval(h_bin_count, k1,ngridptsx-2,l1-2);
   I = find(bc1);
   Vx = [0;I;ngridptsx-1];
   BP1 = BP_full1(Vx+1);
     
   for j = 1:length(q{2});
      k2 = q{2}(j);
      bc2 = feval(h_bin_count, k2,ngridptsy-2,l2-2);
      I = find(bc2);
      Vy = [0;I;ngridptsy-1];
      BP2 = BP_full2(Vy+1);
      
      BPI1 = feval(h_linear1, Vx,BP1,0:n-1);
      BPI2 = feval(h_linear1, Vy,BP2,0:m-1);
            
      VAL = feval(h_valspline2, Xk,Yk,V,cs,BPI1(:),BPI2(:));
      
      % (3) cost function
      
      opt = [];
      E = feval(h_linear2, BPI1,BPI2,VAL,Rx,Cy);
      
      
      opt = M-E;
      
      
      Q = trace(opt'*opt);
      
      Fstore = [Fstore;Q];
   end
end

[m,K] = min(Fstore);

lgi = length(q{1});
lgj = length(q{2});

ix = floor((K-1)/lgj)+1;
jx = K-lgi*(ix-1);

bc1 = feval(h_bin_count, q{1}(ix),ngridptsx-2,l1-2);
I = find(bc1);
Vx = [0;I;ngridptsx-1];
BP1 = BP_full1(Vx+1);

N(1).info = N(1).setBPunofficial(BP1(:));
N(1).info = N(1).setVunofficial(Vx(:));
N(1).info = N(1).set('bplocks',zeros(size(BP1)));

bc2 = feval(h_bin_count, q{2}(jx),ngridptsy-2,l2-2);
I = find(bc2);
Vy = [0;I;ngridptsy-1];
BP2 = BP_full2(Vy+1);

N(2).info = N(2).setBPunofficial(BP2(:));
N(2).info = N(2).setVunofficial(Vy(:));
N(2).info = N(2).set('bplocks',zeros(size(BP2)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_ab_stuff                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function out = i_ab_stuff(N,x,y,BX,BY,VAL,eq,Range,ngridptsx,ngridptsy,info)

cgm = cgmathsobject;
h_bin_count = gethandle(cgm,'bin_count');
h_linear1 = gethandle(cgm, 'linear1');
h_linear2 = gethandle(cgm, 'linear2');
h_extinterp2 = gethandle(cgm, 'extinterp2');

% Set up the comparison stuff

out = [];

X = N(1).get('x');
Y = N(2).get('x');

xval = x.eval;
yval = y.eval;

xdata = linspace(Range(1,1),Range(1,2),ngridptsx);
ydata = linspace(Range(2,1),Range(2,2),ngridptsy);

[XD,YD] = ndgrid(xdata,ydata);

x.info = x.set('value',XD(:));
y.info = y.set('value',YD(:));

M = [];

% (3) set up comparison matrix

% evaluate the expression at the values set up
M = eq.i_eval;

% get the pointers to variables in the expression, don't put in duplicates
varExpr = eq.vectors;

dvarExpr = double(varExpr);
dvar = double([x y]);

if length(dvar) == 2
   % determine whether to transpose M or not. Depends on the order of the variables in the list
   [junk, xindex] = intersect(dvarExpr, dvar(1));
   [junk, yindex] = intersect(dvarExpr, dvar(2));

   % need to flip M if the variables in the lookup table appear in the same order as in the expression
   % tables seem to be funky, and the xvariable goes in the colums, the y-variables goes in the rows
   if yindex < xindex
      M = M';
   end
end



Rx = X.i_eval;

Cy = Y.i_eval;

% Get three best values fields

Store = [];

for i = 1:length(N);
   BP_full = N(i).get('breakpoints');
   nl = length(BP_full);
   k = info{i}.length;
   St = [];
   if i==1
      Vy = N(2).get('values');
      BP2 = N(2).get('breakpoints');
      m = max(Vy);
   else
      Vx = N(1).get('values');
      BP1 = N(1).get('breakpoints');
      n = max(Vx);
   end
   
   for j = 1:(prod(nl-k+1:nl-2)/prod(1:k-2));
      bc = feval(h_bin_count, j,nl-2,k-2);
      I = find(bc);
      new_val = [0;I;nl-1];
      new_BP = BP_full(new_val+1);
      
      if i ==1
         Vx = new_val;
         BP1 = new_BP;
         n = max(Vx);
      else
         Vy = new_val;
         BP2 = new_BP;
         m = max(Vy);
      end
      
      BPI1 = feval(h_linear1, Vx,BP1,0:n-1);
      BPI2 = feval(h_linear1, Vy,BP2,0:m-1);
            
      val = feval(h_linear2, BX,BY,VAL,BPI1(:),BPI2(:));
      
      % (3) cost function
      
      opt = [];
      E = feval(h_extinterp2, BPI2,BPI1,val,Rx,Cy);
      
      
     
      opt = (M(:)-E(:));
     
      
      Q = trace(opt'*opt);
      
      St(j) = Q;
   end
   [As,Is] = sort(St);
   
   if length(Is)>=3
      q{i} = Is(1:3);
   else 
      q{i} = Is;
   end
end

% Find best combination of the values fields
l1 = info{1}.length;
l2 = info{2}.length;
BP_full1 = N(1).get('breakpoints');
BP_full2 = N(2).get('breakpoints');
ngridptsx = length(BP_full1);
ngridptsy = length(BP_full2);

Fstore = [];

for i = length(q{1});
   k1 = q{1}(i);
   bc1 = feval(h_bin_count, k1,ngridptsx-2,l1-2);
   I = find(bc1);
   Vx = [0;I;ngridptsx-1];
   BP1 = BP_full1(Vx+1);
     
   for j = length(q{2});
      k2 = q{2}(j);
      bc2 = feval(h_bin_count, k2,ngridptsy-2,l2-2);
      I = find(bc2);
      Vy = [0;I;ngridptsy-1];
      BP2 = BP_full2(Vy+1);
      
      BPI1 = feval(h_linear1, Vx,BP1,0:n-1);
      BPI2 = feval(h_linear1, Vy,BP2,0:m-1);
            
      val = feval(h_linear2, BX,BY,VAL,BPI1(:),BPI2(:));
      
      % (3) cost function
      
      opt = [];
      E = feval(h_extinterp2, BPI1,BPI2,val,Rx,Cy);
      
      opt = M(:) - E(:);
      
      Q = trace(opt'*opt);
      
      Fstore = [Fstore;Q];
   end
end

lgi = length(q{1});
lgj = length(q{2});

[m,K] = min(Fstore);

ix = floor((K-1)/lgj)+1;
jx = K-lgi*(ix-1);

bc1 = feval(h_bin_count, q{1}(ix),ngridptsx-2,l1-2);
I = find(bc1);
Vx = [0;I;ngridptsx-1];
BP1 = BP_full1(Vx+1);

N(1).info = N(1).setBPunofficial(BP1(:));
N(1).info = N(1).setVunofficial(Vx(:));
N(1).info = N(1).set('bplocks',zeros(size(BP1)));

bc2 = feval(h_bin_count, q{2}(jx),ngridptsy-2,l2-2);
I = find(bc2);
Vy = [0;I;ngridptsy-1];
BP2 = BP_full2(Vy+1);

N(2).info = N(2).setBPunofficial(BP2(:));
N(2).info = N(2).setVunofficial(Vy(:));
N(2).info = N(2).set('bplocks',zeros(size(BP2)));
