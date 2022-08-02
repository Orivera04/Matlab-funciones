function varargout = finargfmt(ClassList, varargin)
%FINARGFMT Format arguments into strings according to argument class.
%   A collection of M arguments can be transformed to strings in one call.
%
%   [AString] = finargfmt(ClassString, A)
%   [AString1, AString2, ..., AStringM] = finargfmt(ClassList, A1, A2, ... AM)
%
%   Inputs:
%     ClassList - String or Mx1 cell array of strings listing the
%     data class of each field.  The class determines how the DataList
%     will be parsed.  Valid strings are 'dble', 'date', and 'char'.
%
%     A, A1, ... AM - Arguments in default storage form as parsed by
%     FINARGPARSE.  Classes 'date' and 'dble' are double arrays while
%     'char' is a character array.
%
%   Outputs:
%     AString, AString1, ... AStringM - Formatted string representations of
%     the corresponding input arguments.  Class 'date' is formatted with
%     DATEDISP, and class 'dble' is formatted with NUM2STR.
%
%   Note: 
%     Call DATEDISP or NUM2STR directly to pass the optional format
%     specifiers.  FINARGFMT always uses the default formats.
%
%   See also FINARGPARSE, NUM2STR, DATEDISP.
     
%   Author(s): J. Akao
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.10 $  $Date: 2002/04/14 21:39:07 $

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
    varargout{i} = num2str( varargin{i} );
    
   case 'date'
    varargout{i} = datedisp( varargin{i} );
    
   case 'index'
    % undocumeted to support inst* references
    varargout{i} = num2str( varargin{i} );
    
   otherwise
    varargout{i} = varargin{i};
  end
end

