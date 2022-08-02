function absvar = exprprofvar(data,varargin)
%EXPRPROFVAR calculates the variance of expression profiles.
%
%   EXPRPROFVAR(DATA) calculates the variance of each expression profile in
%   dataset DATA. 
%
% 	If no output arguments are specified, a histogram bar plot of the
% 	variance is displayed.
%     
%   EXPRPROFVAR(...,'SHOWHIST',TF) displays a histogram of the variance of
%   data if TF is true. 
%
%   Example:
%
%       load yeastdata
%       datavar = exprprofvar(yeastvalues,'showhist',true);
%
%   See also EXPRPROFRANGE, GENERANGEFILTER, GENEVARFILTER.

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.8.4.2 $   $Date: 2004/01/24 09:18:15 $

showhist = false;
if nargout == 0
    showhist = true;
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
            error('Bioinfo:UnknownParameterName',...
                'Unknown parameter name: %s.',pname);
        elseif length(k)>1
            error('Bioinfo:AmbiguousParameterName',...
                'Ambiguous parameter name: %s.',pname);
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

absvar = var(data,[],2);

if showhist
    numbuckets = max(10,numel(absvar)/100);
    numbuckets = ceil(min(numbuckets,100));
    hist(absvar,numbuckets);
    title('Profile Variances');
end
