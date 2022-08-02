function varargout = instengineadd(TypeString, FieldInfo, varargin)
%INSTENGINEADD Subroutine for defined instrument constructors.
%   Boilerplate code for INSTADDCF, INSTADDBOND, INSTCAP, etc.
%   Parses the arguments by class and size limiting, and them passes the
%   information to INSTENGINESET to construct the instrument variable.
%
%   ISet = instengineadd(TypeString, FieldInfo, varargin{:})
%
%   [FieldList, ClassList, TypeString, SizeList, DefDataList] = ...
%          instengineadd(TypeString, FieldInfo)
%
%   Inputs:
%     TypeString - String specifying the type of instrument added.
%
%     FieldInfo - NFIELDS x 4 cell array with columns: FieldList,
%     ClassList, SizeList, and DefDataList.
%
%     Varargin{:} - Input data arguments for the fields.  If there are no
%      data arguments, the second usage is invoked to return the field
%      information. 
%
%   Outputs: 
%     Outputs are wrapped in 1x1 or 5x1 cell array.
%
%     ISet - Variable containing a collection of instruments.  Instruments
%     are broken down by type and each type can have different data fields.
%     The stored data field is a row vector or string for each instrument.
%     Type "help instget" for more information on the ISet variable. 
%
%     FieldList - NFIELDSx1 cell array of strings listing the name of each
%     data field.  
%
%     ClassList - NFIELDSx1 cell array of strings listing the
%     data class of each field.  The class determines how the DataList
%     will be parsed.  Valid strings are 'dble', 'date', and 'char'.
%
%     SizeList - NFIELDSx1 cell array of SizeLimit arrays.  Each SizeLimit
%     is an 1 x 2 array listing the maximum size of the argument
%     allowed in each dimension.  Type "help finargflip" for more.
%
%     DefDataList - NFIELDSx1 cell array containing the default value for
%     a data entry.  This information is currently unused.
% 
%   Notes:
%     This function is a subroutine and subject interface changes in a
%     future release.  INSTENGINEADD is not intended as a user function.
%
%   See also INSTGETFIELD, INSTADDCF, INSTADDCAP, INSTADDBOND.

%   Author(s): J. Akao 19-Mar-1999
%   Copyright 1995-2003 The MathWorks, Inc. 
%   $Revision: 1.8.2.1 $  $Date: 2003/08/29 04:45:57 $

% parse list
FieldList = FieldInfo(:,1);     % FieldName
ClassList = FieldInfo(:,2);     % FieldClass
SizeList = FieldInfo(:,3);      % Field Size Limits
DefDataList = FieldInfo(:,4);   % Default Data values
NumFields = size(FieldInfo,1);  

%---------------------------------------------------------------------
% Return just the default field information if called without args
%---------------------------------------------------------------------
if length(varargin)==0
  varargout = {{ FieldList, ClassList, TypeString, SizeList , DefDataList }};
  return
end

%---------------------------------------------------------------------
% Parse inputs
%---------------------------------------------------------------------

% strip off an existing instrument to pass first
if isafin(varargin{1},'Instruments')
  % Existing instrument passed in
  IVar = varargin{1};
  argI = 2;
else
  argI = 1;
  IVar = [];
end

% count the number of data arguments
NumArg = length(varargin) - argI + 1;

% This could be substituted with DefDataList (JHA 3/19/99) to fill
% unspecified fields with the defaults in the portfolio structure.
% create argument set of empties
%DataList = cell(NumFields,1);
DataList = DefDataList;

% Apportion arguments to the list
if NumArg > NumFields
  error('Too many input arguments.');
end
DataList(1:NumArg) = varargin(argI:end)';
  
%---------------------------------------------------------------------
% Interpret the size limit information here.
% You first need to parse the types.
% If size information were parsed in INSTENGINESET, you would not need to
% do this.
%---------------------------------------------------------------------
% parse the types
[DataList{:}] = finargparse(ClassList, DataList{:});
% now do the implicit transposing
[DataList{:}] = finargflip(SizeList, DataList{:});

%---------------------------------------------------------------------
% Pass the NumArg data arguments to the instrument constructor
% Pass all NumFields Field, Class pairs to store the information in the 
% variable, even when there is no data yet.
%---------------------------------------------------------------------
if isempty(IVar),
  IVar = instengineset(1,'FieldName',FieldList, ...
                      'FieldClass', ClassList, ...
                      'Data',  DataList, ...
                      'Type', TypeString);
else
  IVar = instengineset(1,IVar, 'FieldName',FieldList, ...
                      'FieldClass', ClassList, ...
                      'Data',  DataList, ...
                      'Type', TypeString);
end

varargout = {{ IVar }};

return
