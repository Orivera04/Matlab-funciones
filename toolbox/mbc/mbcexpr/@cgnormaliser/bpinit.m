function [om,OK,msg]= bpinit(N, varargin) 
%BPINIT 
%
% [om, OK,msg] = bpinit(N)  (uses the underlying values of the variables to set the breakpoints) 
% N = bpinit(N, minBP, maxBP, maxVal, numBPs) 
% [N, cost, OK,msg] = run(om, N, []) 
% N - normaliser 
% minBP - minimum breakpoint value 
% maxBP - maximum breakpoint value 
% maxVal - largest normaliser output (an integer) 
% numBP - the number of breakpoints (red ones!) 
% an optmgr for equally spacing the moveable breakpoints.  
% Run with 
% [N,cost,OK,msg]= run(om,N,[]); 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.3.2.3 $  $Date: 2004/02/09 07:13:43 $

% create the xregoptmgr. It is a context object, associated with a normaliser N 
om= contextimplementation(xregoptmgr,N,@i_autospace,[],['InitBP_' getname(N)],@bpinit); 

% work out what the default values should be 
if nargin == 1 
   NormExpr = N.Xexpr; 
   
   % get the variables in the normaliser. Usually just one, but can have more complex cases too.  
   NPtrs = getptrs(N); 
   tableVariables = []; 
   for j = 1:length(NPtrs) 
      if isddvariable(NPtrs(j).info) & ~isconstant(NPtrs(j).info) 
         tableVariables = [tableVariables NPtrs(j)]; 
      end 
   end 
    
   % set the values of the variables in the normaliser to be 10 equally spaced points between the ranges 
   for i = 1:length(tableVariables) 
      savevar{i} = tableVariables(i).get('value'); 
      range = tableVariables(i).get('range'); 
      if ~isempty(range) 
         varmin(i) = range(1); 
         varmax(i) = range(2); 
      else % use the underlying values 
         varmin(i) = min(tableVariables(i).eval); 
         varmax(i) = max(tableVariables(i).eval); 
      end 
      if varmin(i) < varmax(i) 
         tableVariables(i).info = tableVariables(i).set('value',linspace(varmin(i), varmax(i),10)); 
      else % if they are equal 
          tableVariables(i).info = tableVariables(i).set('value', varmin(i)); 
      end 
  end 
   
   % evaluate the normaliser at these variables, and find the max/min values 
   evalNormexpr = NormExpr.eval; 
   minBP = min(evalNormexpr(:)); 
   maxBP = max(evalNormexpr(:)); 
   % reset variables 
   for i = 1:length(tableVariables) 
      tableVariables(i).info = tableVariables(i).set('value',savevar{i}); 
  end 
  maxVal = [];  %set these to be empty 
  numBP = []; 

elseif   nargin == 5   
   minBP = varargin{1}; 
   maxBP = varargin{2}; 
   maxVal = varargin{3}; 
   numBP = varargin{4};    
    
end    

om= AddOption(om,'Range',[minBP maxBP],{'range',[-Inf,Inf]}, 'Breakpoint range'); 
% when called with particular arguments cg_breakpoint_editor, have MaxVal and NumBP options,  
% otherwise do without 
om= AddOption(om,'MaxVal',maxVal,{'int',[1, Inf]}, 'Maximum value', false); 
om= AddOption(om,'NumBP',numBP,{'int',[1,Inf]}, 'No. of breakpoints', false); 
OK = 1; 
msg =''; 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5 
function [N,cost,OK,msg] = i_autospace(N,om,x0) 

range = get(om, 'Range'); 
minBP = range(1); 
maxBP = range(2); 

OK = 0;
cost = Inf;
msg = '';

% Bug-fix DCL 2517, oms do not update when we delete breakpoints, so do not use them to specifiy Maxval and NumBP 
maxVal = get(om, 'MaxVal'); 
numBP = get(om, 'NumBP'); 
if isempty(maxVal) | isempty(numBP) 
    % calculate them from current normaliser values.  
     NormExpr = N.Xexpr; 
     NormVals = N.Values; 
     maxVal = max(NormVals);   
     numBP = length(NormVals); 
end 

BPL = N.BPLocks;% get the locks 
if all(BPL>0)
    msg = 'All breakpoints locked.  Skipping';
    OK = 1; % not really an error
    return
end

if minBP >= maxBP 
   msg= 'Minimum breakpoint must be less than the maximum breakpoint.'; 
   return 
end    

% pad the locks if numBP > length(BPL) 
if numBP - length(BPL) >0 
   BPL = [BPL; zeros(numBP -length(BPL),1)];  
end    
oldBP = N.Breakpoints; 

lockindices = find(BPL >0); 

if any(oldBP(lockindices) < minBP) | any(oldBP(lockindices) > maxBP) 
   msg = 'A locked breakpoint falls outside the given breakpoint range.'; 
   return 
end     
    
if any(lockindices > numBP) 
   msg = 'A locked breakpoint would have to be removed to space this number of breakpoints.'; 
   return 
end    

if ~isempty(lockindices) & any(lockindices == 1) & ~isequal(oldBP(1), minBP) 
   minBP = oldBP(1);
   msg = 'First breakpoint is locked.  Overriding requested minimum value'; % not fatal
end

if ~isempty(lockindices) & any(lockindices == numBP) & ~isequal(oldBP(numBP), maxBP) 
   maxBP = oldBP(numBP); % not fatal
   if isempty(msg)
       msg = 'Last breakpoint is locked.   Overriding requested maximum value'; 
   else
       msg = 'First and last breakpoints locked.  Overriding requested limits';
   end
end    

% lock the first and the last, if needed 
lockindices = unique([1; lockindices; numBP]); 
BP = zeros(numBP,1); 
oldBP(1) = minBP; 
oldBP(numBP) = maxBP; 

if isequal(numBP,maxVal+1);%if all breakpoints are red, then equally space 
   V = [0:maxVal]'; 
   count = [0:numBP-1]'; 
elseif numBP < maxVal +1;%if there are interpolated breakpoints 
   k = maxVal/(numBP-1); 
   count = round([0:numBP-1]'*k); 
   V = count; 
else % if there are more breakpoints required than normaliser values available,  
   %then pad by repeating the last normaliser value 
   extra = numBP-(maxVal+1); 
   V = [[0:maxVal]'; maxVal*ones(extra,1)]; 
   count = [0:numBP-1]'; 
end 

% equally space between the locked breakpoints 
for i = 1:length(lockindices) -1  
   gap = (oldBP(lockindices(i+1)) - oldBP(lockindices(i)))/(V(lockindices(i+1)) - V(lockindices(i))); 
   BP(lockindices(i):lockindices(i+1)) = oldBP(lockindices(i)) + gap*(count(lockindices(i):lockindices(i+1))- count(lockindices(i))); 
end    


% sets breakpoints, values + history fields, and removes locks 
N = set(N, 'matrix',{[BP,V],'Breakpoints linearly autospaced'});  

N = set(N, 'bplocks',BPL(1:numBP));% reset the locks 
OK = 1; 

