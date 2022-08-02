function ftsout = smoothts(ftsin, smethod, wsize, extarg)
%@FINTS/SMOOTHTS smooths a FINTS object using a specified method.
%
%   FTSOUT = SMOOTHTS(FTSIN, SMETHOD, WSIZE, EXTARG)
%
%   SMOOTHTS, using the specified method, will smooth the data 
%   contained in a row-oriented matrix.  Valid smoothing methods
%   (SMETHOD) are Exponential (e), Gaussian (g) or Box (b).  Valid
%   SMETHOD's are in parentheses.  A row-oriented matrix is one
%   where each row is a variable and each column is an observation
%   for the specific variable.
%
%   FTSOUT = SMOOTHTS(FTSIN) smooths the FINTS object FTSIN using the 
%   default Box method with window size, WSIZE, of 5.
%
%   FTSOUT = SMOOTHTS(FTSIN, 'b', WSIZE) smooths the FINTS object FTSIN
%   using the Box (simple, linear) method.  WSIZE is an optional 
%   integer (scalar) argument that specifies the width of the box
%   to be used.  If WSIZE is not supplied, the default is 5.
%
%   FTSOUT = SMOOTHTS(FTSIN, 'g', WSIZE, STDEV) smooths the FINTS object
%   FTSIN using Gaussian Window method.  WSIZE and STDEV are optional
%   input arguments.  WZISE is an integer (scalar) that specifies the
%   size of the windows used.  STDEV is a scalar that represents the
%   standard deviation of the Gaussian Window.  If WSIZE and STDEV are
%   not supplied the defaults are 5 and 0.65, respectively.
%
%   FTSOUT = SMOOTHTS(FTSIN, 'e', WSIZE_OR_ALPHA) smooths the FINTS object
%   FTSIN using Exponential method.  WZISE_OR_ALPHA is a value 
%   that can specify either the window size (WSIZE) or exponential 
%   factor (ALPHA).  If WSIZE_OR_ALPHA is an integer greater than 1, 
%   it is considered as the window size (WSIZE); however, if it is 
%   between 0 and 1, it is considered as ALPHA, the exponential factor.
%   When it is 1, the effect is the same whether it is regarded as 
%   WSIZE or ALPHA.  If WSIZE_OR_ALPHA is not supplied the default 
%   is WSIZE = 5 (thus, ALPHA = 0.3333).
%
%   FTSOUT is a FINTS object with the same size as FTSIN.
%
%   See also FINTS/TSMOVAVG.

%   Author: P. N. Secakusuma, 01-08-98
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.9.2.1 $   $Date: 2003/01/16 12:51:02 $

% If the object is of an older version, convert it.
if fintsver(ftsin) == 1
    ftsin = ftsold2new(ftsin); % This sorts the fts too.
elseif ~issorted(ftsin);
    ftsin = sortfts(ftsin);
end

switch nargin
case 1
    smethod = 'b';
    wsize = 5;
case 2   % EXTARG only applies to Gaussian.
    if isempty(smethod)
        smethod = 'b';
    end
    wsize = 5;
    extarg = 0.65;
case 3   % EXTARG only applies to Gaussian.
    if isempty(wsize)
        wsize = 5;
    end
    extarg = 0.65;
case 4  % Only applies to Gaussian.
    if isempty(wsize)
        wsize = 5;
    end
    if isempty(extarg)
        extarg = 0.65;
    end
otherwise
    error('Ftseries:ftseries_fints_smoothts:InvalidNumberOfInputArguments', ...
        'Invalid number of input arguments.');
end

ftsout = ftsin;
switch lower(smethod(1))
case 'b'
    ftsout.data{1} = ['Box-smoothed of ', ftsin.data{1}];
    ftsout.data{4} = smoothts(ftsin.data{4}', smethod, wsize)';
case 'g'
    ftsout.data{1} = ['Gaussian-smoothed of ', ftsin.data{1}];
    ftsout.data{4} = smoothts(ftsin.data{4}', smethod, wsize, extarg)';
case 'e'
    ftsout.data{1} = ['Exponential-smoothed of ', ftsin.data{1}];
    ftsout.data{4} = smoothts(ftsin.data{4}', smethod, wsize)';
otherwise
    error('Ftseries:ftseries_smoothts:InvalidSmoothingMethod', ...
        'Valid smoothing methods are Box (''b''), Exponential (''e''), or Gaussian (''g'').');
end

% [EOF]