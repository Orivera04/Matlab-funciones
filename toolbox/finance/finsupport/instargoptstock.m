function [OptSpec,Strike,Settle,ExerciseDates,AmericanOpt] = instargoptstock(varargin)
%INSTARGOPTSTOCK Subroutine for 'Type','OptStock' argument validation.  
%   This function is called at the top of processing routines.
%
%   [OptSpec, Strike, Settle, ExerciseDates, AmericanOpt] = instargoptstock(ArgList{:})
%
%   Inputs: 
%     ArgList{:} input arguments to be dealt one-to-one to the outputs.
%
%   Outputs: 
%     OptSpec         - NINSTx1 cell array of strings 'call' or 'put'.
%     Strike          - NINST x NSTRIKES (for European/Bermuda) or 
%                       NINST x 1 (for American)of strike price values.
%     Settle          - NINST x 1 of settle dates.
%     ExerciseDates   - NINST x NSTRIKES (for European/Bermuda) or 
%                       NINST x 2(for American) of exercise dates.
%     AmericanOpt     - NINST x 1 flags 0(European/Bermuda) or
%                       1(American). Default is 0.
%
%   See also  INSTOPTSTOCK.

%   Author(s): M. Reyes-Kattar 01-Nov-2002
%   Copyright 1998-2003 The MathWorks, Inc. 
%   $Revision: 1.1.6.1 $  $Date: 2003/08/29 04:45:53 $

%---------------------------------------------------------------------
% Content independent processing
%---------------------------------------------------------------------

% Get the argument information for the option and bond instrument
[FieldList, ClassList, TypeString, SizeList, DefDataList] = instoptstock;

NumFields = length(FieldList);

% list of output arguments through parsing
ArgCells = cell(NumFields,1);

% Check the number of arguments, 3 to NumFields
if nargin<4,
  error('Four arguments are required for a stock option');
elseif nargin>NumFields
  error('Too many input arguments');
else
  EndArgs = cell(1,NumFields-nargin);
end

% Parse for type 
[ArgCells{:}] = finargparse(ClassList, varargin{:}, EndArgs{:});

% Enforce size limits if possible by transposing 
[ArgCells{:}] = finargflip(SizeList, ArgCells{:});

% Report size violations
for iArg = 1:NumFields,
    NumCols = size(ArgCells{iArg},2);
    if (NumCols > SizeList{iArg}(2))
        error(sprintf('%s can have only %d columns, not %d\n', ...
            FieldList{iArg}, SizeList{iArg}(2), NumCols));
    end
end

% perform row expansion along the instruments
[ArgCells{:}] = finargsz(1,ArgCells{:});

% Fill in defaults for NaNs
for iArg = 5:NumFields,
    Ind = isnan(ArgCells{iArg});
    ArgCells{iArg}(Ind) = DefDataList{iArg};
end

%---------------------------------------------------------------------
% Content independent processing done
%---------------------------------------------------------------------

[OptSpec,Strike, Settle, ExerciseDates,AmericanOpt] = deal(ArgCells{:});


% Verify that Settle is before all exercise dates:
if(any(Settle(:, ones(1,size(ExerciseDates,2)))>= ExerciseDates,2))
    error('Settle cannot be greater or equal to ExerciseDates.');
end

%---------------------------------------------------------------------
% Handle strike schedule sizes
%---------------------------------------------------------------------
AmericanOpt = logical(AmericanOpt);

AmericanInd = find(AmericanOpt);
EuropeanInd = find(~AmericanOpt);

% American Option:
% Strike should be a single number, one or two dates in Exercise
if ~isempty(AmericanInd)
    StrikeA = Strike(AmericanInd,:);
    ExerciseA = ExerciseDates(AmericanInd,:);
    
    % collect the non-Nan's in the front
    [StrikeA,   NSperRow] = finargpack(1, StrikeA);
    [ExerciseA, NDperRow] = finargpack(1, ExerciseA);
    
    % There should be a single strike value
    NS = size(StrikeA,2);
    if any(NSperRow == 0)
        error('Every option must have a strike value');
    elseif any(~all((StrikeA(:,ones(1,NS))==StrikeA) | isnan(StrikeA),2));
        error('Each American exercise option can have only 1 strike value')
    end
    StrikeA = StrikeA(:,1);
    
    % There must be 1 or 2 dates in ExerciseDates
    if any(NDperRow == 0)
        error('Every option must have an exercise date')
    elseif any(NDperRow>2)
        error(['Each American option can have only a starting and ending' ...
                ' ExerciseDate']);
    end        
    
    %   % Add default starting date of Settle
    %   ND = size(ExerciseA);
    %   if ND==1
    %     ExerciseA = [Settle(AmericanInd), ExerciseA];
    %   else
    %     ExerciseA(NDperRow==1,2) = Settle(AmericanInd(NDperRow==1));
    %   end
    
    if NDperRow == 2
        % Make the first date the start and the last date the end
        Ind = ( ExerciseA(:,1) > ExerciseA(:,2) );
        S = ExerciseA(Ind,1);
        ExerciseA(Ind,1) = ExerciseA(Ind,2);
        ExerciseA(Ind,2) = S;
    end
    
else
    StrikeA = [];
    ExerciseA = [];
end

% European/Bermudan option
% Strikes should be expanded over all the exercise dates
if ~isempty(EuropeanInd)
    StrikeE = Strike(EuropeanInd,:);
    ExerciseE = ExerciseDates(EuropeanInd,:);
    
    % collect the non-Nan's in the front and pad strike columns
    [ExerciseE, NDperRow] = finargpack(1, ExerciseE);
    [StrikeE,   NSperRow] = finargpack(1, StrikeE);
    StrikeE = finargpad(2, StrikeE, ExerciseE);
    
    if any(NSperRow > NDperRow)
        error('A Bermuda option cannot have more strikes than exercise dates');
    elseif any( (NDperRow > NSperRow) & (NSperRow ~= 1) )
        error('A Bermuda option must have a strike for each exercise dates');
    end
    
    % scalar expand strikes to all exercise dates
    Ind = find(NDperRow > NSperRow);
    for k = Ind(:)'
        StrikeE(k,1:NDperRow(k)) = StrikeE(k,1);
    end
    
    % ensure that the dates are in increasing order
    Ind = find( any( diff(ExerciseE,[],2) < 0 , 2 ) );
    for k = Ind(:)'
        [ExerciseE(k, 1:NDperRow(k)), I] = sort( ExerciseE(k,1:NDperRow(k)) );
        StrikeE(k, 1:NDperRow(k)) = StrikeE(k, I);
    end
    
else
    StrikeE = [];
    ExerciseE = [];
end

% Catenate the American and European sets and then reorder
Strike = finargcat(1, StrikeE, StrikeA);
ExerciseDates = finargcat(1, ExerciseE, ExerciseA);

Strike([EuropeanInd; AmericanInd],:) = Strike;
ExerciseDates([EuropeanInd; AmericanInd],:) = ExerciseDates;

%--------------------------------------------------------------------
% Check string arguments
%--------------------------------------------------------------------
OptSpec = cellstr( lower(OptSpec) );
CallMatch = strcmp(OptSpec, 'call');
PutMatch  = strcmp(OptSpec, 'put');

Ind = find(~(CallMatch | PutMatch));
if any(Ind)
    BadOpt = unique(strvcat(OptSpec(Ind,:)), 'rows')';
    BadOpt = finargcat(1,BadOpt,' ');
    error(['Unrecognized OptSpec: ',BadOpt(:)'])
end

