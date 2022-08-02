function [PortSens, PortCost, PortHolds] = hedgeopt(Sensitivities, Price, CurrentHolds, FixedInd, ...
                                                    NumCosts, TargetCost, TargetSens, ConSet)
%HEDGEOPT Allocate an optimal hedge for a set of target costs or sensitivities.
%   Allocate an optimal hedge by one of two criteria: (1) Minimize portfolio
%   sensitivities (exposure) for a given set of target costs, or (2) Minimize 
%   the cost of hedging a portfolio given a set of target sensitivities. The 
%   hedging problem involves the fundamental tradeoff between portfolio 
%   insurance and the cost of such insurance coverage. This function allows
%   investors to modify portfolio allocations among instruments according to 
%   either of the two above-referenced criteria. The problem is cast as a 
%   constrained linear least-squares problem. The particular criteria is 
%   inferred from the input argument list.
%
%   [PortSens, PortCost, PortHolds] = hedgeopt(Sensitivities, Price, ...
%              CurrentHolds, FixedInd, NumCosts, TargetCost, TargetSens, ConSet)
%
%   Optional input arguments: FixedInd, NumCosts, TargetCost, TargetSens, ConSet
%
%   [PortSens, PortCost, PortHolds] = hedgeopt(Sensitivities, Price, ...
%                                              CurrentHolds)
% Inputs:
%   Sensitivities - NINST by NSENS matrix of dollar sensitivities of 
%   instruments in a portfolio, with each row representing a different 
%   instrument, and each column a different sensitivity. 
%   
%   Price - NINST by 1 vector of portfolio instrument unit prices.
%   
%   CurrentHolds - NINST by 1 vector of contracts allocated to each instrument.
%
% Optional Inputs:
%   FixedInd - Empty or NFIXED by 1 vector of indices of instruments to hold
%   fixed. The default is FixedInd = [] (i.e., holdings of no instruments in
%   the portfolio are held fixed). For example, assume holdings in the first 
%   and third instruments of a 10 instrument portfolio must remain unchanged, 
%   then set FixedInd = [1 3].
%
%   NumCosts - Number of points generated along the cost frontier when a
%   vector of target costs (TargetCost) is not specified. The default is 10 
%   equally-spaced points between the point of minimum cost and the point of 
%   minimum exposure. When specifying TargetCost, enter NumCosts as an empty
%   matrix [].
%
%   TargetCost - Vector of target cost values along the cost frontier. If 
%   TargetCost is empty, or not entered, NumCosts equally-spaced target costs
%   between the minimum cost and minimum exposure will be evaluated. When
%   specified, the elements of TargetCost should be positive numbers that
%   represent the maximum amount of money the owner is willing to spend to 
%   rebalance the portfolio.
%
%   TargetSens - 1 by NSENS vector containing the target sensitivity values of
%   the holding portfolio. When specifying TargetSens, enter NumCosts and 
%   TargetCost as empty matrices [].
%
%   ConSet - NCONS by NINST matrix of additional constraints on the portfolio
%   reallocations.  An eligible NINST by 1 vector of contract holdings, 
%   PortHolds, satisfies all the inequalities A*PortHolds <= b, where 
%   A = ConSet(:,1:end-1) and b = ConSet(:,end).
%
% Outputs:
%   PortSens - NPOINTS by NSENS matrix of portfolio dollar sensitivities.
%   When a perfect hedge exists, PortSens is zeros.  Otherwise, the best 
%   hedge possible is chosen.
%   
%   PortCost - NPOINTS by 1 vector of total portfolio rebalancing costs.
%
%   PortHolds - NPOINTS by NINST matrix of contracts allocated to each
%   instrument.  These are the reallocated portfolios.
%   
% Notes:
% (1) The user-specified constraints included in ConSet may be created with 
%     the functions PCALIMS or PORTCONS. However, the PORTCONS default 
%     positivity and sum-to-one constraints are typically inappropriate for 
%     hedging problems, since short-selling is usually required. 
% (2) NPOINTS (i.e., the number of rows in PortSens and PortHolds, and the
%     length of PortCost) is inferred from the inputs. When the target
%     sensitivities, TargetSens, is entered, NPOINTS = 1; otherwise 
%     NPOINTS = NumCosts, or equal the length of the TargetCost vector.
% (3) Not all problems are solvable (e.g., the solution space may be 
%     infeasible, unbounded, or insufficiently constrained), or the solution 
%     may fail to converge. When a valid solution is not found, the 
%     corresponding rows of PortSens and PortHolds and elements of PortCost 
%     are padded with NaN's as placeholders. In addition, the solution may 
%     not be unique.
%
% See also HEDGESLF, PORTOPT, PORTCONS, PCALIMS, LSQLIN.

% Author(s): R. A. Baker, 01-28-2000
%   Copyright 1998-2002 The MathWorks, Inc. 
% $Revision: 1.8 $  $Date: 2002/04/14 16:37:38 $

%----------------------------------------------------------------
% Input argument validation
%----------------------------------------------------------------

%
% Check for sufficient inputs.
%
if nargin < 3
   error('Sensitivities, Price, and CurrentHolds are required.');
end

%
% Enure input argument consistency.
%
[r, c] = size(Price);
if ((r ~= 1) & (c ~= 1))
	error('Price must be a vector.')   
end

Price  =  Price(:);
NINST  =  length(Price);

[r, c] = size(CurrentHolds);
if ((r ~= 1) & (c ~= 1))
	error('CurrentHolds must be a vector.')   
end

CurrentHolds  =  CurrentHolds(:);

if length(CurrentHolds) ~= NINST
	error('CurrentHolds and Price must be vectors of the same length.')   
end

[r, NSENS] = size(Sensitivities);
if (r ~= NINST)
   error('Number of rows in Sensitivities must equal the number of elements in Price.')
end

%
% Determine which optional arguments were entered as non-empty.
%

TargetSensEntered = logical(0);
NumCostsEntered   = logical(0);
TargetCostEntered = logical(0);

if (nargin >= 4) & ~isempty(FixedInd)
   FixedInd  =  unique(FixedInd(:));
   if length(FixedInd) > NINST
      error('Number of instruments held fixed must be <= total number of instruments.')
   end
   if any(FixedInd > NINST)
      error('Indices of instruments held fixed must be <= total number of instruments.')
   end
else
   FixedInd  =  [];
end

if (nargin >= 5) & ~isempty(NumCosts)

   if (length(NumCosts) ~= 1) | (NumCosts < 1)
       error('NumCosts must be a positive scalar integer.')
   end

   NumCostsEntered = logical(1);

end

if (nargin >= 6) & ~isempty(TargetCost)

   if NumCostsEntered
      error('NumCosts and TargetCost are mutually exclusive inputs.')   
   else
      [r, c] = size(TargetCost);
      if (r ~= 1) & (c ~= 1)
         error('TargetCost must be a vector.')   
      end
      TargetCost  =  TargetCost(:);
      if any(TargetCost < 0)
         error('Negative costs in TargetCost are not allowed.')   
      end
      NumCosts          =  length(TargetCost);
      TargetCostEntered =  logical(1);
   end

end

if (nargin >= 7) & ~isempty(TargetSens)

   if NumCostsEntered
      error('TargetSens and NumCosts are mutually exclusive inputs.')
   elseif TargetCostEntered
      error('TargetSens and TargetCost are mutually exclusive inputs.')
   else

      [r, c] = size(TargetSens);
      if (r ~= 1) & (c ~= 1)
         error('TargetSens must be a vector.')   
      end

      TargetSens  =  TargetSens(:);

      if length(TargetSens) ~= NSENS
         error('Number of columns in Sensitivities must equal the number of elements in TargetSens.')
      end

      TargetSensEntered =  logical(1);
      NumCosts          =  1;

   end

end

%
% When entering a TargetCost vector, NumCosts must be an empty matrix.
%

if (TargetSensEntered + NumCostsEntered + TargetCostEntered) ~= 1
   NumCosts  =  10;
end

%
% The user-specified constraints included in ConSet may be created 
% with the functions PCALIMS or PORTCONS. However, the PORTCONS 
% default positivity and sum-to-one constraints are typically 
% inappropriate for hedging problems, since short-selling is usually 
% required. If no explicit user constraints exist, then assume none.
%

if nargin < 8
   ConSet = [];
end

%--------------------------------------------------------------------------
% User specified constraints from FixedInd and ConSet
% ConA   <= Conb   : from user specified constraint ConSet
% ConAeq == Conbeq : from user specified FixedInd
%--------------------------------------------------------------------------
% Consider inequality constraints passed in by user

if (nargin >= 8) & ~isempty(ConSet)
   ConA = ConSet(:,1:end-1);
   Conb = ConSet(:,end);
else
   ConA = [];
   Conb = [];
end

ConAeq = []; Conbeq = [];

% Fix weight as required in FixedInd
if(~isempty(FixedInd))
   % Set to column
   FixedInd = FixedInd(:);
     
   % Identify variable elements
   IndexVar = 1:NINST;
   IndexVar(FixedInd) = [];
   
   % Create diagonal matrix and take out rows corresponding to variable instruments
   FixAeq  = eye(NINST);
   FixAeq(IndexVar, :) = [];
   
   Fixbeq = CurrentHolds(FixedInd);
   
   % Add to previous equality constraints
   ConAeq = [ConAeq; FixAeq]; 
   Conbeq = [Conbeq; Fixbeq];
   
end

%
% Set options for optimization.
%

LsqOptions = optimset('Display' , 'off' , 'LargeScale', 'off');

%
%  Pre-allocate the outputs.
%

PortSens  =  repmat(NaN , NumCosts , NSENS);
PortCost  =  repmat(NaN , NumCosts , 1);
PortHolds =  repmat(NaN , NumCosts , NINST);

%
% Decide which type of problem to solve.
%

if TargetSensEntered

%
%  Since a target sensitivity matrix was entered, we attempt to minimize 
%  the cost associated with a given set of fixed sensitivities. In this
%  case, the sensitivities become EQUALITY constraints. The resulting 
%  costs are what you need to spend to obtain the input sensitivities.
%
   AeqSens = Sensitivities';
   beqSens = TargetSens;
%
%  Add to user specified equality constraints.
%
   Aeq = [ConAeq; AeqSens]; 
   beq = [Conbeq; beqSens];
%
%  Calculate the value of the portfolio before re-balancing.
%
   V0 = Price' * CurrentHolds;
%
%  Define the objective function as the drift (V1 - V0), where
%  V1 is the value of the portfolio after re-balancing.
%
   C  =  Price';
   d  =  V0;

   [holdings, Resnorm, Residual, ExitFlag] = lsqlin(C, d, ...
        ConA, Conb , Aeq, beq, [], [], CurrentHolds, LsqOptions);

   if ExitFlag >= 0
%
%     Assign the instrument holdings (i.e., the number of units) and 
%     find the re-balanced portfolio value & sensitivities.
%
      PortHolds  =  holdings(:)';
      PortSens   =  holdings(:)' * Sensitivities;
      PortCost   = -Residual;

   end

else

%
%  Since a target cost vector, or a number of target costs, was 
%  entered, we attempt to minimize the portfolio sensitivities 
%  associated with a given set of maximum costs needed. In contrast
%  to the preceding case in which the sensitivities were EQUALITY
%  constraints, this case incorporates the costs as INEQUALITY
%  constraints. In other words, the target costs are viewed as 
%  the MOST an individual is willing to spend to minimize the
%  sensitivities of a portfolio. The resulting sensitivities are
%  the best obtainable given the maximum amount you're willing 
%  to spend.
%
   C = Sensitivities';
   d = zeros(NSENS,1);
%
%  Calculate the value of the portfolio before re-balancing.
%
   V0 = Price' * CurrentHolds;
%
%  Specify any equality constraints.
%
   Aeq = ConAeq;   % equality constraints matrix (Aeq*x = beq)
   beq = Conbeq;   % equality constraints vector (Aeq*x = beq)
%
%  Slice the cost frontier into 'NumCosts' cost points if needed.
%  The cost frontier will consist of equally-spaced points between 
%  the point of minimum cost (i.e., zero cost) and the point of 
%  minimum exposure (i.e., maximum cost).
%
   if ~TargetCostEntered
      [S, V1, H]  = hedgeslf(Sensitivities , Price    , ...
                             CurrentHolds  , FixedInd , ConSet);
      minimumCost = 0;
      maximumCost = max(V0 - V1 , minimumCost);
      TargetCost  = linspace(minimumCost , maximumCost , NumCosts);
   end
%
%  Incorporate the cost(s) as INEQUALITY constraints. The cost 
%  of re-balancing a portfolio is defined as
%
%      c = max(V0 - V1 , 0) 
%
%  such that the cost incurred is always non-negative. Assume that 
%  the cost is positive. Since
%
%      c = V0 - V1, then  V1 = V0 - c
%       
%  To account for the cost of re-balancing, we place a lower bound
%  on the value, V1, of the re-balanced portfolio, which implies
%  an inequality constraint of the form A*x >= b. But since the
%  LSQLIN minimizer requires inequality constraints of the form
%  A*x <= b, we must negate both sides of the inequality constraint
%  and flip the inequality sign. Thus, what we need is 
%
%      A*x >= b = V1 = V0 - c
%
%  which must be passed to LSQLIN as 
%
%     -A*x <= -(V0 - c)] = c - V0
%

   A  = -Price';
   b  =  TargetCost(:) - V0;

   for Point = 1:NumCosts

       [holdings, Resnorm , Residual, ExitFlag] = lsqlin(C, d, ...
               [ConA ; A] , [Conb ; b(Point)] , Aeq, beq, [], [], CurrentHolds, LsqOptions);

       if ExitFlag >= 0
%
%         Assign the instrument holdings (i.e., the number of units) and 
%         find the re-balanced portfolio value, sensitivities, and the 
%         cost incurred to re-balance.
%
          PortHolds(Point,:)  =  holdings(:)';
          PortSens (Point,:)  =  holdings(:)' * Sensitivities;
          PortCost (Point)    =  max(Price'*(CurrentHolds - holdings) , 0);

       end

   end

end  % IF end
