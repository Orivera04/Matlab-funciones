function [AllCF, IsTreeDate, AllDates, AllTF, AllInd, PriceObsInd, RateObsInd, DiscFrac ] = bdttreetime(CFAmounts, CFDates, CFTimes, TreeDates, TreeTimes)
%BDTTREETIME Map instrument cash flows to the time structure of a BDT tree.
%  Subroutine for BONDBYBDT, CFBYBDT, CAPBYBDT, etc.
% 
%   [AllCF, IsTreeDate, AllDates, AllTimes, AllInd, ...
%    PriceObsInd, RateObsInd, DiscFrac] = ...
%         bdttreetime(CFAmounts, CFDates, CFTimes, TreeDates, TreeTimes) 
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
%     to use between this date and the following date in the dynamic
%     programming.  The sum of the DiscFrac values over a tree interval
%     is 1.  At each timestep you use Disc.^DiscFrac(iObs) so that the
%     product of the fractional discounts over a tree interval is Disc.
%
%
% Example:
%   If a tree interval with discount, Disc, is broken up into 1/4 and 3/4
%   parts (DiscFrac = [1/4, 3/4], then the total discount over the
%   interval is Disc^(1/4) * Disc^(3/4) =  Disc^( 1/4 + 3/4 ) = Disc.
%

%   Author(s): M.Reyes-Kattar 5-Dec-2000
%   Copyright 1998-2002 The MathWorks, Inc. 
%   $Revision: 1.3 $     $Date: 2002/04/14 16:39:46 $

% ---------------------------------------------------
% Just call the HJM equivalent since they are similar
[AllCF, IsTreeDate, AllDates, AllTF, AllInd, PriceObsInd, RateObsInd, DiscFrac ] = ...
	hjmtreetime(CFAmounts, CFDates, CFTimes, TreeDates, TreeTimes);