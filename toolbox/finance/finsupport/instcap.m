function varargout = instcap(varargin)
%INSTCAP Constructor for the 'Type','Cap' instrument.
%
%   To create a new instrument variable from data arrays:
%   ISet = instcap(Strike, Settle, Maturity, Reset, Basis, Principal)
%
%   To add 'Cap' instruments to an instrument variable:
%   ISet = instcap(ISet, Strike, Settle, Maturity, Reset, Basis, Principal)
%
%   To list field meta-data for the 'Cap' instrument:
%   [FieldList, ClassList, TypeString] = instcap;
%
%   Inputs: 
%     Data arguments are NINST x 1 vectors, scalar, or empty.  
%     Fill unspecified entries in vectors with the value NaN.   
%     Only one data argument is required to create the instruments, 
%     the others may be omitted or passed as empty matrices [].  
%     Type "[FieldList, ClassList] = instcap" to see the classes.
%     Dates can be input as serial date numbers or date strings.
%
%     Strike     - Rate at which the cap is exercised, as a decimal number. 
%     Settle     - Settlement date.
%     Maturity   - Maturity date.
%     Reset      - Frequency of payments per year. Default is 1.
%	  Basis      - Day-count basis. Default is 0 (actual/actual).
%     Principal  - Notional principal amount. Default is 100.
%   
%
%   Outputs:
%     ISet - Variable containing a collection of instruments.  Instruments
%     are broken down by type and each type can have different data
%     fields.  Each stored data field has a row vector or string for each
%     instrument.  Type "help instget" for more information on the ISet
%     variable. 
%   
%     FieldList - NFIELDSx1 cell array of strings listing the name of each
%     data field for this instrument type.
%   
%     ClassList - NFIELDSx1 cell array of strings listing the data class
%     of each field.  The class determines how arguments will be parsed.
%     Valid strings are 'dble', 'date', and 'char'. 
%   
%     TypeString - String specifying the type of instrument added.
%     TypeString = 'Cap'.
%
%   See also INSTBOND, INSTFLOOR, INSTSWAP, INSTADDFIELD, INSTDISP, 
%            INTENVPRICE, HJMPRICE.

%   Author(s): M. Reyes-Kattar 03/10/99
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.13 $    $Date: 2002/04/14 21:41:23 $

%---------------------------------------------------------------------
% Describe instrument
%---------------------------------------------------------------------
TypeString = 'Cap';

% list default fields: FieldName, Class, SizeLimit, Default
FieldInfo = {
  'Strike'         , 'dble' , [Inf 1] , [0.05] ;
  'Settle'         , 'date' , [Inf 1] , [NaN] ; 
  'Maturity'       , 'date' , [Inf 1] , [NaN] ;
  'CapReset'       , 'dble' , [Inf 1] , [1] ;
  'Basis'          , 'dble' , [Inf 1] , [0] ; 
  'Principal'      , 'dble' , [Inf 1] , [100] };

%---------------------------------------------------------------------
% INSTENGINEADD is a subroutine and not a user function
%---------------------------------------------------------------------
varargout = instengineadd(TypeString, FieldInfo, varargin{:});

return
