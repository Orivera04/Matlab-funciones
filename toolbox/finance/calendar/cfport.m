function [CFBondDate, AllDates, AllT, IndByBond, CFBondDate2] = cfport(AmountMat, DateMat, TMat)
%CFPORT Portfolio form of cash flow amounts.
%   This function computes a vector of all cash flow dates of a bond portfolio, 
%   and a matrix mapping the cash flows of each bond to those dates.  Use the 
%   matrix for pricing the bonds against a curve of discount factors.
% 
%   [CFBondDate, AllDates, AllTF, IndByBond] = cfport(...
%                                         CFlowAmounts, CFlowDates, TFactors)
%   
%   Inputs
%     CFlowAmounts - NUMBONDS by M matrix with entries listing cash flow 
%     amounts corresponding to each date in CFlowDates.  
%
%     CFlowDates   - NUMBONDS by M matrix with rows listing cash flow dates 
%     for each bond and padded with NaNs.  
%
%     TFactors     - NUMBONDS by M matrix with entries listing the time
%     between settlement and the cash flow date measured in semi-annual
%     coupon periods.  
%
%   Outputs
%     CFBondDate - NUMBONDS by NUMDATES matrix of cash flows indexed by
%     bond and by date in AllDates.  Each row contains a bond's cash flow
%     values at the indices corresponding to entries in AllDates.  Other
%     indices in the row contain zeros.  
%
%     AllDates   - NUMDATES by 1 list of all dates that have any cash flow
%     from the bond portfolio. 
%
%     AllTF      - NUMDATES by 1 list of time factors corresponding to the
%     dates in AllDates.  If TFactors is not entered, AllTF contains the
%     number of days from the first date in AllDates.
%
%     IndByBond  - NUMBONDS by NUMDATES matrix of indices.  The ith row
%     contains a list of indices into AllDates where the ith bond has cash
%     flows.  Since some bonds have more cash flows than others, the matrix
%     is padded with NaN's.  
%
%   See also CFAMOUNTS

%   Author(s): J. Akao, 10-15-1998
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.9 $  $Date: 2002/04/14 21:51:21 $

%-----------------------------------------------------------------------
% Inputs have the same shape and NaN locations
%   DateMat   - NumBonds by MaxCFperBond padded with NaNs
%   TMat      - NumBonds by MaxCFperBond padded with NaNs
%   AmountMat - NumBonds by MaxCFperBond padded with NaNs
%-----------------------------------------------------------------------

[NumBonds, MaxCFperBond] = size(DateMat);
if nargin<3,
  TMat = DateMat - min(min(DateMat));
end

%-----------------------------------------------------------------------
% Use the date matrix to find the unique dates and times
% Create AllDates, AllT, and IndByBond
%-----------------------------------------------------------------------
% mask for non-nan entries in DateMat, AmountMat, and TMat
DateMask = ~isnan(DateMat); 

% Screen out the unused NaN entries from the inputs, leaving column
% vectors mapped to the matrices with DateMask.
% A date and time can appear more than once in the vectors.
DateSet   =   DateMat(DateMask);
TSet      =      TMat(DateMask);
AmountSet = AmountMat(DateMask);

% Ensure that the sets are columns; if DateMat is a row you get a row.
DateSet = DateSet(:);
TSet = TSet(:);
AmountSet = AmountSet(:);

% Get the unique dates and a map: AllDates(IndexSet) = DateMat(DateMask)
[AllDates, IndUnique, IndexSet] = unique(DateSet);

% Pull the times from the same locations as the unique dates
% Assume the times are in one-to-one correspondance with the dates
AllT = TSet( IndUnique );

% Change IndexSet from a vector of all cash flows to a matrix by bond
% Reverse the map: AllDates(IndexSet) = DateMat(DateMask)
IndByBond = NaN*ones(NumBonds, MaxCFperBond);
IndByBond(DateMask) = IndexSet;

%-----------------------------------------------------------------------
% Create the expanded matrix of cash flows
% Map the amounts into CFBondDate with an indexing step
%
% for i=1:NumBonds,
%  % put the non-NaN row in the matrix
%  CFBondDate( i, IndByBond(i,DateMask(i,:)) ) = AmountMat(i,DateMask(i,:));
% end
%
% Build a map from IndByBond
% IndByBond - NumBonds by MaxCFperBond gives the column in CFBondDate
% BondRow   - NumBonds by MaxCFperBond gives the row in CFBondDate
% CFInd     - location of each cash flow: Row + NumBonds*(Col-1) 
%-----------------------------------------------------------------------
NumDates = length(AllDates);
CFBondDate = zeros(NumBonds, NumDates);

% Build BondRow matrix and find the rows of each cash flow
BondRow = (1:NumBonds)';
BondRow = BondRow(:,ones(1,MaxCFperBond));
RowSet = BondRow(DateMask);

% What if several cash flows go to the same date from a single instrument?
%  A = [1 NaN 2; 3 4 NaN]; d = [1 NaN 3; 2 2 NaN]
% 
CFBondDate = sparse( RowSet, IndexSet, AmountSet);
CFBondDate = full(CFBondDate);

%-----------------------------------------------------------------------
% Diagnostic and old code
%-----------------------------------------------------------------------

%-----------------------------------------------------------------------
% The old way does not sum cash flows hitting the same location
% make the nan-padded index set into CFBondDate
CFInd = RowSet(:) + NumBonds*( IndexSet - 1);

% % write the cash flow amounts into CFBondDate
% % CFBondDate( CFInd(DateMask) ) = AmountMat( DateMask );
CFBondDate2 = zeros(NumBonds, NumDates);
CFBondDate2( CFInd ) = AmountSet;
%-----------------------------------------------------------------------

%-----------------------------------------------------------------------
% Non-sparse alternative chews up too much memory for a big portfolio
%
% N = sum(DateMask(:))
% Mem = NumBonds*NumDates*N
% Map = zeros(NumBonds*NumDates, N);
% MapLoc = CFInd + NumBonds*NumDates*(0:N-1)';
% Map(MapLoc) = 1;
% CFBondDate(:) = Map*AmountSet;
