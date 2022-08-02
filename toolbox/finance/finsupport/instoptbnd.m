function varargout = instoptbnd(varargin)
%INSTOPTBND Constructor for the 'Type','OptBond' instrument.
%
%   Specify an European or Bermuda Option:
%     InstSet = instoptbnd(BondIndex, OptSpec, Strike, ExerciseDates)
%     InstSet = instoptbnd(BondIndex, OptSpec, Strike, ExerciseDates, AmericanOpt)
%
%   Specify an American Option:
%     InstSet = instoptbnd(BondIndex, OptSpec, Strike, ExerciseDates, AmericanOpt)
%
%   To add 'OptBond' instruments to an instrument variable:
%     InstSet = instoptbnd(InstSetOld, OptSpec, ... )
%
%   To list field meta-data for the 'OptBond' instrument:
%     [FieldList, ClassList, TypeString] = instoptbnd;
%
%   Inputs: 
%     Fill unspecified entries in vectors with the value NaN.   
%     Only one data argument is required to create the instruments, 
%     the others may be omitted or passed as empty matrices [].  
%     Type "[FieldList, ClassList] = instoptbnd" to see the classes.  Dates
%     can be input as serial date numbers or date strings.
%
%     BondIndex - NINST x 1 vector of indices pointing to underlying
%     instruments of Type 'Bond' which are also stored in the InstSet
%     variable. Type "help instbond" to specify the bond data.
%
%     OptSpec - NINST x 1 list of string values 'Call' or 'Put'.
%   
%     For a European or Bermuda Option:
%
%     Strike - NINST x NSTRIKES matrix of strike price values.
%     Each row is the schedule for one option.  If an option has fewer than
%     NSTRIKES exercise opportunities, the end of the row is padded with NaN's.
%
%     ExerciseDates - NINST x NSTRIKES matrix of exercise dates.  Each row is
%     the schedule for one option.  For a European option, there is only one
%     ExerciseDate on the option expiry date.
%
%     AmericanOpt - NINST x 1 vector of flags.  AmericanOpt is zero for each
%     European or Bermuda option.  The default is 0 if AmericanOpt is NaN or
%     not entered.
%
%     For an American Option:
%
%     Strike - NINST x 1 vector of strike price values for each option.
%
%     ExerciseDates - NINST x 2 vector of exercise date boundaries. For each
%     instrument, the option can be exercised on any coupon date between or
%     including the pair of dates on that row. If only one non-Nan date is
%     listed, or if ExerciseDates is NINST x 1, the option can be exercised 
%     between the underlying bond Settle and the single listed ExerciseDate.
%
%     AmericanOpt - NINST x 1 vector of flags.  AmericanOpt is 1 for each
%     American option.  The AmericanOpt argument is required to invoke
%     American exercise rules.
%   
%   Outputs:
%     InstSet - Variable containing a collection of instruments.  Instruments
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
%                  TypeString = 'OptBond'.
%
%
%   See also INSTADD, INSTGET, INSTDISP, HJMPRICE.

%   Author(s): M. Reyes-Kattar 04/25/99
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.14 $  $Date: 2002/04/14 21:40:30 $

%---------------------------------------------------------------------
% Checking input arguments
%---------------------------------------------------------------------
if nargin > 1
    if isafin(varargin{1},'Instruments')
        NargNum = 4;
    else
        NargNum = 3;
    end
    DateInd = NargNum+1;
    
    if nargin > NargNum & iscell(varargin{DateInd})
        EDates  = varargin{DateInd};
        InSize  = size(EDates);
        varargin{DateInd} = reshape(datenum(EDates(:)), InSize);
    end
end

%---------------------------------------------------------------------
% Describe instrument
%---------------------------------------------------------------------
TypeString = 'OptBond';

% list default fields: FieldName, Class, SizeLimit, Default
FieldInfo = {
  'UnderInd'       , 'index', [Inf 1] ,   [NaN] ;
  'OptSpec'        , 'char' , [Inf 4] ,   ['Call'] ;
  'Strike'         , 'dble' , [Inf Inf] , [NaN] ; 
  'ExerciseDates'  , 'date' , [Inf Inf] , [NaN] ; 
  'AmericanOpt'    , 'dble' , [Inf 1] ,   [0] };

%---------------------------------------------------------------------
% INSTENGINEADD is a subroutine and not a user function
%---------------------------------------------------------------------
varargout = instengineadd(TypeString, FieldInfo, varargin{:});

return

