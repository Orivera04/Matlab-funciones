function [nmers,buckets] = nmercount(seq,len)
%NMERCOUNT counts n-mers in a sequence.
%
%   NMERCOUNT(SEQ,LEN) counts the number of n-mers, or patterns, of
%   length LEN in sequence SEQ.
%
%   Example:
%
%       S = getgenpept('AAA59174','SequenceOnly',true)
%       nmers = nmercount(S,4);
%       nmers(1:20,:)
%
%   See also BASECOUNT, CODONCOUNT, DIMERCOUNT.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.3.4.5 $  $Date: 2004/02/01 21:35:48 $

if nargin < 2
   error('Bioinfo:NotEnoughInputs','Not enough input arguments.'); 
end

% If the input is a structure then extract the Sequence data.
if isstruct(seq)
    try
        seq = seqfromstruct(seq);
    catch
        rethrow(lasterror);
    end
end

% figure out how much big everything is.
seqLen = length(seq);
numberOfNmers = seqLen - len + 1;

% now stash all of the nmers in the array
for count = len:-1:1
    nmers(:,count) = seq(count:count+numberOfNmers-1);
end

% look for the unique nmers
[nmers ,i,j] = unique(nmers,'rows');
numUniqueVals = numel(i);

% now use j to calculate multiplicity
buckets = accumarray(j,1);

% we want to order by the multiplicity
[buckets,perm] = sort(-buckets);
buckets = - buckets;
nmers = nmers(perm,:);

% with one output we save this into a cell array.
if nargout == 1
    tempcell = cell(numUniqueVals,2);
    for count = 1:numUniqueVals
        tempcell{count,1} = nmers(count,:);
        tempcell{count,2} = buckets(count);
    end
    nmers = tempcell;
end
