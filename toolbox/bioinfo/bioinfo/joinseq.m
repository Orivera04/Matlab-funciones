function joined = joinseq(left,right)
%JOINSEQ joins two sequences to produce the shortest supersequence.
%
%   JOINSEQ(SEQ1,SEQ2) creates a new sequence that is the shortest         
%   supersequence of SEQ1 and SEQ2. If there is no overlap between the     
%   sequences, then SEQ2 is concatenated to the end of SEQ1. If the length 
%   of the overlap is the same at both ends of the sequence, then the      
%   overlap at the end of SEQ1 and the start of SEQ2 is used to join the   
%   sequences.    
%
%   If SEQ1 is a subsequence of SEQ2, then SEQ2 is returned as the shortest
%   supersequence and vice versa.
%
%   Example:
%
%       seq1 = 'ACGTAAA'; seq2 = 'AAATGCA';
%       joined = joinseq(seq1,seq2)
%
%   See also CAT, PAREN, STRCAT, STRFIND.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.5.4.2 $  $Date: 2004/01/24 09:17:43 $

llen = length(left);
rlen = length(right);

[slen, shortest] = min([llen,rlen]);

% is one contained in the other?
if shortest == 1 % left shorter
    subseq = strfind(right,left);
    if ~isempty(subseq)
        joined = right;
        return
    end
else
    subseq = strfind(left,right);
    if ~isempty(subseq)
        joined = left;
        return
    end

end

% find the longest prefix of one seq in the other
rightLength = findprefix(left(1:slen),right(1:slen),1);

leftLength = findprefix(right(1:slen),left(1:slen),rightLength);

[prelength , longest] = max([leftLength,rightLength]);

if longest == 1 % left longer
    joined = [left(1:llen - prelength), right];
else
    joined = [right(1:rlen - prelength), left];
end

function maxPrefix = findprefix(text,pattern,bestyet)
%FINDPREFIX finds the maximum prefix of a pattern in string.
lpatt = length(pattern);
if bestyet == 0
    bestyet =1;
end
maxPrefix = 0;
for count = lpatt-1:-1:bestyet
    if text(count) == pattern(lpatt)
        match = true;
        for inner = 2:count
            if text(count + 1 - inner) ~= pattern(lpatt + 1 - inner)
                match = false;
                break
            end
        end
        if match
            maxPrefix = count;
            return;
        end
    end
end
