function tree = xregfittree( varargin )
%XREGFITTREE Regression tree for fitting RBF models
%  T = XREGFITTREE(X,Y) forms a tree a with a single panel that encompasses the 
%  data.
%
%  See also
%   XREGFITTREE/PLOTTREE
%   XREGFITTREE/SPLIT
%   XREGFITTREE/PRESPLIT
%   XREGFITTREE/POSTSPLIT
%   XREGFITTREE/BUILD
%   XREGFITTREE/COMPACT
%   XREGFITTREE/GETXYDATA
%   XREGFITTREE/GETNDATA
%   XREGFITTREE/GETCENTER
%   XREGFITTREE/GETWIDTH
%   XREGFITTREE/GETPARENT
%   XREGFITTREE/GETCHILDREN
%   XREGFITTREE/GETUPPERBDRY
%   XREGFITTREE/GETLOWERBDRY
%   XREGFITTREE/GETUSERDATA
%   XREGFITTREE/SETUSERDATA
%   XREGFITTREE/GETSPLITABLE
%   XREGFITTREE/SETSPLITABLE
%   XREGFITTREE/GETCHILDLESS
%   XREGFITTREE/GETMEAN
%   XREGFITTREE/GETNPANELS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.3.6.1 $ 

if nargin < 1,
    xdata = [];
    ydata = [];    
elseif isa( varargin{1}, 'xregfittree' ),
    tree = varargin{1};
    return    
elseif nargin ~= 2,
    error( 'Invalid input arguments' );    
else,
    xdata = varargin{1};
    ydata = varargin{2};
    if size( xdata, 1 ) ~= size( ydata, 1 ),
        error( 'X and Y must have the same number of rows' );
    end
end

%      X Data: Data sites used to generate the tree.  Will get sorted.
%       YData: 
%      Parent: n by 1 vector of parent indices.
%    Children: n by 2 matrix of child indices.
%   UpperBdry: n by d vector of booleans indicating conincidence of panel with 
%              the upper boundaries.
%   LowerBdry: n by d vector of booleans indicating conincidence of panel with 
%              the lower boundaries.
%        Mean: Average value of YData in each panel. 
%       First: Index of first data point in each panel.
%        Last: Index of last data point in each panel.
%   Splitable: Vector of booleans.
%  SplitPoint: Vector indicating at which point each panel was split.
%    SplitDim: Vector indicating which dimension each panel was split.
%    UserData: Cell array of user specfic data for each panel.
%

a = min( xdata, [], 1 );
b = max( xdata, [], 1 );
d = size( xdata, 2 );
if isempty( ydata ),
    m = [];
else,
    m = mean( ydata );
end

% if any input is constant, then set the range of that input to be 2.0
i = find( b - a < eps );
b(i) = b(i) + 2.0;

tree = struct( ...
    'XData', xdata, ...
    'YData', ydata, ...
    'Parent', 0, ...
    'Children', [0, 0], ...
    'Center', 0.5 * (a + b), ...
    'HalfWidth', 0.5 * (b - a), ...
    'UpperBdry', true( 1, d ), ...
    'LowerBdry', true( 1, d ), ...
    'Mean', m, ...
    'First', 1, ...
    'Last', size( xdata, 1 ), ...
    'Splitable', 1, ...
    'SplitDim', 0, ...
    'UserData', {[]} );

tree = class( tree, 'xregfittree' );

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|

