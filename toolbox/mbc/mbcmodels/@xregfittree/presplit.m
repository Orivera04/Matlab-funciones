function data = presplit( Tree, panel, splitDim, splitPoint, PanelSize )
%XREGFITTREE/PRESPLIT  
%  DATA = PRESPLIT(TREE,PANEL,DIM,SPLIT,SIZE) does the necessary computations 
%  required to perform the given split (as per SPLIT) but doesn't actaully 
%  perform the split. This allows the user to perform several possible splits, 
%  choose the best of these and then only implement that best split. The 
%  returned object is a structure with the following fields:
%  
%            Ok: TRUE if split can be made, false otherwise
%         Panel: PANEL.
%      SplitDim: DIM.
%       Centers: the centers of the new tree panels.
%    HalfWidths: the half-widths of the new tree panels.
%   ChildPoints: index into TREE.XData and TREE.YData of the data points that 
%                are in each of the new child panels.
%
%  The way in which PANEL will be split can be specified in three ways.
%  SPLIT = 'Center': the PANEL is split through the center of the panel
%  SPLIT is a scalar: PANEL is split at the given point in the DIM
%  SPLIT is 1 by 2 cell array: SPLIT{1} is an index into the data for PANEL 
%    and specifies those points that will be in the left or lower child. 
%    Similary, SPLIT{2} specifies the data in the right or upper child.
%
%  This function does not alter the tree at all.
%
%  See also XREGFITTREE, XREGFITTREE/SPLIT, XREGFITTREE/POSTSPLIT.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.3.6.1 $ 

nDim  = size( Tree.XData, 2 );

%
% Setup output data structure
% ---------------------------
data = struct( ...
    'Ok', false, ...
    'Parent', panel, ...
    'SplitDim', splitDim, ...
    'Centers', [], ...
    'HalfWidths', [], ...
    'ChildPoints', {{}} );

%
% Check that panel can be split
% -----------------------------
if ~Tree.Splitable(panel),
    data.Ok = false; 
    return
end

%
% Find data points in each panel
% ------------------------------
first = Tree.First(panel);
last  = Tree.Last(panel);

if iscell( splitPoint ),
    leftPoints  = first - 1 + splitPoint{1};
    rightPoints = first - 1 + splitPoint{2};
    splitPoint = 0.5 * ( max( Tree.XData(leftPoints,splitDim) ) ...
        + min( Tree.XData(rightPoints,splitDim) ) );
else
    if ischar( splitPoint ),
        splitPoint = Tree.Center(panel,splitDim);
    end
    
    tmp = Tree.XData(first:last,splitDim) < splitPoint;
    
    leftPoints  = first - 1 + find(  tmp );
    rightPoints = first - 1 + find( ~tmp );
    if isempty( leftPoints ) | isempty( rightPoints ),
        % one child has no data
        data.Ok = false;
        return
    end
end

%
% find centers and widths of the new panels
% -----------------------------------------
switch lower( PanelSize ),
case 'shrink',
    % Shrink to data version
    leftA  = min( Tree.XData(leftPoints,:),  [], 1 ); 
    leftB  = max( Tree.XData(leftPoints,:),  [], 1 ); 
    rightA = min( Tree.XData(rightPoints,:), [], 1 );
    rightB = max( Tree.XData(rightPoints,:), [], 1 );
case 'cover',
    % Cover the parent version 
    leftA = Tree.Center(panel,:) - Tree.HalfWidth(panel,:);
    leftB = Tree.Center(panel,:) + Tree.HalfWidth(panel,:);
    leftB(splitDim) = splitPoint;
    
    rightA = Tree.Center(panel,:) - Tree.HalfWidth(panel,:);
    rightB = Tree.Center(panel,:) + Tree.HalfWidth(panel,:);
    rightA(splitDim) = splitPoint;
otherwise
    % Unknown Panel size
    data.Ok = false;
    return
end
leftCenter  = 0.5 * (  leftA +  leftB );
rightCenter = 0.5 * ( rightA + rightB );

minHalfWidth = Tree.HalfWidth(panel)/( Tree.Last(panel) - Tree.First(panel) );
leftHalfWidth  = max( 0.5 * (  leftB -  leftA ), minHalfWidth );
rightHalfWidth = max( 0.5 * ( rightB - rightA ), minHalfWidth );

%
% Set output data
% ---------------
data.Ok          = true;
data.Centers     = [leftCenter; rightCenter];
data.HalfWidths  = [leftHalfWidth; rightHalfWidth];
data.ChildPoints = {leftPoints, rightPoints};

return

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|

