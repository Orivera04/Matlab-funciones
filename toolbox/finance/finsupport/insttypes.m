function [TypeList] = insttypes(IVar, varargin)
%INSTTYPES Retrieve list of types stored in an instrument variable.
%
%   [TypeList] = insttypes(InstSet)
%
%   Inputs: 
%     InstSet - Variable containing a collection of instruments. Instruments
%     are broken down by type and each type can have different data fields.
%     The stored data field is a row vector or string for each instrument. 
%
%   Outputs:
%     TypeList - NTYPESx1 cell array of strings listing the Type of
%     instruments contained in the variable.
%
%   Example:
%     Retrieve the instrument set variable, ExampleInst, from a data file. 
%     There are 3 types of instruments in the variable: 'Option', 'Futures', 
%     and 'TBill'.
%
%     load InstSetExamples.mat
%     instdisp(ExampleInst)
%
%     TypeList = insttypes(ExampleInst)
%     TypeList = 
%          'Futures'
%          'Option'
%          'TBill'
%
%   See also INSTFIELDS, INSTLENGTH, INSTDISP.

%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.11 $  $Date: 2002/04/14 21:40:47 $

%---------------------------------------------------------------------
% Strip off an existing instrument or create one
%---------------------------------------------------------------------
if ~isafin(IVar,'Instruments')
  error('The first argument must be a Financial Instrument Variable')
end


%---------------------------------------------------------------------
% Pass arguments to instget for the work
%---------------------------------------------------------------------
TypeSet = instget(IVar, varargin{:}, 'FieldName',{'Type'});


%---------------------------------------------------------------------
% Return only unique types
%---------------------------------------------------------------------
TypeList = unique(cellstr(TypeSet));

