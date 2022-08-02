function [FieldList, ClassList] = instfields(IVar, varargin)
%INSTFIELDS Retrieve list of fields stored in an instrument variable.  
%   The function queries the names of fields and their data storage classes.
%
%   [FieldList, ClassList] = instfields(InstSet, 'Type', TypeList)
%   [FieldList, ClassList] = instfields(InstSet)
%
%   Inputs: 
%     InstSet - Variable containing a collection of instruments. Instruments
%     are broken down by type and each type can have different data fields.
%     The stored data field is a row vector or string for each instrument. 
%
%     TypeList - String or NTYPESx1 cell array of strings listing the
%     instrument Type(s) to query.
%
%   Outputs:
%     FieldList - NFIELDSx1 cell array of strings listing the name of
%     each data field corresponding to the listed types.
%
%     ClassList - NFIELDSx1 cell array of strings listing the class of each
%     field in DataList. The class was used to parse data on input, 
%     and is one of 'dble', 'date', or 'char'.
%     
%   Examples:
%   1) Retrieve the InstSet variable, ExampleInst, from a data file.  
%      load InstSetExamples.mat
%      instdisp(ExampleInst)
%
%   2) Get only the fields listed for an 'Option'
%      [FieldList, ClassList] = instfields(ExampleInst, 'Type', 'Option')
%
%   3) Get the fields listed for types 'Option' and 'TBill'
%      FieldList = instfields(ExampleInst, 'Type', {'Option', 'TBill'})
%
%   4) Get all the fields listed in any type in the variable
%      FieldList = instfields(ExampleInst)
%
%   See also INSTTYPES, INSTLENGTH, INSTDISP.

%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.12 $  $Date: 2002/04/14 21:40:05 $

%---------------------------------------------------------------------
% Strip off an existing instrument or create one
%---------------------------------------------------------------------
if ~isafin(IVar,'Instruments')
  error('The first argument must be a Financial Instrument Variable')
end


%---------------------------------------------------------------------
% Pass arguments to instgetcell for the work
% Throw the data away
%---------------------------------------------------------------------
[Dummy, FieldList, ClassList] = instgetcell(IVar, varargin{:});


