function IVar = instaddfield(varargin)
%INSTADDFIELD Add new instruments to an instrument collection variable.
%   Use INSTADDFIELD to create your own types of instruments, or to
%   append new instruments to an existing collection.
%
%   To create an instrument variable:
%     InstSet = instaddfield('FieldName', FieldList, 'Data' , DataList, ...      
%                       'Type', TypeString)
%
%     InstSet = instaddfield('FieldName', FieldList, 'FieldClass', ClassList, ...
%                       'Data' , DataList, 'Type', TypeString)
%
%   To add instruments:
%     InstSet = instaddfield(InstSetOld, 'FieldName', FieldList, ... 
%                             'Data' , DataList, 'Type', TypeString)
%
%   Inputs: 
%     Parameter value pairs can be entered in any order.  An
%     existing InstSet variable must be the first argument.  
%
%     InstSetOld - Variable containing a collection of instruments. Instruments
%     are broken down by type and each type can have different data fields.
%     The stored data field is a row vector or string for each instrument. 
%
%     FieldList - String or NFIELDSx1 cell array of strings listing the name
%     of each data field.  FieldList should not be either 'Type' or 'Index', 
%     these field names are reserved.
%
%     DataList - NINSTxM array or NFIELDSx1 cell array of data contents for
%     each field. Each row in a data array corresponds to a separate instrument.
%     Single rows are copied to apply to all instruments to be worked on.
%     The number of columns is arbitrary and data will be padded along columns.
%
%     ClassList - String or NFIELDSx1 cell array of strings listing the data
%     class of each field.  The class determines how the DataList will be
%     parsed.  Valid strings are 'dble', 'date', and 'char'.  The 'FieldClass',
%     ClassList pair is always optional.  ClassList will be inferred from 
%     existing fieldnames or from the data if not entered. 
%
%     TypeString - String specifying the type of instrument added.
%     Instruments of different types can have different fieldname collections. 
%
%   Output:   
%     InstSet - Instrument set variable containing the new input data.
%
%   Examples: 
%   1) Build a portfolio around July Options:
%
%      Strike Call  Put
%       95    12.2  2.9
%      100     9.2  4.9
%      105     6.8  7.4
%
%      Strike = (95:5:105)'
%      CallP = [12.2; 9.2; 6.8]
%   
%   2) Enter 3 call options with data fields 'Strike', 'Price', and 'Opt'
%      ISet = instaddfield('Type','Option', ...
%                         'FieldName',{'Strike','Price','Opt'}, ...
%                         'Data',{ Strike,  CallP, 'Call'});
%      instdisp(ISet)
%   
%   3) Enter a futures contract and set the input parsing class:
%      ISet = instaddfield(ISet,'Type','Futures', ...
%                          'FieldName',{'Delivery','F'}, ...
%                          'FieldClass',{  'date'  , 'dble'}, ...
%                          'Data' ,{'01-Jul-99' , 104.4  });
%      instdisp(ISet)
%   
%   4) Enter a put option:
%      FN = instfields(ISet,'Type','Option')
%      ISet = instaddfield(ISet,'Type','Option','FieldName',FN,...
%                       'Data',{105, 7.4, 'Put'});
%      instdisp(ISet)
%   
%   5) Make a placeholder for another put:
%      ISet = instaddfield(ISet,'Type','Option','FieldName','Opt','Data','Put')
%      instdisp(ISet)
%   
%   6) Add a cash instrument:
%      ISet = instaddfield(ISet, 'Type', 'TBill', 'FieldName','Price','Data',99)
%      instdisp(ISet)
%   
%
%   See also INSTSETFIELD, INSTGETCELL, INSTGET, FINARGPARSE, INSTDISP.


%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.14 $  $Date: 2002/04/14 21:39:25 $

%---------------------------------------------------------------------
% Call instengineset to do the work
%---------------------------------------------------------------------
NewFlag = 1;
IVar = instengineset(NewFlag, varargin{:});

return
