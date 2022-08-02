function [Rates] = dateinterp(RefDates, RefRates, Dates, Basis)
% DATEINTERP Interpolates rates at financial serial dates.  Performs
% columnwise interpolation from a series of reference rate curves.
%
%   Syntax:
%     Rates = dateinterp(RefDates, RefRates, Dates, Basis)
%
%   Inputs:
%     RefDates : Nref by 1 vector of date reference points
%     RefRates : Nref by Ncurve matrix of reference rates.  Each column is a
%                rate curve observed at RefDates
%     Dates    : Ndates by 1 vector of dates to compute interpolated rates
%     Basis    : Market basis used to compute elapsed time
%
%   Outputs:  
%     Rates : Ndates by Ncurve matrix of interpolated rates.  Each column
%             is a rate curve derived from the corresponding rate curve in
%             RefRates.  Interpolation is constant for Dates outside of the
%             range of RefDates, and linear within RefDates.
%
%   See also INTERP1Q, DAYSDIF.

%   Training example function JHA 1/13/98
%   Copyright 1995-2002 The MathWorks, Inc. 
%   $Revision: 1.5 $  $Date: 2002/04/14 21:57:47 $


% Note: Error checking for correct sizes should go here

if (nargin < 4)
  Basis = 0;
end
[Nref, Ncurve] = size(RefRates);
Ndates = length(Dates);

% Lay out the RefDates correctly in a sorted column
[RefDates, RefOrder] = sort(RefDates(:));
RefRates = RefRates(RefOrder,:);
RDmin = RefDates(1);
RDmax = RefDates(end);

% Find where the target dates fall
IDmin = find(Dates <= RDmin);
IDmax = find(Dates >= RDmax);
IDint = find( (Dates > RDmin) & (Dates < RDmax) );

% allocate memory for interpolated rates
Rates = NaN*ones(Ndates,Ncurve);

% extrapolate early dates to the earliest rate
if ~isempty(IDmin)
  % assign rows in Rates to the first row of RefRates
  Rates(IDmin,:) = RefRates(1*ones(length(IDmin),1),:);
end
  
% extrapolate late dates to the latest rate
if ~isempty(IDmax)
  % assign rows in Rates to the last row of RefRates
  Rates(IDmax,:) = RefRates(Nref*ones(length(IDmax),1),:);
end

% interpolate intermediate dates
if ~isempty(IDint)
  % Find elapsed time for interpolation
  RefTimes = daysdif(RDmin, RefDates, Basis);
     Times = daysdif(RDmin, Dates(IDint), Basis);
  Rates(IDint,:) = interp1q(RefTimes, RefRates, Times);
end

