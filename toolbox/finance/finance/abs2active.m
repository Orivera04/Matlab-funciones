function ActiveConSet = abs2active(AbsConSet, Index)
%ABS2ACTIVE Convert constraints from absolute format to active format.
%   Given an index portfolio weight vector of NASSETS assets and a matrix of
%   NCONSTRAINTS portfolio linear inequality constraints expressed in absolute
%   weight format, transform the constraint matrix to an equivalent matrix 
%   expressed in active weight format (i.e., relative to the index).
%
%   ActiveConSet = abs2active(AbsConSet, Index)
%
% Inputs:
%   AbsConSet - Portfolio linear inequality constraint matrix expressed in 
%     absolute weight format. AbsConSet is formatted as [A b] such that 
%     A*w <= b, where A is an NCONSTRAINTS by NASSETS weight coefficient 
%     matrix, and b and w are both column vectors of length NASSETS. In this
%     case, w represents a vector of absolute asset weights whose elements sum
%     to the total portfolio value. See the output ConSet from PORTCONS for
%     additional details about constraint matrices.
%
%   Index - NASSETS by 1 vector of index portfolio weights. The sum of the 
%     index weights must equal the total portfolio value (e.g., a standard
%     portfolio optimization problem would impose a sum-to-one budget 
%     constraint).
%
% Outputs:
%   ActiveConSet - Transformed portfolio linear inequality constraint matrix 
%     expressed in active weight format, also of the form [A b] such that 
%     A*w <= b (see description for AbsConSet). In this case, w represents a 
%     vector of active asset weights (i.e., relative to the index portfolio) 
%     whose elements sum to zero.
%
% See also ACTIVE2ABS, PORTCONS, PCALIMS, PCGCOMP, PCGLIMS, PCPVAL.


%  Copyright 2003 The MathWorks, Inc.  
%  $Revision: 1.1.6.1 $   $Date: 2003/11/29 20:34:36 $

% Check number of inputs
if nargin < 2
   error('Finance:abs2active:TooFewInputs', ...
         'Two inputs are required: AbsConSet and Index.');
end

% Size of index weight constraints
nAssets  =  numel(Index);

if length(Index) ~= nAssets
   error('Finance:abs2active:NonVectorInput', ...
         'Index portfolio is must be a vector.');
end

Index  =  Index(:);  % Ensure a column vector.

% AbsConSet = [A b], thus it has 1 column more than the
% number of rows in the Index vector.

[conSetI,conSetJ] = size(AbsConSet);  % Size of absolute weight constraints

if (conSetJ-1) ~= nAssets
   error('Finance:abs2active:InconsistentDimensions', ...
         'Length of Index vector inconsistent with AbsConSet constraint matrix.');
end

% Allocate memory.
ActiveConSet = AbsConSet;

% Extract A and b.
A = AbsConSet(:,(1:end-1));
b = AbsConSet(:,end);

% Convert from absolute to active.
ActiveConSet(:,end) = b - A*Index;
