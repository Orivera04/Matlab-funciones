function sumst = cgsumstore(varargin)
%CGSUMSTORE Constructor for cgsumstore object
%
%  SUMST = CGSUMSTORE constructs an empty cgsumstore object. 
%  SUMST = CGSUMSTORE(OS) creates an cgsumstore object for the optimization
%  that is contained in the optimstore object, OS. 
%  SUMST = CGSUMSTORE(OS, OBJGRADFLAG, CONGRADFLAG) creates a cgsumstore
%  object that is told whether the optimization in OS has gradients
%  specified or not. OBJGRADFLAG and CONGRADFLAG must be specified as TRUE
%  or FALSE.
%  The CGSUMSTORE object is a utility that handles data for sum and mixed
%  'sum/point' optimizations. In particular, it handles the evaluation of
%  the following quantities in an optimization:
%  - Linear constraints
%  - Start positions
%  - Free variable bounds
%  - Evaluation of objective functions
%  - Evaluation of constraint functions
%  - Evaluation of objective gradients
%  - Evaluation of constraint gradients
%
%  See also CGOPTIMSTORE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.1.6.2 $  $Date: 2004/02/09 06:55:29 $


%BACKGROUND Background to the 'sum' optimization problem 
%
%  A sum optimization can be defined by the following problem:
%  User chooses: 
%  Free variables: F1, F2, ...
%  Objectives: O1, O2, ...
%  Point Constraints: CP1, CP2, ...
%  Sum Constraints: CS1, CS2, ...
%  Operating Point Set: OP, which defines points, P1, P2, ...
%  Weight for objective function R at operating point S: W_RS
%  Weight for sum constraint function R at operating point S: WC_RS
%
%  Now we construct:
%  S1 = W_11*O1(F1_P1, F2_P1, ...; P1) + W_12*O1(F1_P2, F2_P2, ...; P2) + ...
%  S2 = W_21*O2(F1_P1, F2_P1, ...; P1) + W_22*O2(F1_P2, F2_P2, ...; P2) + ...
%           .
%           .
%
%  CS1 = WC_11*CS1(F1_P1, F2_P1, ...; P1) + WC_12*CS1(F1_P2, F2_P2, ...; P2) + ...
%  CS2 = WC_21*CS2(F1_P1, F2_P1, ...; P1) + WC_22*CS2(F1_P2, F2_P2, ...; P2) + ...
%           .
%           .
%
%  The free variables for the problem are defined as the set of Fr_Ps where
%  Ws is non zero for all objectives and constraints. Define this set as
%  FVARS. As an example, consider a 3 point operating set, P1, P2, P3, P4,
%  two free variables, F1, F2 and two objectives, O1, O2. The user has specified weights
%  W_11 = [1 0 0 1]
%  W_12 = [1 1 0 1]
%  In this case the free variables are F1_P1, F2_P1, F1_P2, F2_P2, F1_P4,
%  F2_P4 (point 3 has no free variables, as both objectives have zero weight
%  there)
%  
%  The 'sum' problem can now be stated:
%  min S1, min S2, ...
%  over: FVARS
%  subject to 
%  CS1(FVARS;nonzero P) <= VAL1
%  CS2(FVARS;nonzero P) <= VAL2
%  CP1 <= VAL3 to be applied at every point with non zero weights
%

os  = [];
objgrad = false;
congrad = false;

if nargin > 0
    os = varargin{1};
end
if nargin > 1
    objgrad = varargin{2};
end
if nargin > 2
    congrad = varargin{3};
end
    
s = struct('os', os, ...
    'gradglob', [], ...
    'objgrad', objgrad, ...
    'congrad', congrad);
s.gradglob = struct('objective', [], 'constraint', []);
s.gradglob.objective = cell(1, 4);
s.gradglob.constraint = cell(1, 4);
sumst = class(s, 'cgsumstore');