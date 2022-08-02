function varargout = instget(Inst, varargin)
%INSTGET Retrieve data arrays from an instrument variable.
%
%    [Data_1, Data_2, ... Data_NFIELDS ] = instget(InstSet, ...
%                                        'FieldName', FieldList, ...
%                                        'Index', IndexSet, ...
%                                        'Type', TypeList)
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
%     instruments to be worked on to match one of TypeList types. The
%     default is all types in the instrument variable.
%
%   Outputs:
%     Data_1 - NINSTxM array of data contents for the first field in FieldList.
%     Each row corresponds to a separate instrument in IndexSet.  Any data
%     which is not available is returned as NaN or as spaces. 
%
%     Data_NFIELDS - NINSTxM array of data contents for the last field in
%     FieldList.   
%
%   Examples:
%   1) Retrieve the instrument set variable, ExampleInst, from a data file.  
%      There are 3 types of instruments in the variable: 'Option', 'Futures', 
%      and 'TBill'.
%
%      load InstSetExamples.mat
%      instdisp(ExampleInst)
%
%      Index Type   Strike Price Opt  Contracts
%      1     Option  95    12.2  Call     0    
%      2     Option 100     9.2  Call     0    
%      3     Option 105     6.8  Call  1000    
%     
%      Index Type    Delivery       F     Contracts
%      4     Futures 01-Jul-1999    104.4 -1000    
%     
%      Index Type   Strike Price Opt  Contracts
%      5     Option 105     7.4  Put  -1000    
%      6     Option  95     2.9  Put      0    
%     
%      Index Type  Price Maturity       Contracts
%      7     TBill 99    01-Jul-1999    6        
%
%   2) Extract the price from all instruments
%      P = instget(ExampleInst,'FieldName','Price')
%   
%   3) Get both the price and the number of contracts held
%      [P,C] = instget(ExampleInst, 'FieldName', {'Price', 'Contracts'})
%   
%   4) Compute a value, V, and store it back to the variable, ISet.
%      V = P.*C
%      ISet = instsetfield(ExampleInst, 'FieldName', 'Value', 'Data', V);
%      instdisp(ISet)
%   
%   5) Look at only the instruments which have nonzero Contracts.
%      Ind = find( C ~= 0 )
%   
%   6) Get the Type and Opt parameters from those instruments.
%      Only Options have a stored 'Opt' field.
%      [T,O] = instget(ExampleInst, 'Index', Ind, 'FieldName', {'Type', 'Opt'})
%   
%   7) Create a string report of holdings Type, Opt, and Value
%      rstring = [T, O, num2str(V(Ind))]
%
%   See also INSTGETCELL, INSTADDFIELD, INSTSETFIELD, INSTDISP.

%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.11 $  $Date: 2002/04/14 21:40:19 $

varargout = instgetcell(Inst, varargin{:});

