function [AllCF, IsTreeDate, AllDates, AllTF, AllInd, PriceObsInd, RateObsInd, DiscFrac ] = bintreetime(CFAmounts, CFDates, CFTimes, TreeDates, TreeTimes)
%BINTREETIME Map instrument cash flows to the time structure of an Binary tree.
%  Subroutine for OPTSTOCKBYBINTREE, etc.
% 
%   This is a private function that is not meant to be called directly
%   by the user.
%
%   [AllCF, IsTreeDate, AllDates, AllTimes, AllInd, ...
%    PriceObsInd, RateObsInd, DiscFrac] = ...
%       bintreetime(CFAmounts, CFDates, CFTimes, TreeDates, TreeTimes) 
%
% Inputs:
%   CFAmounts - NINST x NCFS matrix of instrument cash flow amounts.
%   CFDates   - NINST x NCFS matrix of instrument cash flow dates.
%   CFTimes   - NINST x NCFS matrix of instrument cash flow times
%
%   TreeDates - NLEVELS+1 x 1 vector of tree observation dates along with
%               the maturity date of the last forward rate.
%   TreeTimes - NLEVELS+1 x 1 vector of tree times.
%
% Outputs:
%   AllCF      - NINST x NUMDATES matrix of all instrument cash flows
%   IsTreeDate - 1 X NUMDATES mask is 1 on a tree node date
%   AllDates   - NUMDATES x 1 list of cash flow dates
%   AllTimes   - NUMDATES x 1 list of cash flow times
%   AllInd     - NINST x NCFS index of instrument locations in columns of AllCF
%
%   PriceObsInd - 1 x NUMDATES cash flows belong to this price observation
%   RateObsInd  - 1 x NUMDATES cfs discount using this spot rate observation
%
%   DiscFrac - 1 x NUMDATES-1 Power fraction of the RateObsInd discount
%              to use between this date and the following date in the dynamic
%              programming.  The sum of the DiscFrac values over a tree interval
%              is 1.  At each timestep you use Disc.^DiscFrac(iObs) so that the
%              product of the fractional discounts over a tree interval is Disc.
%

%   Author(s): M. Reyes-Kattar 01-Nov-2002
%   Copyright 1998-2003 The MathWorks, Inc. 
%   $Revision: 1.1.6.1 $  $Date: 2003/08/29 04:46:12 $

%--------------------------------------------------------
% Add the tree times to the cash flows for mapping
%--------------------------------------------------------
CFAmounts = finargcat(1,CFAmounts,ones(1,length(TreeDates)));
CFDates = finargcat(1,CFDates, TreeDates');
CFTimes = finargcat(1,CFTimes, TreeTimes');

% map out all the cash flows 
[AllCF, AllDates, AllTF, AllInd] = cfport(CFAmounts, CFDates, CFTimes);

% strip the tree times back off
TreeInd = AllInd(end,:);
AllInd = AllInd(1:end-1,:);
TreeInd = TreeInd(~isnan(TreeInd));

IsTreeDate = logical( AllCF(end,:) );
AllCF = AllCF(1:end-1,:);

%---------------------------------------------------------------------
% Map all the cash flows to their proper places in the tree
% PriceObsInd [1 x NT] cash flow events belong to this price observation 
% RateObsInd  [1 x NT] cash flow events use this spot rate observation
% 
% DiscFrac [1 x NT-1] power fraction of the RateObsInd discount to use between
%                     this time and the following time.  The sum of the
%                     DiscFrac values over a tree interval is 1.  At each cf
%                     timestep you use Disc.^DiscFrac(iObs) so that the product
%                     of cf timesteps over a tree interval is Disc.
%---------------------------------------------------------------------
PriceObsInd = cumsum(IsTreeDate);
RateObsInd = min(PriceObsInd, length(TreeTimes)-1);

dtRate = diff(AllTF(IsTreeDate))'; % lengths of intervals for each rate obs
dtRate = dtRate(RateObsInd(1:end-1)); % find this for every cf interval
dtAll  = diff(AllTF'); % row lengths of intervals between cf events

DiscFrac = (dtAll./dtRate);



