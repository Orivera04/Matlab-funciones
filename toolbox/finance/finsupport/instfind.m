function [Index, Data, Field, Class, IndexSet, TypeSet] = instfind(IVar, varargin)
%INSTFIND Search instruments for matching conditions.
%   Return indices of instruments matching Type, Field or Index values.
%
%   IndexMatch = instfind(InstSet, 'FieldName', FieldList, 'Data' , DataList,...
%                                  'Index', IndexSet, 'Type', TypeList)
%
%   Inputs: 
%     Parameter value pairs can be entered in any order. The InstSet variable 
%     must be the first argument.  'FieldName' and 'Data' parameters must appear
%     together or not at all, 'Index' and 'Type' parameters are each optional.
%
%     InstSet - Variable containing a collection of instruments. Instruments
%     are broken down by type and each type can have different data fields. 
%     The stored data field is a row vector or string for each instrument. 
%
%     FieldList - String or NFIELDSx1 cell array of strings listing the
%     name of each data field to match with data values.
%
%     DataList - NVALUESxM array or NFIELDSx1 cell array of acceptable
%     data values for each field.  Each row lists a data row value to search
%     for in the corresponding FieldList. The number of columns is arbitrary
%     and matching will ignore trailing NaN's or spaces.
%
%     IndexSet - NINSTx1 vector restricting positions of instruments to check
%     for matches. The default is all indices available in the instrument 
%     variable. 
%
%     TypeList - String or NTYPESx1 cell array of strings restricting
%     instruments to match one of TypeList types. The default is all
%     types in the instrument variable. 
%
%   Output:
%     IndexMatch - NINSTx1 vector of positions of instruments matching the
%     input criteria.  Instruments are returned in IndexMatch if all the
%     Field, Index, and Type conditions are met.  An instrument meets an
%     individual Field condition if the stored FieldName data matches any
%     of the rows listed in the DataList for that FieldName.
%
%   Examples:
%   1) Retrieve the instrument set variable, ExampleInst, from the data file 
%      InstSetExamples.mat. The variable contains three types of instruments: 
%      Option, Futures, and TBill. 
%
%      load InstSetExamples.mat
%      ISet = ExampleInst
%      instdisp(ISet)
%
%      Index Type   Strike Price Opt  Contracts
% 	   1     Option  95    12.2  Call     0     
% 	   2     Option 100     9.2  Call     0     
% 	   3     Option 105     6.8  Call  1000    
%      
%  	   Index Type    Delivery       F     Contracts
% 	   4     Futures 01-Jul-1999    104.4 -1000    
%      
% 	   Index Type   Strike   Price Opt  Contracts
% 	   5     Option 105      7.4   Put  -1000     
% 	   6     Option  95      2.9   Put      0     
% 	
% 	   Index Type  Price Maturity       Contracts
% 	   7     TBill 99    01-Jul-1999    6      
%
%
%   2) Make a vector, Opt95, containing the indexes within ExampleInst 
%      of the options struck at 95:
%      Opt95 = instfind(ExampleInst, 'FieldName','Strike','Data','95') 
%
%   3) Locate the Futures and Treasury bill instruments:
%      Types = instfind(ExampleInst,'Type',{'Futures';'TBill'})
%
%
%   See also INSTSELECT, INSTGET, INSTGETCELL, INSTADDFIELD.

%   Author(s) : J. Akao 31-Mar-1999
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.12 $  $Date: 2002/04/14 21:40:16 $

%---------------------------------------------------------------------
% Allow easy fieldname-data tags
%---------------------------------------------------------------------
% TagStyle = 'None';
TagStyle = 'Pair';

if ~strcmp(TagStyle,'Pair')
  % Just let instgetcell parse this
  Args = varargin;

else
  
  % Preprocess the arguments to catch value-data pairs
  %               1       2         3           4        5
  ParamList = {'Type', 'Index', 'FieldName', 'Data', 'FieldClass'};


  % Perform parsing
  [PV,PVFlag,TagList,TagData] = instpvp(TagStyle,ParamList, varargin{:});

  % ---------- FieldNames ------------------
  ColNameSet = cellstr( finargchar(PV{3}) );

  % Add any miscellaneous tags 
  ColNameSet = [ColNameSet; TagList];
  
  if length(TagList)>0
    % Make sure to pass FieldName
    PVFlag(3) = 1;
  end
  
  % squeeze out any empty strings
  ColNameSet( cellfun('isempty',ColNameSet) ) = []; % squeeze out any empties

  % record all fieldnames in the fieldname list
  PV{3} = ColNameSet;
  
  NumCols = length(ColNameSet);
  % ------------- Data ---------------------
  ColData = PV{4};

  % catch cases when you should wrap a single argument into a cell
  if ~iscell(ColData) & ~isempty(ColData)
    ColData = {ColData};
  elseif ( NumCols==1 & (length(ColData) > 1) )
    ColData = {ColData};
  end

  % Add any miscellanous data values 
  ColData = [ColData; TagData];
  
  % you pass Field and Data in pairs or not at all
  PVFlag(4) = PVFlag(3);
  
  % Store back any fieldname data
  PV{4} = ColData;

  % ------------- Create arguments ---------------------
  PV = PV';
  Args = [ParamList(PVFlag); PV(PVFlag)];
  
  if isempty(Args)
    Args = {};
  end

end

[Data, Field, Class, IndexSet, TypeSet] = instgetcell(IVar, Args{:});

% You can get a fair amount of Data junk to throw away if not matching
% fieldnames. 
Index = IndexSet;
