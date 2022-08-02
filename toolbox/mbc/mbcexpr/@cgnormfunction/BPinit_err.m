function [LT, cost, OK, msg] = BPinit_err(LT,om, sf)
%BPINIT_ERR

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:14:25 $

% LT = BPinit_err(LT,om, sf)
% LT - cgnormfunction
% x - pointer to variable feeding into the normalizer
% sf - pointer to subfeature
% range - range of the variable pointed to by x

% an adaptation of the old mfiles/BreakPointAnalysis/Initialisation/BP_initoneerr
% to be a method of a cgnormfunction

Norm = LT.Xexpr;

oldBPx = Norm.get('breakpoints');%get breakpoints
BPxval = Norm.get('values');
valx =[min(BPxval):max(BPxval)];
ngBP = length(valx)-length(intersect(valx, BPxval));% number of green breakpoints in x   
X = Norm.get('x');%pointer to x-coordinates of first normalizer

eq = get(sf, 'model');

% get pointers to the variables feeding into the LT
[var, problem, otherVariables] = getvariables(LT,eq);
x = var(1);

if length(var) > 1
   OK = 0;
   msg = 'There is more than one variable feeding into the normalizer. Try optimizing instead. ';
   cost = Inf;
   return
end


xval = x.eval;%store the original values in 'x' and 'y' so we can reset at the end

saveothervar = setVariables(LT, otherVariables,om);

cgm = cgmathsobject;
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

BPL = Norm.get('bplocks');%BPL locked breakpoints
nx = length(BPL);%number of red breakpoints

% if the locks are empty, assume there are no locks
if isempty(nx) 
   nx = length(BPx);
end

nBP = nx + ngBP;%total number of breakpoints

   
x.info = x.set('value',range(1,:));% set the 'value' in x to be the range

% evaluate the expression (nd grid) and average the results over the other variable ranges
M = evalAveOtherVariables(eq.info,x);
    
Xk = X.eval; 
Xk = Xk(:); % get the input vectors for the normalizers
      

% check for infs and NaNs
anynan = find(isnan(M));
anyinfin = find(isinf(M));
if ~isempty(anynan)
    cost = Inf;
    OK = 0;
    msg = 'Model returns NaN''s. ';
    %reset
    x.info = x.set('value',xval);
    resetVariables(LT, otherVariables,saveothervar); 
    return
elseif ~isempty(anyinfin)
    cost = Inf;
    OK = 0;
    msg = 'Model gets infinite. ';
    %reset
    x.info = x.set('value',xval);
    resetVariables(LT, otherVariables,saveothervar); 
    return
end

% set the end breakpoints  
if BPL(1) >0 | BPL(end) > 0  % if the end points are locked
   %leave the end breakpoints alone
else
   oldBPx(1) = min(Xk);
   oldBPx(nx) = max(Xk);
end   


% lock the end breakpoints
lockindx = find(BPL >0);
lockindx = unique([1; lockindx; nx]);

% start with the breakpoints being all the locked ones
BPx = oldBPx(lockindx);
BPI = oldBPx(1);
for i = 1:length(lockindx)-1
   % number of red breakpoints between locked breakpoints
   nrbetween = lockindx(i+1) - lockindx(i) - 1;
   % number of red + green between locked breakpoints
   nrgbetween = BPxval(lockindx(i+1)) - BPxval(lockindx(i)) - 1;
   % number of green between locked breakpoints
   ngbetween = nrgbetween - nrbetween;
   newBPI = linspace(oldBPx(lockindx(i)),oldBPx(lockindx(i+1)),2+ngbetween)';
   BPI = [BPI; newBPI(2:end)]; %equally space the green breakpoints
   
   
   % current total number of breakpoints between the locked bps
   numbp = 2 + ngbetween; 

   while (numbp < 2+ nrgbetween)
      numxtestknots = 10*(nrgbetween+2); %10 times the number of bps between the locked ones
      
      
      xtestBP = linspace(oldBPx(lockindx(i)),oldBPx(lockindx(i+1)),numxtestknots); 
      % set the xexpr to equal xtestBP, by playing with the variable x
      [x, OK, msg] = setvalue(X.info,xtestBP,x);
      if ~OK
         OK = 0;
         msg = 'Problem inverting the normalizer';
         resetVariables(LT, otherVariables,saveothervar);
         x.info = x.set('value',xval);
         return
      end
      
      
      % we now take into account the value of eq, at a wider range of values of the other variables
      M = evalAveOtherVariables(eq.info,x);
      
      Xk = X.eval; 
      VAL = eval(cgm, 'linear1',Xk,M,BPI);%finds the values at BPI of the linear spline that has values V at
   	
      % the knots Xk 
      % find the value of the  table interpolant at the grid of test knots 
      tabinterp = eval(cgm, 'linear1',BPI,VAL,Xk(:));
        
      err = (M(:)-tabinterp(:));%compute the error at the grid of test knots
      
      if all(abs(err) < eps)
         %reset
         x.info = x.set('value',xval);
         resetVariables(LT, otherVariables,saveothervar);
         % autospace instead
         [om, OK, msg] =bpinit(LT, oldBPx(1), oldBPx(end), valx(end), nBP);
         if OK
            [om, cost, OK, msg] = run(om, LT, []);
         end   
         if ~OK
            return
         end
      end   
      
      [errmax,rindex] = max(abs(err));%find the  maximum error and the row number 		
      %where the max error occurs
      
      newxknot = Xk(rindex);% candidate new knot, where max error occurs
      
      %find where the new breakpoint slots in 
      redindex1  = min(find(BPx > newxknot)) - 1;
      redindex2 = min(find(BPx>newxknot));
      greenindex1 = find(BPI == BPx(redindex1)); 
      greenindex2 = min(find(BPI > newxknot)) -1;
      greenindex3 = find(BPI == BPx(redindex2));
      
      %respace the green knots   
      tmp = linspace(BPx(redindex1),newxknot,abs(greenindex2-greenindex1)+2)';
      tmp2 = linspace(newxknot,BPx(redindex2), abs(greenindex3 - greenindex2) +1)';
      BPI = [BPI(1:(greenindex1-1)); tmp;tmp2(2:end-1);BPI(greenindex3: end)];  
      
      %add the new breakpoint
      BPx = [BPx;newxknot];
      BPx = sort(BPx);% place in ascending order   
      BPI = sort(BPI);
      
      numbp = numbp + 1;        
   end

end   
if ngBP >0
	% if there were green lines, then the distribution of green
	% and red lines may have changed, so adjust the values of the normalizers 
	Normval = 0;
	for i=2:nx-1
   	Normval = [Normval;find(BPI ==BPx(i))-1];
	end 
   Normval = [Normval;nBP-1];
    Norm.info = Norm.set('values',Normval(:));
end


Norm.info = Norm.set('breakpoints',{BPx(:),'Filled - reduce error algorithm. '});

% reset values

%reset
x.info = x.set('value',xval);
resetVariables(LT, otherVariables,saveothervar);   
cost = Inf;
OK = 1;
msg = '';
