function varargout = instbond(varargin)
%INSTBOND Constructor for the 'Type','Bond' instrument.
%
%   To create a new instrument variable from data arrays:
%   ISet = instbond(CouponRate, Settle, Maturity, ...
%             Period, Basis, EndMonthRule, ...
%             IssueDate, FirstCouponDate, LastCouponDate, ...
%             StartDate, Face)
%
%   To add 'Bond' instruments to an instrument variable:
%   ISet = instbond(ISet, CouponRate, Settle, Maturity, ...
%             Period, Basis, EndMonthRule, ...
%             IssueDate, FirstCouponDate, LastCouponDate, ...
%             StartDate, Face)
%
%   To list field meta-data for the 'Bond' instrument:
%   [FieldList, ClassList, TypeString] = instbond;
%
%   Inputs: 
%     Data arguments are NINST x 1 vectors, scalar, or empty.  Fill
%     unspecified entries in vectors with the value NaN.   
%     Only one data argument is required to create the instruments,
%     the others may be omitted or passed as empty matrices [].  
%     Type "[FieldList, ClassList] = instbond" to see the classes.
%     Dates can be input as serial date numbers or date strings.
%     Type "help ftb" for more detail on SIA fixed income arguments.
%
%     CouponRate      - Decimal annual rate.
%     Settle          - Settlement date.
%     Maturity        - Maturity date.
%     Period          - Coupons per year. Default is 2.
%     Basis           - Day-count basis.  Default is 0 (actual/actual).
%     EndMonthRule    - End-of-month rule.  Default is 1 (in effect).
%     IssueDate       - Bond issue date.
%     FirstCouponDate - Irregular first coupon date.
%     LastCouponDate  - Irregular last coupon date.
%     StartDate       - Input ignored.
%     Face            - Face value.  Default is 100.
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
%     TypeString = 'Bond'.
%
%
%   See also INSTADDFIELD, INSTGET, INSTDISP, INTENVPRICE, HJMPRICE.

%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.15 $  $Date: 2002/04/14 21:39:52 $

%---------------------------------------------------------------------
% Describe instrument
%---------------------------------------------------------------------
TypeString = 'Bond';

% list default fields: FieldName, Class, SizeLimit, Default
FieldInfo = {
  'CouponRate'     , 'dble' , [Inf 1] , [0] ;
  'Settle'         , 'date' , [Inf 1] , [NaN] ; 
  'Maturity'       , 'date' , [Inf 1] , [NaN] ;
  'Period'         , 'dble' , [Inf 1] , [2] ;
  'Basis'          , 'dble' , [Inf 1] , [0] ; 
  'EndMonthRule'   , 'dble' , [Inf 1] , [1] ; 
  'IssueDate'      , 'date' , [Inf 1] , [NaN] ; 
  'FirstCouponDate', 'date' , [Inf 1] , [NaN] ; 
  'LastCouponDate' , 'date' , [Inf 1] , [NaN] ; 
  'StartDate'      , 'date' , [Inf 1] , [NaN] ; 
  'Face'           , 'dble' , [Inf 1] , [100] };

%---------------------------------------------------------------------
% INSTENGINEADD is a subroutine and not a user function
%---------------------------------------------------------------------
varargout = instengineadd(TypeString, FieldInfo, varargin{:});

return

