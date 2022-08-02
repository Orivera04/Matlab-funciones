function varargout = instcompound(varargin)
%INSTCOMPOUND Constructor for the 'Type','Compound ' instrument.
%
%   InstSet = instcompound(UOptSpec, UStrike, USettle, UExerciseDates,...
%                          UAmericanOpt,COptSpec, CStrike, CSettle, ...
%                          CExerciseDates, CAmericanOpt)
%
%   To add 'Compound' instruments to an instrument variable:
%     InstSet = instcompound(InstSetOld, UOptSpec, ... )
%
%   To list field meta-data for the 'Compound' instrument:
%     [FieldList, ClassList, TypeString] = instcompound;
%
%   Inputs: 
%     Fill unspecified entries in vectors with the value NaN.   
%     Only one data argument is required to create the instruments, 
%     the others may be omitted or passed as empty matrices [].  
%     Type "[FieldList, ClassList] = instcompound" to see the classes.  Dates
%     can be input as serial date numbers or date strings.
%
%     UOptSpec        - String 'call' or 'put' of the underlying option.                     
%     UStrike         - 1 X 1 vector of the underlying strike price.
%     USettle         - 1 X 1 vector of the settlement date or trade date.
%
%     UExerciseDates  - For an European Option:
%                       1 X 1 vector of the underlying exercise date. For an 
%                       European option,there is only one ExerciseDate on the 
%                       option expiry date.
%                     
%                       For an American Option:
%                       1 x 2 vector of the underlying exercise date boundaries. 
%                       The option can be exercised on any tree date. If only 
%                       one non-Nan date is listed, or if ExerciseDates is 1 x 1, 
%                       the option can be exercised between the ValuationDate of the 
%                       stock tree and the single listed ExerciseDate.
%
%     UAmericanOpt    - Flag of the underlying option: 0(European)or 1(American).
%                     
%     COptSpec        - NINST x 1 cell array of strings 'call' or 'put' 
%                       of the compound option.
%     CStrike         - For an European and American Option:
%                       NINST x 1  matrix of compound strike price values. Each row
%                       is the schedule for one option. 
%     CSettle         - 1 X 1 vector of the settlement date or trade date.
%
%     CExerciseDates  - For an European Option:
%                       NINST x 1 matrix of compound exercise dates. Each row is 
%                       the schedule for one option. For an European option,there 
%                       is only one ExerciseDate on the option expiry date.
%                     
%                       For an American Option:
%                       NINST x 2 vector of the compound exercise date boundaries. 
%                       For each instrument, the option can be exercised on any tree date 
%                       between or including the pair of dates on that row. If only 
%                       one non-Nan date is listed, or if ExerciseDates is NINST x 1, 
%                       the option can be exercised between the ValuationDate of the 
%                       stock tree and the single listed ExerciseDate.
%
%     CAmericanOpt    - NINST x 1 vector of flags 0(European) or 1(American)
%                       of the compound option. Default is 0.
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
%                  TypeString = 'Compound'.
%
%
%   See also INSTADD, INSTGET, INSTDISP.

%   Author(s): M. Reyes-Kattar 01-Nov-2002
%   Copyright 1998-2003 The MathWorks, Inc. 
%   $Revision: 1.1.6.1 $  $Date: 2003/08/29 04:45:56 $

%---------------------------------------------------------------------
% Checking input arguments
%---------------------------------------------------------------------
if nargin > 1
    if isafin(varargin{1},'Instruments')
        NargNum = [5 10];
    else
        NargNum = [4 9];
    end
    
    for DateIdx=NargNum
        if nargin >= DateIdx & iscell(varargin{DateIdx})
            EDates  = varargin{DateIdx};
            InSize  = size(EDates);
            varargin{DateIdx} = reshape(datenum(EDates(:)), InSize);
        end
    end
end

%---------------------------------------------------------------------
% Describe instrument
%---------------------------------------------------------------------
TypeString = 'Compound';

% list default fields: FieldName, Class, SizeLimit, Default
FieldInfo = {
    'UOptSpec'         , 'char' , [Inf Inf]   ,    ['Call'] ;
    'UStrike'          , 'dble' , [Inf Inf]   ,    [NaN] ; 
    'USettle'          , 'date' , [Inf 1]   ,      [NaN] ; 
    'UExerciseDates'   , 'date' , [Inf Inf] ,      [NaN] ; 
    'UAmericanOpt'     , 'dble' , [Inf 1]   ,      [0] 
    'COptSpec'         , 'char' , [Inf Inf]   ,    ['Call'] ;
    'CStrike'          , 'dble' , [Inf Inf]   ,    [NaN] ; 
    'CSettle'          , 'date' , [Inf 1]   ,      [NaN] ; 
    'CExerciseDates'   , 'date' , [Inf Inf] ,      [NaN] ; 
    'CAmericanOpt'     , 'dble' , [Inf 1]   ,      [0] };

%---------------------------------------------------------------------
% INSTENGINEADD is a subroutine and not a user function
%---------------------------------------------------------------------
varargout = instengineadd(TypeString, FieldInfo, varargin{:});

return

