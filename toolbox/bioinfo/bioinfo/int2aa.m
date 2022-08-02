function aa = int2aa(sequence,varargin)
%INT2AA converts a sequence of integers to a character array of amino acid symbols.
%
%   NT = INT2AA(SEQ) converts the sequence SEQ from integers into a sequence
%   of characters representing the amino acids.
%
%   A R N D C Q E G H I  L  K  M  F  P  S  T  W  Y  V  B  Z  X  *  -  ?
%   1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26
%
%   Where B is D or N (aspartic), Z is E or Q (glutamic), X represents any
%   amino acid, * represents an end terminator, - is a gap, and ? is an
%   unknown amino acid.
%
%   N = INT2AA(SEQ,...,'CASE',case) sets the output case of the nucleotide
%   string. Default is 'upper' case.
%
%   Example:
%
%       s = int2aa([13 1 17 11 1 21])
%
%   See also AA2INT, AMINOLOOKUP, INT2NT, NT2INT.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.12.6.4 $  $Date: 2004/01/24 09:17:41 $

if isempty(sequence)
    aa = '';
    return
end

% If the input is a structure then extract the Sequence data.
if isstruct(sequence)
    try
        sequence = seqfromstruct(sequence);
    catch
        rethrow(lasterror);
    end
end

origsize = size(sequence);
sequence = sequence(:);
sequence = sequence';

% A R N D C Q E G H I  L  K  M  F  P  S  T  W  Y  V  B  Z  X  *  -  ?
% 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26
% B = D | N; Aspartic
% Z = E | Q; Glutamic
% X = Any
% * End terminator
% - Gap
% ? Unknown

map='?ARNDCQEGHILKMFPSTWYVBZX*-?';

if nargin > 1
    lowercase = false;
    if rem(nargin,2)== 0
        error('Bioinfo:IncorrectNumberOfArguments',...
            'Incorrect number of arguments to %s.',mfilename);
    end
    okargs = {'case',''};
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
                case 1  % case
                    if ~isempty(strmatch(lower(pval),'lower'))
                        lowercase = true;
                    end
            end
        end
    end
    if lowercase
        map = lower(map);
    end
end

sequence(sequence>26) = 0;
sequence(sequence<0) = 0;
seqLength = length(sequence);
% pre-allocate the char
aa = char(0);aa(1,seqLength) = char(0);

for count = 1:seqLength
    aa(count) = map(double(sequence(count))+1);
end
aa = reshape(aa,origsize);
