function IVar = instsetfield(varargin)
%INSTSETFIELD Set data for existing instruments in an instrument collection variable.
%
%   To reset or add fields to every instrument:
%   InstSet = instsetfield(InstSetOld, 'FieldName', FieldList, ... 
%                             'Data' , DataList)
%
%   To reset or add fields to a subset of instruments:
%   InstSet = instsetfield(InstSetOld, 'FieldName', FieldList, ... 
%                             'Data' , DataList, 'Index', IndexSet, ...
%                             'Type', TypeList)
%
%   Inputs: 
%     Parameter value pairs can be entered in any order. An existing
%     InstSet variable must be the first argument.  
%
%     InstSetOld - Variable containing a collection of instruments.  Instruments
%     are broken down by type and each type can have different data fields. 
%     The stored data field is a row vector or string for each instrument. 
%
%     FieldList - String or NFIELDSx1 cell array of strings listing the
%     name of each data field.  FieldList should _not_ be either 'Type' 
%     or 'Index'; these field names are reserved.
%
%     DataList - NINSTxM array or NFIELDSx1 cell array of data contents for
%     each field. Each row in a data array corresponds to a separate instrument
%     Single rows are copied to apply to all instruments to be worked on.
%     The number of columns is arbitrary and data will be padded along columns.  
%
%     TypeList - String or NTYPEx1 cell array of strings restricting
%     instruments to be worked on to match one of TypeList types.
%
%     IndexSet - NINSTx1 vector of positions of instruments to work on.
%     If TypeList is also entered, instruments referenced must be one of
%     TypeList types and contained in IndexSet.
%
%   Output:   
%     InstSet - Instrument set variable containing the new input data.
%
%   Examples: 
%   1) Retrieve the instrument set variable, ExampleInstSF, from a data file. 
%      The variable contains three types of instruments: Option, Futures, 
%      and TBill. 
%
%     load InstSetExamples.mat
%
%     ISet = ExampleInstSF;
%     instdisp(ISet)
%   
%   2) Enter data for the option in Index 6: Price 2.9 for a strike of 95
%      ISet = instsetfield(ISet, 'Index',6, 'FieldName',{'Strike','Price'}, ...
%                                               'Data',{  95    ,  2.9 });
%     instdisp(ISet)
%   
%   3) Create a new field, Maturity, for the cash instrument
%      MDate = datenum('7/1/99')
%      ISet = instsetfield(ISet, 'Type', 'TBill', 'FieldName', 'Maturity', ...
%                                                 'FieldClass', 'date', ...
%                                                 'Data', MDate );
%      instdisp(ISet)
%   
%   4) Create a new field, Contracts, for all instruments
%      ISet = instsetfield(ISet, 'FieldName', 'Contracts', 'Data', 0);
%      instdisp(ISet)
%   
%   
%   5) Set the Contracts fields for some instruments
%      ISet = instsetfield(ISet,'Index',[3; 5; 4; 7],'FieldName','Contracts', ...
%                               'Data', [1000; -1000; -1000; 6]);
%   
%      instdisp(ISet)
%
%   See also INSTADDFIELD, INSTGET, INSTGETCELL, INSTDISP, FINARGPARSE.


%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.10 $  $Date: 2002/04/14 21:40:41 $

%---------------------------------------------------------------------
% Call instengineset to do the work
%---------------------------------------------------------------------
NewFlag = 0;
IVar = instengineset(NewFlag, varargin{:});

return
