function schema
% SCHEMA Defines class properties

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.4 $ $Date: 2004/04/11 00:42:29 $

% Get handles of associated packages and classes
hDeriveFromPackage = findpackage('ParameterEstimator');
hDeriveFromClass   = findclass(hDeriveFromPackage, 'IOData');
hCreateInPackage   = findpackage('ParameterEstimator');

% Construct class
c = schema.class(hCreateInPackage, 'FrequencyData', hDeriveFromClass);

% Sampling frequency
p = schema.prop(c, 'Fs', 'double');
p.FactoryValue = 1;
p.SetFunction = @LocalSetFs;

% Start frequency
p = schema.prop(c, 'Fstart', 'double');
p.FactoryValue = 0;
p.SetFunction = @LocalSetFstart;

% Frequency data
p = schema.prop(c, 'Frequency', 'MATLAB array');
p.GetFunction = @LocalGetFrequency;
p.SetFunction = @LocalSetFrequency;

% ----------------------------------------------------------------------------- %
function value = LocalSetFs(this, value)
if ( value > 0 )
  this.Frequency = [];
elseif ~isnan( value )
  error('The sampling frequency must be a strictly positive number.')
end

% ----------------------------------------------------------------------------- %
function value = LocalSetFstart(this, value, varargin)
if ( value < 0 )
  error('The start frequency must be a non-negative number.')
end

% --------------------------------------------------------------------------- %
function value = LocalGetFrequency(this, value)
if isempty(value)
  N = this.getDataLength;
  value = this.Fstart:this.Fs:this.Fstart+(N-1)*this.Fs;
  value = value(:);
else
  value = value - value(1) + this.Fstart;
end

% --------------------------------------------------------------------------- %
function value = LocalSetFrequency(this, value)
if isnumeric(value) && isreal(value) && isvector(value)
  N = this.getDataLength;
  if (N > 0)
    value = value(:); % Make it a column vector.
    if ( length(value) ~= N )
      error('Length of Frequency vector does not match the number of data samples.')
    end
  else
    error('Data must be assigned a value before setting Frequency.');
  end
elseif ~isempty(value)
  error('Frequency must be set to a column vector of real numbers.');
end

% Determine if frequency vector is uniformly sampled.
if ~isempty( value )
  df = diff(value);
  if any(df == 0)
    error('Identical frequency points are not allowed.')
  elseif any(df < 0)
    error('Frequency data must be monotonically increasing.')
  end

  dfn = df ./ max(df);

  % Treshold for "numerical" uniform sampling
  if min(dfn) > 1 - 1e-3;
    this.Fs     = df(1);
    this.Fstart = value(1);
    value = [];
  else
    this.Fs     = NaN;
    this.Fstart = value(1);
  end
end
