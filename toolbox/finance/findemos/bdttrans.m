function [TreeMat, TreeTimes] = bdttrans(Tree)
% BDTTRANS Translate a tree returned by BDTBOND.
% Unpack and convert a Short Discount tree structure to a Short Rate tree,
% or a Price tree structure to a Clean Price tree.  The output is a matrix
% of tree node values and a vector of node times.
%
% Usage:
%   [TreeMat, TreeTimes] = bdttrans(Tree)
%   bdttrans(Tree)
% 
% Inputs:
%   Tree : Tree structure returned by BDTBOND.
%
% Outputs
%   TreeMat : [NSTATES by NTIMES] Converted matrix of Short Rate or
%   Clean Price values at points on the tree.  Time layers are
%   columns containing the different states.  Unused entries of the
%   matrix are screened with NaN's
%
%   TreeTimes: [1 by NTIMES] Vector of times corresponding to
%   layers of TreeMat. 
% 
% If BDTTRANS is called without output arguments, it plots the translated
% tree against the time axis in coupon intervals.
%
% See also BDTBOND, PLOTBINTREE
% 

%   Author: J. Akao, 05-18-98
%   Copyright 1995-2002 The MathWorks, Inc.  
%   $Revision: 1.6 $   $Date: 2002/04/14 21:47:11 $ 

%----------------------------------------------------------------
if ~isa(Tree,'struct')
  error('Input must be a tree structure from BDTBOND');
else
  [NStates, NTimes] = size(Tree.Values);
end

%----------------------------------------------------------------
% Convert Tree to times and values
% PlotVals  : [NStates by NTimes] tree of values 
% PlotTimes : [1 by NTimes] vector of times
%----------------------------------------------------------------
switch( Tree.Type )
  case 'Short Discount'
    % D = (1 + r/F)^(-dt)
    ShortDiscounts = Tree.Values;
    TreeIntervals = [1, diff(Tree.Times)];
    TreeIntervals = TreeIntervals(ones(NStates,1),:);
    Freq = Tree.Frequency;
    
    % Short rates
    TreeMat = Freq*( ShortDiscounts.^(-1./TreeIntervals) - 1 );
    TreeMat(1,1) = TreeMat(1,2); 
    
    TreeTimes = Tree.Times;
    
  case 'Price'
    % Clean Price = Value - Accrued Interest - Coupons
    BondOpt = Tree.Values;
    Coupons = Tree.Coupons;
    AccrInt = Tree.AccrInt;
    
    % You don't get the coupon if you buy on a date
    % You also pay accrued interest
    TreeMat = BondOpt - Coupons(ones(NStates,1),:) - ... 
        AccrInt(ones(NStates,1),:);
    
    TreeTimes = Tree.Times;

  otherwise
    error('Tree type not recognized')
end

%----------------------------------------------------------------
% either create outputs or data
%----------------------------------------------------------------
if nargout==0
  % call findemos/plotbintree to make the plot
  plotbintree(TreeMat, TreeTimes);
  clear TreeMat;
end

