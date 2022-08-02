function [InterpTimes, CFIndex, InterpDates] = ...
    mktreetimes(TFactors, Accuracy, CFlowDates) 
% MKTREETIMES node times for an bond option pricing tree
% Place Accuracy intervals within each regular coupon period
% (length 1) defined by TFactors.  Round the interval lengths in
% odd length periods. 
%
% [InterpTimes, CFIndex, InterpDates] = ...
%    createtreetimes(TFactors, Accuracy, CFlowDates) 
%
% InterpTimes is the set of times for the tree in coupon periods
% (the same as TFactors).
% InterpDates is the set of (rounded) dates for the tree nodes.
%
% CFIndex is the set of indices in TreeTimes of the original TFactors.
% CFIndex is the same length as TFactors.
%
% Private function not indended for calling by the user

%Author: C. Bassignani, 04-18-98
%        J. Akao        05-10-98
%   Copyright 1995-2002 The MathWorks, Inc. 
%$Revision: 1.6 $   $Date: 2002/04/14 21:47:47 $ 

% Treetimes are used to determine the intervals.
% Dates are along for the ride

%length of each bond interval (row)
BondIntervals = diff(TFactors); 
DateIntervals = diff(CFlowDates);

% number of tree intervals fitting in each bond interval
NumNodesPerInt = max( 1, round(BondIntervals*Accuracy) ); 

% length of the tree time periods within each bond interval
TreeIntervals = BondIntervals./NumNodesPerInt;
ApproxDateInt = DateIntervals./NumNodesPerInt;

% Locations of TFactors in cumsum(TreeTimes)

% replicate each bond interval
% NumReplicas has columns of NumNodesPerInt
% ReplicaCount has columns of 1, 2, .. max(NumReplicas)
% TreeReplicas has coluns of TreeIntervals
CountPerInt = ( 1:max(NumNodesPerInt) );
[NumReplicas, ReplicaCount] = meshgrid(NumNodesPerInt, CountPerInt);
ReplicaMask = ( ReplicaCount <= NumReplicas );
TreeReplicas = TreeIntervals( ones(max(NumNodesPerInt),1), : );
DateReplicas = ApproxDateInt( ones(max(NumNodesPerInt),1), : );

% Mask each column of replicas to get the length of every interval
% between nodes of the tree.
TreeTimes = TreeReplicas( ReplicaMask );
DateTimes = DateReplicas( ReplicaMask );

% Accumulate the interval lengths to get the actual times
% InterpTimes and InterpDates
InterpTimes = cumsum( [TFactors(1); TreeTimes(:)] );
InterpDates = round( cumsum( [CFlowDates(1); DateTimes(:)] ) );

% Get the indices in InterpTimes and InterpDates of the original
% TFactors and CFlowDates
CFIndex = cumsum([1; NumNodesPerInt(:)]);

% To eliminate roundoff effects, go back and patch in the original
% values. 
InterpTimes( CFIndex ) = TFactors';
InterpDates( CFIndex ) = CFlowDates';

