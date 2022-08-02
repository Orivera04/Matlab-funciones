function CheckedVolCurve = checkvolcrv(InputVolCurve, MinDate, MaxDate)
%CHECKVOLCRV Checked Volatility Curve from Input Zero Curve
%
%     This is a private function that is not meant to be called directly
%     by the user.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Author: C. Bassignani, 04-18-98 
%   Copyright 1995-2002 The MathWorks, Inc. 
%$Revision: 1.6 $   $Date: 2002/04/14 21:57:20 $ 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                 ************* CHECK INPUTS **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Check the number of input arguments
if (nargin < 1)
     error('Too few input arguments!')
end

if (~isempty(InputVolCurve))
     if (~isa(InputVolCurve, 'struct'))
          error('Volatility curve must be a structure!')
     end
else
     error('Volatility curve cannot be empty!')
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%                ************* GENERATE OUTPUTS **************
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Check if the structure has already been checked; if it has return
if (isfield(InputVolCurve, 'CheckVolFlag'))
     if (InputVolCurve.CheckVolFlag)
          CheckedVolCurve = InputVolCurve;
          return
     end
end


CheckedVolCurve = checkstruct(InputVolCurve, 'volcurvestand');

CurveDates = makedatenumeric(CheckedVolCurve.CurveDates);
CurveRates = CheckedVolCurve.VolatilityRates;

% sort the dates into increasing order and make curves columns
[CurveDates, CurveInd] = sort(CurveDates(:));
CurveRates = CurveRates(CurveInd);
CurveRates = CurveRates(:);

% extend curve over span of the bond (JHA)
if (nargin>=2)
     % MinDate is specified
     if (MinDate < CurveDates(1))
          CurveDates = [MinDate; CurveDates];
          CurveRates = [CurveRates(1); CurveRates];
     elseif any(CurveDates < MinDate)
          FirstDate = MinDate;
          if any(CurveDates > MinDate)
               FirstRate = interp1(CurveDates, CurveRates, FirstDate);
          else
               FirstRate = CurveRates(end);
          end
          
          CurveDates = [FirstDate; CurveDates(CurveDates>MinDate)];
          CurveRates = [FirstRate; CurveRates(CurveDates>MinDate)];
     end
end
if (nargin>=3)
     % MaxDate is specified
     if (CurveDates(end) < MaxDate)
          CurveDates = [CurveDates; MaxDate];
          CurveRates = [CurveRates; CurveRates(end)];
     end
end
    
CheckedVolCurve.CurveDates = CurveDates;
CheckedVolCurve.VolatilityRates = CurveRates;

%Set a flag indicating that the vol curve structure has been checked
CheckedVolCurve = rmfield(CheckedVolCurve, 'CSCheckFlag');

CheckedVolCurve.CheckVolFlag = 1;


function DateNumber = makedatenumeric(DateParameter)
% MAKEDATENUMERIC takes numbers, strings, or cell arrays of strings
% and changes them to date numbers.

if ischar(DateParameter)
     % can only be a column
     MRows = size(DateParameter,1);
     NCols = 1;
     DateNumber = datenum(DateParameter);
elseif iscell(DateParameter)
     [MRows, NCols] = size(DateParameter);
     DateNumber = datenum(char(DateParameter));
else
     [MRows, NCols] = size(DateParameter);
     DateNumber = DateParameter;
end
DateNumber = reshape(DateNumber, MRows, NCols);
