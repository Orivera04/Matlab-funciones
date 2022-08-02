function seq = randseq(n,varargin)
%RANDSEQ generates a random sequence.
%
%   RANDSEQ(n) generates a random DNA sequence of length n.
%
%   RANDSEQ(...,'ALPHABET',ALPHA) generates a sequence from alphabet ALPHA.
%   The default alphabet is 'DNA'. 'RNA' and 'AMINO' create sequences of
%   RNA and proteins respectively.
%
%   RANDSEQ(...,'WEIGHTS',W) creates a weighted random sequence where the
%   i-th letter of the sequence alphabet is selected with weight W(i). The
%   weight vector is usually a probability vector or a frequency count
%   vector. Note that the i-th element of the nucleotide alphabet is given
%   by int2nt(i), and the i-th element of the amino acid alphabet is given
%   by int2aa(i).
%
%   RANDSEQ(...,'FROMSTRUCTURE',STRUCT) creates a weighted random sequence
%   with weights given by the output structure from BASECOUNT, DIMERCOUNT,
%   CODONCOUNT, or AACOUNT.
%
%   RANDSEQ(...,'CASE',CASE) generates the sequence as 'UPPER' (default) or
%   'lower' case characters.
%
%   RANDSEQ(...,'DATATYPE',TYPE) creates the sequence as an array of type
%   TYPE. The default data type is 'char'. For numeric sequences use 'uint8'
%   or 'double'.
%
%   Example:
%
%       % Generate a 250 character random sequence of amino acids
%       randseq(250, 'ALPHABET', 'AMINO')
%
%   See also HMMGENERATE, RAND, RANDPERM, RANDSAMPLE.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.11.6.4 $  $Date: 2004/01/24 09:18:52 $

alphabet = 'dna';
dtype = 'char';
upperlower = 'upper';
weights = [];
alphalength = 4;
numWeights = 4;
nucleotides = true;
useStruct = false;

if  nargin > 1
    if rem(nargin,2)== 0
        error('Bioinfo:IncorrectNumberOfArguments',...
            'Incorrect number of arguments to %s.',mfilename);
    end
    okargs = {'alphabet','weights','fromstructure','case','datatype'};
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
                        alphabet = 'rna';
                    elseif strcmpi(pval,'DNA')
                        alphabet = 'dna';
                    elseif strcmpi(pval,'amino') || strcmpi(pval,'protein') || strcmpi(pval,'aa')
                        alphabet = 'amino';
                        alphalength = 20;
                        nucleotides = false;
                    else
                        error('Bioinfo:UnknownAlphabetType',...
                            'Unknown Alphabet Type: %s.',pval);
                    end

                case 2  % weights
                    weights = pval./sum(pval);
                    numWeights = numel(weights);
                    if numWeights == 20  % guess that we are dealing with a protein
                        alphabet = 'amino';
                        alphalength = 20;
                        nucleotides = false;
                    end
                case 3  % fromstructure
                    if ~isstruct(pval)
                        error('Bioinfo:StructureExpected','Expected a structure.');
                    end
                    theStruct = pval;
                    useStruct = true;
                case 4  % case
                    k4 = strmatch(lower(pval),{'lower','upper'});
                    if isempty(k4)
                        error('Bioinfo:UnknownCase','Unknown Case: %s.',pval);
                    else switch k4
                            case 1, upperlower = 'lower';
                            case 2, upperlower = 'upper';
                        end
                    end
                case 5  % format
                    okTypes = {'char','double','int8','int16','int32','int64','uint8','uint16','uint32','uint64'};
                    k5 = strmatch(lower(pval),okTypes);
                    if isempty(k5)
                        error('Bioinfo:UnknownDataType','Unknown Datatype: %s.',pval);
                    elseif length(k5)>1
                        error('Bioinfo:AmbiguousDataType','Ambiguous Datatype: %s.',pval);
                    else
                        dtype = okTypes{k5};
                    end
            end
        end
    end
end

if ~useStruct

    rseq = rand(1,n);

    if nargin < 2
        seq = ceil(rseq * alphalength);
    else
        if isempty(weights)
            weights = repmat(1/alphalength,1,alphalength);
        elseif numWeights ~= alphalength
            error('Bioinfo:InvalidWeightVector',...
                'Weight vector is not the same length as the alphabet');
        end
        [dum,seq] = histc(rseq,[0 ,cumsum(weights)]);
    end
    dtype = lower(dtype);

    if strmatch(dtype,'char')
        if nucleotides
            seq = int2nt(seq,'alphabet',alphabet,'case',upperlower);
        else
            seq = int2aa(seq,'case',upperlower);
        end
    else
        switch dtype
            case 'uint8', seq=uint8(seq);
            case 'uint16', seq=uint16(seq);
            case 'uint32', seq=uint32(seq);
            case 'uint64', seq=uint64(seq);
            case 'int16', seq=int16(seq);
            case 'int32', seq=int32(seq);
            case 'int64', seq=int64(seq);
            case 'double',  seq=double(seq);
        end
    end

else
    useHMM = false;
    theFields = fieldnames(theStruct);
    % Need to guess if we have DNA, RNA, Codons, Dimers or Amino Acids.
    numFields = length(theFields);
    fieldLen = length(theFields{1});
    theCell = struct2cell(theStruct);
    theVals = [theCell{:}];
    if fieldLen == 1
        if  numFields < 20
            % we have nucleotides or extended nucleotides
            theFields = strrep(theFields,'Others','*');
            theFields = strrep(theFields,'Gap','-');
        else
            % we have amino acids
            theFields = strrep(theFields,'Others','X');
            theFields = strrep(theFields,'Gap','-');
            theFields = strrep(theFields,'Unknown','?');
            theFields = strrep(theFields,'Any','X');
            theFields = strrep(theFields,'Stop','*');
        end
    elseif fieldLen == 3  % codons
        theFields = strrep(theFields,'Others','***');
    elseif fieldLen == 2
        % should really do something with a state machine generator as in
        % hmmgenerate.
        useHMM = true;
        transtionMatrix = dimer2tm(theStruct);
        seq = int2nt(hmmgenerate(n,transtionMatrix,eye(4)));
    else
        % make sure all fields are the same length

    end
    if ~useHMM
        seq = char(randsample(theFields,n,true,theVals))';
        % truncate here for the codon case
        seq = seq(1:n);
    end
    dtype = lower(dtype);
    if strmatch(dtype,'char')
        if (upperlower(1) == 'l')
            seq = lower(seq);
        end
    else
        seq = nt2int(seq);
        switch dtype
            case 'uint8', seq=uint8(seq);
            case 'uint16', seq=uint16(seq);
            case 'uint32', seq=uint32(seq);
            case 'uint64', seq=uint64(seq);
            case 'int16', seq=int16(seq);
            case 'int32', seq=int32(seq);
            case 'int64', seq=int64(seq);
            case 'double',  seq=double(seq);
        end
    end
end

function matrix = dimer2tm(theStruct)
% converts the dimercount output to a transition matrix that can be used by hmmgenerate
matrix = zeros(4);
for outer = 1:4
    outerLetter = int2nt(outer);
    for inner = 1:4
        innerLetter = int2nt(inner);
        matrix(outer,inner) = theStruct.([outerLetter,innerLetter]);
    end
end

