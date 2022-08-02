function varargout = finargsz(ExpDims, varargin)
%FINARGSZ Arrays of common size by expanding scalar dimensions.
%   [AEXP, BEXP] = finargsz('scalar', A, B) creates equal sized outputs
%   AEXP and BEXP by expanding scalars A or B to the maximum size of the
%   inputs.  Inputs must be scalar or conforming matrices.
%
%   [AEXP, BEXP] = finargsz(1, A, B) creates outputs AEXP and BEXP having
%   the same number of rows.  Single-row inputs are expanded along the
%   first dimension.  The first dimensions of A and B must be scalar or the
%   same size.
%
%   [AEXP, BEXP] = finargsz(EXPDIMS, A, B) creates outputs AEXP and BEXP
%   having the same size in every dimension listed in the vector, EXPDIMS.
%
%   [AEXP, BEXP] = finargsz('all', A, B) creates outputs AEXP and BEXP
%   having the same size in every dimension.  Any scalar dimension is
%   expanded. 
%
%   For two-dimensional arrays, FINARGSZ('all', A, B) is the same as
%   FINARGSZ([1 2], A, B).  Row, column, or scalar inputs are expanded.
%
%   [AEXP1, AEXP2, AEXP3, ... ] = finargsz(EXPDIMS, A1, A2, A3, ...)
%   applies the expansion to arrays A1, A2, etc.  EXPDIMS can be a list
%   of dimensions or the string 'scalar', or 'all'.
%
%   Examples:
%   1) Expand rows, columns, or both
%   a = [1 2 3; 4 5 6]
%   b = [10; 20]
%   c = [100 200 300]
%   d = [1000]
%   [ae,be,ce,de] = finargsz('all', a,b,c,d)
%   ae =
%        1     2     3
%        4     5     6
%   be =
%       10    10    10
%       20    20    20
%   ce =
%      100   200   300
%      100   200   300
%   de =
%      1000  1000  1000
%      1000  1000  1000
%           
%   2) Expand scalars
%   [ae,be] = finargsz('scalar', 10, [1 2;3 4])
%   ae =
%       10    10
%       10    10
%   be =
%        1     2
%        3     4
%
%   3) The vector [10;20] can not be scalar-expanded
%   [ae,be] = finargsz('scalar', [10; 20], [1 2;3 4]) is an error
% 
%   4) The vector [10;20] can be expanded along the 2nd dimension
%   [ae,be] = finargsz(2, [10; 20], [1 2;3 4])
%   ae =
%       10    10
%       20    20
%   be =
%        1     2
%        3     4
     
%   Author(s): J. Akao, C. Bassignani, 03-30-98
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.6 $  $Date: 2002/04/14 21:39:19 $

%------------------------------------------------------------------
% parse the size of the inputs
%
% NumExp   [scalar]      : number of dimensions to expand along
% ExpDims  [1 by NumExp] : list of dimensions to expand along
% FixedSize [1 by NumExp] : sizes of output in dimensions ExpDims
%
% NumArr   [scalar]      : number of arrays to expand
% NumDims  [NumArr by 1] : number of dimensions in each input
% ArrayDim [scalar]      : number of dimensions to examine
% Sizes    [NumArr by ArrayDim] : sizes of each input
%
% IsScalar [NumArr by 1] : 1 if the array is a pure scalar
% DemandScalar [scalar]  : 1 if only pure scalars can be expanded
%------------------------------------------------------------------

% Number of dimensions in each input
NumDims = cellfun('ndims', varargin);

% List dimensions to expand
if ischar(ExpDims)

  if strcmp(lower(deblank(ExpDims)), 'scalar')
    ExpDims = 1:max(NumDims);
    DemandScalar = logical(1);
  elseif strcmp(lower(deblank(ExpDims)), 'all')
    ExpDims = 1:max(NumDims);
    DemandScalar = logical(0);
  else
    error(['Unknown ExpDims: ' ExpDims']);
  end

else

  % check if the dimensions listed are integers > 0.
  if all( (ExpDims >= 1) | (ExpDims == round(ExpDims)) )
    ExpDims = ExpDims(:)';
    DemandScalar = logical(0);
  else
    StringDims = num2str(ExpDims)';
    StringDims = StringDims(:)';
    error(['Invalid dimension list, ExpDims: ', StringDims])
  end

end
NumExp = length(ExpDims);

% Number of input arrays to examine
NumArr = length(varargin);

% Number of dimensions to examine
ArrayDim = max( max(NumDims), max(ExpDims) );

% Sizes of each input
Sizes = ones(NumArr, ArrayDim);
for i=1:NumArr,
  Sizes(i,1:NumDims(i)) = size(varargin{i});
end
IsScalar = all(Sizes==1, 2);

% Fixed Sizes
FixedSize = max( Sizes(:,ExpDims) , [], 1);

%------------------------------------------------------------------
% Check for required size conformity
% All non-unit entries in ExpDims must equal FixedSize
%
% ExpMask [NumArr by NumExp] : 1 if the dimension should be expanded
%------------------------------------------------------------------
ExpMask = ( Sizes(:,ExpDims) ~= FixedSize(ones(NumArr,1),:) );

if DemandScalar
  % Only pure scalar arguments can be expanded
  if any(  any(ExpMask,2) & ~IsScalar )
    % loop through and flag errors specifically
    error('arguments must be scalar or conforming arrays')
  end
else
  % Any scalar dimensions can be expanded, but not non-scalar dims
  if any(any( ExpMask & ( Sizes(:,ExpDims) ~= 1 ) ))
    % loop through and flag errors specifically
    error('non-conforming sizes')
  end
end

%------------------------------------------------------------------
% Expand scalar dimensions
% FixedOnes [1 by NumExp] cell : vectors of ones for each fixed dimension
%------------------------------------------------------------------

% Create expander indices
FixedOnes = cell(1, NumExp);
for jExp = 1:NumExp
  FixedOnes{jExp} = ones(FixedSize(jExp),1);
end

% Initialize to inputs
varargout = varargin;

% Loop over the arguments and change
if ( DemandScalar )
  % Perform all scalar expansion
  OneMat = ones(FixedSize);
  
  for iArr = 1:NumArr
    if any(ExpMask(iArr,:))
      varargout{iArr} = varargin{iArr}.*OneMat;
    end
  end

elseif ( (ArrayDim==2) & (NumExp==1) & (ExpDims==1) )
  % Hardcode shortcut for 2D arrays along columns

  for iArr = 1:NumArr
    if ExpMask(iArr)
      varargout{iArr} = varargin{iArr}(FixedOnes{1},:);
    end
  end

elseif ( (ArrayDim==2) & (NumExp==1) & (ExpDims==2) )
  % Hardcode shortcut for 2D arrays along rows

  for iArr = 1:NumArr
    if ExpMask(iArr)
      varargout{iArr} = varargin{iArr}(:,FixedOnes{1});
    end
  end

else    
  % Expand any dimension ExpDim( ExpMask(iArr,:) )
  Sub.type = '()';
  Sub.subs = cell(1,ArrayDim);
  
  for iArr = 1:NumArr
    if any(ExpMask(iArr,:))
      
      % Build subrefs with default :
      Sub.subs(:) = {':'};
      
      % Put ones into the proper places
      Sub.subs(ExpDims( ExpMask(iArr,:) )) = FixedOnes( ExpMask(iArr,:) );
      
      varargout{iArr} = subsref( varargin{iArr}, Sub);
    end
  end
  
end






