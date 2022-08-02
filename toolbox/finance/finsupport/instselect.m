function [IVar, IndexSet] = instselect(varargin)
%INSTSELECT Create a subset of instruments by matching conditions.
%
%   InstSubSet = instselect(InstSet, 'FieldName', FieldList,'Data' , DataList, ...      
%                              'Index', IndexSet, 'Type', TypeList)
%
%   Inputs: 
%     Parameter value pairs can be entered in any order. The
%     InstSet variable must be the first argument.  'FieldName' and 'Data'
%     parameters must appear together or not at all, 'Index' and 'Type'
%     parameters are each optional.
%
%     InstSet - Variable containing a collection of instruments. Instruments
%     are broken down by type and each type can have different data fields.
%     The stored data field is a row vector or string for each instrument. 
%
%     FieldList - String or NFIELDSx1 cell array of strings listing the
%     name of each data field to match with data values.
%
%     DataList - NVALUESxM array or NFIELDSx1 cell array of acceptable
%     data values for each field. Each row lists a data row value to
%     search for in the corresponding FieldList.  The number of columns
%     is arbitrary and matching will ignore trailing NaN's or spaces.
%
%     IndexSet - NINSTx1 vector restricting positions of instruments to
%     check for matches. The default is all indices available in the
%     instrument variable. 
%
%     TypeList - String or NTYPESx1 cell array of strings restricting
%     instruments to match one of TypeList types.  The default is all
%     types in the instrument variable. 
%
%   Output:
%     InstSubSet - Variable containing instruments matching the input criteria.
%     Instruments are returned in InstSubSet if all the Field, Index, and Type
%     conditions are met. An instrument meets an individual Field condition 
%     if the stored FieldName data matches any of the rows listed in the
%     DataList for that FieldName.
%
%
%   Examples:
%   1) Retrieve the instrument set variable, ExampleInst, from a data file. 
%      There are 3 types of instruments in the variable: 'Option', 'Futures', 
%      and 'TBill'.
%
%      load InstSetExamples.mat
%      instdisp(ExampleInst)
%
%   2) Create a new variable with Options struck at 95
%      ISet = instselect(ExampleInst, 'FieldName','Strike','Data',95)
%      instdisp(ISet)
%
%   See also INSTFIND, INSTDELETE, INSTGET, INSTADDFIELD.

%   Author(s) : J. Akao 31-Mar-1999
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.10 $  $Date: 2002/04/14 21:40:38 $

%-----------------------------------------------------------------------
% Call instfind to do the matching
%-----------------------------------------------------------------------
IndexSet = instfind(varargin{:});
NInst = length(IndexSet);

% The instrument variable is the first in
IVar = varargin{1};
NInstOld = size(IVar.IndexTable.TypeI, 1);

% Do a quick job in IndexTable.  This doesn't remove unused Types, but
% I'm not sure we should.
IVar.IndexTable.TypeI = IVar.IndexTable.TypeI(IndexSet);
IVar.IndexTable.RowK  = IVar.IndexTable.RowK(IndexSet);

%-----------------------------------------------------------------------
% update any FieldClass, 'index' entries
%-----------------------------------------------------------------------

% Create a map from old 'index' entries to new entries
IMap = NaN*ones(NInstOld,1);
IMap(IndexSet) = (1:NInst)';

% change any index entries to point to the same instruments
NumTypes = length(IVar.Type);
for iType=1:NumTypes
  FieldJ = find(strcmp('index', IVar.FieldClass{iType}));
  for jField = FieldJ(:)'
    IndexRef = IVar.FieldData{iType}{jField};

    % trap indices which didn't point to anything originally
    IndexRef(IndexRef>NInstOld) = NaN;
    
    % remap any non-nan indices
    IndexRef( ~isnan(IndexRef) ) = IMap( IndexRef( ~isnan(IndexRef) ) );
    
    IVar.FieldData{iType}{jField} = IndexRef;
  end
end

