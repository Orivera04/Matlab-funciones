function varargout = finargpack(TrimFlag, varargin)
%FINARGPACK Pack the non-NaN values in each row to the front.
%
%   [Arr, NumPerRow] = finargpack(TrimFlag, A)
%   [Arr1, Arr2, ..., ArrM, NR1, NR2, ... NRM] = ...
%                      finargpack(TrimFlag, A1, A2, ... AM)
%
%   Inputs:
%     TrimFlag - Scalar flag.  If non-zero, all-NaN columns will be cut
%     off each argument.
%
%     A, A1, ... AM - Arguments to be packed to the left.
%
%   Outputs:
%     Arr, Arr1, ... ArrM - Output arrays.   Each row contains the non-NaN
%     values of the input row followed by trailing NaN's, if untrimmed.
%
%     NumPerRow, NR1, ... NRM - Column listing the number of non-NaN
%     entries in each row of the output array.
%
%   See also FINARGPAD, FINARGCAT.
     
% This interface is flakey, and the function will be undocumented for now.

%   Author(s): J. Akao
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.10 $  $Date: 2002/04/14 21:39:10 $

if isempty(TrimFlag) | isnan(TrimFlag)
  TrimFlag = 0;
end

% Number of input arrays to examine
NumArr = length(varargin);

varargout = cell(1,NumArr*2);
for i=1:NumArr,
  [NumRows, NumCols] = size(varargin{i});
  
  % Matrix of original row and column indices
  [RowInd, OldColInd] = ndgrid(1:NumRows, 1:NumCols);
  
  % Matrix of new column indicies formed by taking the non-NaN's in order
  EntryMask = ~isnan(varargin{i});
  NewColInd = cumsum( EntryMask , 2 );
  
  % Make index maps of the non-NaN entries
  OldMap = RowInd + NumRows*(OldColInd - 1);
  NewMap = RowInd + NumRows*(NewColInd - 1);
  
  OldMap = OldMap(EntryMask);
  NewMap = NewMap(EntryMask);
  
  % create an output of the proper size
  if TrimFlag
    NumCols = max(NewColInd(:,end));
  end
  varargout{i} = NaN*ones(NumRows, NumCols);
  
  % write the entries into the new locations
  varargout{i}(NewMap) = varargin{i}(OldMap);
  
  % return the number of non-NaN rows after the matrices themselves
  varargout{NumArr+i} = NewColInd(:,end);
  
end
  
