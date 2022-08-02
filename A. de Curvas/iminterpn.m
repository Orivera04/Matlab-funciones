function VI = iminterpn(varargin)
%IMINTERPN Multidimensional interpolation using Image Processing Toolbox functions.
%    IMINTERPN performs multidimensional interpolation using Image
%    Processing Toolbox functions.  Unlike the MATLAB INTERPN function,
%    IMINTERPN can interpolate an integer array without converting it to
%    double.
%
%    VI = IMINTERPN(V, I1, I2, ..., IN, METHOD, EXTRAPVAL) interpolates the
%    array V at locations specified by I1, I2, ..., and IN.  I1 specifies
%    the interpolation locations along the first dimension; I2 specifies
%    the interpolation locations along the second dimension; and so on.
%    The number of interpolating location arguments must be at least
%    ndims(V). METHOD must be one of the strings 'nearest', 'linear', or
%    'cubic'. You can also omit METHOD, in which case IMINTERPN uses linear
%    interpolation.  EXTRAPVAL specifies the value to be interpolated
%    outside the domain of V.  You can omit EXTRAPVAL, in which case
%    IMINTERPN uses 0.
%
%    Class Support
%    -------------
%    V can be any nonsparse numeric array, and can be real or complex.  V
%    can also be logical.  The output, VI, has the same class as V.
%
%    Examples
%    --------
%    Interpolate the cameraman.tif image at a single point, corresponding
%    to a row coordinate of 50.1 and a column coordinate of 65.9. Compare
%    with the surrounding pixel values.
%
%        I = imread('cameraman.tif');
%        I(50:51, 65:66)
%        iminterpn(I, 50.1, 65.9)
%
%    Interpolate the cameraman.tif image at a set of locations using cubic 
%    interpolation.  Notice that the output has the same size as the 
%    location inputs.
%
%        I = imread('cameraman.tif');
%        [r,c] = ndgrid(50:.3:54, 65:.4:68);
%        iminterpn(I,r,c,'cubic')
%    
%    See also INTERPN, TFORMARRAY.

%    Steve Eddins
%    $Revision: 1.2 $  $Date: 2006/06/29 14:56:28 $

[V,locations,method,extrap_val] = parseInputs(varargin{:});

num_dims = max(ndims(V), numel(locations));

% Create tformarray inputs.
T = [];
R = makeresampler(method, 'fill');
TDIMS_A = 1:num_dims;
TDIMS_B = 1:num_dims;
TSIZE_B = [];
TMAP_B = cat(num_dims + 1, locations{:});
F = extrap_val;

VI = tformarray(V, T, R, TDIMS_A, TDIMS_B, TSIZE_B, TMAP_B, F);

%=========================================================================
function [V,locations,method,extrap_val] = parseInputs(varargin)

iptchecknargin(3, Inf, nargin, mfilename);

V = varargin{1};

locations = cell(1,0);
k = 2;
while (k <= nargin) && ~ischar(varargin{k})
    locations{1, end+1} = varargin{k};
    k = k + 1;
end

if k <= nargin
    method = varargin{k};
    k = k + 1;
else
    method = 'linear';
end

if k <= nargin
    extrap_val = varargin{k};
else
    extrap_val = 0;
end

% Do some basic input validation.  Must be at least two lcoations arrays;
% locations arrays must all have the same size; method must be a valid 
% string; extrap_val must be a scalar.

if numel(locations) < 2
    error('Must provide at least two interpolating location arrays, I1 and I2.');
end

for k = 2:numel(locations)
    if ~isequal(size(locations{1}), size(locations{k}))
        error('Interpolating location arrays must all have the same size.');
    end
end

valid_method_strings = {'nearest', 'linear', 'cubic'};
idx = find(strncmpi(method, valid_method_strings, numel(method)));

if isempty(idx)
    error('Invalid method specified.');
elseif numel(idx) > 1
    error('Ambiguous method specified.');
else
    method = valid_method_strings{idx};
end

if ~isscalar(extrap_val)
    error('EXTRAPVAL must be a scalar.');
end




    





