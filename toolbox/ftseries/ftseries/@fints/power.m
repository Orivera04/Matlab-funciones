function fts = power(varargin)
%@FINTS/POWER (.^) Array/non-matrix power of a FINTS object.
%
%   NEWFTS = OLDFTS .^ A_SCALAR calculates the A_SCALAR-th power of all 
%   the values contained in the data series in the FINTS object OLDFTS 
%   and puts the results in another FINTS object, NEWFTS.  NEWFTS will
%   contain the same data series names as OLDFTS.
%
%   NEWFTS = A_SCALAR .^ OLDFTS raises the value A_SCALAR to the values
%   contained in the data series in the FINTS object OLDFTS, and puts 
%   the results in another FINTS object, NEWFTS.  NEWFTS will contain 
%   the same data series names as OLDFTS.
%
%   NEWFTS = FTSA .^ FTSB raises the values in the object FTSA 
%   element-per-element to the values in the object FTSB.  The data 
%   series names in both series must be identical as well as the dates 
%   and the number of data points.  NEWFTS will contain the same data 
%   series names as FTSA.
%
%   See also @FINTS/PLUS, @FINT/MINUS, @FINTS/TIMES, @FINTS/RDIVIDE.
%

%   Author: P. Wang, P. N. Secakusuma
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.7 $   $Date: 2002/01/21 12:21:39 $

arg1 = varargin{1};
arg2 = varargin{2};

if isa(arg1, 'fints') & ~isa(arg2, 'fints')
    % Convert/sort
    if fintsver(arg1) == 1
        arg1 = ftsold2new(arg1); % This sorts the fts too.
    elseif ~issorted(arg1)
        arg1 = sortfts(arg1);
    end
    
    fts = arg1;
    fts.data{4} = arg1.data{4} .^ arg2;
elseif ~isa(arg1, 'fints') & isa(arg2, 'fints')
    % Convert/sort
    if fintsver(arg2) == 1
        arg2 = ftsold2new(arg2); % This sorts the fts too.
    elseif ~issorted(arg2)
        arg2 = sortfts(arg2);
    end
    
    fts = arg2;
    fts.data{4} = arg1 .^ arg2.data{4};
else
    % Convert/sort
    if fintsver(arg1) == 1
        arg1 = ftsold2new(arg1); % This sorts the fts too.
    elseif ~issorted(arg1)
        arg1 = sortfts(arg1);
    end
    if fintsver(arg2) == 1
        arg2 = ftsold2new(arg2); % This sorts the fts too.
    elseif ~issorted(arg2)
        arg2 = sortfts(arg2);
    end
    
    if iscompatible(arg1, arg2)
        fts = arg1;
        fts.data{4} = arg1.data{4} .^ arg2.data{4};
    else
        error('Ftseries:ftseries_fints_power:FINTSObjNotIdentical', ...
            'FINTS objects are not compatible (identical).');
    end
end

% [EOF]