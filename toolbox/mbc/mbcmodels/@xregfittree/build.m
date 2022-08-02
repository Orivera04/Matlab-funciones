function varargout = build( Tree, varargin )
%XREGFITTREE/BUILD  Build a regression tree for RBF fitting
%  TREE = BUILD(TREE,<OPTIONS>) build a regression tree model for the data in 
%  TREE.
%
%  Options:
%  --------
%  MinPerPanel,      integer, default 2.
%     Minimum number of data points in a panel that is allowed to be split.
%  MaxNPanels,       integer, default Inf.
%     Maximum number of panels allowed in the tree.
%  PanelSize,        {'Cover'}|'Shrink', 
%     How the sizes of the child panels are determined from the parent. 'Cover' 
%     means that the total size of the two children should be equal to that of 
%     the parent. 'Shrink' means that the sizes of the child panels should be 
%     dictated by the data they contain. While this option would have no effect 
%     if the tree was being built as a regression tree model, it will effect of 
%     the RBF widths when it is being used to guide the construction of an RBF 
%     model.
% 
%  The overall syntax to build a model is 
%     tree = xregfittree( xdata, ydata );
%     tree = build( tree );
% 
%  See also XREGFITTREE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.3.6.1 $ 

% Default values for user options
MinPerPanel = 2;
MaxNPanels = Inf;
PanelSize = 'Cover';

% Get user options
if ~mod( nargin, 2 ), % i.e., if nargin is even
    error( 'Parameters and values must occur in pairs' );
end

for i = 1:2:(nargin-1),
    if strcmpi( varargin{i}, 'MinPerPanel' ),
        MinPerPanel = varargin{i+1};
    elseif strcmpi( varargin{i}, 'MaxNPanels' ),
        MaxNPanels = varargin{i+1};
    elseif strcmpi( varargin{i}, 'PanelSize' ),
        PanelSize = varargin{i+1};
    else
        error( sprintf( 'Unknown option ''%s''', varargin{i} ) );
    end
end

nDim  = size( Tree.XData, 2 );

TwoMinPerPanel = 2 * MinPerPanel;

panel = 1;
Tree.UserData{1} = 0;
while ~isempty( panel ) & length( Tree.Parent ) < MaxNPanels,
    %
    % Find best place to split node
    % -----------------------------
    first = Tree.First(panel);
    last = Tree.Last(panel);
    
    bestCost = Inf;
    bestIData = 0;
    splitIndex  = 0;
    splitReorder = [];
    for iDim = 1:nDim,
        xData = Tree.XData(first:last,:);
        yData = Tree.YData(first:last);
        nData = size( xData, 1 );
        
        % sort data by coordinate in this dimension
        [junk, ind] = sort( xData(:,iDim) );
        xData = xData(ind,:);
        yData = yData(ind);
        
        % initialize totals of left and right subsets
        leftTotal  = sum( yData(1:MinPerPanel-1) );
        rightTotal = sum( yData(MinPerPanel:end) );
        
        % try all possible splits
        for iData = MinPerPanel:(nData-MinPerPanel), 
            % try split between iData and iData+1
            % the iData point gets moved from the right subset to the left subset
            nLeft  = iData;
            nRight = nData - iData;
            leftTotal  = leftTotal  + yData(iData);
            rightTotal = rightTotal - yData(iData);
            leftMean  = leftTotal  /nLeft;
            rightMean = rightTotal /nRight;
            
            %% diff = yData - [ leftMean(ones( nLeft, 1 )); rightMean(ones( nRight, 1 )) ];
            diff = [ yData(1:nLeft) - leftMean; yData(nLeft+1:end) - rightMean ];
            cost = sum( diff .* diff );
            if cost < bestCost,
                bestCost = cost;
                splitDim = iDim;
                splitPoint = 0.5 * ( xData(iData,iDim) + xData(iData+1,iDim) );
                splitIndex  = iData;
                leftPoints = ind(1:iData);
                rightPoints = ind(iData+1:end);
            end
        end
    end
    
    %
    % Split node
    % ----------
    Tree = split( Tree, panel, splitDim, {leftPoints, rightPoints}, PanelSize );
    
    %
    % Work out costs for new panels
    % -----------------------------
    [child1, child2] = getchildren( Tree, panel );
    setuserdata( Tree, child1, pr_VarianceCost( Tree, child1 ) );
    setuserdata( Tree, child2, pr_VarianceCost( Tree, child2 ) );
    setuserdata( Tree, panel, 0.0 );

    setsplitable( Tree, [child1; child2], ...
        getndata( Tree, [child1; child2] ) >= TwoMinPerPanel );

    %
    % Find next panel to split
    % ------------------------
    tmp = find( Tree.Splitable );
    [null, ind] = max( [ Tree.UserData{tmp} ] );
    panel = tmp(ind);
end

% remove the user data
Tree.UserData = cell( size( Tree.Parent ) );

% all done, assign outputs and return
if nargout == 1
    varargout{1} = Tree;
elseif isvarname( inputname(1) ),
    assignin( 'caller', inputname(1), Tree );
end

return

%     leftTotal  = cumsum( yData );
%     rightTotal = leftTotal(end) - leftTotal;
%     leftMean  = leftTotal ./(1:nData);
%     rightMean = rightTotal./(nData:-1:1);

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|

