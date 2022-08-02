function [y, ysums] = gridpevevaluate(optimstore, X, varargin)
%GRIDPEVEVALUATE Grid evaluation of prediction error variance (PEV)
%
%  Y = GRIDPEVEVALUATE(OPTIMSTORE, X) evaluates PEV for the objectives and
%  constraints at all combinations of the points in the 'Primary' data set,
%  P, with X. The return matrix, Y, is of size SIZE(X, 1) by (NOBJ+NCON) by
%  NPTS, where NOBJ is the number of objectives, NCON is the number of
%  constraints and NPTS is the number of rows in P. Further, Y(I, J, K) is
%  the value of the J-th objective/constraint at X(I, :) and P(K, :).
%
%  Y = GRIDPEVEVALUATE(OPTIMSTORE, X, OBJCONNAME) evaluates PEV for the 
%  objectives/constraints specified in the cell array of strings,
%  OBJCONNAME, as described above. Note that the return matrix will be of
%  size, SIZE(X, 1) by LENGTH(OBJCONNAME) by NPTS
%
%  Y = GRIDPEVEVALUATE(OPTIMSTORE, X, OBJCONNAME, DATASETNAME) evaluates PEV
%  for the objectives/constraints as described above. The evaluation is
%  performed at the operating points in the data set specified by the
%  string DATASETNAME. Note that the return matrix will be of size, SIZE(X,
%  1) by LENGTH(OBJCONNAME) by NPTS, where NPTS is the number of points in
%  the data set specified by DATASETNAME. 
%
%  Y = GRIDPEVEVALUATE(OPTIMSTORE, X, OBJCONNAME, DATASETNAME, ROWIND)
%  evaluates PEV for the specified objectives/constraints at the points of
%  DATASETNAME given by ROWIND as described above. Y is a LENGTH(ROWIND) by
%  LENGTH(OBJCONNAME) by NPTS matrix.
%
%  See also PEVEVALUATE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.6.1 $    $Date: 2004/02/09 06:54:28 $ 

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
    
yvector = eval(optimstore.cgoptim, 'pev', X , objconname, dsname, rowind, 1);

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
