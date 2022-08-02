function varargout = finargparse(ClassList, varargin)
%FINARGPARSE Parse arguments into default storage according to argument class.
%   A collection of M arguments can be parsed in one call.
%
%   [Arr] = finargparse(ClassString, A)
%   [Arr1, Arr2, ..., ArrM] = finargparse(ClassList, A1, A2, ... AM)
%
%   Inputs:
%     ClassList - String or Mx1 cell array of strings listing the
%     data class of each field.  The class determines how the DataList
%     will be parsed.  Valid strings are 'dble', 'date', and 'char'.
%
%     A, A1, ... AM - Arguments to be parsed into default array storage form.
%     Type "help finargdate", "help finargchar", and "help finargdble",
%     for descriptions of allowable input forms and their translations.
%
%   Outputs:
%     Arr, Arr1, ... ArrM - Default array representations of the
%     corresponding input arguments.  Class 'date' and 'dble' are stored
%     as double arrays, and class 'char' is stored as a character array. 
%
%   See also FINARGFMT, FINARGDATE, FINARGDBLE, FINARGCHAR.
     
%   Author(s): J. Akao
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.11 $  $Date: 2002/04/14 21:39:16 $

% Number of input arrays to examine
NumArr = length(varargin);

ClassList = cellstr(finargchar(ClassList));
ClassList(cellfun('isempty',ClassList)) = []; % squeeze out empties
if (length(ClassList) == 1)
  ClassList = ClassList(ones(NumArr,1));
elseif (length(ClassList) ~= NumArr)
  error(sprintf('Cannot format %d arguments with %d class types\n', ...
                NumArr, length(ClassList)));
end

varargout = cell(1,NumArr);
for i=1:NumArr,
  switch ClassList{i}
   case 'dble'
    varargout{i} = finargdble( varargin{i} );
    
   case 'date'
    varargout{i} = finargdate( varargin{i} );
    
   case 'char'
    varargout{i} = finargchar( varargin{i} );
    
   case 'index'
    % undocumeted to support inst* references
    varargout{i} = finargdble( varargin{i} );
    
   otherwise
    varargout{i} = varargin{i};
  end
end

