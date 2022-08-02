function [Val, RateSpec] = intenvget(RateSpec, Name, Default)
%INTENVGET Get properties of an interest term structure.
%
%   ParameterValue = intenvget(RateSpec , 'ParameterName')
%
%   Inputs:
%     RateSpec - A structure encapsulating the properties of an interest 
%     rate structure.
%
%     ParameterName - String indicating the parameter name to be accessed. The 
%     value of the named parameter is extracted from the structure RateSpec.
%     It is sufficient to type only the leading characters that uniquely 
%     identify the parameter. Case is ignored for parameter names.
%
%     INTENVGET Parameter names:
%       Compounding 
%       Disc
%       Rates 
%       EndTimes
%       StartTimes
%       EndDates
%       StartDates
%       ValuationDate
%       Basis
%       EndMonthRule
%
%   Output:
%     ParameterValue - The value of the named parameter ParameterName extracted
%     from the structure RateSpec.
%
%   Examples:
%     [RateSpec] = intenvset('Rates', 0.05, 'StartDates', '20-Jan-2000', ...
%                                      'EndDates', '20-Jan-2001')
%     R = intenvget(RateSpec, 'Rates')
%     [R, RateSpec] = intenvget(RateSpec, 'Rates')
%
%   See also INTENVSET.

%   Author(s): M. Reyes-Kattar 02/08/99
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.12 $  $Date: 2002/04/14 21:40:50 $

%Checking input arguments
if nargin > 3
   error(' Too many input arguments.');
end

if nargin < 2
  error(' Not enough input arguments.');
end

if nargin < 3
  Default = [];
end

if ~isempty(RateSpec) & ~isafin(RateSpec,'RateSpec')
  error(' First argument must be an RateSpec structure created with INTENVSET.');
end

if isempty(RateSpec)
  Val = Default;
  return;
end

Names = [
   'Compounding    '
   'Disc           '
   'Rates          '
   'EndTimes       '
   'StartTimes     '
   'EndDates       '
   'StartDates     '
   'ValuationDate  '
   'Basis          '
   'EndMonthRule   '
];



%[m,n] = size(Names);
names = lower(Names);
lowName = lower(Name);

j = strmatch(lowName,names);
if isempty(j)               % if no matches
  error(sprintf([ 'Unrecognized property name ''%s''. See INTENVSET for possibilities.'], Name));
elseif length(j) > 1        % if more than one match
% 
% Check for any exact matches (in case any names are subsets of others).
%
  k = strmatch(lowName,names,'exact');
  if length(k) == 1
    j = k;
  else
    msg = sprintf('Ambiguous property name ''%s'' ', name);
    msg = [msg '(' deblank(Names(j(1),:))];
    for k = j(2:length(j))'
      msg = [msg ', ' deblank(Names(k,:))];
    end
    msg = sprintf('%s).', msg);
    error(msg);
  end
end


if any(strcmp(fieldnames(RateSpec),deblank(Names(j,:))))
  eval(['Val = RateSpec.' Names(j,:) ';']);
  if isempty(Val)
    Val = Default;
  end
else
  Val = Default;
end
