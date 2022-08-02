function AbsConSet = active2abs(ActiveConSet, Index)
%ACTIVE2ABS Convert constraints from active format to absolute format.
%   Given an index portfolio weight vector of NASSETS assets and a matrix of
%   NCONSTRAINTS portfolio linear inequality constraints expressed in active
%   weight format (i.e., relative to the index), transform the constraint 
%   matrix to an equivalent matrix expressed in absolute weight format.
%
%   AbsConSet = active2abs(ActiveConSet, Index)
%
% Inputs:
%   ActiveConSet - Portfolio linear inequality constraint matrix expressed in
%     active weight format. ActiveConSet is formatted as [A b] such that 
%     A*w <= b, where A is an NCONSTRAINTS by NASSETS weight coefficient 
%     matrix, and b and w are both column vectors of length NASSETS. In this
%     case, w represents a vector of active asset weights (i.e., relative to 
%     the index portfolio) whose elements sum to zero.
%
%   Index - NASSETS by 1 vector of index portfolio weights. The sum of the 
%     index weights must equal the total portfolio value (e.g., a standard
%     portfolio optimization problem would impose a sum-to-one budget 
%     constraint).
%
% Outputs:
%   AbsConSet - Transformed portfolio linear inequality constraint matrix 
%     expressed in absolute weight format, also of the form [A b] such that 
%     A*w <= b (see description for ActiveConSet). In this case, w represents
%     a vector of absolute asset weights whose elements sum to the total 
%     portfolio value. See the output ConSet from PORTCONS for additional 
%     details about constraint matrices.
%
% See also ABS2ACTIVE, PORTCONS, PCALIMS, PCGCOMP, PCGLIMS, PCPVAL.


%  Copyright 2003 The MathWorks, Inc.  
%  $Revision: 1.1.6.1 $   $Date: 2003/11/29 20:34:37 $

% Check number if inputs
if nargin < 2
   error('Finance:active2abs:TooFewInputs', ...
         'Two inputs are required: ActiveConSet and Index.');
end

% Size of index weight constraints
nAssets  =  numel(Index);

if length(Index) ~= nAssets
   error('Finance:active2abs:NonVectorInput', ...
         'Index portfolio is must be a vector.');
end

Index  =  Index(:);  % Ensure a column vector.

% ActiveConSet = [A b], thus it has 1 column more than the
% number of rows in the Index vector.

[conSetI,conSetJ] = size(ActiveConSet);  % Size of absolute weight constraints

if (conSetJ-1) ~= nAssets
   error('Finance:active2abs:InconsistentDimensions', ...
         'Length of Index vector inconsistent with ActiveConSet constraint matrix.');
end

% Allocate memory.
AbsConSet = ActiveConSet;

% Extract A and b 
A = ActiveConSet(:,(1:end-1));
b = ActiveConSet(:,end);

% Convert from active to absolute.
AbsConSet(:,end) = b + A*Index;
