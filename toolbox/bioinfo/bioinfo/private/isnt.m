function result = isnt(seq,varargin)
%ISNT True for nucleotide sequences.
%   ISNT(SEQ) returns 1 for a DNA sequence, 0 otherwise. Valid symbols are
%   A,C,G,T,U,N,R,Y,K,M,S,W,B,D,H,V and *.
%
%   ISNT(...,'ACGTUOnly',true) returns 1 only if the sequence contains
%   A,C,G and T or U only.   
%
%   See also ISDNA, ISRNA, ISAA.

%   Copyright 2003-2004 The MathWorks, Inc. 
%   $Revision: 1.10.6.5 $  $Date: 2004/01/24 09:18:38 $

acgtonly = false;
if nargin > 1
    if rem(nargin,2)== 0
        error('Bioinfo:IncorrectNumberOfArguments',...
            'Incorrect number of arguments to %s.',mfilename);
    end
    okargs = {'acgtuonly'};
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
                case 1  % others forces everything except ACTG to be the unknown value
                    if islogical(pval)
                        acgtonly = pval;
                    else
                        error('Bioinfo:InvalidACGTOnly',...
                            'Invalid value for ACGTonly parameter. Value must be true or false.');
                    end
            end
        end
    end
end

persistent maxval
    if isempty(maxval)
        [dummy,map] = nt2int('a'); %#ok
        maxval = max(map);
    end
if ischar(seq)
    try
        seq = nt2int(seq);
    catch
        result = false;
        return
    end
    
end

if acgtonly
    upperLimit = 4;
else
    upperLimit = maxval; % max(nt2int('ACGTUNRYKMSWBDHV*'));
end
result = ~any(any(seq <= 0 | seq > upperLimit | seq ~= floor(seq)));
