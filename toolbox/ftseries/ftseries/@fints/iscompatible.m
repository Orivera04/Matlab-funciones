function [isid, whynot]= iscompatible(varargin)
%@FINTS/ISCOMPATIBLE Structural equality for FINTS objects.
%
%   ISCOMP = iscompatible(FTSA, FTSB) returns 1 (one) if both FINTS 
%   objects FTSA and FTSB have the same dates, AND data series names; 
%   and, it returns 0 (zero) if any of those components is different.  
%
%   Remember that the data series names are case-sensitive.  ISCOMP = 1 
%   implies that there are the same number of data points between the two 
%   objects as well as equal number of data series.  HOWEVER, the values 
%   contained in the data series can be different.
%
%   See also @FINTS/ISEQUAL.

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.5 $   $Date: 2002/01/21 12:26:03 $

isid   = ones(1, nargin-1);
whynot = ones(1, nargin-1);

for oidx = 1:nargin-1
    arg1 = varargin{oidx};
    arg2 = varargin{oidx+1};
    [arg1Ver,arg1Time] = fintsver(arg1);
    [arg2Ver,arg2Time] = fintsver(arg2);
    
    if ~isa(arg1, 'fints') | ~isa(arg2, 'fints')
        isid(oidx)   = 0;
        whynot(oidx) = 1;   % Not the same object type (class).
    elseif isa(arg1, 'fints') & isa(arg2, 'fints')
        if (arg1Ver ~= arg2Ver)
            isid(oidx) = 0;
            whynot(oidx) = 4;   % Different versions
        elseif (arg1.datacount ~= arg2.datacount) | (arg1.serscount ~= arg2.serscount)
            isid(oidx)   = 0;
            whynot(oidx) = 2;   % Different number of data points (dates).
        elseif any(arg1.data{3} - arg2.data{3})  % Check dates.
            isid(oidx)   = 0;
            whynot(oidx) = 3;   % Different dates exist.
        elseif (arg1Time == 1) & (arg2Time == 1)
            if any((arg1.data{5} - arg2.data{5}) > (0.001/60/60/24))   % Check times. tolerance of .001 of a sec
                iseq(oidx) = 0;
                whynot(oidx) = 5;% Different times
            end
        else   % Check data series names.
            eval('isid(oidx) = ~any(any(char(sort(arg1.names(4:end)))-char(sort(arg2.names(4:end)))));', ...
                'isid(oidx) = 0; whynot(oidx) = 4;');   % Different data series name(s) exist.
        end
    end
end

isid = all(isid);

% [EOF]