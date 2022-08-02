function [LT,cost,OK, msg] = BPinit_curv(LT,om, sf)
%BPINIT_CURV

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.2 $  $Date: 2004/02/09 07:14:24 $

% LT = BPinit_curv(LT,om, sf)
% LT - cgnormfunction

% an adaptation of the old mfiles/BreakPointAnalysis/Initialisation/BP_initonecurv
% to be a method of a cgnormfunction
% see pg 46 of Carl de Boor's 'A Practical guide to splines',
% which gives a method of choosing knots for 1D linear splines 

Norm = LT.Xexpr;% get the normaliser
BPx = Norm.get('breakpoints');%get breakpoints
BPxval = Norm.get('values');
valx =[min(BPxval):max(BPxval)];
ngBPx = length(valx)-length(intersect(valx, BPxval));% number of green breakpoints in x

Xexpr = Norm.get('x');%pointer to x-coordinates of first normalizer

eq = get(sf, 'model');

% get pointers to the variables feeding into the LT
[var, problem, otherVariables] = getvariables(LT,eq);
x = var(1);

if length(var) > 1
   OK = 0;
   msg = 'There is more than one variable feeding into the normalizer.  Try optimizing instead. ';
   cost = Inf;
   return
end

xval = x.eval;%store the original values in 'x' and 'y' so we can reset at the end

saveothervar = setVariables(LT, otherVariables,om);

for i = 1:length(var)
   savetablevar{i} = var(i).eval;
   range(i,1:2) = get(om, ['Range_' var(i).getname]);
   if range(i,1) >=  range(i,2)
      OK = 0;
      msg = ['Range_' var(i).getname ' must be strictly increasing. '];
      cost = Inf;
      resetVariables(LT, [otherVariables var(1:i)],[saveothervar savetablevar]);
      return
   end   
end   


BPLx = Norm.get('bplocks');%BPL locked breakpoints
nx = length(BPLx);%number of red breakpoints in x

% if the locks are empty, assume there are no locks
if isempty(nx) 
   nx = length(BPx);
   BPLx = false(nx,0);
end



nBPx = nx + ngBPx;%total number of breakpoints
% set the values of the variables to be the endpoints of the range
x.info = x.set('value',range(1,:));

% get the end breakpoints 
Xk = Xexpr.eval; 

% set the end breakpoints  
if BPLx(1) >0 | BPLx(end) > 0  % if the end points are locked
   %leave the end breakpoints alone
else
   BPx(1) = min(Xk);
   BPx(nx) = max(Xk);
end   

lockindx = find(BPLx >0);
% lock the end breakpoints
lockindx = unique([1; lockindx; nx]);




% share the average curvature between the locked breakpoints
for  i = 1:length(lockindx) -1 
   % number of breakpoints between two adjacent locked ones
   nbetweenx = lockindx(i+1) - lockindx(i) - 1;
   if nbetweenx > 0 % if there is space between locked BPs
      % Set up grid of test knots, from which we will select a good choice of initial knots
      % test 10 x (the number of desired knots)  possible positions in both x and y 
      numxtestknots = 10*(nbetweenx+2); %10 times the number of bps between the locked ones
      
      xtestBP = linspace(BPx(lockindx(i)),BPx(lockindx(i+1)),numxtestknots); 
      % set the xexpr to equal xtestBP, by playing with the variable x
      [x, OK, msg] = setvalue(Xexpr.info,xtestBP,x);
      if ~OK
         OK = 0;
         msg = 'Problem inverting the normalizer';
         resetVariables(LT, [otherVariables var],[saveothervar savetablevar]);
         x.info = x.set('value',xval);
         y.info = y.set('value',yval);
         return
      end
       
      % we now take into account the value of eq, at a wider range of values of the other variables
      M = evalAveOtherVariables(eq.info,x);
      
      % check for infs and NaNs
      anynan = find(isnan(M));
      anyinfin = find(isinf(M));
      if ~isempty(anynan)
         cost = Inf;
         OK = 0;
         msg = 'Models returns NaN''s.';
         % reset values
         x.info = x.set('value',xval);
         resetVariables(LT, otherVariables,saveothervar); 
         return
      elseif ~isempty(anyinfin)
         cost = Inf;
         OK = 0;
         msg = 'Model gets infinite.';
         % reset values
         x.info = x.set('value',xval);
         resetVariables(LT, otherVariables,saveothervar);
         return
      end
       xcurvs = diff(M,2);
      
      %measure of the total curvature in x between the locked breakpoints
      totalxcurv= sum(sqrt(abs(xcurvs)))/(numxtestknots-3); %measure of the total curvature in x

      if totalxcurv == 0   
         % autospace instead
         % reset values
         x.info = x.set('value',xval);
         resetVariables(LT, otherVariables,saveothervar);
         [om, OK, msg] =bpinit(LT, BPx(1), BPx(end), valx(end), nBPx);
         if OK
            [om, cost, OK, msg] = run(om, LT, []);
         end 
         if ~OK
            return
         end
      end
      

      for j=1:numxtestknots-2
         xcurvsofar(j) = sum(sqrt(abs(xcurvs(1:j))))/(numxtestknots-3);
         % a measure of the model curvature from the first breakpoint to the ith breakpoint  
      end


      Xk = Xexpr.eval; 

      for j=1: nbetweenx
         %find at what x-value the xcurvsofar exceeds the fraction of the curvature 
         %that should have happened by the jth breakpoint   
        
         index =  min(find(xcurvsofar > ((BPxval(lockindx(i)+j)-BPxval(lockindx(i)))/(BPxval(lockindx(i+1))-BPxval(lockindx(i))))*totalxcurv));
         if ~isempty(index) 
            BPx(lockindx(i)+j) = Xk(index); %set this to be the new breakpoint 
         else
            BPx(lockindx(i)+j) = max(Xk);
         end   
      end   
  end
end

BPx = sort(BPx);

Norm.info = Norm.set('breakpoints',{BPx(:),'Filled - share ave curvature algorithm.'});

% reset values
x.info = x.set('value',xval);
resetVariables(LT, otherVariables,saveothervar);

cost = Inf;
OK =1;
msg = '';
