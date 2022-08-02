function varargout = finargflip(SizeList, varargin)
%FINARGFLIP Transpose array arguments to conform to size conventions.
%   Arguments are transposed on output if needed to conform to size
%   limits in a particular dimension or to conform to other arguments.
%
%   [Arr] = finargflip(SizeLimit, A)
%   [Arr1, Arr2, ..., ArrM] = finargflip(SizeList, A1, A2, ... AM)
%
%   Inputs:
%     SizeLimit - 1 x 2 array listing the maximum size of the argument
%     allowed in each dimension.  For instance, if SizeLimit = [Inf, 1],
%     any row input is transposed into a column.
%
%     SizeList - Mx1 cell array of SizeLimit arguments.  
%
%     A, A1, ... AM - Arguments to be matched against size conventions. 
%     If an argument violates a size limit and if transposing the argument
%     would conform to the size limit, the argument is transposed.
%     Otherwise, it is passed through unchanged.
%
%   Outputs:
%     Arr, Arr1, ... ArrM - Output arrays.  An output can still violate the
%     size limit if transposing will not bring the size into conformance.
%
%   See also FINARGSZ.
     
% This interface is flakey, and the function will be undocumented for now.

%   Author(s): J. Akao
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.9 $  $Date: 2002/04/14 21:39:04 $

% Number of input arrays to examine
NumArr = length(varargin);

SizeList = num2cell(finargdble(SizeList), 2);
SizeList(cellfun('isempty',SizeList)) = []; % squeeze out empties
if (length(SizeList) == 1)
  SizeList = SizeList(ones(NumArr,1));
elseif (length(SizeList) ~= NumArr)
  error(sprintf('Cannot format %d arguments with %d size limits\n', ...
                NumArr, length(SizeList)));
end

varargout = varargin;
for i=1:NumArr,
  Size = size(varargin{i});
  
  if ( any(Size > SizeList{i}) & all(Size([2,1]) <= SizeList{i}) )
    varargout{i} = varargin{i}';
  end
  
end
  
