function [RateSpec, RateSpecOld] = intenvset(varargin)
%INTENVSET Set properties of an interest term structure.
%
%   [RateSpec, RateSpecOld] = intenvset('Parameter1', Value1 , 'Parameter2' , Value2 , ...) 
%   [RateSpec, RateSpecOld] = intenvset(RateSpec , 'Parameter1' , Value1 , ...)
%
%   The first calling syntax creates an Interest Term structure (RateSpec) in
%   which the input argument list is specified as parameter/value pairs. The 
%   Parameter portion of the pair must be recognized as a valid field of the 
%   output structure RateSpec; the Value portion of the pair is then assigned to
%   its paired Parameter field such that the named parameters have the specified 
%   values. It is sufficient to type only the leading characters that uniquely 
%   identify a parameter. Case is ignored for parameter names. Valid parameters 
%   fields are listed below.
%
%   The second calling syntax modifies an existing Interest Term structure  
%   RateSpec by changing the named parameters to the specified values, and 
%   recalculating the parameters dependent on the new values.
%
%
%   Inputs:
%     Parameter - String representing a valid parameter field of the output 
%     structure RateSpec (see below).
%
%     Value - The value assigned to the corresponding Parameter. 
%
%     RateSpec - An existing RateSpec specification structure to be changed,
%     probably created from a previous call to INTENVSET.
%
%     INTENVSET Parameter names:
%     Compounding  - Scalar value representing the rate at which the input
%     zero rates were compounded when annualized. Default is 2.
%
%     Disc - NPOINTS x NCURVES matrix of unit bond prices over investment
%     intervals from StartDates, when the cash flow is valued, to EndDates, 
%     when the cash flow is received.
%
%     Rates - NPOINTS x NCURVES matrix of rates in decimal form. Rates are the
%     yields over investment intervals from StartDates, when the cash flow is
%     valued, to EndDates, when the cash flow is received.
%                     
%     EndDates - NPOINTS x 1 vector or scalar of maturity dates ending the 
%     interval to discount over.
%
%     StartDates - NPOINTS x 1 vector or scalar of starting dates beginning the 
%     interval to discount over.
%
%     ValuationDate - Scalar value representing the observation date of the 
%     investment horizons entered in StartDates and EndDates.  The default
%     is min(StartDates).
%
%     Basis - Day count basis; default is "0" for Actual/Actual
%
%     EndMonthRule - End of month rule; default is "1" meaning "in effect".
%
%     When creating a new RateSpec, the set of parameters passed to intenvset
%     must include StartDates, EndDates, in addition to either Rates or Disc.
%
%   Output:
%     RateSpec - Structure encapsulating the properties of an interest rate 
%     structure.
%
%     RateSpecOld - Structure encapsulating the properties of an interest rate 
%     structure prior to the changes introduced by the call to intenvset.
%
%   Examples:
%     [RateSpec] = intenvset('Rates', 0.05, 'StartDates', '20-Jan-2000',...
%                        'EndDates', '20-Jan-2001')
%     [RateSpec] = intenvset(RateSpec, 'Compounding', 1)
% 
%   Notes:
%     Calling intenvset with no input arguments and no output arguments displays 
%     all parameter names and information about their possible values.
%
%   See also INTENVGET.

%   Author(s): M. Reyes-Kattar, J. Akao 02/08/99
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.17 $  $Date: 2002/04/14 21:41:08 $

%------------------------------------------------------------------------
% Checking input arguments
%------------------------------------------------------------------------

% Print out possible values of properties.
if (nargin == 0) & (nargout == 0)
   fprintf('            Compounding: [ 1 | {2} | 3 | 4 | 6 | 12 | 365 | -1 ]\n');
   fprintf('                   Disc: [ scalar | vector (NPOINTS x 1) ]\n');
   fprintf('                  Rates: [ scalar | vector (NPOINTS x 1) ]\n');
%   fprintf('               EndTimes: [ scalar | vector (NPOINTS x 1)]\n');
%   fprintf('             StartTimes: [ scalar | vector (NPOINTS x 1) ]\n');
   fprintf('               EndDates: [ scalar | vector (NPOINTS x 1) ]\n');
   fprintf('             StartDates: [ scalar | vector (NPOINTS x 1) ]\n');
   fprintf('          ValuationDate: [ scalar ]\n');
   fprintf('                  Basis: [ {0} | 1 | 2 | 3 ]\n');
   fprintf('           EndMonthRule: [ 0 | {1} ]\n');
   fprintf('\n');
   return;
end

% If the first arg is a RateSpec struct, save it as RateSpecOld. If not, just set 
% RateSpecOld to a new struct with emtpy fields
if (nargin>0) & isafin(varargin{1},'RateSpec')
  RateSpecOld = varargin{1};
  
  % Start looking for parameter value pairs at the second place
  Iarg = 2;
else
  % Create a new structure, and initialize all fields to []
  % Do this by hand for mcc compilability
  RateSpecOld = classfin('RateSpec');
  RateSpecOld.Compounding    = [];
  RateSpecOld.Disc           = [];
  RateSpecOld.Rates          = [];
  RateSpecOld.EndTimes       = [];
  RateSpecOld.StartTimes     = [];
  RateSpecOld.EndDates       = [];
  RateSpecOld.StartDates     = [];
  RateSpecOld.ValuationDate  = [];
  RateSpecOld.Basis          = [];
  RateSpecOld.EndMonthRule   = [];

  % Start looking for parameter value pairs at the second place
  Iarg = 1;
end

% If any input beyond the first is a structure, flag an error
for i = 2:nargin
   if isstruct(varargin{i})
      error(' Only the first input may be structure.');
   end
end

% If the user calls intenvset with output arg and no input args, return a struct full
% of empties
if(nargin == 0 & nargout ~= 0)
   RateSpec = RateSpecOld;
   return
end

%------------------------------------------------------------------------
% Parse through the ArgName/ArgValue pairs, and set the ArgValues in the appropriate fields
% in the structure
%------------------------------------------------------------------------
Names = [
   'Compounding    ';  % 1
   'Disc           ';  % 2
   'Rates          ';  % 3
   'EndTimes       ';  % 4
   'StartTimes     ';  % 5
   'EndDates       ';  % 6
   'StartDates     ';  % 7
   'ValuationDate  ';  % 8
   'Basis          ';  % 9
   'EndMonthRule   ';  % 10
];

Types = {
   'dbl'
   'dbl'
   'dbl'
   'dbl'
   'dbl'
   'date'
   'date'
   'date'
   'dbl'
   'dbl'
};

% Catch an internal error if case we forget to complete a VarName/VarType pair
if(size(Names,1) ~= size(Types,1))
   error('The number of variable names and types must be the same')
end

[m,n] = size(Names);
names = lower(Names);

% Find close PropNames and change them for their real equivalents
PropValList = varargin(Iarg:end);
PropPos = find(cellfun('isclass', PropValList, 'char') & ...
   (cellfun('size', PropValList, 1)==1));
for iPos = PropPos
   iPropInd = strmatch(lower(PropValList{iPos}), names);
   if length(iPropInd)>1
      error(sprintf('Ambiguous property name: ''%s''', PropValList{iPos}));
   end
   if ~isempty(iPropInd)
      PropValList{iPos} = deblank(Names(iPropInd, :));   
   end   
end

% Call instpvp to parse parameter value information
[ValueList, FoundFlags] = instpvp('None',Names, PropValList{:});

% Make sure StartTimes and EndTimes are never passed in:
%if(FoundFlags(4) | FoundFlags(5))
%   error('StartTimes and EndTimes are Read-Only properties')
%end

% Do the type parsing
[ValueList{:}] = finargparse(Types, ValueList{:});

% Make RateSpec an updated RateSpecOld
RateSpec = RateSpecOld;

% Update by hand for mcc
if FoundFlags(1),  RateSpec.Compounding    = ValueList{1};  end
if FoundFlags(2),  RateSpec.Disc           = ValueList{2};  end
if FoundFlags(3),  RateSpec.Rates          = ValueList{3};  end
if FoundFlags(4),  RateSpec.EndTimes       = ValueList{4};  end
if FoundFlags(5),  RateSpec.StartTimes     = ValueList{5};  end
if FoundFlags(6),  RateSpec.EndDates       = ValueList{6};  end
if FoundFlags(7),  RateSpec.StartDates     = ValueList{7};  end
if FoundFlags(8),  RateSpec.ValuationDate  = ValueList{8};  end
if FoundFlags(9),  RateSpec.Basis          = ValueList{9};  end
if FoundFlags(10), RateSpec.EndMonthRule   = ValueList{10}; end

%------------------------------------------------------------------------
% Do some input checking before the internal consistency updates
%------------------------------------------------------------------------

% Do scalar expansion if necessary
% FieldList = {'Disc', 'Rates', 'StartDates', 'EndDates', 'StartTimes', 'EndTimes'};
% ArgList = '';
% for i = 1:length(FieldList)
%    eval(['EmptyFlag = ~isempty(RateSpec.' FieldList{i} ');']);
%    if(EmptyFlag)
%       ArgList = [ArgList 'RateSpec.' FieldList{i} ' ,'];
%    end   
% end
% 
% if ~isempty(ArgList)
%    CommandCommas = find(ArgList == ',');
%    ArgList(CommandCommas(end)) = [];
%    
%    % Scalar expansion temporarily disabled while we decide what to do when 
%    % the user modifies the number of tree steps.
%    % Do the actual expansion. If there is an error, explain.
%    %command = ['[' ArgList '] = finargsz(''scalar'' ,' ArgList ');'];
%    %ExpandError = 0;
%    %eval(command, 'ExpandError = 1;');
%    %if(ExpandError == 1)
%    %   error('Disc, Rate, StartDates, EndDate, StartTimes, and/or EndTimes must be scalars or have consistent sizes');
%    %end
% end


% Make sure Compounding has a legal value
if( ~isempty(RateSpec.Compounding))
   if(size(RateSpec.Compounding, 1) ~= 1 | size(RateSpec.Compounding, 2) ~= 1)
      error('Compounding must be a scalar');
   end
   
	LegalVals = [1 2  3 4 6 12 365 -1 ];
   if( ~any(RateSpec.Compounding == LegalVals))
      error('Invalid Compounding value');
   end
end

% Make sure ValuationDate has a legal value
if( ~isempty(RateSpec.ValuationDate))
   if(size(RateSpec.ValuationDate, 1) ~= 1 | size(RateSpec.ValuationDate, 2) ~= 1)
      error('ValuationDate must be a scalar');
   end
end

% Make sure Basis has a legal value
if( ~isempty(RateSpec.Basis))
   if(size(RateSpec.Basis, 1) ~= 1 | size(RateSpec.Basis, 2) ~= 1)
      error('Basis must be a scalar');
   end
   
	LegalVals = [0 1 2 3];
   if( ~any(RateSpec.Basis == LegalVals))
      error('Invalid Basis value');
   end
end

% Make sure EndMonthRule has a legal value
if( ~isempty(RateSpec.EndMonthRule))
   if(size(RateSpec.EndMonthRule, 1) ~= 1 | size(RateSpec.EndMonthRule, 2) ~= 1)
      error('EndMonthRule must be a scalar');
   end
   
	LegalVals = [0 1];
   if( ~any(RateSpec.EndMonthRule == LegalVals))
      error('Invalid EndMonthRule value');
   end
end

% If creating a new RateSpec, make sure Dates are consistent
if(Iarg == 1)
%    if (isempty(RateSpec.StartDates) | isempty(RateSpec.EndDates) | ...
%          (isempty(RateSpec.Rates) & isempty(RateSpec.Disc)))
%         msg1 = 'When creating a new RateSpec, the set of paramenters passed to intenvset ';
% 		msg2 = 'must include StartDates, EndDates, in addition to either Rates or Disc.';
%       error(sprintf('%s\n%s', msg1, msg2))
%    end
         
   if(isempty(RateSpec.ValuationDate) & ~isempty(RateSpec.StartDates))
      RateSpec.ValuationDate = min(RateSpec.StartDates);
   end
   
   if isempty(RateSpec.Compounding)
		RateSpec.Compounding = 2;      
   end
   
   if isempty(RateSpec.EndMonthRule)
		RateSpec.EndMonthRule = 1;      
   end
   
   if isempty(RateSpec.Basis)
		RateSpec.Basis = 0;      
   end
end

if(~isempty(RateSpec.StartDates) & ~isempty(RateSpec.ValuationDate))
   if(any(RateSpec.StartDates < RateSpec.ValuationDate))
      error('All values in StartDates must be greater or equal to ValuationDate')
   end   
end

% Make sure that StartDates is consistent with EndDates, and that StartTimes
% is consisten with EndTimes
if(isempty(RateSpec.EndTimes))
   ET = RateSpecOld.EndTimes;
else
   ET = RateSpec.EndTimes;
end

if(isempty(RateSpec.StartTimes))
   ST = RateSpecOld.StartTimes;
else
   ST = RateSpec.StartTimes;
end

if(isempty(RateSpec.EndDates))
   ED = RateSpecOld.EndDates;
else
   ED = RateSpec.EndDates;
end

if(isempty(RateSpec.StartDates))
   SD = RateSpecOld.StartDates;
else
   SD = RateSpec.StartDates;
end

if(any(SD > ED))
   error('StartDate must be less than corresponding EndDate');
end

if(any(ST > ET))
   error('StartTime must be less than corresponding EndTime');
end

%-----------------------------------------------------------------------
% Internal consistency computations
%-----------------------------------------------------------------------

% Save input rate and time
RatesIn = RateSpec.Rates;
EndTimesIn = RateSpec.EndTimes;
StartTimesIn = RateSpec.StartTimes;

% Create a compounding ratio
OldPeriod = RateSpecOld.Compounding;
if isempty(OldPeriod)
  OldPeriod = 2;
elseif OldPeriod==-1
  OldPeriod = 1;
end

Period = RateSpec.Compounding;
if isempty(Period)
  Period = 2;
elseif Period==-1
  Period = 1;
end

%-----------------------------------------------------------------------
% Find out what has been passed in
% For now, check what has changed
%-----------------------------------------------------------------------
CompNew = FoundFlags(1);
DiscNew = FoundFlags(2);
RateNew = FoundFlags(3);

EndTimeNew =   FoundFlags(4);
StartTimeNew = FoundFlags(5);
TimeNew = EndTimeNew | StartTimeNew ;

EndDateNew =       FoundFlags(6);
StartDateNew =     FoundFlags(7);
ValuationDateNew = FoundFlags(8);
DateNew = EndDateNew | StartDateNew | ValuationDateNew;

%-----------------------------------------------------------------------
% Parsing logic
%
%                                          RescaleO
% Disc Rate Comp Date Time | ClearD Rescale d2rOld, rtT, rtD, d2rT, d2rD, r2dT, r2dD, checkR, checkT 
%                      X       1.................... 2 ................... 3 ...................... 'ClearD', 'ratetimesT', 'rate2discT'               
%                 X            .......................... 1 .............. 2 ...................... 'ratetimesD', 'rate2discT'                         
%                 X    X       .......................... 1 .............. 2 .................. 3 . 'ratetimesD', 'rate2discT', 'CheckT'               
%            X                 .....  1 ...................... 2 .................................. 'Rescale', 'disc2rateT'                            
%            X         X       1 ............ 2 .... 3 ................... 4 ...................... 'ClearD', 'RescaleOld', 'ratetimesT', 'rate2discT'  
%            X    X            .............. 1 ......... 2 .............. 3 ...................... 'RescaleOld', 'ratetimesD', 'rate2discT'           
%            X    X    X       .............. 1 ......... 2 .............. 3 .................. 4 . 'RescaleOld', 'ratetimesD', 'rate2discT', 'CheckT' 
%       X                      ........................................... 1 ...................... 'rate2discT'                                       
%       X              X       1 ......................................... 2 ...................... 'ClearD', 'rate2discT'                             
%       X         X            .................................................. 1 ............... 'rate2discD'                                       
%       X         X    X       .................................................. 1 ........... 2 . 'rate2discD', 'CheckT'                             
%       X    X                 ...... 1 .................................. 2 ...................... 'Rescale', 'rate2discT'                            
%       X    X         X       1 ......................................... 2 ...................... 'ClearD' , 'rate2discT'                            
%       X    X    X            ........................................... 1 ...................... 'rate2discT'                                       
%       X    X    X    X       ........................................... 1 .................. 2 . 'rate2discT', 'Check'                             
%  X                           ............................... 1 .................................. 'disc2rateT'                                       
%  X                   X       1 ............................. 2 .................................. 'ClearD', 'disc2rateT'                             
%  X              X            ..................................... 1 ............................ 'disc2rateD'                                       
%  X              X    X       ..................................... 1 ........................ 2 . 'disc2rateD', 'CheckT'                             
%  X         X                 ...... 1 ...................... 2 .................................. 'Rescale', 'disc2rateT'                            
%  X         X         X       1 ............................. 2 .................................. 'ClearD', 'disc2rateT'                             
%  X         X    X            ..................................... 1 ............................ 'disc2rateD'                                       
%  X         X    X    X       ..................................... 1 ........................ 2 . 'disc2rateD', 'CheckT'                             
%  X    X                      ............................... 1 ....................... 2 ........ 'disc2rateT', 'CheckR'                             
%  X    X              X       1 ............................. 2 ....................... 3 ........ 'ClearD', 'disc2rateT', 'CheckR'                   
%  X    X         X            ..................................... 1 ................. 2 ........ 'disc2rateD', 'CheckR'                             
%  X    X         X    X       ..................................... 1 ................. 2 .... 3 . 'disc2rateD', 'CheckR', 'CheckT'                   
%  X    X    X                 ...... 1 ...................... 2 ....................... 3 ........ 'Rescale', 'disc2rateT', 'CheckR'                  
%  X    X    X         X       1 ............................. 2 ....................... 3 ........ 'ClearD', 'disc2rateT', 'CheckR'                   
%  X    X    X    X            ..................................... 1 ................. 2 ........ 'disc2rateD', 'CheckR'                             
%  X    X    X    X    X       ..................................... 1 ................. 2 .... 3 . 'disc2rateD', 'CheckR', 'CheckT'                   


%-----------------------------------------------------------------------
% Map changes in Disc, Rate, Comp, Date, and Time to tasks
%-----------------------------------------------------------------------
TaskMap = cell(2,2,2,2,2);
TaskMap{1,1,1,1,1} = { };
TaskMap{1,1,1,1,2} = {'ClearD', 'ratetimesT', 'rate2discT'                };
TaskMap{1,1,1,2,1} = {'ratetimesD', 'rate2discT'                          };
TaskMap{1,1,1,2,2} = {'ratetimesD', 'rate2discT', 'CheckT'                };
TaskMap{1,1,2,1,1} = {'Rescale', 'disc2rateT'                             };
TaskMap{1,1,2,1,2} = {'ClearD', 'RescaleOld', 'ratetimesT', 'rate2discT'  };
TaskMap{1,1,2,2,1} = {'RescaleOld', 'ratetimesD', 'rate2discT'            };
TaskMap{1,1,2,2,2} = {'RescaleOld', 'ratetimesD', 'rate2discT', 'CheckT'  };
TaskMap{1,2,1,1,1} = {'rate2discT'                                        };
TaskMap{1,2,1,1,2} = {'ClearD', 'rate2discT'                              };
TaskMap{1,2,1,2,1} = {'rate2discD'                                        };
TaskMap{1,2,1,2,2} = {'rate2discD', 'CheckT'                              };
TaskMap{1,2,2,1,1} = {'Rescale', 'rate2discT'                             };
TaskMap{1,2,2,1,2} = {'ClearD' , 'rate2discT'                             };
TaskMap{1,2,2,2,1} = {'rate2discD'                                        };
TaskMap{1,2,2,2,2} = {'rate2discT', 'CheckT'                              };
TaskMap{2,1,1,1,1} = {'disc2rateT'                                        };
TaskMap{2,1,1,1,2} = {'ClearD', 'disc2rateT'                              };
TaskMap{2,1,1,2,1} = {'disc2rateD'                                        };
TaskMap{2,1,1,2,2} = {'disc2rateD', 'CheckT'                              };
TaskMap{2,1,2,1,1} = {'Rescale', 'disc2rateT'                             };
TaskMap{2,1,2,1,2} = {'ClearD', 'disc2rateT'                              };
TaskMap{2,1,2,2,1} = {'disc2rateD'                                        };
TaskMap{2,1,2,2,2} = {'disc2rateD', 'CheckT'                              };
TaskMap{2,2,1,1,1} = {'disc2rateT', 'CheckR'                              };
TaskMap{2,2,1,1,2} = {'ClearD', 'disc2rateT', 'CheckR'                    };
TaskMap{2,2,1,2,1} = {'disc2rateD', 'CheckR'                              };
TaskMap{2,2,1,2,2} = {'disc2rateD', 'CheckR', 'CheckT'                    };
TaskMap{2,2,2,1,1} = {'Rescale', 'disc2rateT', 'CheckR'                   };
TaskMap{2,2,2,1,2} = {'ClearD', 'disc2rateT', 'CheckR'                    };
TaskMap{2,2,2,2,1} = {'disc2rateD', 'CheckR'                              };
TaskMap{2,2,2,2,2} = {'disc2rateD', 'CheckR', 'CheckT'                    };

%-----------------------------------------------------------------------
% Evaluate which tasks to perform on this call
% Change logical 0/1 flag to 1/2 values
%-----------------------------------------------------------------------
TaskList = TaskMap{DiscNew+1, RateNew+1, CompNew+1, DateNew+1, TimeNew+1};

% Diagnostic code
% Mask = [DiscNew, RateNew, CompNew, DateNew, TimeNew];
% C = {'Disc', 'Rate', 'Comp', 'Date', 'Time'};
% C(Mask);
% TaskList

%-----------------------------------------------------------------------
% Perform update tasks
%-----------------------------------------------------------------------
for iTask = 1:length(TaskList)
  switch TaskList{iTask}
    
   case 'ClearD'
    RateSpec.EndDates = [];
    RateSpec.StartDates = [];
      
   case 'Rescale'
    % rescale the times
    RateSpec.EndTimes = RateSpecOld.EndTimes*(Period/OldPeriod);
    RateSpec.StartTimes = RateSpecOld.StartTimes*(Period/OldPeriod);
    
   case 'RescaleOld'
    % rescale the times
    RateSpecOld.EndTimes = RateSpecOld.EndTimes*(Period/OldPeriod);
    RateSpecOld.StartTimes = RateSpecOld.StartTimes*(Period/OldPeriod);
    
    % recompute the rates in RateSpecOld
    [RateSpecOld.Rates, RateSpecOld.EndTimes, RateSpecOld.StartTimes] = ...
        disc2rate(RateSpec.Compounding, RateSpecOld.Disc, ...
                  RateSpecOld.EndTimes, RateSpecOld.StartTimes);
    
   case 'ratetimesT'
    % recompute the rates at new times
    [RateSpec.Rates, RateSpec.EndTimes, RateSpec.StartTimes] = ratetimes(...
        RateSpec.Compounding, RateSpecOld.Rates, ...
        RateSpecOld.EndTimes, RateSpecOld.StartTimes, ...
        RateSpec.EndTimes, RateSpec.StartTimes);
    
   case 'ratetimesD'
    % recompute the rates at new dates
    RateSpec.EndTimes = date2time(RateSpec.ValuationDate,RateSpec.EndDates, ...
                                  RateSpec.Compounding, RateSpec.Basis, ...
                                  RateSpec.EndMonthRule);
    RateSpec.StartTimes = date2time(RateSpec.ValuationDate,RateSpec.StartDates, ...
                                  RateSpec.Compounding, RateSpec.Basis, ...
                                  RateSpec.EndMonthRule);
    
    [RateSpec.Rates, RateSpec.EndTimes, RateSpec.StartTimes] = ratetimes(...
        RateSpec.Compounding, RateSpecOld.Rates, ...
        RateSpecOld.EndTimes, RateSpecOld.StartTimes, ...
        RateSpec.EndTimes, RateSpec.StartTimes);
    
   case 'disc2rateT'
    % compute the rates
    [RateSpec.Rates, RateSpec.EndTimes, RateSpec.StartTimes] = disc2rate(...
        RateSpec.Compounding, RateSpec.Disc, ...
        RateSpec.EndTimes, RateSpec.StartTimes);
   
   case 'disc2rateD'
    % Compute new times from new dates
    RateSpec.EndTimes = date2time(RateSpec.ValuationDate,RateSpec.EndDates, ...
                                  RateSpec.Compounding, RateSpec.Basis, ...
                                  RateSpec.EndMonthRule);
    RateSpec.StartTimes = date2time(RateSpec.ValuationDate,RateSpec.StartDates, ...
                                  RateSpec.Compounding, RateSpec.Basis, ...
                                  RateSpec.EndMonthRule);
    
    % compute the rates
    [RateSpec.Rates, RateSpec.EndTimes, RateSpec.StartTimes] = disc2rate(...
        RateSpec.Compounding, RateSpec.Disc, ...
        RateSpec.EndTimes, RateSpec.StartTimes);
   
   case 'rate2discT'
    % Compute new discount factors from rates
    [RateSpec.Disc, RateSpec.EndTimes, RateSpec.StartTimes] = rate2disc(...
        RateSpec.Compounding, RateSpec.Rates, ...
        RateSpec.EndTimes, RateSpec.StartTimes);

   case 'rate2discD'
    % Compute new times from new dates
    RateSpec.EndTimes = date2time(RateSpec.ValuationDate,RateSpec.EndDates, ...
                                  RateSpec.Compounding, RateSpec.Basis, ...
                                  RateSpec.EndMonthRule);
    RateSpec.StartTimes = date2time(RateSpec.ValuationDate,RateSpec.StartDates, ...
                                  RateSpec.Compounding, RateSpec.Basis, ...
                                  RateSpec.EndMonthRule);

    % Compute new discount factors from rates
    [RateSpec.Disc, RateSpec.EndTimes, RateSpec.StartTimes] = rate2disc(...
        RateSpec.Compounding, RateSpec.Rates, ...
        RateSpec.EndTimes, RateSpec.StartTimes);

   case 'CheckR'
    [R1,R2] = finargsz(1,RatesIn,RateSpec.Rates);
    if ~isequal(R1,R2)
      warning('Input Rates incompatible with Disc')
    end
    
   case 'CheckT'
    if EndTimeNew
      [T1,T2] = finargsz(1,EndTimesIn, RateSpec.EndTimes);
      if ~isequal(T1,T2)
        warning('Input EndTimes incompatible with EndDates')
      end
    end
    if StartTimeNew
      [T1,T2] = finargsz(1,StartTimesIn, RateSpec.StartTimes);
      if ~isequal(T1,T2)
        warning('Input StartTimes incompatible with StartDates')
      end
    end
    
   otherwise
    warning(['Bad task tag ', TaskList{iTask}])
  end
end

return
