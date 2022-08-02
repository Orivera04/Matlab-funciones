function seq = seqfromstruct(seqStruct)
%SEQFROMSTRUCT returns Sequence field of a structure.
%   
%   SEQFROMSTRUCT(STRUCTURE) returns the field Sequence from STRUCTURE. If
%   no Sequence field exists but a field with some other capitalization of
%   Sequence does exist, then this field is returned but a warning is
%   given.
%
%   If the input contains a nested structure then the leaf node is
%   returned.
%
%   The function gives an error if it encounters an array of structures.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2004/01/24 09:18:42 $

if numel(seqStruct) > 1
    error('Bioinfo:SeqStructArray',...
        ['The input structure contains multiple sequences.\n',...
        'Please specify a single sequence.']);
end
% if the struct has a field Sequence then we use it
try
    seq = seqStruct.Sequence;
    % call recursively to find the sequence
    if isstruct(seq)
        try
        seq = seqfromstruct(seq);
        catch
            rethrow(lasterror);
        end
    end
    return
catch
    % if not we check for fields with different capitalization
    fields = fieldnames(seqStruct);
    matches = find(strcmpi(fields,'sequence'));
    if numel(matches) == 1
        seq = seqStruct.(fields{matches});
        warning('Bioinfo:StructSeqCapitalization',...
            ['Field names in MATLAB structures are case sensitive.\nThe input',...
            'structure contains a ''%s'' field. However, most \nfunctions in the',...
            'toolbox create structures with a ''Sequence'' field.\nUsing mixed',...
            'capitalization can lead to unexpected results.'], fields{matches});
    elseif numel(matches) > 1
        error('Bioinfo:StructMultiSeqFields',...
            ['The input structure contained multiple sequence fields.\n',...
            'Please specify a single sequence.']);
    else
        error('Bioinfo:StructNoSequence',...
            'Input value is a structure that does not contain a Sequence field.');
    end
end