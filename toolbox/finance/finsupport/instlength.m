function [NInst] = instlength(IVar, varargin)
%INSTLENGTH Counts the instruments stored in an instrument variable.
%
%   NInst = instlength(InstSet)
%
%   Inputs: 
%     InstSet - Variable containing a collection of instruments. Instruments
%     are broken down by type and each type can have different data fields. 
%     The stored data field is a row vector or string for each instrument. 
%
%   Outputs:
%     NInst - Number of instruments contained in the variable, InstSet.
%
%   Example:  
%     Retrieve the instrument set variable, ExampleInst, from a data file.
%     There are 7 instruments in the variable.
%
%     load InstSetExamples.mat
%     instdisp(ExampleInst)
%
%     NInst = instlength(ExampleInst)
%     NInst = 7
%
%   See also INSTTYPES, INSTFIELDS, INSTDISP.

%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.9 $  $Date: 2002/04/14 21:40:27 $

%---------------------------------------------------------------------
% Strip off an existing instrument or create one
%---------------------------------------------------------------------
if ~isafin(IVar,'Instruments')
  error('The first argument must be a Financial Instrument Variable')
end


%---------------------------------------------------------------------
% Pass arguments to instgetcell for the work
%---------------------------------------------------------------------
IndexSet = instget(IVar, varargin{:}, 'FieldName',{'Index'});


%---------------------------------------------------------------------
% count the instruments possible
%---------------------------------------------------------------------
NInst = size(IndexSet,1);

