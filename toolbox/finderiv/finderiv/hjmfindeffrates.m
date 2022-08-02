function Rates = hjmfindeffrates(HJMTree, StartTime, EndTime)
% HJMFINDEFFRATES Calculate the effective rate between two tree levels.
%
%   This is a private function that is not meant to be called directly
%   by the user.
%
% Inputs:
% 	HJMTree		- HJMTree containing rates
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
%   $Revision: 1.2 $  $Date: 2002/04/14 16:38:25 $

%-----------------------------------------------------------------
% Checking inputs
%-----------------------------------------------------------------
if ~isafin(HJMTree,'HJMFwdTree')
  error('The first argument must be an HJM tree created by HJMTREE');
end

if (nargin < 3),
  error('You must pass at least three input arguments')
end

if(length(StartTime) ~=1 | length(EndTime) ~=1)
    error('StartTime and EndTime must be scalars')
end

% Find Tree Times;
TreeTimes = [HJMTree.tObs'; HJMTree.CFlowT{end}];

% if(StartTime > TreeTimes(end) | EndTime < TreeTimes(1))
%     error(sprintf('StartTime and EndTime must be in the interval [%d, %d]', TreeTimes(1), TreeTimes(end)));
% end

% Obtain tree shape information:
[NumLevels, NumChild, NumPos, NumStates] = bushshape(HJMTree.FwdTree);

% Define price-tree info
NumStates = [NumStates NumStates(end)];
NumChild =  [NumChild(1:end-1) 1, 0];

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
    tDisc = findeffdisc(HJMTree, NumChild, TreeTimes, jrObs, Times(iInt), Times(iInt+1));
    
    % Find cummulative discount (if not the first segment)
    if(~isempty(CummDisc))
	    CummDisc = tDisc .* CummDisc;
    else
        CummDisc = tDisc;
    end
    
    if(iInt < (length(Times)-1))
        % Expand to look like next node:
        tPos = find(TreeTimes == Times(iInt+1));
        if ~isempty(tPos)
            cObsInd = tPos;
        else
            cObsInd = jrObs;
        end
        CummDisc = (ones(NumChild(cObsInd),1) * CummDisc)';
        CummDisc = CummDisc(:)';
    end
    
end
    
% Calculate effective rates
if(~isempty(CummDisc))
	Rates = disc2rate(HJMTree.RateSpec.Compounding, CummDisc, EndTime, StartTime);
end

return


function TotalDisc = findeffdisc(HJMTree, NumChild, TreeTimes, ind, StartTime, EndTime)

if all(ismember([StartTime EndTime],TreeTimes))
    TotalDisc = 1 ./ HJMTree.FwdTree{ind}(1,:);  	  	     
else
    if(StartTime>=TreeTimes(end))
        % The last leg starts at the end of the tree and end
        % in EndTime. We will hit this point if the instrument
        % requires the interest rate after the last maturity
        % of the tree. We will assume constant interest rates,
        % but this is not an arbitrage-free assumption.
        warning('Instrument maturity exceeds last maturity of the tree')
        ExpFrac = (EndTime-StartTime)/(TreeTimes(end) - TreeTimes(end-1));
        TotalDisc = (1 ./ HJMTree.FwdTree{end}(1,:)) .^ ExpFrac;
        
        % Since we are to the right of the tree, we should not
        % expand the nodes of the tree. Make ind point to 1.
        ind = length(NumChild)-1;
    else
        % If StartTime and EndTime are not at least one tree
        % period apart, return the discount from StartTime to
        % EndTime. We are assuming constant interest rate between 
        % tree nodes,which is not an arbitrage-free assumption.         
        ExpFrac = (EndTime-StartTime)/(TreeTimes(ind+1) - TreeTimes(ind));
        TotalDisc = (1 ./ HJMTree.FwdTree{ind}(1,:)) .^ ExpFrac;    
    end
end

% We need to expand TotalDisc to match the dimensions of the 
% next tree level
TotalDisc = (ones(max(1,NumChild(ind)),1) * TotalDisc)';
TotalDisc = TotalDisc(:)';       


