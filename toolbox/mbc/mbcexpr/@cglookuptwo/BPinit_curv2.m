function [LT,cost, OK,msg] = BPinit_curv2(LT,om, sf)
%BPINIT_CURV2

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.2 $  $Date: 2004/02/09 07:11:18 $

% LT = BPinit_curv(LT,var,eq,range)
% LT - lookuptwo
% var - 2 x 1 array of pointers to values
% eq - pointer to model
% range - range of inputs to normalisers
%


OK = 1;
cost = inf;
msg = '';

% Pick out some basic items
Nx = LT.Xexpr;
Ny = LT.Yexpr;
Xexpr = Nx.get('x');
Yexpr = Ny.get('x');
mdl = get(sf, 'model');
% get pointers to the variables feeding into the LT
[var, problem, otherVariables] = getvariables(LT,mdl);
px = var(1);
py = var(2);   % this algoriothm will only handle cases where there are ultimately one x and one y variable


% Save some current variable settings
saveothervar = setVariables(LT, otherVariables, om);
for n = 1:length(var)
   savetablevar{n} = var(n).eval;
   range(n,1:2) = get(om, ['Range_' var(n).getname]);
   if range(n,1) >=  range(n,2)
      OK = 0;
      msg = ['Range_' var(n).getname ' must be strictly increasing. '];
      cost = Inf;
      resetVariables(LT, [otherVariables var(1:n)],[saveothervar savetablevar]);
      return
   end   
end 

[BPx, BPvalx, NBPx, lockindx] = i_getData(Nx, px, range(1,:));
[BPy, BPvaly, NBPy, lockindy] = i_getData(Ny, py, range(2,:));

% do X breakpoints
ytestknots = linspace(range(2,1), range(2,2),NBPy);
py.info = py.set('value',ytestknots);
[BPx, STATUS, msg] = i_doBreakpoints(BPx, BPvalx, lockindx, Xexpr, px, [px py], mdl);

if ~STATUS
   Nx.info = Nx.set('breakpoints',{BPx(:),'Set using share curvature then average algorithm'});
   
   % go on with y-dimension
   xtestknots = linspace(range(2,1), range(2,2),NBPx);
   px.info = px.set('value',xtestknots);
   [BPy, STATUS, msg] = i_doBreakpoints(BPy, BPvaly, lockindy, Yexpr, py, [px py], mdl);
   if ~STATUS
      Ny.info = Ny.set('breakpoints',{BPy(:),'Set using share curvature then average algorithm'});
   end
end
OK = ~STATUS;
resetVariables(LT, [otherVariables var],[saveothervar savetablevar]);



%===============================================================


function [BP, BPval, NBP, lockind] = i_getData(pNorm, pVal, range)
BP = pNorm.get('breakpoints');
pVal.info = pVal.set('value',range);
rng = pVal.eval;
BP(1) = min(rng);
BP(end) = max(rng);

BPval = round(pNorm.get('values'));
lockind = unique([1; find(pNorm.get('bplocks')); length(BP)]);
NBP = max(BPval) - min(BPval) + 1;




function [BP, STATUS, msg] = i_doBreakpoints(BP, BPval, lockind, pExpr, pVal, pAllVals, pMdl);
%
%  STATUS = return status indicator.  0 => no problems
%                                 1 => failed. 
%  msg = message to accompany STATUS flag
%  BP = updated breakpoints
%  

STATUS=0;
msg='';

% share the average curvature between the locked breakpoints
for  n = 1:length(lockind) -1 
   nbetween = lockind(n+1) - lockind(n) - 1;
   if nbetween > 0
      % Set up grid of test knots, from which we will select a good choice of initial knots
      % test 10 x (the number of desired knots)  possible positions in both x and y 
      numtestknots = 10*(nbetween+2)+2; %10 times the number of bps between the locked ones
      testBP = linspace(BP(lockind(n)),BP(lockind(n+1)),numtestknots); 
      
      [pVal, setOK, msg] = setvalue(pExpr.info,testBP,pVal);
      if ~setOK
         STATUS = 1;
         msg = 'A normalizer cannot be inverted. ';
         return
      end
      
      % we now take into account the value of eq, at a wider range of values of the other variables
      M = evalAveOtherVariables(pMdl.info, pAllVals);
      
      % deccide if we need to transpose M (for y breakpoint)
      workingdim = (pVal==pAllVals);
      if workingdim(2)
         M=M.';
      end
      
      % check for infs and NaNs in model evaluation
      anynan = isnan(M);
      anyinfin = isinf(M);
      if any(anynan(:)) | any(anyinfin(:))
         STATUS = 1;
         msg = 'Model returns NaN''s or Inf''s';
         return
      end

      % find the 2nd divided differences at the grid of test knots	
      curv = diff(M,2,1);     
      curv = sqrt(abs(curv))/(numtestknots-3);
      curvsofar = cumsum(curv,1);
      
      %measure of the total curvature between the locked breakpoints
      totalcurv= curvsofar(end,:);
      
      if sum(totalcurv) == 0  
         % perform autospacing in this interval
         intvl = (BP(lockind(n)+1) - BP(lockind(n))) ./ (nbetween+1);
         BP(lockind(n)+(1:nbetween)) = BP(lockind(n)) + (intvl*(1:nbetween));
      else
         % do curvature-based spacing
         Xk = pExpr.eval; 
         weights = totalcurv(:)/sum(totalcurv);       %relative importance of each slice 
         nslices = length(totalcurv);                 %number of slices to average over
         denom = (BPval(lockind(n+1))-BPval(lockind(n)));
         BP(lockind(n)+(1:nbetween)) = 0;
         for j=1: nbetween
            %find at what x-value the curvsofar exceeds the fraction of the curvature 
            %that should have happened by the ith breakpoint   
            fraction = (BPval(lockind(n)+j)-BPval(lockind(n)))/denom;
            for k=1: nslices    
               index =  min(find(curvsofar(:,k) > fraction*totalcurv(k)));
               if ~isempty(index) 
                  BP(lockind(n)+j) = BP(lockind(n)+j) + weights(k) * Xk(index); %set the ith breakpoint at slice j 
               else
                  BP(lockind(n)+j) = BP(lockind(n)+j) + weights(k) * max(Xk);
               end   
            end
         end
      end
   end
end
BP = sort(BP);