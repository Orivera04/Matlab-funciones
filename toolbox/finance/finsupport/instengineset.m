function IVar = instengineset(NewFlag, varargin)
%INSTENGINESET Subroutine for instaddfield and instsetfield.
%   Adds new instruments or adds or resets data to existing instruments.
%
%   ISet = instengineset(NewFlag, ISet, 'FieldName', FieldList, ... 
%                                       'Data' , DataList, ...      
%                                       'FieldClass', ClassList, ...
%                                       'Index', IndexSet, ...
%                                       'Type', TypeList)
%
%   Inputs: 
%     Parameter value pairs can be entered in any order.  An
%     existing ISet variable must be the first argument.  
%
%     NewFlag - Set to 1 if new instruments are to be added, or set to 0 if
%     existing instruments are to be modified.
%
%     ISet - Variable containing a collection of instruments.  Optional if
%     NewFlag = 1, Required if NewFlag = 0.
%
%   Output:   
%     ISet - New instrument set variable containing the input data.
%
%   See also INSTADDFIELD, INSTSETFIELD.

%   Author(s): J. Akao 22-Mar-1999
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.11 $  $Date: 2002/04/14 21:40:13 $

% This is a prototype to demonstrate the interface.  It is not a comment
% on design spec. JHA 1/20/98

% This should be made capable of resetting the FieldClass of a field
% without passing any data.

%---------------------------------------------------------------------
% strip off an existing instrument or create one
if isafin(varargin{1},'Instruments')
  % Existing instrument passed in
  argI = 2;

  IVar = varargin{1};
else
  if NewFlag==0,
    error('An instrument variable is required')
  end
  argI = 1;
  
  IVar = classfin('Instruments');
  IVar.IndexTable.TypeI = zeros(0,1);
  IVar.IndexTable.RowK  = zeros(0,1);
  IVar.Type = cell(0,1);
  IVar.FieldName  = cell(0,1);
  IVar.FieldClass = cell(0,1);
  IVar.FieldData  = cell(0,1);
end


%---------------------------------------------------------------------
% Parse for instrument selection pairs:
% 'Type', FieldType  [NumTypes x 1 cell] : 'Bond', etc 
% 'Index' IndexRows  [NumRows x 1] : indices of entries in IndexTable
%         FieldNames [NumFields x 1] : names of fields to retrieve
%
% InstXList : list of instruments to work on
% TypeList  : cellstr list of types to work on
%
% NumCols    number of columns in the output
% ColNameSet [NumCols x 1] cellstr of output column (field) names
%---------------------------------------------------------------------
%---------------------------------------------------------------------

%               1       2         3           4        5
ParamList = {'Type', 'Index', 'FieldName', 'Data', 'FieldClass'};

% Allow easy fieldname-data tags
% TagStyle = 'None';
TagStyle = 'Pair';

% Perform parsing
[PV,PVFlag,TagList,TagData] = instpvp(TagStyle,ParamList, varargin{argI:end});

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
if strcmp(TagStyle,'Pair')
  ColNameSet = [ColNameSet; TagList];
end
NumCols = length(ColNameSet);

% ColClassSet = cellstr( finargchar(S.FieldClass) );
ColClassSet = cellstr( finargchar(PV{5}) );
ColClassSet( cellfun('isempty',ColClassSet) ) = [];

%---------------------------------------------------------------------
% Process the data
% ColData is a cell for each FieldName
%---------------------------------------------------------------------

% Get 'Data' tags 
% ColData = S.Data;
ColData = PV{4};

% catch cases when you should wrap a single argument into a cell
if ~iscell(ColData) & ~isempty(ColData)
  ColData = {ColData};
elseif ( NumCols==1 & (length(ColData) > 1) )
  ColData = {ColData};
end

% Add any miscellanous data values 
if strcmp(TagStyle,'Pair')
  ColData = [ColData; TagData];
end
NumColsData = length( ColData );
  
% check that the data has the correct number of columns
if ( NumColsData ~= NumCols )
  CellStr = cell(2,NumCols);
  CellStr(1,:) = ColNameSet(:)';
  CellStr(2,:) = { ''',''' };
  CellStr{2,end} = [];
  error(sprintf('Cannot match %d Data entries to Field set: {''%s''}\n', ...
                NumColsData, cat(2, CellStr{:}) ));
end

%---------------------------------------------------------------------
% Determine the class of each output field
% first use a value passed in
% otherwise look for the class by the column names
% finally guess from the input data
%---------------------------------------------------------------------
if ( length(ColClassSet) ~= NumCols )
  ColClassSet = cell(NumCols,1);
  
  % look for names
  AllFieldNames = cat(1,IVar.FieldName{:});
  AllFieldClass = cat(1,IVar.FieldClass{:});
  if ~isempty(AllFieldNames)
    [MatchNames, ColJ, FieldJ] = intersect( ColNameSet, AllFieldNames );
    ColClassSet( ColJ ) = AllFieldClass( FieldJ );
  end
  
  % guess remaining columns from the raw data
  ColJ = find(cellfun('isempty', ColClassSet));
  for jCol = ColJ'
    Arg = ColData{jCol};
    while iscell(Arg)
      Arg = Arg{1};
    end
    
    if ischar(Arg)
      ColClassSet( jCol ) = {'char'};
    else
      ColClassSet( jCol ) = {'dble'};
    end
  end
end
  
%---------------------------------------------------------------------
% Process the input into arrays
%---------------------------------------------------------------------
[ColData{:}] = finargparse(ColClassSet, ColData{:});

% Expand the arguments to the same number of rows
[ColData{:}] = finargsz(1, ColData{:});

% check how many rows were processed
NumInstData = size( ColData{1} , 1 );

% If NumInstData == 1, you may need to expand to NumInst later

%---------------------------------------------------------------------
% Determine the IndexRows to work on
% InstXSet if not passed in
%---------------------------------------------------------------------
if NewFlag,
  % add new instruments
  InstXSet = length(IVar.IndexTable.TypeI) + (1:NumInstData)';
  
  if PVFlag(2)
    warning('New instruments are appended and Index input is ignored')
  end
  
elseif ~PVFlag(2) % & ~NewFlag
  % all current instruments are fair game
  % restrict to types later
  InstXSet = (1:length(IVar.IndexTable.TypeI))';

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

%---------------------------------------------------------------------
% Determine the list InstXSet of instruments to return
% and their locations {TypeI}{*}(RowK,:) in the data
%
% NumInst : Number of instruments in the output set
% InstXSet  [NumInst x 1] : list of IndexTable Rows to output
% TypeISet  [NumInst x 1] : TypeI value for each output instrument
% RowKSet   [NumInst x 1] : RowK value for each output instrument
%---------------------------------------------------------------------

% Restrict to input listed Types unless none are listed
if (~NewFlag & PVFlag(1) )
  [InstTypeI, InputTypeI] = ndgrid( IVar.IndexTable.TypeI(InstXSet), ...
                                    TypeIList );
  InstXSetMask = any( InstTypeI == InputTypeI , 2 );
  
  % Find positions matching an input type
  InstXSet = InstXSet( InstXSetMask );
end

NumInst = length(InstXSet);

% check that the data has the correct number of rows
if ( NumInstData==1 & NumInst>1 )
  % expand the data down the rows
  [ColData{:}] = finargsz(1, ColData{:}, zeros(NumInst,1) );

elseif ( (NumInst ~= NumInstData) & (NumInst > 0) )
  % the row size is incompatible
  error(sprintf('Cannot match %d data rows to Index set: [%s]\n', ...
                NumInstData, num2str( InstXSet(:)' ) ));
end

%---------------------------------------------------------------------
% Expand the IndexTable if there are new instruments
% Expand the Type lists if there are new types
%---------------------------------------------------------------------
if (NewFlag)
  if (length(TypeIList) ~= 1)
    error('A single ''Type'' specifier is required for new instruments');
  else
    TypeI = TypeIList(1);
  end
  
  % record a new type in the structure, without data
  if TypeI > length(IVar.Type)
    IVar.Type       = [IVar.Type;       TypeList];
    IVar.FieldName  = [IVar.FieldName;  cell(1,1)];
    IVar.FieldClass = [IVar.FieldClass; cell(1,1)];
    IVar.FieldData  = [IVar.FieldData;  cell(1,1)];
    
    IVar.FieldName{end}  = ColNameSet;
    IVar.FieldClass{end} = ColClassSet;
    IVar.FieldData{end}  = cell(NumCols,1);
    
    IVar.FieldData{end}(:) = { zeros(0,0) };
  end
  
  % find how many rows there are of the current type
  NumRows = size(IVar.FieldData{TypeI}{1}, 1);

  % expand the IndexTable by NumInst instruments
  IVar.IndexTable.TypeI = [IVar.IndexTable.TypeI; TypeI*ones(NumInst,1)];
  IVar.IndexTable.RowK  = [IVar.IndexTable.RowK ; NumRows+(1:NumInst)'];
end  

% Indexing is now by TypeI and RowK values
TypeISet = IVar.IndexTable.TypeI(InstXSet);
RowKSet = IVar.IndexTable.RowK(InstXSet);


% If NumInst==o, break out here

%---------------------------------------------------------------------
% Block down the output instrument set by TypeI
%
% NumBlocks : number of blocks
% TypeIBlock [NumBlocks x 1] : TypeI of each block
% RowKBlock  [NumBlocks x 1] : cell RowK list (FieldData) for each block
% PosIBlock  [NumBlocks x 1] : cell PosI list (Values) for each block
%
% PosISet    [NumInst x 1]: out inst position of each blocked inst
%
% Local for mapping the blocked instruments to the output instruments
% BlockSet   [NumInst x 1]: Block index of each instrument
%
%---------------------------------------------------------------------

% Find which TypeI values are represented in the output
[TypeIBlock, I, BlockSet] = unique( TypeISet );
NumBlocks = length(TypeIBlock);

% Find the list of rows needed from each block
% RowKBlock is in the Instrument Data
% PosIBlock is in the output instruments
RowKBlock = cell(NumBlocks,1);
PosIBlock = cell(NumBlocks,1);
for iBlock = 1:NumBlocks,
  InstMask = ( BlockSet == iBlock );
  RowKBlock{iBlock} = RowKSet( InstMask );
  PosIBlock{iBlock} =    find( InstMask );
  NumKBlock(iBlock) =     sum( InstMask );
end

PosISet = cat(1, PosIBlock{:});


%---------------------------------------------------------------------
% Determine the map of fieldnames in each block to input fields
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
  
  % Match input names to existing names
  [MatchNames,  FieldJ, ColJ] = intersect( IVar.FieldName{iType}, ColNameSet);
  
  if ( length(ColJ) < NumCols )
    % some names are not yet represented in this block
    ListNew = true(NumCols,1);
    ListNew(ColJ) = 0;
    ListNew = find(ListNew); % change to a list of indices
    
    % Add the new fields to the structure in the block
    IVar.FieldName{iType} = [IVar.FieldName{iType}; ColNameSet(ListNew)];
    IVar.FieldClass{iType} = [IVar.FieldClass{iType}; ColClassSet(ListNew)];
    
    % Find out how many rows are in the Data block and add space
    NumRows = size( IVar.FieldData{iType}{1} , 1);
    NewData = cell(size(ListNew));
    NewData(:) = { zeros(NumRows,0) };
    IVar.FieldData{iType} = [IVar.FieldData{iType}; NewData ];
    
    % Recompute the positions
    [MatchNames,  FieldJ, ColJ] = intersect(IVar.FieldName{iType}, ColNameSet);
  end
  if ( length(ColJ) < NumCols )
    error('i made a programming mistake')
  end
    
  FieldJBlock{iBlock} = FieldJ;
  ColJBlock{iBlock} = ColJ;
  NumJBlock(iBlock) = length( ColJBlock{iBlock} );
end
                                                  

%---------------------------------------------------------------------

%---------------------------------------------------------------------
% Build the field values
%
% Values{ PosI , ColJ } <=> FieldData{ TypeI }{ FieldJ }(RowK,:)
%---------------------------------------------------------------------


% Map the fieldnames to the columns but put the new values at the end
% after the preserved values

% Copy the values from the FieldData
for iBlock = 1:NumBlocks,
  TypeI  =  TypeIBlock(iBlock);
  NumJ   =   NumJBlock(iBlock);
  ColJ   =   ColJBlock{iBlock};
  PosI   =   PosIBlock{iBlock};
  FieldJ = FieldJBlock{iBlock};
  RowK   =   RowKBlock{iBlock};
  
  % Compute the preserved indices RowP
  NumRows = size( IVar.FieldData{TypeI}{1} , 1);
  RowP = true(NumRows,1);
  RowP(RowK) = 0;
  RowP = find(RowP); % change to a list
  
  
  if isempty(RowP)
    % you are replacing all the rows in the fields

    for jCol = 1:NumJ
      % Extract the input data belonging in this block
      FieldData = ColData{ ColJ(jCol) }(PosI,:);

      % rearrange the rows according to the RowK locations
      FieldData(RowK,:) = FieldData;
      
      % Assign to the instrument data
      IVar.FieldData{TypeI}{ FieldJ(jCol) } = FieldData;
    end % field in block

  else
    % you need to keep data from before
    MapK = [RowP; RowK];
    
    for jCol = 1:NumJ
      % Extract the data to preserve
      FieldDataP = IVar.FieldData{TypeI}{ FieldJ(jCol) }(RowP,:);
      
      % Extract the input data belonging in this block
      FieldData = ColData{ ColJ(jCol) }(PosI,:);

      % pad to common column size
      FieldData = finargcat(1, FieldDataP, FieldData);
      
      % rearrange the rows according to thier RowP and RowK locations
      FieldData(MapK,:) = FieldData;
    
      % Assign back to the instrument data
      IVar.FieldData{TypeI}{ FieldJ(jCol) } = FieldData;
    end % field in block
    
    if ( NewFlag & ( NumJ < length(IVar.FieldData{TypeI}) ) )
      % you are adding data to only some of the fields.
      % The other fields need to be padded with NumInst rows.
      
      ListJ = true(length(IVar.FieldData{TypeI}),1);
      ListJ(FieldJ) = 0;
      ListJ = find(ListJ);
      
      for jCol = ListJ(:)'
        % Extract the data to preserve
        FieldDataP = IVar.FieldData{TypeI}{ jCol }(RowP,:);
        
        % Padd with null data at the end
        FieldData = finargcat(1, FieldDataP, zeros(NumInst,0) );
      
        % rearrange the rows according to thier RowP and RowK locations
        FieldData(MapK,:) = FieldData;
    
        % Assign back to the instrument data
        IVar.FieldData{TypeI}{ jCol } = FieldData;
      end % field in block without input data

    end % check for padding only fields
      
    
  end % choice of new data or combined data
  
end % loop over blcoks

return


