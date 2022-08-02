function nt = int2nt(sequence,varargin)
%INT2NT converts a sequence of integers to a character array of nucleotides.
%
%   NT = INT2NT(SEQ) converts the sequence SEQ from integers into a sequence
%   of characters representing the nucleotides A,C,T,G. Unknown nucleotides
%   are represented by the symbol '*'.
%
%   N = INT2NT(SEQ,...,'ALPHABET',A) defines which nucleotide alphabet to
%   use. The default value is 'DNA' which uses the symbols A,C,T,G. If
%   ALPHABET is set to 'RNA', then A,C,U,G are used instead.
%
%   N = INT2NT(SEQ,...,'UNKNOWN',C) defines the symbol used to represent an
%   unknown nucleotide. The default value is '*'.
%
%   N = INT2NT(SEQ,...,'CASE',case) sets the output case of the nucleotide
%   string. Default is uppercase.
%
%   Example:
%
%       s = int2nt([1 2 4 3 2 4 1 3 2])
%
%   See also AA2INT, INT2AA, NT2INT.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.12.6.5 $  $Date: 2004/03/14 15:31:29 $

if isempty(sequence)
    nt = '';
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

% A C G T U R Y K M S  W  B  D  H  V N  -(gap)
% 1 2 3 4 4 5 6 7 8 9 10 11 12 13 14 15 16
map = '*ACGTRYKMSWBDHVN-';

if nargin > 1
    unknown = '*';
    tORu = 'T';
    lowercase = false;
    if rem(nargin,2)== 0
        error('Bioinfo:IncorrectNumberOfArguments',...
            'Incorrect number of arguments to %s.',mfilename);
    end
    okargs = {'alphabet','unknownsymbol','case'};
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
                case 1  % alphabet
                    if strcmpi(pval,'RNA')
                        tORu = 'U';
                    end
                case 2  % unknown
                    unknown = pval;
                    if ~ischar(pval)
                        error('Bioinfo:UnknownSymbolMustBeChar',...
                            'Unknown symbol must be a character');
                    end
                    if any(pval == 'acgtrykmswbdhvn')
                        error('Bioinfo:UnknownSymbolNotACGT',...
                            'Unknown symbol cannot be a standard nucleotide symbol {A,C,G,T,U,R,Y,K,M,S,W,B,D,H,V,N}');
                    end
                case 3  % case
                    if ~isempty(strmatch(lower(pval),'lower'))
                        lowercase = true;
                    end
            end
        end
    end
    map = strrep(map,'*',unknown);
    map = strrep(map,'T',tORu);
    if lowercase
        map = lower(map);
    end
end

sequence(sequence>16) = 0;
sequence(sequence<0) = 0;
seqLength = length(sequence);


% pre-allocate the char

nt = char(0);nt(1,seqLength) = char(0);

for count = 1:seqLength
    nt(count) = map(double(sequence(count))+1);
end
nt = reshape(nt,origsize);
