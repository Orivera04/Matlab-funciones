function I = seqmatch(strs,lib,varargin)
%SEQMATCH Find matches for every string in a library.
%   IND = SEQMATCH(STRS,LIB) looks through the elements of LIB to find
%   strings that begin with every string in STRS. IND contains the indices
%   the first occurrence for every string in the query. If no match is found
%   for a given query the respective index is 0. STRS and LIB must be cell
%   arrays of strings. 
%
%   IND = SEQMATCH(STRS,LIB,'exact',true) looks for exact matches only.
%
%   Example:
%      
%     lib = {'VIPS_HUMAN','SCCR_RABIT','CALR_PIG','VIPR_RAT','PACR_MOUSE'};
%     query = {'CALR','VIP'};
%     h = seqmatch(query,lib);
%     lib(h)
%
%   See also REGEXPI, STRMATCH.

%   Copyright 2003-2004 The MathWorks, Inc. 

doExactMatch = false;

if  nargin > 2
    if rem(nargin,2) == 1
        error('Bioinfo:IncorrectNumberOfArguments',...
            'Incorrect number of arguments to %s.',mfilename);
    end
    okargs = {'exact',''};
    for j=1:2:nargin-2
        pname = varargin{j};
        pval = varargin{j+1};
        k = strmatch(lower(pname), okargs); %#ok
        if isempty(k)
            error('Bioinfo:UnknownParameterName',...
                'Unknown parameter name: %s.',pname);
        elseif length(k)>1
            error('Bioinfo:AmbiguousParameterName',...
                'Ambiguous parameter name: %s.',pname);
        else
            switch(k)
                case 1
                   doExactMatch = opttf(pval);
                    if isempty(doExactMatch)
                        error('Bioinfo:InputOptionNotLogical',...
                            '%s must be a logical value, true or false.',...
                             upper(char(okargs(k))));
                    end
            end %switch
        end %if
    end %for
end %if
         
if ~iscell(strs)
    error('Bioinfo:IncorrectInputType','STRS must be string cells')
end

if ~iscell(lib)
    error('Bioinfo:IncorrectInputType','LIB must be string cells')
end

strs = strs(:);
lib = lib(:);

numStrs = numel(strs);

if ~iscellstr(strs)
    error('Bioinfo:IncorrectInputType','All entries in STRS must be string arrays')
end
if ~iscellstr(lib)
    error('Bioinfo:IncorrectInputType','All entries in LIB must be string arrays')
end

I = zeros(numStrs,1);
for i = 1:numStrs
   if doExactMatch
       h = strmatch(strs{i},lib,'exact'); %#ok
   else
       h = strmatch(strs{i},lib); %#ok
   end
   if ~isempty(h)
       I(i) = h(1);
   end
end

if any(I==0)
     warning('Bioinfo:StringNotFound','String(s) not found')
end

 
