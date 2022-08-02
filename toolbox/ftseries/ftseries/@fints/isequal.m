function iseq = isequal(varargin)
%@FINTS/ISEQUAL Exact equality for FINTS objects.
%
%   ISEQ = isequal(FTSA, FTSB) returns 1 (one) if both FINTS objects FTSA and
%   FTSB have the same dates, frequencies, data series names, AND data values.
%   Otherwise it returns 0 (zero). Please note that the data series names are
%   case-sensitive, but do not have to be in the same order within each object.
%
%   ISEQ = 1 implies that there are the same number of data points between the
%   the objects as well as equal number of data series.
%
%   See also @FINTS/ISCOMPATIBLE.

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2003 The MathWorks, Inc.
%   $Revision: 1.8.2.2 $   $Date: 2004/04/06 01:08:24 $

iseq = ones(1, nargin-1);
for oidx = 1:nargin-1
    arg1 = varargin{oidx};
    arg2 = varargin{oidx+1};
    [arg1Ver,arg1Time] = fintsver(arg1);
    [arg2Ver,arg2Time] = fintsver(arg2);

    if ~isa(arg1, 'fints') || ~isa(arg2, 'fints')
        iseq(oidx) = 0;
    elseif isa(arg1, 'fints') && isa(arg2, 'fints')
        if (arg1Ver ~= arg2Ver)
            iseq(oidx) = 0;
        elseif (arg1.datacount ~= arg2.datacount) || (arg1.serscount ~= arg2.serscount)
            iseq(oidx) = 0;
        elseif (isempty(arg1.data{2})&isempty(arg2.data{2})) || (arg1.data{2}~=arg2.data{2})   % Check frequency.
            iseq(oidx) = 0;
        elseif any(arg1.data{3} - arg2.data{3})   % Check dates.
            iseq(oidx) = 0;
        elseif (arg1Time == 1) && (arg2Time == 1)
            if any((arg1.data{5} - arg2.data{5}) > (0.001/60/60/24))   % Check times. tolerance of .001 of a sec
                iseq(oidx) = 0;
            end
        else   % Check data series names.
            eval('iseq(oidx) = ~any(any(char(sort(arg1.names(4:end)))-char(sort(arg2.names(4:end)))));', ...
                'iseq(oidx) = 0;');
            if iseq   % Check values.
                eval('iseq(oidx) = ~any(any(arg1.data{4}-arg2.data{4}));', ...
                    'iseq(oidx) = 0;');
            end
        end
    end
end

iseq = all(iseq);

% [EOF]
