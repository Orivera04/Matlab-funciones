function [absrange,logrange] = exprprofrange(data,varargin)
%EXPRPROFRANGE calculates the range of expression profiles.
%
%   EXPRPROFRANGE(DATA) calculates the range of each expression profile in
%   dataset DATA.
%
%   [RANGE, LOGRANGE] = EXPRPROFRANGE(DATA) also calculates the log range,
%   that is log(max(prof)) - log(min(prof)), of each expression profile.
%
%   If no output arguments are specified, a histogram bar plot of the range
%   is displayed.   
%
%   EXPRPROFRANGE(...,'SHOWHIST',TF) displays a histogram of the range
%   data if TF is true.
%
%   Example:
%
%       load yeastdata
%       range = exprprofrange(yeastvalues,'showhist',true);
%
%   See also GENERANGEFILTER.

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.7.4.2 $   $Date: 2004/01/24 09:18:14 $

showhist = false;
if nargout == 0
    showhist = true;
end
dorel = false;

if nargout >1
    dorel = true;
end

if nargin > 1

    if rem(nargin,2)== 0
        error('Bioinfo:IncorrectNumberOfArguments',...
            'Incorrect number of arguments to %s.',mfilename);
    end
    okargs = {'showhistogram',''};
    for j=1:2:nargin-2
        pname = varargin{j};
        pval = varargin{j+1};
        k = strmatch(lower(pname), okargs);
        if isempty(k)
            error('Bioinfo:UnknownParameterName','Unknown parameter name: %s.',pname);
        elseif length(k)>1
            error('Bioinfo:AmbiguousParameterName','Ambiguous parameter name: %s.',pname);
        else
            switch(k)
                case 1  % showhist
                    showhist = opttf(pval);
                    if isempty(showhist)
                        error('Bioinfo:InputOptionNotLogical','%s must be a logical value, true or false.',...
                            upper(char(okargs(k))));
                    end
            end
        end
    end
end

lb = min(data,[],2);
ub = max(data,[],2);
absrange = ub-lb;

% log range only makes sense if we have absolute values -- guess if this is
% the case by looking for all non-negative values.
if dorel
    if any(lb<0)
        warning('Bioinfo:CannotCalculateLogRange',...
            'Data appears to be relative expression levels, log range change will not be calculated')
        logrange = [];
    else
        logrange = log(ub) - log(lb);
    end
end

% show histogram -- if both abs and rel range make sense, show these on the
% same plot in two axes.
if showhist
    numbuckets = max(10,numel(absrange)/100);
    numbuckets = ceil(min(numbuckets,100));
    if dorel
        subplot(2,1,1);
    end
    hist(absrange,numbuckets);
    title('Profile Ranges');
    if dorel
        subplot(2,1,2);
        title('Profile Log Ranges');
        hist(logrange(isfinite(logrange)),numbuckets);
    end
end
