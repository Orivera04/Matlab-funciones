function [LT, cost, OK, msg] = BPinit_curv(LT,om, sf)
%BPINIT_CURV

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:11:17 $

% LT = BPinit_curv(LT, om, sf)
% LT - lookuptwo
% var - 2 x 1 array of pointers to values
% eq - pointer to model
% range - range of inputs to normalisers
%
% an adaptation of the old mfiles/BreakPointAnalysis/Initialisation/BP_inittwocurv
% to be a method of LookupTwo
% see pg 46 of Carl de Boor's 'A Practical guide to splines',
% which gives a method of choosing knots for 1D linear splines 
% this has been adapted to 2D
%


% get the normalisers, and their variables
Nx = LT.Xexpr;
Ny = LT.Yexpr;

X = Nx.get('x');%pointer to x-coordinates of first normaliser
Y = Ny.get('x');


eq = get(sf, 'model');

% get pointers to the variables feeding into the LT
[var, problem, otherVariables] = getvariables(LT,eq);
x = var(1);
y = var(2);

[saveothervar, OK, msg] = setVariables(LT, otherVariables,om);

if ~OK
   resetVariables(LT, otherVariables,saveothervar);
   return
end


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


BPxval = round(Nx.get('values'));
BPyval = round(Ny.get('values'));

valx =[min(BPxval):max(BPxval)];
ngBPx = length(valx)-length(intersect(valx, BPxval));% number of green breakpoints in x
valy =[min(BPyval):max(BPyval)];
ngBPy= length(valy)-length(intersect(valy, BPyval));% number of green breakpoints in y

BPx = Nx.get('breakpoints');%get current breakpoints
BPy = Ny.get('breakpoints');% get current breakpoints

BPLx = Nx.get('bplocks');%BPL locked breakpoints
nx = length(BPLx);%number of red breakpoints

% if the locks are empty, assume there are no locks
if isempty(nx) 
   nx = length(BPx);
end

BPLy = Ny.get('bplocks');%BPL locked breakpoints
ny = length(BPLy);%number of red breakpoints

% if the locks are empty, assume there are no locks
if isempty(ny) 
   nx = length(BPy);
end



nBPx = nx + ngBPx;%total number of breakpoints in x
nBPy = ny + ngBPy;%total number of breakpoints in y

% set the values of the variables to be the endpoints of the range
x.info = x.set('value',range(1,:));
y.info = y.set('value',range(2,:));

% get the end breakpoints 
Xk = X.eval; 
Yk = Y.eval;  

% set the end breakpoints
BPx(1) = min(Xk);
BPx(nx) = max(Xk);
BPy(1) = min(Yk);
BPy(ny) = max(Yk);

% lock the end breakpoints
lockindx = find(BPLx >0);
lockindx = unique([1; lockindx; nx]);
lockindy = find(BPLy >0);
lockindy = unique([1; lockindy; ny]);

% share the average curvature between the locked breakpoints
for  i = 1:length(lockindx) -1 
   % number of breakpoints between two adjacent locked ones
   nbetweenx = lockindx(i+1) - lockindx(i) - 1;
   if nbetweenx > 0 % if there is space between locked BPs
      % Set up grid of test knots, from which we will select a good choice of initial knots
      % test 10 x (the number of desired knots)  possible positions in both x and y 
      numxtestknots = 10*(nbetweenx+2); %10 times the number of bps between the locked ones
      numytestknots = 10*(nBPy); %10 times the number of bps between the locked ones
      
      xtestBP = linspace(BPx(lockindx(i)),BPx(lockindx(i+1)),numxtestknots); 
      % set the xexpr to equal xtestBP, by playing with the variable x
      [x, OK, msg] = setvalue(X.info,xtestBP,x);
      if ~OK
         msg = 'A normalizer cannot be inverted.';
         resetVariables(LT, otherVariables,saveothervar);
         cost = Inf;
         return
      end
      
      ytestknots = linspace(range(2,1), range(2,2),numytestknots);

      y.info = y.set('value',ytestknots);
      

      % we now take into account the value of eq, at a wider range of values of the other variables
      M = evalAveOtherVariables(eq.info,var);
      
      % check for infs and NaNs
      anynan = find(isnan(M));
      anyinfin = find(isinf(M));
      if ~isempty(anynan)
         OK = 0;
         msg = 'Models returns NaN''s';
         resetVariables(LT, [otherVariables var],[saveothervar savetablevar]);
         cost = Inf;
         return
      elseif ~isempty(anyinfin)
         OK = 0;
         msg ='Model gets infinite';
         resetVariables(LT, [otherVariables var],[saveothervar savetablevar]);
         cost = Inf;
         return
      end
      
      xcurvs = diff(M,2,1);% find the 2nd divided differences in x at the grid of test knots	
      avexcurvs = mean(abs(xcurvs),2);% average the xcurvs in the y-direction
      
      %measure of the total curvature in x between the locked breakpoints
      totalxcurv= sum(sqrt(abs(avexcurvs)))/(numxtestknots-3); 
      if totalxcurv == 0   
         warning('Not enough curvature in x for this algorithm - autospacing instead.');
         % reset values
         resetVariables(LT, [otherVariables var],[saveothervar savetablevar]);
         [om, OK, msg] =bpinit(LT, [BPx(1) BPy(1)], [BPx(end) BPy(end)], [valx(end) valy(end)], [nBPx nBPy]);
         if OK
            [om, cost, OK, msg] = run(om, LT, []);
         end  
         if ~OK
             resetVariables(LT, [otherVariables var],[saveothervar savetablevar]);
             cost = Inf;
            return
         end
      end
      

      for j=1:numxtestknots-2
         xcurvsofar(j) = sum(sqrt(abs(avexcurvs(1:j))))/(numxtestknots-3);
         % a measure of the model curvature from the locked breakpoint to the ith test knot  
      end

      Xk = X.eval; 

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
% share the average curvature between the locked breakpoints
for  i = 1:length(lockindy) -1 
   % number of red breakpoints between two adjacent locked ones
   nbetweeny = lockindy(i+1) - lockindy(i) - 1;
   if nbetweeny > 0 % if there is space between locked BPs
      % Set up grid of test knots, from which we will select a good choice of initial knots
      % test 10 y (the number of desired knots)  possible positions in both x and y 
      numytestknots = 10*(nbetweeny+2); %10 times the number of bps between the locked ones
      numxtestknots = 10*(nBPx); %10 times the number of bps between the locked ones
      
      
      xtestknots = linspace(range(1,1), range(1, 2),numxtestknots);
      x.info = x.set('value',xtestknots);% set the 'cgvalue' in y to be the testknots in y
      
      ytestBP = linspace(BPy(lockindy(i)),BPy(lockindy(i+1)),numytestknots); 
      % set the yexpr to equal ytestBP, by playing with the variable y
      [y, OK, msg] = setvalue(Y.info,ytestBP,y);
      if ~OK
         OK = 0;
         msg = 'A normalizer cannot be inverted.';
         resetVariables(LT, [otherVariables var],[saveothervar savetablevar]);
         cost = Inf;
         x.info = x.set('value',xval);
         y.info = y.set('value',yval);
         return
      end

      % we now take into account the value of eq, at a wider range of values of the other variables
      M = evalAveOtherVariables(eq.info,var);
      
      % check for infs and NaNs
      anynan = find(isnan(M));
      anyinfin = find(isinf(M));
      if ~isempty(anynan)
         OK = 0;
         msg = 'Models returns NaN''s';
         resetVariables(LT, [otherVariables var],[saveothervar savetablevar]);
         cost = Inf;
         return
      elseif ~isempty(anyinfin)
         OK = 0;
         msg = 'Model gets infinite';
         resetVariables(LT, [otherVariables var],[saveothervar savetablevar]);
         return
      end
      
      ycurvs = diff(M,2,2);% find the 2nd divided differences in y at the grid of test knots	
      aveycurvs = mean(abs(ycurvs),1);% average the ycurvs in the y-direction
      
      %measure of the total curvature in y between the locked breakpoints
      totalycurv= sum(sqrt(abs(aveycurvs)))/(numytestknots-3); 
      if totalycurv == 0   
         warning('Not enough curvature in y for this algorithm - autospacing instead.');
         % reset values
        resetVariables(LT, [otherVariables var],[saveothervar savetablevar]);
         [om, OK, msg] =bpinit(LT, [BPx(1) BPy(1)], [BPx(end) BPy(end)], [valx(end) valy(end)], [nBPx nBPy]);
         if OK
            [om, cost, OK, msg] = run(om, LT, []);
         end   
         if ~OK
             resetVariables(LT, [otherVariables var],[saveothervar savetablevar]);
             cost = Inf;
            return
         end
      end
      

      for j=1:numytestknots-2
         ycurvsofar(j) = sum(sqrt(abs(aveycurvs(1:j))))/(numytestknots-3);
         % a measure of the model curvature from the locked breakpoint to the ith test knot  
      end

     
      Yk = Y.eval;  
      
      for j=1: nbetweeny
         %find at what y-value the ycurvsofar eyceeds the fraction of the curvature 
         %that should have happened by the jth breakpoint   
        
         index =  min(find(ycurvsofar > ((BPyval(lockindy(i)+j)-BPyval(lockindy(i)))/(BPyval(lockindy(i+1))-BPyval(lockindy(i))))*totalycurv));
         if ~isempty(index) 
            BPy(lockindy(i)+j) = Yk(index); %set this to be the new breakpoint 
         else
            BPy(lockindy(i)+j) = max(Yk);
         end   
      end   
  end
end
BPy = sort(BPy);
   
   
Nx.info = Nx.set('breakpoints',{BPx(:),'Set using share ave curvature algorithm'});
Ny.info = Ny.set('breakpoints',{BPy(:),'Set using share ave curvature algorithm'});
  
% reset values

resetVariables(LT, [otherVariables var],[saveothervar savetablevar]);
cost = Inf;
OK = 1;
msg = '';
