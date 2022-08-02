function schema
% SCHEMA Defines class properties

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:43:09 $

% Get handles of associated packages and classes
hDeriveFromPackage = findpackage('ParameterEstimator');
hDeriveFromClass   = findclass(hDeriveFromPackage, 'IOData');
hCreateInPackage   = findpackage('ParameterEstimator');

% Construct class
c = schema.class(hCreateInPackage, 'TransientData', hDeriveFromClass);

% Sampling time
p = schema.prop(c, 'Ts', 'double');
p.FactoryValue = 1;
p.SetFunction = @LocalSetTs;

% Start time
p = schema.prop(c, 'Tstart', 'double');
p.FactoryValue = 0;
p.SetFunction = @LocalSetTstart;

% Stop time
p = schema.prop(c, 'Tstop', 'double');
p.AccessFlags.PublicSet =  'off';
p.FactoryValue = NaN;
p.GetFunction = @LocalGetTstop;

% Time data
p = schema.prop(c, 'Time', 'MATLAB array');
p.GetFunction = @LocalGetTime;
p.SetFunction = @LocalSetTime;

% Periodic signal?
p = schema.prop(c, 'Periodic', 'bool');

% Intersample behavior: 'zoh', 'foh'
p = schema.prop(c, 'InterSample', 'HoldType');

% ----------------------------------------------------------------------------- %
function value = LocalSetTs(this, value)
if ( value > 0 )
  this.Time = [];
elseif ~isnan( value )
  error('The sample time must be a strictly positive number.')
end

% ----------------------------------------------------------------------------- %
function value = LocalSetTstart(this, value, varargin)
if ( value < 0 )
  error('The start time must be a non-negative number.')
end

% ----------------------------------------------------------------------------- %
function value = LocalGetTstop(this, value)
if ~isempty(this.Time)
  value = this.Time(end);
end

% --------------------------------------------------------------------------- %
function value = LocalGetTime(this, value)
if isempty(value)
  N = this.getDataLength;
  value = this.Tstart:this.Ts:this.Tstart+(N-1)*this.Ts;
  value = value(:);
else
  value = value - value(1) + this.Tstart;
end

% --------------------------------------------------------------------------- %
function value = LocalSetTime(this, value)
if isnumeric(value) && isreal(value) && isvector(value)
  N = this.getDataLength;
  if (N > 0)
    value = value(:); % Make it a column vector.
    if ( length(value) ~= N )
      error('Length of Time vector does not match the number of data samples.')
    end
  else
    error('Data must be assigned a value before setting Time.');
  end
elseif ~isempty(value)
  error('Time must be set to a column vector of real numbers.');
end

% Determine if time vector is uniformly sampled.
if ~isempty( value )
  dt = diff(value);
  if any(dt == 0)
    error('Identical time points are not allowed.')
  elseif any(dt < 0)
    error('Time data must be monotonically increasing.')
  end

  dtn = dt ./ max(dt);

  % Treshold for "numerical" uniform sampling
  if min(dtn) > 1 - 1e-3;
    this.Ts     = dt(1);
    this.Tstart = value(1);
    value = [];
  else
    this.Ts     = NaN;
    this.Tstart = value(1);
  end
end
