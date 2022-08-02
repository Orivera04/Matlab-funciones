function plotbintree(TreeMat, TreeTimes, TreeMask)
%PLOTBINTREE Plots the nodes of a binary recombining tree.  
%   The tree is stored in the upper triangle of a matrix and with time running
%   along the rows and states running along the columns.  The tree values can
%   contain NaN entries to mask unused nodes.
%
%   plotbintree(TreeMat, TreeTimes)
%
%   Inputs:
%     TreeMat : [NSTATES by NTIMES] matrix with the upper triangle
%       storing the Y values on the tree at every time and state.
%     TreeTimes : [1 by NTIMES] vector containing the X values of the
%       nodes.  If TreeTimes is empty, [], or not entered, the times
%       are numbered 1 to NTimes.
%
%   Example:
%     [PriceTree] = binprice(52,50,.1,5/12,1/12,.4,0,0,2.06,3.5)
%
%     PriceTree = 
% 
%       52.0000   58.1367   65.0226   72.7494   79.3515   89.0642 
%             0   46.5642   52.0336   58.1706   62.9882   70.6980 
%             0         0   41.7231   46.5981   49.9992   56.1192 
%             0         0         0   37.4120   39.6887   44.5467 
%             0         0         0         0   31.5044   35.3606 
%             0         0         0         0         0   28.0688 
%
%     plotbintree(PriceTree, (0:5)/12)
%

%       Author(s): J. Akao 18-May-1998
%       Copyright 1995-2002 The MathWorks, Inc.  
%       $Revision: 1.9 $   $Date: 2002/04/14 21:43:56 $ 

[NTree, NTimes] = size(TreeMat);

% Mask out lower triangle with NaN's
[IRow, JCol] = ndgrid(1:NTree, 1:NTimes);
UTriMask = (IRow <= JCol);

% Also mask out any points passed in as NaN's
% TreeMask is any points to keep
TreeMask = (~isnan(TreeMat)) & UTriMask;

if nargin<2 | isempty(TreeTimes),
  TreeTimes = 1:NTimes;
else
  TreeTimes = TreeTimes(:)';
end

% Expand TreeTimes to a matrix
TreeTimes = TreeTimes(ones(NTree,1),:);
TreeTimes(~TreeMask) = NaN;

%-----------------------------------------------------------------------
% The up tree (TreeMat) has lines going across the rows of TreeMat
% The down tree (TreeMatD) has lines going along the diagonals of TreeMat
NTD = min(NTimes, NTree);
TreeMatD   = NaN*ones(NTimes-1, NTD);
TreeTimesD = NaN*ones(NTimes-1, NTD);
TreeMaskD  = false(NTimes-1, NTD);
for i=1:NTimes-1;
  Row = diag(TreeMat,i-1);
  NRow = length(Row);
  
  TreeMatD(i, NTD-NRow+1:NTD) = Row';
  TreeTimesD(i, NTD-NRow+1:NTD) = diag(TreeTimes,i-1)';
  TreeMaskD(i, NTD-NRow+1:NTD) =  diag(TreeMask, i-1)';
end

[XUp, YUp] = plotbinvec(TreeMat, TreeTimes, TreeMask);
[XDn, YDn] = plotbinvec(TreeMatD, TreeTimesD, TreeMaskD);

h = plot(XUp, YUp, XDn, YDn);
set(h(2),'Color',get(h(1),'Color'));

%-----------------------------------------------------------------------
% end of function plotbintree
%-----------------------------------------------------------------------
function [X,Y] = plotbinvec(TreeMat, TreeTimes, TreeMask)
% turn the rows of a matrix into lines
[NTree, NTimes] = size(TreeMat);

Mask = true(NTimes+1, NTree);
Mask(1:NTimes, :) = TreeMask';

XVals = NaN*ones(NTimes+1, NTree);
XVals(1:NTimes, :) = TreeTimes';

YVals = NaN*ones(NTimes+1, NTree);
YVals(1:NTimes, :) = TreeMat';

X = XVals(Mask);
Y = YVals(Mask);

