function [Values, ColNameSet, ColClassSet, InstXSet, InstTypeSet] = instgetcell(IVar, varargin)
%INSTGETCELL Retrieve data and context from an instrument variable.
%
%   [DataList, FieldList, ClassList , IndexSet, TypeSet] = ... 
%                           instgetcell(InstSet, 'FieldName', FieldList, ...
%                                       'Index', IndexSet,'Type', TypeList)
%
%   Inputs: 
%     Parameter value pairs can be entered in any order. The InstSet variable
%     is required and must be the first argument.  
%
%     InstSet - Variable containing a collection of instruments. Instruments
%     are broken down by type and each type can have different data fields.
%     The stored data field is a row vector or string for each instrument. 
%
%     FieldList - String or NFIELDSx1 cell array of strings listing the
%     name of each data field.  FieldList entries can also be either 'Type'
%     or 'Index'; these return type strings and index numbers respectively.
%     The default is all fields available for the returned set of instruments. 
%
%     IndexSet - NINSTx1 vector of positions of instruments to work on.
%     If TypeList is also entered, instruments referenced must be one of
%     TypeList types and contained in IndexSet. The default is all indices
%     available in the instrument variable.
%
%     TypeList - String or NTYPESx1 cell array of strings restricting
%     instruments to be worked on to match one of TypeList types. 
%     The default is all types in the instrument variable.
%
%   Outputs:
%     DataList - NFIELDSx1 cell array of data contents for each field.
%     Each cell is an NINSTxM array, where each row corresponds to a
%     separate instrument in IndexSet.  Any data which is not available
%     is returned as NaN or as spaces.
%
%     FieldList - NFIELDSx1 cell array of strings listing the name of each
%     field in DataList.
%
%     ClassList - NFIELDSx1 cell array of strings listing the class of each
%     field in DataList.  The class was used to parse data on input, and
%     is one of 'dble', 'date', or 'char'.
%
%     IndexSet - NINSTx1 vector of positions of instruments returned in
%     DataList. 
%
%     TypeSet - NINSTx1 cell array of strings listing the type of each
%     instrument row returned in DataList.
%
%   Notes:  
%     This function is best used for programming where the structure
%     of the instrument variable is not known.  INSTGET gives more direct
%     access to the data in a variable.
%
%   Examples:
%   1) Retrieve the instrument set variable, ExampleInst, from a data file.  
%      There are 3 types of instruments in the variable: 'Option', 'Futures', 
%      and 'TBill'.
%
%      load InstSetExamples.mat
%      instdisp(ExampleInst)
%
%       Index Type   Strike Price Opt  Contracts
%       1     Option  95    12.2  Call     0    
%       2     Option 100     9.2  Call     0    
%       3     Option 105     6.8  Call  1000    
%     
%       Index Type    Delivery       F     Contracts
%       4     Futures 01-Jul-1999    104.4 -1000    
%     
%       Index Type   Strike Price Opt  Contracts
%       5     Option 105     7.4  Put  -1000    
%       6     Option  95     2.9  Put      0    
%     
%       Index Type  Price Maturity       Contracts
%       7     TBill 99    01-Jul-1999    6        
%
%   2) Get the prices and contracts from all instruments.
%      FieldList = {'Price'; 'Contracts'}
%      DataList = instgetcell(ExampleInst, 'FieldName', FieldList )
%      P = DataList{1}
%      C = DataList{2}
%   
%   3) Get all the option data: Strike, Price, Opt, Contracts
%      [DataList, FieldList, ClassList] = instgetcell(ExampleInst,'Type','Option')
%   
%   4) Look at the data as a comma separated list. Type "help lists" for more 
%      information on cell array lists.
%      DataList{:}
%   
%   See also INSTGET, INSTADDFIELD, INSTDISP.

%   Author(s): J. Akao, 31-Mar-1999
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.19 $  $Date: 2002/04/14 21:40:24 $

%---------------------------------------------------------------------
% Strip off an existing instrument or create one
%---------------------------------------------------------------------
if ~isafin(IVar,'Instruments')
  error('The first argument must be a Financial Instrument Variable')
end


%---------------------------------------------------------------------
% Parse for instrument selection pairs:
% 'Type', FieldType  [NumTypes x 1 cell] : 'Bond', etc 
% 'Index' IndexRows  [NumRows x 1] : indices of entries in IndexTable
%         FieldNames [NumFields x 1] : names of fields to retrieve
%
% InstXList : list of instruments to work on
% TypeList  : cellstr list of types to work on
% ColNameSet : cellstr list of field names to retrieve
%---------------------------------------------------------------------

%               1       2         3           4        5
ParamList = {'Type', 'Index', 'FieldName', 'Data', 'FieldClass'};

% Allow easy fieldname tags
% TagStyle = 'None';
TagStyle = 'Single';

% Perform parsing
[PV,PVFlag,TagList] = instpvp(TagStyle,ParamList, varargin{:});

% InstXSet = finargdble(S.Index);
InstXSet = finargdble(PV{2}); % Index
InstXSet(isnan(InstXSet)) = []; % squeeze out any NaN's
InstXSet = InstXSet(:);

% TypeList = cellstr( finargchar(S.Type) );
TypeList = cellstr( finargchar(PV{1}) ); % Type
TypeList(cellfun('isempty',TypeList)) = []; % squeeze out empty type cells
NumTypeList = length(TypeList);

% ColNameSet = cellstr( finargchar(S.FieldName) );
ColNameSet = cellstr( finargchar(PV{3}) );
ColNameSet( cellfun('isempty',ColNameSet) ) = []; % squeeze out any empties

% Add any miscellaneous tags 
if strcmp(TagStyle,'Single')
  ColNameSet = [ColNameSet; TagList];
end
NumCols = length(ColNameSet);

% ColClassSet = cellstr( finargchar(S.FieldClass) );
ColClassSet = cellstr( finargchar(PV{5}) );
ColClassSet( cellfun('isempty',ColClassSet) ) = [];

%---------------------------------------------------------------------
% Process any input data
% ColData is a cell for each FieldName or an empty matrix
%---------------------------------------------------------------------
% ColData = S.Data;
ColData = PV{4};

% catch cases when you should wrap a single argument into a cell
if ~iscell(ColData) & ~isempty(ColData)
  ColData = {ColData};
elseif ( NumCols==1 & (length(ColData) > 1) )
  ColData = {ColData};
end
NumColsData = length( ColData );
  
% check that the data has the correct number of columns
if ( NumColsData ~= NumCols  & NumColsData > 0 )
  CellStr = cell(2,NumCols);
  CellStr(1,:) = ColNameSet(:)';
  CellStr(2,:) = { ''',''' };
  CellStr{2,end} = [];
  error(sprintf('Cannot match %d Data entries to Field set: {''%s''}\n', ...
                NumColsData, cat(2, CellStr{:}) ));
end

%---------------------------------------------------------------------
% Map TypeList strings to TypeI indices
% Both lists are assumed to be unique
%
% TypeIList : indices within IVar. Type corresponding to TypeList strings
%
% TypeIFound : unordered indices within IVar.Type of found TypeList strings
% ListFound : unordered indices within input TypeList of found strings
% ListNew   : indices of input TypeList strigns which were not found
%---------------------------------------------------------------------

[TypeMatches, TypeIFound, ListFound] = intersect(IVar.Type, TypeList);

% Check if entered types are represented
ListNew = true(NumTypeList,1);
ListNew(ListFound) = 0;
ListNew = find(ListNew); % change to a list of indices

% Give new types their own numbers
TypeIList = NaN*ones(length(TypeList),1);
TypeIList(ListFound) = TypeIFound;
TypeIList(ListNew) = length(IVar.Type) + (1:length(ListNew))';

for iType = 1:length(ListNew)
  warning(sprintf('Type %s not represented in Instrument\n', ...
                  TypeList{ ListNew(iType) }))
end

%---------------------------------------------------------------------
% Determine the list InstXSet of instruments to return
% and their locations {TypeI}{*}(RowK,:) in the data
%
% NumInst : Number of instruments in the output set
% InstXSet  [NumInst x 1] : list of IndexTable Rows to output
% TypeISet  [NumInst x 1] : TypeI value for each output instrument
% RowKSet   [NumInst x 1] : RowK value for each output instrument
%---------------------------------------------------------------------
if ~PVFlag(2)
  % consider all rows by default
  InstXSet = (1:length(IVar.IndexTable.TypeI))';
end

% Restrict to input listed Types unless none are listed
if PVFlag(1)
  [InstTypeI, InputTypeI] = ndgrid( IVar.IndexTable.TypeI(InstXSet), ...
                                    TypeIList );
  InstXSetMask = any( InstTypeI == InputTypeI , 2 );
  
  % Find positions matching an input type
  InstXSet = InstXSet( InstXSetMask );
end

NumInst = length(InstXSet);
TypeISet = IVar.IndexTable.TypeI(InstXSet);
RowKSet = IVar.IndexTable.RowK(InstXSet);
InstTypeSet = IVar.Type( TypeISet );

% If there is nothing to return, break out here
if NumInst==0
  Values = cell(NumCols,1);
  Values(:) = { [] };
  return
end
  
%---------------------------------------------------------------------
% If no fields were requested, return all available fields
%---------------------------------------------------------------------
if isempty(ColNameSet)
  if isempty(TypeISet)
    % all the fields in all the types
    AllFieldNames = cat(1,IVar.FieldName{:});
  else
    % just fields in requested types
    AllFieldNames = cat(1,IVar.FieldName{TypeISet});
  end
  [ColNameSet,I] = unique(AllFieldNames);
  ColNameSet = AllFieldNames( sort(I) );
  NumCols = length(ColNameSet);
end
  
%---------------------------------------------------------------------
% Determine the class of each output field
% first use a value passed in
% otherwise look for the class by the column names
% otherwise default to 'dble'
%---------------------------------------------------------------------
if ( length(ColClassSet) ~= NumCols )
  ColClassSet = cell(NumCols,1);
  
  % look for names in the table
  AllFieldNames = cat(1,IVar.FieldName{:});
  AllFieldClass = cat(1,IVar.FieldClass{:});
  if ~isempty(AllFieldNames)
    [MatchNames, ColJ, FieldJ] = intersect( ColNameSet, AllFieldNames );
    ColClassSet( ColJ ) = AllFieldClass( FieldJ );
  end
  
  % guess remaining columns as dble
  ColJ = find(cellfun('isempty', ColClassSet));
  ColClassSet( ColJ ) = { 'dble' };
end
  
%---------------------------------------------------------------------
% Block down the output instrument set by TypeI
%
% NumBlocks : number of blocks
% TypeIBlock [NumBlocks x 1] : TypeI of each block
% RowKBlock  [NumBlocks x 1] : cell RowK list (FieldData) for each block
% NumKBlock  [NumBlocks x 1] : number of rows fetched from each block
%
% PosISet    [NumInst x 1]: out inst position of each blocked inst
%
% Local for mapping the blocked instruments to the output instruments
% BlockSet   [NumInst x 1]: Block index of each instrument
% PosIBlock  [NumBlocks x 1] : cell PosI list (Values) for each block
%---------------------------------------------------------------------

% Find which TypeI values are represented in the output
[TypeIBlock, I, BlockSet] = unique( TypeISet );
NumBlocks = length(TypeIBlock);

% Find the list of rows needed from each block
% RowKBlock is in the Instrument Data
% PosIBlock is in the output instruments
RowKBlock = cell(NumBlocks,1);
PosIBlock = cell(NumBlocks,1);
NumKBlock = zeros(NumBlocks,1);
for iBlock = 1:NumBlocks,
  InstMask = ( BlockSet == iBlock );
  RowKBlock{iBlock} = RowKSet( InstMask );
  PosIBlock{iBlock} =    find( InstMask );
  NumKBlock(iBlock) =     sum( InstMask );
end

PosISet = cat(1, PosIBlock{:});

%---------------------------------------------------------------------
% Determine the map of fieldnames in each block to requested fields
% 
% In each block, i, 
% Output(*, ColJBlock{i}) <=> FieldData{TypeIBlock(i)}{ FieldJBlock{i} }(*,:)
%
% ColJBlock   [NumBlocks x 1] cell of FieldJ lists
% FieldJBlock [NumBlocks x 1] cell of ColJ lists
% NumJBlock   [NumBlocks x 1] length of list in each block
%---------------------------------------------------------------------
NumJBlock = zeros(NumBlocks,1);
ColJBlock = cell(NumBlocks,1);
FieldJBlock = cell(NumBlocks,1);
for iBlock = 1:NumBlocks
  iType = TypeIBlock(iBlock);
  [MatchNames,  FieldJBlock{iBlock}, ColJBlock{iBlock}] = intersect( ...
      IVar.FieldName{ iType }, ColNameSet);
  NumJBlock(iBlock) = length( ColJBlock{iBlock} );
end
                                                  
%---------------------------------------------------------------------
% Build the field values
%
% Values{ PosI , ColJ } <=> FieldData{ TypeI }{ FieldJ }(RowK,:)
%---------------------------------------------------------------------


% Map the fieldnames to the columns but only order the instruments within
% blocks (by RowK)

% fill in default rows if the data is missing from a block
ValueBlock = cell(NumBlocks, NumCols);
for jCol = 1:NumCols
  for iBlock = 1:NumBlocks
    switch ColClassSet{jCol}
     case {'dble', 'date', 'curr','index'}
      ValueBlock{iBlock,jCol} =  NaN * ones(NumKBlock(iBlock),1);
     case 'char'
      ValueBlock{iBlock,jCol} =  char( ones(NumKBlock(iBlock),0) );
    end
  end
end

% Copy the values from the FieldData
for iBlock = 1:NumBlocks,
  TypeI  =  TypeIBlock(iBlock);
  NumJ   =   NumJBlock(iBlock);
  ColJ   =   ColJBlock{iBlock};
  FieldJ = FieldJBlock{iBlock};
  RowK   =   RowKBlock{iBlock};
  for jCol = 1:NumJ
        ValueBlock{ iBlock,   ColJ(jCol) } = ...
    IVar.FieldData{ TypeI }{ FieldJ(jCol) }(RowK,:);
  end
end

% Collapse the values into arrays: NumInst rows for each of NumCols Fields
Values = cell(NumCols, 1);
for jCol = 1:NumCols
  Values{jCol} = finargcat(1, ValueBlock{:,jCol});
end

% Move the rows from thier positions within blocks to their postions
% within output instruments
for jCol = 1:NumCols
  Values{jCol}(PosISet,:) = Values{jCol};
end

%---------------------------------------------------------------------
% Handle special ColNames 'Type', 'Index'
%---------------------------------------------------------------------
jType = find( strcmp('Type', ColNameSet) );
if ~isempty(jType)
  for jCol = jType(:)'
    Values{jCol} = char( InstTypeSet );
    ColClassSet{jCol} = 'char';
  end
end

jIndex = find( strcmp('Index', ColNameSet) );
if ~isempty(jIndex)
  for jCol = jIndex(:)'
    Values{jCol} = InstXSet;
    ColClassSet{jCol} = 'dble';
  end
end

if NumColsData==0
  % no data matching restrictions
  return
end

%---------------------------------------------------------------------
% Restrict output to Data matches
% If Data field is passed in, only return rows matching the input data
% values. 
%---------------------------------------------------------------------

% Process the input into arrays
[ColData{:}] = finargparse(ColClassSet, ColData{:});

% Identify non-matching rows
IKeepSet = (1:NumInst)';
for jCol = 1:NumCols
  
  IKeepCol = false(size(IKeepSet));
  for kData = 1:size(ColData{jCol},1)
    % Match one of the Data values to stay
    IKeepCol = IKeepCol | eqrows(ColData{jCol}(kData,:), ...
                                    Values{jCol}(IKeepSet,:));
  end

  % preserve rows which matched one of the values
  IKeepSet = IKeepSet(IKeepCol);
  if isempty(IKeepSet)
    break
  end

end

% Trim the output rows
for jCol = 1:NumCols
  Values{jCol} = Values{jCol}(IKeepSet,:);
end
InstXSet = InstXSet(IKeepSet);
InstTypeSet = InstTypeSet(IKeepSet);

return

%---------------------------------------------------------------------
% Subfunctions
%---------------------------------------------------------------------
function [Mask] = eqrows(Row1, Row2)
% match rows ignoring trailing NaN's or spaces

% do row expansion
[Row1, Row2] = finargsz(1,Row1,Row2);
NumRows = size(Row1, 1);

% do padding (not the most efficient way)
AllRows = finargcat(1,Row1,Row2);
Row1 = AllRows(1:NumRows,:);
Row2 = AllRows(NumRows+1:end,:);

if isa(AllRows,'double')
  Mask = all( ...
      ( ( isnan(Row1) == isnan(Row2) ) & ... 
        ( isnan(Row1) | (Row1==Row2) ) ), 2);
elseif isa(AllRows,'char')
  Mask = all( ...
      ( ( isspace(Row1) == isspace(Row2) ) & ... 
        ( isspace(Row1)  |  (Row1==Row2) ) ), 2);
else
  error('bad class to eqrows in instgetcell')
end
