function [UOptSpec, UStrike, USettle, UExerciseDates, UAmericanOpt, COptSpec,...
    CStrike, CSettle, CExerciseDates, CAmericanOpt] = instargcompound(varargin)
%INSTARGCOMPOUND Subroutine for 'Type','Compound' argument validation.  
%   This function is called at the top of processing routines.
%
%   [UOptSpec, UStrike, USettle, UExerciseDates, UAmericanOpt, COptSpec,...
%    CStrike, CSettle, CExerciseDates, CAmericanOpt) = instargcompound(ArgList{:})
%
%   Inputs: 
%     ArgList{:} input arguments to be dealt one-to-one to the outputs.
%
%   Outputs: 
%     UOptSpec        - String 'call' or 'put' of the underlying option.                     
%     UStrike         - 1 X 1 vector of the underlying strike price.
%     USettle         - 1 X 1 vector of the settlement date or trade date.
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
%     COptSpec        - NINSTx1 cell array of strings 'call' or 'put' 
%                       of the compound option.
%     CStrike         - For an European and American Option:
%                       NINST x 1  matrix of compound strike price values. Each row
%                       is the schedule for one option. 
%     CSettle         - 1 X 1 vector of the settlement date or trade date.
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
%     CAmericanOpt    - NINST x 1 flags 0(European) or 1(American)
%                       of the compound option. Default is 0.
%
%   See also INSTCOMPOUND.

%   Author(s): M. Reyes-Kattar 01-Nov-2002
%   Copyright 1998-2003 The MathWorks, Inc. 
%   $Revision: 1.1.6.1 $  $Date: 2003/08/29 04:45:51 $

% instargoptstock does what I need to do.
if nargin<9,
  error('Nine arguments are required for a Compound stock option');
end


[UOptSpec,UStrike,USettle,UExerciseDates,UAmericanOpt] = instargoptstock(varargin{1:5});
[COptSpec,CStrike,CSettle,CExerciseDates,CAmericanOpt] = instargoptstock(varargin{6:end});