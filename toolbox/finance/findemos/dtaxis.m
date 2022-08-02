function TicksOut = dtaxis(XYZ,DateForm,StartDate,TickDateSpace)
%DTAXIS Date axis labels synced to the data.
%   Syntax: dtaxis(XYZ, DateForm, StartDate, TickDateSpace)
%
%   Inputs:
%     XYZ           : string either 'x', 'y', or 'z' Default: 'x'
%     DateForm      : Date Form flag for datestr     Default: 6  -> 'mm/dd'
%     StartDate     : Axis minimum date              Default: data-min
%     TickDateSpace : minimum number of days allowed between ticks 
%    
%   Example:
%     dates = cfdates(today, today+3*365, 2);
%     plot( dates, rand(size(dates)) )
%     dtaxis('x',2,[],180)

% Example utility J. Akao 11/08/97
% Copyright 1995-2002 The MathWorks, Inc.  
% $Revision: 1.6 $ $Date: 2002/04/14 21:42:29 $

% parse arguments
if ( nargin<4 )
  TickDateSpace = []; % set from data
end
if ( nargin<3 )
  StartDate = []; % use data min
end
if ( (nargin<2) | isempty(DateForm) )
  DateForm = 6;
end
if ( (nargin<1) | isempty(XYZ) )
  XYZ = 'x';
end

% Find the lines in the current axes
HandlesInAxes = get(gca,'children');
HandlesAreLines = strcmpi( get(HandlesInAxes,'type') , {'line'} );
LineHandles = HandlesInAxes(HandlesAreLines);

% Get a list of data vectors (dates) for every line.
DateList = get(LineHandles,[XYZ 'data']);
if (~iscell(DateList)), DateList = {DateList}; end
NumLines = length(DateList);

% Sort and filter date data points
MaxDateOfLine = NaN*ones(1,NumLines);
for i=1:NumLines
  dlist = DateList{i};
  MaxDateOfLine(i) = max(dlist);
  DateList{i} = dlist(isfinite(dlist));
end
MatDates = unique(MaxDateOfLine); % assumed to be maturity dates
AllDates = unique([DateList{:}]); % row vector of unique dates

% Determine the limits of the axis
if isempty(StartDate),
  MinDate = min(AllDates);
else
  MinDate = StartDate;
end
MaxDate = max(AllDates);

% Determine the minimum spacing between ticks
if isempty(TickDateSpace)
  DateSpan = MaxDate-MinDate;
  TickDateSpace = DateSpan/8; 
  % Note (JHA) Should actually check the font for what fits on the axis
end

% First try to tick in the maturity dates and the first date
MatDates = [MinDate MatDates];
MatTickDates = addticksbelow(MinDate,TickDateSpace,MaxDate, MatDates);

% Now see if any other dates fit in the cracks
TickDates = MatTickDates(end);
for iMat=length(MatTickDates)-1:-1:1
  % Add from AllDates in the crack
  TickCrackMin = MatTickDates(iMat)+TickDateSpace; 
  TickDates = addticksbelow(TickCrackMin,TickDateSpace,TickDates, AllDates);
  
  % Add the MatDate below the crack
  TickDates = [MatTickDates(iMat) TickDates];
end

% set the axis properties
set(gca, [XYZ 'lim'], [MinDate MaxDate]);
set(gca, [XYZ 'tick'], TickDates);
set(gca, [XYZ 'ticklabel'], datestr(TickDates,DateForm));

% return the ticks if there is an output argument
if nargout==1
  TicksOut = TickDates;
end

%--------------------- end of dtaxis --------------------------------------

function Ticks = addticksbelow(TickMin, TickSpace, Ticks, TickCandidates)
% Uses a greedy method to add to the front of the Tick list from the list in
% TickCandidates.  Candidates are eligible if they are in the interval
% [TickMin, Tick(1)-TickSpace], and the largest eligible candidate is
% prepended to the Tick list.
CandInd = find( ( TickCandidates <= (Ticks(1)-TickSpace) ) & ...
                ( TickCandidates >= TickMin ) );
while ( ~isempty(CandInd) )
  Ticks = [TickCandidates(CandInd(end)) Ticks];
  CandInd = find( ( TickCandidates <= (Ticks(1)-TickSpace) ) & ...
                  ( TickCandidates >= TickMin              ) );
end

% Note (JHA) Should TickSpace be specified in months with basis?  
% The date (Ticks(1)-TickSpace) could be replaced by 
% datemnth(Ticks(1),-TickSpace,0,Basis,EOM) 

