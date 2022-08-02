function Rates = bdtfindeffrates(BDTTree, StartTime, EndTime)
% BDTFINDEFFRATES Calculate the effective rate between two tree levels.
%
%   This is a private function that is not meant to be called directly
%   by the user.
%
% Inputs:
% 	BDTTree		- BDTTree containing rates.
%   StarTime	- Scalar indicating the StartTime.
%   EndTime     - Scalar indicating the EndTime.
%                   
% Outputs:
%  	Rates       - 1 x NStates vector holding the effective rates
%                   between StartTime and EndTime. NStates is the 
%                   number of states at the tree level falling in 
%                   EndTime.
%

%   Author(s): M. Reyes-Kattar, 03/01/2001
%   Copyright 1998-2002 The MathWorks, Inc. 
%   $Revision: 1.4 $  $Date: 2002/04/14 16:40:10 $

%-----------------------------------------------------------------
% Checking inputs
%-----------------------------------------------------------------
if ~isafin(BDTTree,'BDTFwdTree')
  error('The first argument must be a BDT tree created by BDTTREE');
end

if (nargin < 3),
  error('You must pass at least three input arguments')
end

if(length(StartTime) ~=1 | length(EndTime) ~=1)
    error('StartTime and EndTime must be scalars')
end

% Find Tree Times;
TreeTimes = [BDTTree.tObs'; BDTTree.CFlowT{end}];

% Obtain tree shape information:
[NumLevels, NumPos] = treeshape(BDTTree.FwdTree);


% Find the elements of the TreeTimes vector occurring between
% StartTime and EndTime
TTimesInd = find(TreeTimes >= StartTime & TreeTimes <= EndTime);
Times = union([StartTime EndTime], TreeTimes(TTimesInd));

% Calculate the effective discount for each time-to-time interval
CummDisc = [];
tDisc = [];
for iInt = 1:(length(Times)-1)
    
    % Find index to previous level
    jrObs = find(TreeTimes <= Times(iInt));
	jrObs = jrObs(end);
    
	% Find Discount for this segment        
    tDisc = findeffdisc(BDTTree, TreeTimes, jrObs, Times(iInt), Times(iInt+1));
    
    % Find cummulative discount (if not the first segment)
    if(~isempty(CummDisc))
		if(size(CummDisc,2) < size(tDisc,2))
			CummDisc = [CummDisc CummDisc(end)];
		end
	    CummDisc = tDisc .* CummDisc;
    else
        CummDisc = tDisc;
    end
    
end

    
% Calculate effective rates
if(~isempty(CummDisc))
	Rates = disc2rate(BDTTree.RateSpec.Compounding, CummDisc, EndTime, StartTime);
end

return


function TotalDisc = findeffdisc(BDTTree, TreeTimes, ind, StartTime, EndTime)

if all(ismember([StartTime EndTime],TreeTimes))
    TotalDisc = 1 ./ BDTTree.FwdTree{ind};		
else
    if(StartTime>=TreeTimes(end))
        % The last leg starts at the end of the tree and ends
        % in EndTime. We will hit this point if the instrument
        % requires the interest rate after the last maturity
        % of the tree. We will assume constant interest rates,
        % but this is not an arbitrage-free assumption.
        warning('Instrument maturity exceeds last maturity of the tree')
        ExpFrac = (EndTime-StartTime)/(TreeTimes(end) - TreeTimes(end-1));
        TotalDisc = (1 ./ BDTTree.FwdTree{end}) .^ ExpFrac;
        
        % Since we are to the right of the tree, we should not
        % expand the nodes of the tree.
        ind = length(BDTTree.FwdTree);
    else
        % If StartTime and EndTime are not at least one tree
        % period apart, return the discount from StartTime to
        % EndTime. We are assuming constant interest rate between 
        % tree nodes,which is not an arbitrage-free assumption.         
        ExpFrac = (EndTime-StartTime)/(TreeTimes(ind+1) - TreeTimes(ind));
        TotalDisc = (1 ./ BDTTree.FwdTree{ind}) .^ ExpFrac;    
    end
end

% We may need to expand TotalDisc to match the dimensions of the 
% next tree level
if(EndTime <= TreeTimes(end-1))
	% TotalDisc = [TotalDisc TotalDisc(end)];
	
	% Find rates corresponding to discount - apply averaging algorithm
	% This will not give us an arbitrage-free rate as recombining trees
	% lose the rate evolution history and we reconstruct it using a simple
	% average.
	Rates = disc2rate(BDTTree.TimeSpec.Compounding, ...
		TotalDisc, EndTime, StartTime);	
	
	colIdx = 1:length(Rates);
	Idx = [1 colIdx; colIdx colIdx(end)];
	
	TotalRates = [0.5 0.5] * Rates(Idx);
	TotalDisc = rate2disc(BDTTree.TimeSpec.Compounding, ...
		TotalRates, EndTime, StartTime);		

end



