function [PadArray] = finargcat(CatDim,varargin)
%FINARGCAT Concatenate arrays with padding unequal sizes.
%   FINARGCAT(DIM,A,B) concatenates the arrays A and B along the 
%   dimension DIM.  If the sizes of A and B are unequal in the 
%   dimensions other than DIM, A and B are padded with NaN to
%   the smallest common size in those dimensions.  If input arguments are
%   strings, the padding character is SPACE instead of NaN.
%
%   B = FINARGCAT(DIM,A1,A2,A3,A4,...) concatenates the input 
%   arrays A1, A2, etc. along the dimension DIM.
% 
%   FINARGCAT is the same as CAT when the sizes of all the 
%   inputs are equal in the dimensions other than DIM.
%
%   Examples:  The concatenated layers are marked in the 
%   output of the examples. 
%     A1 =   ones(2,3)
%     A2 = 2*ones(1,4)
%     A3 = 3*ones(3,1)
%     finargcat(1,A1,A2,A3)
%   produces a (2+1+3) by 4 matrix:
%     1     1     1   NaN
%     1     1     1   NaN
%     -------------------
%     2     2     2     2
%     -------------------
%     3   NaN   NaN   NaN
%     3   NaN   NaN   NaN
%     3   NaN   NaN   NaN
%   while
%     finargcat(2,A1,A2,A3)
%   produces a 3 by (3+4+1) matrix:
%       1     1     1  |   2     2     2     2  |  3
%       1     1     1  | NaN   NaN   NaN   NaN  |  3
%     NaN   NaN   NaN  | NaN   NaN   NaN   NaN  |  3
%   and 
%     finargcat(3,A1,A2,A3)
%   produces a 3 by 4 by (1+1+1) matrix.
%
% See also CAT.

%FINARGCAT Concatenate arrays with NaN padding unequal sizes.
%   Layer input arrays along dimension CatDim.  If some input arrays
%   are smaller in the fixed dimensions than others, pad them out
%   with the value NaN.  If all input arrays have equal fixed dimensions,
%   FINARGCAT behaves exactly like CAT.
%
%   Array = finargcat(CatDim, Array1, Array2)
%   Array = finargcat(CatDim, Array1, Array2, ..., ArrayN )
%
% Inputs: 
%   CatDim - Stack layers down the dimension CatDim.  For example, 
%     CatDim = 1 stacks vertically down columns, and CatDim = 2 stacks
%     horizontally across rows.
%   Array1 - First array in the stack.
%   Array2 - Second array in the stack.
%   ArrayN - N'th array in the stack.
%
% Outputs:
%   Array  - Array formed by stacking up input arrays.  
%     If S is: size(Array,CatDim), S equals: size(Array1,CatDim) +
%     size(Array2,CatDim) + ... + size(ArrayN,CatDim).  The layers
%     corresponding to each input array are padded out to a common size
%     in the fixed dimensions other than CatDim.
%
% Examples:  The layers are marked in the output of the examples.
%   Array1 =   ones(2,3)
%   Array2 = 2*ones(1,4)
%   Array3 = 3*ones(3,1)
%
%   Array = finargcat(1,Array1,Array2,Array3)
%
%   Array =
%        1     1     1   NaN
%        1     1     1   NaN
%        -------------------
%        2     2     2     2
%        -------------------
%        3   NaN   NaN   NaN
%        3   NaN   NaN   NaN
%        3   NaN   NaN   NaN
%
%   Array = finargcat(2,Array1,Array2,Array3)
%
%   Array =
%        1     1     1  |   2     2     2     2  |  3
%        1     1     1  | NaN   NaN   NaN   NaN  |  3
%      NaN   NaN   NaN  | NaN   NaN   NaN   NaN  |  3
%
% See also CAT.

%   Author(s): J. Akao 12/18/98
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.8 $  $Date: 2002/04/14 21:38:50 $

%------------------------------------------------------------------
% parse the size of the inputs
%
% NumCat   [scalar]      : number of matrices to concatenate
% NumDims  [NumCat by 1] : number of dimensions in each input
% ArrayDim [scalar]      : number of dimensions in output
% Sizes    [NumCat by ArrayDim] : sizes of each input
% ArraySize [1 by ArrayDim]     : size of output
%------------------------------------------------------------------

NumCat = length(varargin);

% Number of dimensions in each input
NumDims = cellfun('ndims', varargin);

% Number of dimensions in output
ArrayDim = max( max(NumDims), CatDim );

% Sizes of each input
Sizes = ones(NumCat, ArrayDim);
for i=1:NumCat,
  Sizes(i,1:NumDims(i)) = size(varargin{i});
end

% Size of output
ArraySize = max(Sizes,[],1); % padded dimensions
ArraySize(CatDim) = sum(Sizes(:,CatDim)); % catenated dimension

%------------------------------------------------------------------
% Shortcut if no NaN padding is required
% LayerSizes [NumCat by ArrayDim-1] : sizes of each input layer except in
%                                     CatDim dimension
% ArraySizes [NumCat by ArrayDim-1] : replicated sizes of each output
%                                     layer exept in CatDim dimension
%------------------------------------------------------------------
LayerSizes = Sizes;
ArraySizes = ArraySize(ones(NumCat,1),:);
% the CatDim size doesn't need to conform
LayerSizes(:,CatDim) = [];
ArraySizes(:,CatDim) = [];
if all(all( LayerSizes == ArraySizes ))
  PadArray = cat(CatDim, varargin{:});
  return
end
  
%------------------------------------------------------------------
% Create output of NaN's 
% PadArray : [ArraySize]
% Determine what padding character to use
%------------------------------------------------------------------
IsChar  = cellfun('isclass',varargin,'char');
IsEmpty = cellfun('isempty',varargin);

if ( any(IsChar) & all( IsChar | IsEmpty ) )
  % use character padding
  % International issues?
  PadArray = char(' '*ones(ArraySize));
else
  % use NaN padding
  PadArray = NaN*ones(ArraySize);
end


%------------------------------------------------------------------
% Fill in the output array
% FirstPos(iCat)  : CatDim position starting iCat input location
% LastPos(iCat)   : CatDim position ending i cat input location
%
% For the k'th dimension where k ~= CatDim, index is 1:Sizes(iCat,k)
% For CatDim'th dimension, index is FirstPos(iCat):LastPos(iCat)
%
%------------------------------------------------------------------
LastPos  = cumsum(Sizes(:,CatDim));
FirstPos = cumsum([1; Sizes(1:end-1,CatDim)]);

if (ArrayDim==2 & CatDim==1)
  % Hardcode shortcut for 2D arrays [A1;A2]
  for iCat=1:NumCat,
    PadArray(FirstPos(iCat):LastPos(iCat), 1:Sizes(iCat,2)) = varargin{iCat};
  end

elseif( ArrayDim==2 & CatDim==2)
  % Hardcode shortcut for 2D arrays [A1,A2]
  for iCat=1:NumCat,
    PadArray(1:Sizes(iCat,1), FirstPos(iCat):LastPos(iCat)) = varargin{iCat};
  end
  
else
  % General N-D indexing
  
  % Indexing setup
  Sub.type = '()';
  Sub.subs = cell(1,ArrayDim);
  FixDim = (1:ArrayDim);
  FixDim(CatDim) = [];

  for iCat=1:NumCat,
  
    % Populate index structure
    Sub.subs{CatDim} = FirstPos(iCat):LastPos(iCat);
    for k = FixDim
      Sub.subs{k} = 1:Sizes(iCat,k);
    end
    
    % Add the layer
    PadArray = subsasgn(PadArray, Sub, varargin{iCat});

  end

end


