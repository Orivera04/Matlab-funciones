function [PortRisk, PortReturn, PortWts] = portopt(ExpReturn, ExpCovariance, ... 
   NumPorts, PortReturn, ConSet)
%PORTOPT  Portfolios on constrained efficient frontier.
%  Returns portfolios on the mean-variance efficient frontier given asset
%  properties and a user specified set of portfolio constraints (ConSet).
%  Among a collection of NASSETS risky assets, computes a portfolio of asset
%  investment weights which minimize the risk for given values of the  
%  expected return.  The portfolio weights satisfy constraints specified in
%  linear inequality equations.  See PORTCONS for the generation of
%  portfolio constraints.
%
%  [PortRisk, PortReturn, PortWts] = portopt(ExpReturn, ExpCovariance, ...
%                                        NumPorts, PortReturn, ConSet) 
%
%  Inputs: 
%     ExpReturn is a 1xNASSETS vector specifying the expected (mean) 
%     return of each asset.
%
%     ExpCovariance is an NASSETSxNASSETS matrix specifying the 
%     covariance of the asset returns.  ExpCovariance must be symmetric with
%     no negative eigenvalues (positive semi-definite).
%
%     Either NumPorts or PortReturn specifies the set of efficient
%     portfolios computed.
%
%     NumPorts is the number of portfolios generated along the efficient
%     frontier when specific portfolio return values are not requested.
%     The default is 10 portfolios equally spaced between the minimum risk
%     point and the maximum possible return.  Enter NumPorts as an empty
%     matrix [], when specifying PortReturn.
%
%     PortReturn is a vector of length NPORTS containing the target return
%     values along the frontier.  If PortReturn is not entered or is empty,
%     NumPorts equally spaced returns between the minimum and maximum
%     possible values will be used.   
%
%     ConSet is a matrix of constraints for a portfolio of asset
%     investments.  An eligible 1 by NASSETS vector of asset allocation
%     weights, PortWts, satisfies the inequalities A*PortWts' <= b, 
%     where A = ConSet(:,1:end-1) and b = ConSet(:,end).  ConSet should
%     include at least an equation bounding the total value of the
%     portfolio below.
% 
%     See PORTCONS for a list of portfolio constraint types and their
%     corresponding financial parameters.
%
%     If the variable ConSet is not specified, a default constraint set 
%     will be used.  The default constraints scale the total value of the
%     portfolio to 1, and place the minimum weight of every asset at 0 to
%     prevent short-selling.
%
%  Outputs: 
%     PortRisk is an NPORTSx1 vector of the standard deviation of return 
%     for each portfolio. 
%            
%     PortReturn is an NPORTSx1 vector of the expected return of each 
%     portfolio.
%
%     PortWts is an NPORTSxNASSETS matrix of weights allocated to each
%     asset. Each row represents a different portfolio. 
%            
%
%  Notes: 
%     A plot of the efficient frontier is returned if the function is
%     invoked without output arguments.
%             
%
%  See also PORTCONS, PORTSTATS, EWSTATS, FRONTCON

%
%  Author(s): D. Eiler, M. Reyes-Kattar, 03/26/98
%  Copyright 1995-2002 The MathWorks, Inc. 
%  $Revision: 1.23 $   $ Date: 1997/08/15 14:07:00 $

%----------------------------------------------------------------
% Input argument validation
%----------------------------------------------------------------

% Check for input errors
if (nargin < 2)
     error('You must enter ExpReturn and ExpCovariance.');
end

% Make sure that the number of returns entered matches the number of rows/columns in the  
% covariance matrix (which represents the number of assets).
ExpReturn = ExpReturn(:);
NASSETS = length(ExpReturn);
   
[covRows, covCols] = size(ExpCovariance);
if(covRows ~= covCols)
    error('The covariance matrix must be NxN, where N = number of assets');
end
 
EC = eig(ExpCovariance);   
if(min(min(EC)) < (-1E-14 * max(max(abs(EC)))))
    warning('Covariance matrix must be positive semi-definite.');
end
clear EC;

if size(ExpCovariance, 1) ~= NASSETS
  error('The number of expected returns does not equal the number of assets.');
end

% Determine which optional arguments were entered as non-empty.
if (nargin < 3 | isempty(NumPorts))  
   NumPortsEntered = 0; 
else
   NumPortsEntered = 1; 
end

if (nargin < 4 | isempty(PortReturn))  
   PortReturnEntered = 0; 
else
   PortReturnEntered = 1; 
end

% When entering the target rate of return (PortReturn), 
% enter NumPorts as an empty matrix.
if (NumPortsEntered ==1) & (PortReturnEntered == 1)
   error('When entering the target rate of return, PortReturn, enter NumPorts as an empty matrix.');
end


if (nargin < 5 | isempty(ConSet))  
   % A default constraint matrix ConSet will be created if this is not entered.
   ConSet = portcons('default', NASSETS);
end


%----------------------------------------------------------------
% Constraint array construction
%----------------------------------------------------------------
% A = ConSet(:,1:end-1);
% b = ConSet(:,end);
% 
% % Call the function EQPARSE in order to find equality equations implied 
% % by the linear inequalities A* Wts <= b.
% % The first Neq rows of Aset and Bset will be interpreted as equalitiy
% % equations 
% [Aset, Bset, Neq]= eqparse(A,b);
% 
% Aeq = []; Beq = [];
% if(Neq > 0)
%    Aeq  = Aset(1:Neq, :);        %equalities constraints
%    Beq  = Bset(1:Neq, :);        %equalities constraints
% end
% 
% Aineq = []; Bineq = [];
% if(Neq < size(Aset,1))
%    Aineq = Aset(Neq+1:end, :);   %inequalities constraints
%    Bineq = Bset(Neq+1:end, :);   %inequalities constraints
% end

% Call INEQPARSE to find inequalites, equalites, and bounds implied by
% the linear inequalities in ConSet.
[Aineq, Bineq, Aeq, Beq, LB, UB] = ineqparse(ConSet);

% If PortReturn has been entered, check them for legality relative to
% constraints. If it has not been entered, construct the default 
% return range.
W0 = ones(NASSETS, 1)/NASSETS;


%----------------------------------------------------------------
% Maximum return calculation
%----------------------------------------------------------------

% Find the maximum expected return achievable, given the individual asset
% expected returns and all the other constraints. 

% Set the options: ('LargeScale' mode os turned off because it can cause 
%                   some warnings to be thrown.)
options = optimset('display', 'off', 'largescale', 'off');

[MaxReturnWeights, Fval, ErrorFlag] = linprog(-ExpReturn, Aineq, Bineq, Aeq, Beq, LB, UB, W0, options);

if ErrorFlag ~= 1
   error('No portfolios satisfy all the input constraints');
end

MaxReturn = MaxReturnWeights'*ExpReturn;

% Find the minimum variance return.
F = zeros(NASSETS, 1);

[MinVarWeights,  Fval, ErrorFlag] = quadprog(ExpCovariance, F, Aineq, Bineq, Aeq, Beq, LB, UB, W0, options);

if ErrorFlag ~= 1
   error('A solution was not feasible for the minimum variance portfolio.');
end

MinVarReturn = MinVarWeights'*ExpReturn;


%----------------------------------------------------------------
% Calculate return corresponding to minimum risk (variance)
%----------------------------------------------------------------
if PortReturnEntered
  % check the requested returns against points on the frontier
  % use a small numerical fudge factor and assume returns are postitive
  if ( min(PortReturn) < MinVarReturn*(1 - 1000*eps) )
    error(sprintf( ...
        ['One or more requested returns are less than the return %f ',...
         'of the least risky portfolio'], MinVarReturn));
  end
  if ( max(PortReturn) > MaxReturn*(1 + 1000*eps) )
    error(sprintf( ...
        ['One or more requested returns are greater than the maximum ',...
         'achievable return of '], MaxReturn));
  end
 
  NumFrontPoints = length(PortReturn);
  PortfOptResults = zeros(NumFrontPoints, 2 + NASSETS);
  StartPoint = 1;
  EndPoint = NumFrontPoints;

else
   % If NumPorts is not entered, set a default value.
   if NumPortsEntered
      NumFrontPoints = NumPorts;
   else
   	NumFrontPoints = 10; 
	end

	MinVarStd = sqrt(MinVarWeights' * ExpCovariance * MinVarWeights);
      
   if MaxReturn > MinVarReturn % This is just the algorithm from MATLAB function, LINSPACE
      PortReturn = [MinVarReturn+(0:NumFrontPoints-2)*(MaxReturn-MinVarReturn)/(NumFrontPoints-1) MaxReturn];
   else
      PortReturn = MaxReturn;
      NumFrontPoints = 1;
   end
		
	PortfOptResults = zeros(NumFrontPoints, 2 + NASSETS);
	PortfOptResults(1, :) = [MinVarReturn MinVarStd MinVarWeights(:)'];
   StartPoint = 2;
   EndPoint = NumFrontPoints-1;
end

FrontPointConstraint = -ExpReturn';
Aeq = [FrontPointConstraint; Aeq ]; % Add a new equality constraint
Beq = [0; Beq];                    % Add a new equality constraint

W0 = MaxReturnWeights;
% Set the options:
options = optimset(options,'largescale', 'off');
   
for Point = StartPoint:EndPoint
   Beq(1) = -PortReturn(Point);
   
   [Weights, Fval, ErrorFlag] = quadprog(ExpCovariance, F, Aineq, Bineq, Aeq, Beq, LB, UB, W0, options);  
   if ErrorFlag ~=1
		PortfOptResults(Point, :) = [Beq(2) nan*ones(1, NASSETS+1)];
	else
		Return = dot(Weights, ExpReturn);
		Std = sqrt(Weights'*ExpCovariance*Weights);
		PortfOptResults(Point, :) = [Return Std Weights(:)'];
	end

end

if ~PortReturnEntered
   % The last row corresponds to the point of maximum return, which has already been calculated
   Std = sqrt(MaxReturnWeights'*ExpCovariance*MaxReturnWeights);
   PortfOptResults(end, :) = [MaxReturn, Std, MaxReturnWeights(:)'];
end


%----------------------------------------------------------------
% Validate results and generate output
%----------------------------------------------------------------

ErrorIndex = find(isnan(PortfOptResults(:, 2)));
if ~isempty(ErrorIndex)
	NumErrors = num2str(length(ErrorIndex));
	warning(['A solution was not feasible for ', NumErrors, ' expected return(s).']);
end

PortReturn = PortfOptResults(:, 1);
PortRisk = PortfOptResults(:, 2);
PortWts = PortfOptResults(:, 3:size(PortfOptResults, 2));

%A plot of the efficient frontier is returned if the function is
%invoked without output arguments.
if nargout == 0
 		FrontWin = figure;

      set(FrontWin,'NumberTitle','off');
		set(FrontWin,'Name','Efficient Frontier');
		set(FrontWin,'Resize','on');
	
		set(FrontWin,'Tag','FrontWin');
	
      plot(PortRisk, PortReturn);
      title('Mean-Variance-Efficient Frontier', 'Color', 'k');
	   xlabel('Risk(Standard Deviation)');
      ylabel('Expected Return');
      grid on;
      
      % prevent any output
      clear PortRisk;
end

%----------------------------------------------------------------
% Auxiliary function(s)
%----------------------------------------------------------------

function [A,b,Aeq,beq,LB,UB] = ineqparse(Ain, bin)
%INEQPARSE Find inequalities, equalities, and bounds implied by Ain*x <= bin.
%  Identifies equalities specified as Arow*x <= bval, -Arow*x <= -bval.
%  Parses out duplicate entries and all zero equations.
%  Finds bound constraints among inequalities.
%
%  [A,b,Aeq,beq,LB,UB] = ineqparse(Ain, bin)
%  [A,b,Aeq,beq,LB,UB] = ineqparse([Ain, bin])
%
%  The function does not catch linear combinations of inequalities which
%  together imply an equality constraint.
%
%  See also PORTCONS.
%
%----------------------------------------------------------------------
%
% % Test the logic to parse out inequalites with single-entry equations
% % 1 : redundant equaltiy
% % 2 : equality
% % 3 : redundant upper bound
% % 4 : lower bound
% % 5 : upper bound
% Astart = [1 2 -1 1 3 -1 -2 -4 5 3]'
% Ain = full(sparse(1:length(Astart),abs(Astart),Astart))
% [A,b,Aeq,beq,LB,UB] = ineqparse(Ain, zeros(length(Astart),1))
%
% % Catch rows which are multiples
% m = 1:length(Astart)
% Ain = diag(m)*Ain
% [A,b,Aeq,beq,LB,UB] = ineqparse(Ain, zeros(length(Astart),1))
%
% % Degenerate case with equality, lower, upper bounds
% C = portcons('default',3,'AssetLims',0,[0.5 0.6 0.7],3)
% [A,b,Aeq,beq,LB,UB] = ineqparse(C)
%
% % Case with a general inequality constraint
% C = portcons('default',3,'AssetLims',0,[0.5 0.6 0.7],3, ...
%              'Custom',[0.1 0.2 0.3],0.40)
% [A,b,Aeq,beq,LB,UB] = ineqparse(C)
%

% J. Akao 8/22/99

% find usage ineqparse(ConSet)
if nargin==1
  bin = Ain(:,end);
  Ain = Ain(:,1:end-1);
end

[NumEquations, NumVars] = size(Ain);
if any( size(bin)~=[NumEquations, 1] )
  error('dimensions of A and b are inconsistent')
end

% Pull out degenerate rows
I = all(Ain==0,2);
if(any(I))
   warning('Degenerate rows found in constraint matrix. Eliminating these contraints');
   Ain(I,:) = [];
   bin(I) = [];
end

% Constraint rows
ConRows = [Ain, bin];

% Form numerator and denominator dot products.
%
% row I and row J are the same direction when:
%   rowI*rowJ' == sqrt(rowI*rowI')*sqrt(rowJ*rowJ') 
%        numIJ == denIJ
%
% row I and row J are the opposite direction when:
%   rowI*rowJ' == - sqrt(rowI*rowI')*sqrt(rowJ*rowJ') 
%        numIJ == - denIJ

% square (rowI*rowJ') but keep the sign
numIJsqrt = ConRows*ConRows';
numIJ = sign(numIJsqrt).*(numIJsqrt.*numIJsqrt);

% form (rowI*rowI') times (rowJ*rowJ')
rowKdot = dot(ConRows, ConRows, 2);
[rowIdot, rowJdot] = meshgrid(rowKdot, rowKdot);
denIJ = rowIdot .* rowJdot;

% record which equations are negations or duplicates
% denIJ is always positive
% take the upper triangular part only
%
% isdupIJ [NumEqs x NumEqs] row I is a positive multiple of row J
% isnegIJ [NumEqs x NumEqs] row I is a negative multiple of row J
reltol = 1000*eps;
isdupIJ = ( denIJ*(1-reltol) <  numIJ ) & (  numIJ < denIJ*(1+reltol) );
isnegIJ = ( denIJ*(1-reltol) < -numIJ ) & ( -numIJ < denIJ*(1+reltol) );

isdupIJ = triu(isdupIJ, 1);
isnegIJ = triu(isnegIJ, 1);

% search through the equations and clean out equalities and duplicates.
% store the equalities separately.
%
% ConEqs  [NumEqs   x NumVars+1] : [Aeq, beq]
% ConRows [NumInEqs x NumVars+1] : [A, b]
ConEqs = zeros(0, NumVars+1);

i=1;
while (i < size(ConRows,1) )
  % find negations and duplicates of this row
  RowIsNeg = isnegIJ(i,:);
  RowIsDup = isdupIJ(i,:);
  
  % negations and duplicates should be removed from the inequality list
  IndRemove = RowIsNeg | RowIsDup;
  
  if any(RowIsNeg)
    % add the row to the equality list
    ConEqs = [ConEqs; ConRows(i,:)];
    
    % remove the row from the inequality list along with negs and dups
    IndRemove(i) = 1;
  else
    % equation i has been left in
    i = i + 1;
  end
  
  % remove equations from the inequality list
  ConRows(IndRemove,:) = [];
  isnegIJ = isnegIJ(~IndRemove, ~IndRemove);
  isdupIJ = isdupIJ(~IndRemove, ~IndRemove);
end

% Break up into left and right hand sides
Aeq = ConEqs(:,1:NumVars);
beq = ConEqs(:,NumVars+1);
A = ConRows(:,1:NumVars);
b = ConRows(:,NumVars+1);

% search through the inequalities and find bounds
% SingleValue * x(Ind) <= b(Ind)
%
% IndSingle   [NumInEqs x 1] true if only 1 non-zero value in row of A
% SingleValue [NumInEqs x 1] only valid for IndSingle == 1
%
% VarNum       [NumInEqs x NumVars] column of each entry of A
% SingleVarNum [NumInEqs x 1] column of first non-zero entry in A
%
IndSingle   = sum(A~=0 , 2) == 1;
SingleValue = sum(A    , 2);

IndLower = IndSingle & ( SingleValue < 0 );
IndUpper = IndSingle & ( SingleValue > 0 );

VarNum = (1:NumVars);
VarNum = VarNum(ones(size(A,1),1),:);
VarNum(A==0) = Inf;
SingleVarNum = min(VarNum,[],2);

if any(IndLower)
  LB = -Inf*ones(NumVars,1);

  % find the variable and the bound value
  VarNum = SingleVarNum(IndLower);
  BVal = b(IndLower)./SingleValue(IndLower);

  % apply the most restrictive bound to each variable
  UniqVar = unique(VarNum);
  if length(UniqVar)==length(VarNum)
    % no variables have multiple parallel bounds
    LB(SingleVarNum(IndLower)) = BVal;
  else
    for Var=UniqVar(:)'
      LB(Var) = max( BVal( VarNum==Var ) );
    end
  end
    
else
  LB = [];
end

if any(IndUpper)
  UB = Inf*ones(NumVars,1);
  
  % find the variable and the bound value
  VarNum = SingleVarNum(IndUpper);
  BVal = b(IndUpper)./SingleValue(IndUpper);

  % apply the most restrictive bound to each variable
  UniqVar = unique(VarNum);
  if length(UniqVar)==length(VarNum)
    % no variables have multiple parallel bounds
    UB(SingleVarNum(IndUpper)) = BVal;
  else
    for Var=UniqVar(:)'
      UB(Var) = min( BVal( VarNum==Var ) );
    end
  end
    
else
  UB = [];
end

% remove lower or upper bound inequalities
A(IndSingle,:) = [];
b(IndSingle) = [];


%----------------------------------------------------------------
% Auxiliary function(s)
%----------------------------------------------------------------

function [Aset, Bset, Neq]= eqparse(A, b)
% EQPARSE find equality equations implied by linear inequalities A*x <= b
% Orders equality equations to the top of the list and returns the number of
% equations to be treated as equalities.
% 
% [Aset, Bset, Neq] = eqparse(A,b)

%  Author(s): J. Akao, 03/30/98

[NumEquations, NumVars] = size(A);
if any( size(b)~=[NumEquations, 1] )
  error('dimensions of A and b are inconsistent')
end

% Pull out degenerate rows
I = all(A==0,2);
if(any(I))
   warning('Degenerate rows found in constraint matrix. Eliminating these contraints');
   A(I,:) = [];
end


ConLE = [A, b]; % equations which are less than or equal

% Normalize the rows so that dot(row,row) = 1
RowNorm = sqrt(dot( ConLE, ConLE, 2));
ConLE = ConLE./RowNorm(:,ones(1,NumVars+1));

% start a variable for any equality equations found
ConEq = zeros(0,NumVars+1);

% pull out equalities from the inequalities
i = 1; % number of inequalities found + 1
while ( i < size(ConLE,1) )
  % candidate row
  ConRow = ConLE(i,:);
  
  % find which remaining rows are negatives of ConRow
  % dot(ConRow, ConRow) == -1
  % where dot(Row, Row) = 1 because of normalization
  DotWithRows = ConLE(i+1:end,:)*ConRow';
  RowIsNeg = (-1-1000*eps) < DotWithRows & DotWithRows < (-1+1000*eps);
  
  % find which rows are the same as ConRow
  RowIsSame = (1-1000*eps) < DotWithRows & DotWithRows < (1+1000*eps);
  
  if any(RowIsNeg) 
    % add Row i to the equality list
    ConEq = [ConEq; ConRow];

    % build list to delete from the inequalities
    IndRemove = [i; i + find(RowIsNeg | RowIsSame)];
  else
    % build the delete list from the duplicate rows
    IndRemove = i + find(RowIsSame);
    
    % equation i has been left in
    i = i + 1;
  end
  ConLE(IndRemove,:) = [];

end

Aset = [ConEq(:,1:NumVars); ConLE(:,1:NumVars)];
Bset = [ConEq(:,NumVars+1); ConLE(:,NumVars+1)];
Neq = size(ConEq,1);

