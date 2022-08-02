function varargout = instswap(varargin)
%INSTSWAP Constructor for the 'Type','Swap' instrument.
%
%   To create a new instrument variable from data arrays:
%   ISet = instswap(LegRate, Settle, Maturity, LegReset, Basis, Principal,...
%                    LegType)
%
%   To add 'Swap' instruments to an instrument variable:
%   ISet = instswap(ISet, LegRate, Settle, Maturity, LegReset, Basis, Principal,...
%                    LegType)
%
%   To list field meta-data for the 'Swap' instrument:
%   [FieldList, ClassList, TypeString] = instswap;
%
%   Inputs: 
%     Data arguments are NINSTx1 vectors, NINSTx2 matrices, scalar, or empty.  
%     Fill unspecified entries in vectors with the value NaN.   
%     Only one data argument is required to create the instruments, the
%     others may be omitted or passed as empty matrices [].  
%     Type "[FieldList, ClassList] = instswap" to see the classes.  Dates
%     can be input as serial date numbers or date strings.
%
%     LegRate    - NINSTx2 matrix, with each row defined as follows: 
%     [CouponRate Spread] or [Spread CouponRate]
%     where CouponRate is the decimal annual rate and Spread is the number 
%     of basis points over the reference rate. The first column represents
%     the receiving leg, while the second column represents the paying leg.                 
%
%     Settle - NINSTx1 vector of dates representing the settle date for each 
%     swap.
%
%     Maturity - NINSTx1 vector of dates representing the maturity date for 
%     each swap.
%
%     LegReset - NINSTx2 matrix representing the reset frequency per year for 
%     each swap. Default is [1 1].
%
%     Basis - NINSTx1 vector representing the basis used when annualizing the 
%     input forward rate tree for each instrument. Default is 0 (actual/actual).
%
%     Principal - NINSTx1 vector of the notional principal amounts. 
%     The default is 100.
%
%     LegType - NINSTx2 matrix, with each row representing an instrument, and 
%     each column indicating if the corresponding leg is fixed or floating.
%     A value of 0 represents a floating leg, and a value of 1 represents 
%     a fixed leg. Use this matrix to define how to interpret the values
%     entered in the Matrix LegRate. Default is [1,0] for each instrument.
%
%   Outputs:
%     ISet - Variable containing a collection of instruments.  Instruments
%     are broken down by type and each type can have different data fields.
%     Each stored data field has a row vector or string for each instrument. 
%     Type "help instget" for more information on the ISet variable. 
%   
%     FieldList - NFIELDSx1 cell array of strings listing the name of each
%     data field for this instrument type.
%   
%     ClassList - NFIELDSx1 cell array of strings listing the data class
%     of each field.  The class determines how arguments will be parsed.
%     Valid strings are 'dble', 'date', and 'char'. 
%   
%     TypeString - String specifying the type of instrument added.
%     TypeString = 'Swap'.
%
%   See also INSTBOND, INSTCAP, INSTFLOOR, INSTADDFIELD, INSTDISP, 
%            INTENVPRICE, HJMPRICE.

%   Author(s): M. Reyes-Kattar 03/10/99
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.15 $   $Date: 2002/04/14 21:40:44 $

%---------------------------------------------------------------------
% Describe instrument
%---------------------------------------------------------------------
TypeString = 'Swap';

% list default fields: FieldName, Class, SizeLimit, DefaultF
FieldInfo = {
  'LegRate'        , 'dble' , [Inf 2] , [NaN] ;
  'Settle'         , 'date' , [Inf 1] , [NaN] ; 
  'Maturity'       , 'date' , [Inf 1] , [NaN] ;
  'LegReset'       , 'dble' , [Inf 2] , [NaN] ;
  'Basis'          , 'dble' , [Inf 1] , [0] ; 
  'Principal'      , 'dble' , [Inf 1] , [100]; 
  'LegType'        , 'dble' , [Inf 2] , [NaN]};

%---------------------------------------------------------------------
% INSTENGINEADD is a subroutine and not a user function
%---------------------------------------------------------------------
varargout = instengineadd(TypeString, FieldInfo, varargin{:});

return
