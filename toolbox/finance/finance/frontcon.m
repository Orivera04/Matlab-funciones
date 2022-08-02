function [PRisk, PRoR, PWts] = frontcon(ERet, ECov, NPts, RTarget, ACLUBounds, ACGroups, ACGLUBounds)
% FRONTCON  Mean-variance efficient frontier with portfolio constraints.
%   This function returns the mean-variance efficient frontier with user specified
%   asset constraints, covariance and returns. Given a collection of NASSETS risky 
%   assets, computes a portfolio of asset investment weights which minimize the
%   risk for given values of the expected return.  The portfolio risk is minimized
%   subject to constraints on the asset weights or on groups of asset weights.
%
%   [PortRisk, PortReturn, PortWts] = frontcon(ExpReturn, ExpCovariance, ...
%      NumPorts, PortReturn, AssetBounds, Groups, GroupBounds)
%
%   Inputs: 
%     ExpReturn is a 1xNASSETS vector specifying the expected (mean) 
%     return of each asset.
%    
%     ExpCovariance is an NASSETSxNASSETS matrix specifying the covariance of
%     the asset returns.
%    
%     NumPorts is the number of efficient portfolios, NPORTS.  The default value
%     is 10 if NumPorts is entered as the empty matrix [] or not specified. 
%     NumPorts should be entered as [] if PortReturn is to be entered.
%
%     PortReturn is a vector of length NPORTS containing the target return
%     values on the frontier.
%     You can specify the portfolio return values in two ways.  If PortReturn
%     is not entered or is empty, NumPorts equally spaced returns between the
%     minimum and maximum possible values will be used.  
%
%     AssetBounds is a 2xNASSETS matrix containing the lower and upper
%     bounds on the weight to be allocated in each asset in the portfolio.
%     The default lower bound is all zeros (no short-selling), the default 
%     upper bound is all ones (any asset may comprise the entire portfolio). 
%    
%     Groups is an NGROUPSxNASSETS matrix specifying NGROUPS asset  
%     groups or classes.  Each row specifies a group:  Groups(i,j) = 1 if 
%     the j'th asset belongs to the i'th group.  Groups(i,j) = 0 if the j'th
%     asset is not in the i'th group.
%    
%     GroupBounds is a NGROUPSx2 matrix specifying, for each group, the lower
%     and upper bounds of the total weights of all assets in that group.  The
%     default lower bound is all zeros, the default upper bound is all ones.   
%
%
%   Outputs: 
%     PortRisk is an NPORTSx1 vector of the standard deviation of return for
%     each portfolio. 
%    
%     PortReturn is an NPORTSx1 vector of the expected return of each portfolio.
%    
%     PortWts is an NPORTSxNASSETS matrix of weights allocated to each
%     asset. Each row represents a different portfolio. The total of all 
%     weights in a portfolio is 1.
%            
%
%   Notes: 
%     A plot of the efficient frontier is returned if the function is
%     invoked without output arguments.
%
%     The asset returns are assumed to be jointly normal, with expected mean
%     returns of ExpReturn and return covariance ExpCovariance.  The variance
%     of a portfolio with 1 by NASSET weights PortWts is given by
%     PortVar = PortWts*ExpCovariance*PortWts'.  The portfolio expected
%     return is PortReturn = dot(ExpReturn, PortWts).
%
%   See also PORTSTATS, PORTOPT, EWSTATS.
%

%   Author(s): D. Eiler, M. Reyes-Kattar, 01/30/98
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.15 $   $ Date: 1998/01/30 13:45:34 $

%----------------------------------------------------------------
% Input argument validation
%----------------------------------------------------------------

if (nargin < 2)
     error('You must enter ExpReturn and ExpCovariance.');
end

% Make sure that the number of returns entered matches the number of rows/columns in the  
% covariance matrix (which represents the number of assets).
ERet = ERet(:);
NASSETS = length(ERet);
   
if any( size(ECov)~=NASSETS )
    error('The covariance matrix must be NxN, where N = number of assets');
end
   
EC = eig(ECov);   
if(min(min(EC)) < (-1E-14 * max(max(abs(EC)))))
    warning('Covariance matrix must be positive semi-definite.');
end
clear EC;
   
% Determine which optional arguments were entered as non-empty.
if (nargin < 3 | isempty(NPts)) 
   NPtsEntered = 0; 
   NPts = [];
else
   NPtsEntered = 1; 
end

if (nargin < 4 | isempty(RTarget))    
   RTargetEntered = 0; 
   RTarget = [];
else
   RTargetEntered = 1; 
end

%When entering the target rate of return, enter NPts as an empty matrix.
if (NPtsEntered ==1) & (RTargetEntered == 1)
  if (length(RTarget(:)) ~= NPts )
    error('When entering PortReturn, enter NumPorts as an empty matrix')
  end
end

if (nargin < 5 | isempty(ACLUBounds))  
   ACLUBoundsEntered = 0; 
else
   ACLUBoundsEntered = 1; 
end

if (nargin < 6 | isempty(ACGroups))  
   ACGroupsEntered  = 0; 
else
   ACGroupsEntered  = 1; 
end

if (nargin < 7 | isempty(ACGLUBounds))  
   ACGLUBoundsEntered  = 0; 
else
   ACGLUBoundsEntered  = 1; 
end

if(ACGroupsEntered & ~ACGLUBoundsEntered)
   % Set default values for group bounds
   NGroups = size(ACGroups, 1);
	ACGLUBounds = [zeros(NGroups,1), ones(NGroups,1)];   
end


%----------------------------------------------------------------
% Generate Constraint array needed to call PORTOPT
%----------------------------------------------------------------

% ACLUBounds, ACGroups, ACGLUBounds

if(ACLUBoundsEntered)
   % Allow short-selling, ineqparse applies the most restrictive constraint!
   ConSet = pcpval(1, NASSETS); 
   ConSet = [ConSet; portcons('AssetLims', ACLUBounds(1,:), ACLUBounds(2,:))];
else
   ConSet = portcons('Default', NASSETS);
end

if(ACGroupsEntered)
   ConSet = [ConSet; portcons('GroupLims', ACGroups, ACGLUBounds(:,1), ACGLUBounds(:,2))];
end

%----------------------------------------------------------------
% Generate output
%----------------------------------------------------------------

if nargout == 0
   portopt(ERet, ECov, NPts, RTarget, ConSet);
else
   [PRisk, PRoR, PWts] = portopt(ERet, ECov, NPts, RTarget, ConSet);
end
