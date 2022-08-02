function varargout = finargpad(PadDims, varargin)
%FINARGPAD Pad arrays to common sizes.
%
%   [Arr1, Arr2, ..., ArrM] = finargpad('all', A1, A2, ... AM)
%   [Arr1, Arr2, ..., ArrM] = finargpad(PadDims, A1, A2, ... AM)
%
%   Inputs:
%     PadDims - list of dimensions to pad to conforming size, or the 
%     string, 'all'.  
%
%     A, A1, ... AM - Arguments to be padded.
%
%   Outputs:
%     Arr, Arr1, ... ArrM - Output arrays.  The output arrays have the same
%     sizes in each dimension listed in PadDims.  Trailing entries are NaN.
%
%   See also FINARGPACK, FINARGCAT, FINARGSZ.
     
% This interface is flakey, and the function will be undocumented for now.

%   Author(s): J. Akao
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.9 $  $Date: 2002/04/14 21:39:13 $



%------------------------------------------------------------------
% parse the size of the inputs
%
% NumArr   [scalar]      : number of matrices to concatenate
% NumDims  [NumArr by 1] : number of dimensions in each input
% ArrayDim [scalar]      : number of dimensions in output
% Sizes    [NumArr by ArrayDim] : sizes of each input
% ArraySize [1 by ArrayDim]     : size of output
%------------------------------------------------------------------


NumArr = length(varargin);

% Number of dimensions in each input
NumDims = cellfun('ndims', varargin);

% Parse the dimenstions to work on
if ischar(PadDims)
  if strcmp(lower(deblank(PadDims)), 'all')
    PadDims = 1:max(NumDims);
  else
    error(['Unknown PadDims: ' PadDims]);
  end
else

  % check if the dimensions listed are integers > 0.
  if all( (PadDims >= 1) & (PadDims == round(PadDims)) )
    PadDims = PadDims(:)';
  else
    StringDims = num2str(PadDims)';
    StringDims = StringDims(:)';
    error(['Invalid dimension list, PadDims: ', StringDims])
  end

end

% Number of dimensions in output
ArrayDim = max( max(NumDims), max(PadDims) );

% Sizes of each input
Sizes = ones(NumArr, ArrayDim);
for i=1:NumArr,
  Sizes(i,1:NumDims(i)) = size(varargin{i});
end

% Size of output
ArraySize = NaN*ones(1,ArrayDim); % non-padded dimensions float free
ArraySize(PadDims) = max(Sizes(:,PadDims) , [] ,1); % padded dimensions

%------------------------------------------------------------------
% Shortcut if no NaN padding is required
%------------------------------------------------------------------
ArraySizes = ArraySize(PadDims);
ArraySizes = ArraySizes(ones(NumArr,1),:);
if all(all( ArraySizes == Sizes(:, PadDims) ))
  varargout = varargin;
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
  PadValue = char(' ');
else
  % use NaN padding
  PadValue = NaN;
end

%------------------------------------------------------------------
% Fill in the output arrays
%------------------------------------------------------------------

% Indexing setup
Sub.type = '()';
Sub.subs = cell(1,ArrayDim);
% Common sizes

% Assign to the outputs
varargout = cell(1,NumArr*2);
for i=1:NumArr,
  
  % find the proper size of this output
  Size = Sizes(i,:);
  Size(PadDims) = ArraySize(PadDims);
  
  % create the output array
  if ischar(PadValue)
    varargout{i} = char( PadValue*ones(Size) );
  else
    varargout{i} = PadValue*ones(Size);
  end
    
  % put in the values
  if ArrayDim==2
    % hardcode shortcut for 2D arrays
    varargout{i}(1:Sizes(i,1), 1:Sizes(i,2)) = varargin{i};

  else
    % General N-D indexing

    % Populate index structure
    for k = 1:ArrayDim
      Sub.subs{k} = 1:Sizes(i,k);
    end
    
    varargout{i} = subsasgn(varargout{i}, Sub, varargin{i});
  end
end



