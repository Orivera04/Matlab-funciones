function ado = adosc(varargin)
%ADOSC  Accumulation/Distribution (A/D) Oscillator.
%
%   ADO = adosc(HIGHP, LOWP, OPENP, CLOSEP) returns a vector, ADO, that 
%   represents the Accumulation/Distribution (A/D) Oscillator.  The A/D
%   Oscillator is calculated based on the high, low, open, and close 
%   prices of each period.  Each period is treated individually.
%
%   ADO = adosc([HIGHP  LOWP  OPENP  CLOSEP]) does the same as above
%   with the exception of the input argument.  Instead of entering the 
%   price vectors separately, the vectors are combined together to make up 
%   a 4-column matrix.  The order of the columns must be high, low, open, 
%   and close prices.
%
%   Example:   load disney.mat
%              dis_ADOsc = adosc(dis_HIGH, dis_LOW, dis_OPEN, dis_CLOSE);
%              plot(dis_ADOsc);
%
%   See also ADLINE, WILLAD.

%   Reference: Kaufman, P. J., The New Commodity Trading Systems and Methods, 
%              New York: John Wiley & Sons, 1987

%   Author: P. N. Secakusuma, 01-08-98
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.11 $   $Date: 2002/01/21 12:27:41 $

% Check input arguments.
switch nargin
case 1
    if size(varargin{1}, 2) ~= 4
        error('Ftseries:ftseries_adosc:InvalidNumberOfInputDataColumns', ...
            'Need 4 columns of data: HIGH, LOW, CLOSE, and VOLUME.');
    end
    
    highp  = varargin{1}(:, 1);
    lowp   = varargin{1}(:, 2);
    openp  = varargin{1}(:, 3);
    closep = varargin{1}(:, 4);
case 4
    if (size(varargin{1}, 1) ~= size(varargin{2}, 1)) | ...
            (size(varargin{2}, 1) ~= size(varargin{3}, 1)) | ...
            (size(varargin{3}, 1) ~= size(varargin{4}, 1))
        error('Ftseries:ftseries_adosc:InputVectorsMustBeTheSameLength', ...
            'Lengths of all input vectors must be the same.');
    end
    
    highp  = varargin{1}(:);
    lowp   = varargin{2}(:);
    openp  = varargin{3}(:);
    closep = varargin{4}(:);
otherwise
    error('Ftseries:ftseries_adosc:InvalidNumberOfInputArguments', ...
        'Invalid number of input arguments.');
end

% Calculate the A/D Oscilator.
tado = NaN * ones(size(closep));
ado = tado;
nzero = find((highp-lowp) ~= 0);
ado(nzero) = (((highp(nzero)-openp(nzero))+(closep(nzero)-lowp(nzero))) ./ ...
    (2*(highp(nzero)-lowp(nzero)))) * 100;

% [EOF]