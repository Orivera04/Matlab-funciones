function [y, ysums] = gridevaluate(optimstore, X, varargin)
%GRIDEVALUATE Grid evaluation of optimization objectives and constraints
%
%  Y = GRIDEVALUATE(OPTIMSTORE, X) evaluates all the objectives and
%  constraints at all combinations of the points in the 'Primary' data set,
%  P, with X. The return matrix, Y, is of size SIZE(X, 1) by (NOBJ+NCON) by
%  NPTS, where NOBJ is the number of objectives, NCON is the number of
%  constraints and NPTS is the number of rows in P. Further, Y(I, J, K) is
%  the value of the J-th objective/constraint at X(I, :) and P(K, :).
% 
%  Example:
%  
%  Objectives : O1, O2
%  Constraints : C1, C2
%
%  Primary dataset:
%   A | B
%   -----
%   4 | 5
%   1 | 3
% 
%  Free variables:
%       x1 x2 x3
%      (2  4  8)
%  X = (1  9  3)
%      (6  2  7)
%
%  In this case Y = GRIDEVALUATE(OPTIMSTORE, X) will evaluate objectives
%  and constraints at the following points, 
%
%  A  B  X1  X2  X3
%  4  5  2   4   8
%  4  5  1   9   3
%  4  5  6   2   7
%  1  3  2   4   8
%  1  3  1   9   3
%  1  3  6   2   7
%  
%  Y will be a 3 by 4 by 2 matrix, where
%                
%  Y(:, 1, 1) = Values of 01 at A = 4, B = 5 
%  Y(:, 2, 1) = Values of 02 at A = 4, B = 5
%  Y(:, 3, 1) = Values of C1 at A = 4, B = 5
%  Y(:, 4, 1) = Values of C2 at A = 4, B = 5
%  Y(:, 1, 2) = Values of 01 at A = 1, B = 3 
%  Y(:, 2, 2) = Values of 02 at A = 1, B = 3
%  Y(:, 3, 2) = Values of C1 at A = 1, B = 3
%  Y(:, 4, 2) = Values of C2 at A = 1, B = 3
%
%  Y = GRIDEVALUATE(OPTIMSTORE, X, OBJCONNAME) evaluates the
%  objectives/constraints specified in the cell array of strings,
%  OBJCONNAME, as described above. Note that the return matrix will be of
%  size, SIZE(X, 1) by LENGTH(OBJCONNAME) by NPTS
%
%  Y = GRIDEVALUATE(OPTIMSTORE, X, OBJCONNAME, DATASETNAME) evaluates the
%  objectives/constraints as described above. The evaluation is performed
%  at the operating points in the data set specified by the string
%  DATASETNAME. Note that the return matrix will be of size, SIZE(X, 1) by
%  LENGTH(OBJCONNAME) by NPTS, where NPTS is the number of points in the
%  data set specified by DATASETNAME. 
%
%  Y = GRIDEVALUATE(OPTIMSTORE, X, OBJCONNAME, DATASETNAME, ROWIND)
%  evaluates the specified objectives/constraints at the points of
%  DATASETNAME given by ROWIND as described above. Y is a LENGTH(ROWIND) by
%  LENGTH(OBJCONNAME) by NPTS matrix.
%
%  See also EVALUATE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 06:54:27 $ 

objconname = [];
rowind = [];
dsname = [];

if nargin > 2
    objconname = varargin{1};
end

if nargin > 3
    dsname = varargin{2};
end

if nargin > 4
    rowind = varargin{3};
end
    
[yvector, ysums] = eval(optimstore.cgoptim, 'eval', X , objconname, dsname, rowind, 1);

% do rearrangement here for the gridding case
if ~isempty(X) 
    Nevalpoints = size(X,1);
    Ntotal = size(yvector,1);
    Nobjectives = size(yvector,2);
    
    Ndatasetpoints = Ntotal/Nevalpoints;
    
    y = zeros(Nevalpoints, Nobjectives, Ndatasetpoints);
    for k = 1:Ndatasetpoints
        %kth datapoint
        for i =1 :Nevalpoints
            %ith evalpoint 
            y(:,:, k) = yvector(k:Ndatasetpoints:end, :);
        end
    end    
else
    y = yvector;
end
