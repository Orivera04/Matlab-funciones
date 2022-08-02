function varargout = instoptstock(varargin)
%INSTOPTSTOCK Constructor for the 'Type','OptStock' instrument.
%
%   Specify an European or Bermuda Option:
%     InstSet = instoptstock(OptSpec, Strike, Settle, ExerciseDates)
%     InstSet = instoptstock(OptSpec, Strike, Settle, ExerciseDates,...
%                            AmericanOpt)
%
%   Specify an American Option:
%     InstSet = instoptstock(OptSpec, Strike, Settle,ExerciseDates,...
%                            AmericanOpt)
%
%   To add 'OptStock' instruments to an instrument variable:
%     InstSet = instoptstock(InstSetOld, OptSpec, ... )
%
%   To list field meta-data for the 'OptStock' instrument:
%     [FieldList, ClassList, TypeString] = instoptstock;
%
%   Inputs: 
%     Fill unspecified entries in vectors with the value NaN.   
%     Only one data argument is required to create the instruments, 
%     the others may be omitted or passed as empty matrices [].  
%     Type "[FieldList, ClassList] = instoptstock" to see the classes.  Dates
%     can be input as serial date numbers or date strings.
%
%     OptSpec - NINST x 1 list of string values 'Call' or 'Put'.
%     Settle  - NINST x 1 of Settle dates.
%   
%     For an European or Bermuda Option:
%
%     Strike - NINST x NSTRIKES matrix of strike price values.
%              Each row is the schedule for one option.  If an option has fewer 
%              than NSTRIKES exercise opportunities, the end of the row is 
%              padded with NaN's.
%
%     ExerciseDates - NINST x NSTRIKES matrix of exercise dates.  Each row is
%                     the schedule for one option.  For a European option, there 
%                     is only one ExerciseDate on the option expiry date.
%
%     AmericanOpt - NINST x 1 vector of flags.  AmericanOpt is zero for each
%                   European or Bermuda option.  The default is 0 if AmericanOpt 
%                   is NaN or not entered.
%
%     For an American Option:
%
%     Strike - NINST x 1 vector of strike price values for each option.
%
%     ExerciseDates - NINST x 2 vector of exercise date boundaries. For each
%                     instrument, the option can be exercised on any tree date 
%                     between or including the pair of dates on that row. If only 
%                     one non-Nan date is listed, or if ExerciseDates is NINST x 1,
%                     the option can be exercised between the ValuationDate of the 
%                     stock tree and the single listed ExerciseDate.
%
%     AmericanOpt - NINST x 1 vector of flags.  AmericanOpt is 1 for each
%                   American option.  The AmericanOpt argument is required to invoke
%                   American exercise rules.
%   
%   Outputs:
%     InstSet - Variable containing a collection of instruments.  Instruments
%               are broken down by type and each type can have different data fields.
%               Each stored data field has a row vector or string for each instrument. 
%               Type "help instget" for more information on the InstSet variable. 
%
%     FieldList - NFIELDSx1 cell array of strings listing the name of each
%                 data field for this instrument type.
%
%     ClassList - NFIELDSx1 cell array of strings listing the data class
%                 of each field.  The class determines how arguments will be parsed.
%                 Valid strings are 'dble', 'date', and 'char'. 
%
%     TypeString - String specifying the type of instrument added.
%                  TypeString = 'OptStock'.
%
%
%   See also INSTADD, INSTGET, INSTDISP.

%   Author(s): M. Reyes-Kattar 01-Nov-2002
%   Copyright 1998-2003 The MathWorks, Inc. 
%   $Revision: 1.1.6.1 $  $Date: 2003/08/29 04:45:59 $

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
TypeString = 'OptStock';

% list default fields: FieldName, Class, SizeLimit, Default
FieldInfo = {
  'OptSpec'         , 'char' , [Inf Inf]   ,      ['Call'] ;
  'Strike'          , 'dble' , [Inf Inf]   ,    [NaN] ; 
  'Settle'          , 'date' , [Inf 1]   ,      [NaN] ; 
  'ExerciseDates'   , 'date' , [Inf Inf] ,      [NaN] ; 
  'AmericanOpt'     , 'dble' , [Inf 1]   ,      [0] };

%---------------------------------------------------------------------
% INSTENGINEADD is a subroutine and not a user function
%---------------------------------------------------------------------
varargout = instengineadd(TypeString, FieldInfo, varargin{:});

return

