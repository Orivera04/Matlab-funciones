function [pos,plen,sequences] = palindromes(seq,varargin)
%PALINDROMES finds palindromes in a sequence.
%
%   [POS, PLENGTH] = PALINDROMES(SEQ) finds any palindromes of length
%   greater than or equal to 6 in sequence SEQ and returns POS, the
%   starting indices, and PLENGTH, the lengths of the palindromes.
%
%   [POS,PLENGTH,PAL] = PALINDROMES(SEQ) also returns a cell array,
%   PAL, of the palindromes.
%
%   PALINDROMES(...,'LENGTH',LEN) finds all palindromes of length
%   greater than or equal to LEN. The default value is 6.
%
%   PALINDROMES(...,'COMPLEMENT',true) finds complementary palindromes,
%   that is, where the elements match their complementary pairs A-T(orU)
%   and C-G instead of an exact nucleotide match.
%
%   Examples:
%
%       [p,l,s] = palindromes('GCTAGTAACGTATATATAAT')
%
%       [pc,lc,sc] = palindromes('GCTAGTAACGTATATATAAT','complement',true)
%
%   See also REGEXP, SEQRCOMPLEMENT, SEQSHOWWORDS, STRFIND.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.7.4.2 $  $Date: 2004/01/24 09:17:49 $

n = 6;
useComplement = false;
if nargin > 1
    if rem(nargin,2)== 0
        error('Bioinfo:IncorrectNumberOfArguments',...
            'Incorrect number of arguments to %s.',mfilename);
    end
    okargs = {'length','complement'};
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
                case 1   % length
                    n = pval;
                case 2 %  complement
                    useComplement = opttf(pval);
                    if isempty(useComplement)
                        error('Bioinfo:InputOptionNotLogical','%s must be a logical value, true or false.',...
                            upper(char(okargs(k))));
                    end

            end
        end
    end
end

origseq = seq;
seq = lower(seq);
cseq = seq;

if useComplement
    cseq = lower(seqcomplement(seq));
    if isrna(seq)
        cseq = dna2rna(cseq);
    end
end

seqLength = numel(seq);
hits = zeros(seqLength,1);

for outer = 1:seqLength
    len = 1;
    start = 0;
    for  inner = 1:min(outer-1,seqLength-outer)

        if (seq(outer-inner) == cseq(outer+inner))
            len = len + 2;
            start = outer-inner;
        else
            break;
        end
    end
    if start > 0
        hits(start) = len;
    end
    len = 0;
    start = 0;
    for  inner = 1:min(outer,seqLength-outer)

        if (seq(outer-(inner-1)) == cseq(outer+inner))
            len = len + 2;
            start = outer-(inner-1);
        else
            break;
        end
    end
    if (start > 0) && (len > hits(start) )
        hits(start) = len;
    end
end

pos = find(hits>=n);
if nargout > 1
    plen = hits(pos);
    if nargout > 2
        numPalindromes = length(pos);
        sequences = cell(numPalindromes,1);
        for count = 1:numPalindromes
            sequences{count} = origseq(pos(count):pos(count)+hits(pos(count))-1);
        end
    end
end
