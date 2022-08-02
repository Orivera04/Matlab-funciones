function VolSpec = bdtvolspec(varargin)
%BDTVOLSPEC Specify a BDT interest rate volatility process.  
%
%    VolSpec = bdtvolspec(ValuationDate, VolDates, VolCurve)
%
%    VolSpec = bdtvolspec(ValuationDate, VolDates, VolCurve, InterpMethod)
%
%
% Inputs:
%   ValuationDate - Scalar value representing the observation date of the 
%                   investment horizon.
%   VolDates      - NPOINTS x 1 vector of yield volatility end dates.
%   VolCurve      - NPOINTS x 1 vector of yield volatility values in decimal form.
%   InterpMethod  - Method of interpolation to use. Default is 'linear'. 
%                   Type "help interp1" for more information.
%
% Output:
%   VolSpec - Structure specifying the volatility model for BDTTREE.
%
% See also BDTTREE

%   Author(s): M. Reyes-Kattar 01/27/2001
%   Copyright 1998-2002 The MathWorks, Inc. 
%   $Revision: 1.6 $  $Date: 2002/04/14 16:39:04 $


%----------------------------------------------------------------
% Checking input arguments
%----------------------------------------------------------------
if isafin(varargin{1},'BDTVolSpec')
	VolSpec = bdtvolspecshift(varargin{:});
	return;
end

% Make sure that there are exactly 3 argument variables
if nargin<3,
  error('ValuationDate, VolDates and VolCurve are required');
end

if nargin < 4
	VolInterpMethod = 'linear';
else
	VolInterpMethod = varargin{4};
	PosValues = {'nearest'; 'linear'; 'spline'; 'pchip'; 'cubic'; 'v5cubic'};
	if isempty(VolInterpMethod) | ~isa(VolInterpMethod,'char') | ~any(strcmp(VolInterpMethod,PosValues))
        error('VolInterpMethod must be a valid interpolation method. See "help interp1".');
    end
end
  
% parse arguments to standard form: handle dates and empties
ClassList = {'date'; 'date'; 'dble'};
[ValuationDate, VolDates,  VolCurve] = ... 
    finargparse(ClassList, varargin{1:3});

% All should be vectors of the same size
if (any(size(VolDates) ~= size(VolCurve)))
	error('VolDates and VolCurve must be of the same size')
end

if(ndims(VolDates)~=2 | all(size(VolCurve)~=1))
	error('VolDates and VolCurve must be vectors')
end

% Make sure data is sorted
[CurveDates, IOrder] = sort(VolDates(:));
VolCurve = VolCurve(IOrder);

% -------------------------------------------------------
% Save the data in the BDTVolSpec struct
% -------------------------------------------------------
VolSpec = classfin('BDTVolSpec');
VolSpec.ValuationDate = ValuationDate;
VolSpec.VolDates = datenum(CurveDates);
VolSpec.VolCurve   = VolCurve;
VolSpec.VolInterpMethod = VolInterpMethod;

return

%--------------------------------------------------------
% Shift the volatility curve up by SigmaShift
%--------------------------------------------------------
function VolSpecOut = bdtvolspecshift(VolSpecIn, SigmaShift)

VolSpecOut = VolSpecIn;
VolSpecOut.VolCurve = VolSpecOut.VolCurve + SigmaShift;
return
