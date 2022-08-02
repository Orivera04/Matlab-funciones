function [dataInds, designInds] = getClusters(design, data, tol)
% [DATAINDS, DESIGNINDS] = GETCLUSTERS(DESIGN, DATA, TOL)

% CLUSTERS is a cellarray of clusters {[2x1 cell], [2x1 cell], .... }
% each [2x1 cell] is {[designInds]; [dataInds]}
% ADJACENCYMATRIX has numRows = numDesignPoints, numCols = numDataPoints
% ones label where adjacency occurs
% 

% [CLUSTERS, ADJACENCYMATRIX, MDESI, MDATI, UNMDESI, UNMDATI] = GETCLUSTERS(DESIGN, DATA, TOL)
% MDESI matched design indices
% MDATI matched data indices
% UNMDESI unmatched design indices
% UNMDATI unmatched data indices

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.3.6.1 $  $Date: 2004/02/09 08:20:42 $

designByData = [];
clusters = {};

%% ==== FIND THE EDGES FOR THE ADJACENCY MATRIX =====

%% data has records as rows, columns are factors
[numDesign, numDesignFactors] = size(design);
[numData, numDataFactors] = size(data);

%% check that tolerance has an entry for each dim and sizes are consistent
if ~(isnumeric(tol) & numDesignFactors==numDataFactors & length(tol)==numDesignFactors)
   return
end
% initialize output to be a logical array
designByData = false(numDesign, numData);
tolMtx = repmat(tol(:)', numData, 1);

%% check for "closeness" to each design point in turn
for thisDesPoint = 1:numDesign
   reppdThisDesPoint = repmat(design(thisDesPoint, :),[numData,1]);
   distToData = abs( data - reppdThisDesPoint );
   designByData(thisDesPoint,:) = all(distToData < tolMtx, 2)';
end

%% ==== FIND THE CLUSTERS =====

[numDesign, numData] = size(designByData);
%clusters = {};
dataInds = {};
designInds = {};
% The only rows worth looking at
LRowInd = any(designByData,2);

while any(LRowInd)
   %% set LDesignInds = [0 0 0 0 0]
   LDesignInds = false(numDesign,1);
   LDataInds = false(numData,1);
   %% label the starting row
   LDesignInds(min(find(LRowInd))) = true;
   
   while 1
      %% look for data adjacent to points in LDesignInds
      moreDataInds = any(designByData(LDesignInds, :),1);
      %% look for design points adjacent to points in moreDataInds
      moreDesInds = any(designByData(:, moreDataInds),2);
      
      if isequal(moreDesInds,LDesignInds) & isequal(moreDataInds,LDataInds)
         break
      else
         LDesignInds = moreDesInds;
         LDataInds = moreDataInds;
      end
      
   end
   %% remove from LRowInd the design points in this cluster
   LRowInd = LRowInd & ~LDesignInds;
   %% save the designPoints and dataPoints in this cluster (make sure
   %% designInds are horizontal)
   dataInds{end+1} = find(LDataInds);
   designInds{end+1} = find(LDesignInds)';
%   clusters{end+1} = {find(LDesignInds); find(LDataInds)};
%   out{end+1} = {LDesignInds; LDataInds};
end


% ----- find stats -----
numClusters = length(dataInds);
[numDesign, numData] = size(designByData);
%% ----- find lone gunmen -----
unmatchedDesignInds = 1:numDesign;
unmatchedDataInds = 1:numData;
unmatchedDesignInds = setdiff(unmatchedDesignInds, [designInds{:}]);
unmatchedDataInds = setdiff(unmatchedDataInds, [dataInds{:}]);
%% ----- find tribal groups -----
matchedDesignInds = setdiff([1:numDesign], unmatchedDesignInds);
matchedDataInds = setdiff([1:numData], unmatchedDataInds);


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%  ALTERNATIVE IMPLEMENTATION not checking twice any row/column
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% while any(LRowInd)
%    %% set LDesignInds = [0 0 0 0 0]
%    LTotalDesignInds = false(numDesign,1);
%    LTotalDataInds = false(numData,1);
%    %% label the starting row
%    LTotalDesignInds(min(find(LRowInd))) = true;
%    
%    %% initialize LDesignInds with a design point to start building the
%    %% cluster
%    LDesignInds = LTotalDesignInds;
%    while 1
%       %% look for data adjacent to points in LDesignInds
%       LDataInds = any(designByData(LDesignInds, :),1)';
%       %% look for design points adjacent to points in moreDataInds
%       LDesignInds = any(designByData(:, LDataInds),2);
%       
%       if ~any(LDataInds) & ~any(LDesignInds)
%          break
%       else
%          %% design ind to check next iteration are those not already
%          %% checked
%          LnextDesignInds = LTotalDesignInds & ~LDesignInds;
%          %% augment to  running total of design points
%          LTotalDesignInds = LTotalDesignInds | LDesignInds;
%          %% augment the running total of data inds
%          LDataInds = LTotalDataInds | LDataInds;
%          %% give correct name to design inds to be checked in the next
%          %% iteration
%          LDesignInds = LnextDesignInds;
%       end
%       
%    end
%    %% remove from LRowInd the design points in this cluster
%    LRowInd = LRowInd & ~LTotalDesignInds;
%    %% save the designPoints and dataPoints in this cluster
%    out{end+1} = {find(LTotalDesignInds); find(LTotalDataInds)};
% %   out{end+1} = {LDesignInds; LDataInds};
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  ALTERNATIVE IMPLEMENTATION USING INDICES RATHER THAN LOGICAL ARRAYS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% allDesignInds = find(LRowInd);
% out = {};
% 
% while ~isempty(allDesignInds)
%    designInds = allDesignInds(1);
%    dataInds = [];
%    
%    while 1
%       %% find dataPoints that are connected to these designPoints
%   %    [null, moreDataInds] = find(designByData(designInds, :));
%       moreDataInds = find(any(designByData(designInds, :),1));
%       moreDataInds = unique(moreDataInds);
%       %% find designPoints that are connected to these dataPoints
% %      [moreDesInds, null] = find(designByData(:, moreDataInds));
%       moreDesInds = find(any(designByData(:, moreDataInds),2));
%       moreDesInds = unique(moreDesInds);
%       
%       if isequal(moreDesInds,designInds) & isequal(moreDataInds,dataInds)
%          break
%       else
%          designInds = moreDesInds;
%          dataInds = moreDataInds;
%       end
%       
%    end
%    
%    %% kick out the designPoints in this cluster from those we are searching
%    %% over
%    allDesignInds = setdiff(allDesignInds, designInds);
%    %% save the designPoints and dataPoints in this cluster
%    out{end+1} = {designInds; dataInds};
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
