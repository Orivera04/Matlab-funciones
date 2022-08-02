function [mav, uband, lband] = bolling(asset, samples, alpha, width)
%BOLLING Bollinger Band chart.
%   BOLLING(ASSET,SAMPLES,ALPHA,WIDTH) plots Bollinger bands for given ASSET
%   data vector.  SAMPLES specifies the number of samples to use in computing
%   the moving average.  ALPHA is an optional input that specifies the exponent
%   used to compute the element weights of the moving average.  The default
%   ALPHA is 0 (simple moving average).  WIDTH is an optional input that
%   specifies the number of standard deviations to include in the envelope.  It
%   is a multiplicative factor specifying how tight the bounds should be made
%   around the simple moving average.  The default WIDTH is 2.  This calling
%   syntax plots the data only and does not return the data.
%
%   Note: The standard deviations are normalized by (N-1) where N is the
%   sequence length.
%
%   [MAV,UBAND,LBAND] = BOLLING(ASSET,SAMPLES,ALPHA,WIDTH) returns MAV with the
%   moving average of the asset data, UBAND with the upper band data, and LBAND
%   with the lower band data.  It does not plot any data.
%
%   BOLLING(ASSET,20,1) plots linear 20-day moving average Bollinger Bands.
%
%   [MAV,UBAND,LBAND] = BOLLING(ASSET,20,1) returns the data used to plot the
%   linear 20-day moving average Bollinger Bands without plotting the data.
%
%   See also MOVAVG, HIGHLOW, CANDLE, POINTFIG.

%       Author(s): C.F. Garvin, 2-23-95
%       Copyright 1995-2003 The MathWorks, Inc.
%       $Revision: 1.6.2.2 $   $Date: 2004/04/06 01:06:51 $


% error checking for input arguments
if nargin < 1
    error('Finance:bolling:notEnoughInputs', ...
    'No input arguments specified.');
end
if nargin < 2
    error('Finance:bolling:needMovAvgPeriod', ...
    'Please specify a moving average length.');
end
if nargin < 3
    alpha = 0;
end
if nargin < 4
    width = 2;
end

[m,n] = size(asset);

if m > 1 && n > 1
    error('Finance:bolling:assetMustBeVector', ...
    'Please enter ASSET data as a row or column vector.');
end

asset = asset(:);
r = length(asset);

if numel(samples) > 1
    error('Finance:bolling:samplesMustBeScalar', ...
    'SAMPLES must be a scalar.');    
end

if numel(alpha) > 1
    error('Finance:bolling:alphaMustBeScalar', ...
    'ALPHA must be a scalar.');  
end

if samples < 2 || samples > r
    error('Finance:bolling:movAvgInvalidSample', ...
    sprintf('Please specify moving average length > 1 and < %1.0f.',r));
end

if numel(width) > 1
    error('Finance:bolling:widthMustBeScalar', ...
    'WIDTH must be a scalar.');  
end

if width < 0
    error('Finance:bolling:invalidWidth', ...
    'Please select a WIDTH greater than or equal to 0.');
end

% build weight vector
i = (1:samples)';
w = i.^alpha./sum(i.^alpha);

% build moving average vectors with for loops
a = zeros(r-samples,1);
b = a;
for i = samples:r
    a(i-samples+1) = sum(asset(i-samples+1:i).*w);
    b(i-samples+1) = width * sum(std(asset(i-samples+1:i)).*w);
end

if nargout == 0
    ind = samples:r;
    h = plot(ind,asset(ind),ind,a,ind,a+b,ind,a-b);
    if get(0,'screendepth') > 1
        cls = get(gca,'colororder');
        set(h(1),'color',cls(1,:));
        set(h(2),'color',cls(2,:));
        set(h(3),'color',cls(3,:));
        set(h(4),'color',cls(3,:));
    end
else
    mav = a;
    uband = a+b;
    lband = a-b;
end


% [EOF]
