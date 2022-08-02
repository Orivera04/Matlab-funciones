function [data, seq] = fastaread(filename)
%FASTAREAD reads FASTA format file.
%
%   S = FASTAREAD(FILENAME) reads a FASTA format file FILENAME, returning
%   the data in the file as a structure. FILENAME can also be a URL or
%   MATLAB character array that contains the text of a FASTA format file.
%   S.Header is the header information. S.Sequence is the sequence stored
%   as a string of characters.
%
%   [HEADER, SEQ] = FASTAREAD(FILENAME) reads the file into separate
%   variables HEADER and SEQ. If the file contains more than one sequence,
%   then HEADER and SEQ are cell arrays of header and sequence information.
%
%   Examples:
%
%       % Read the sequence for the human p53 tumor gene.
%       p53nt = fastaread('p53nt.txt')
%
%       % Read the sequence for the human p53 tumor protein.
%       p53aa = fastaread('p53aa.txt')
%
%       % Read the human mitochondrion genome in FASTA format.
%       entrezSite = 'http://www.ncbi.nlm.nih.gov/entrez/viewer.fcgi?'
%       textOptions = '&txt=on&view=fasta'
%       genbankID = '&list_uids=NC_001807'
%       mitochondrion = fastaread([entrezSite textOptions genbankID])
%
%   See also EMBLREAD, FASTAWRITE, GENBANKREAD, GENPEPTREAD, MULTIALIGNREAD.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.15.4.7 $  $Date: 2004/04/01 15:57:56 $

% FASTA format specified here:
% http://www.ncbi.nlm.nih.gov/BLAST/fasta.html

% check input is char
% in a future version we may accept also cells
if ~ischar(filename)
    error('Bioinfo:InvalidInput','Input must be a character array')
end

if size(filename,1)>1  % is padded string
    for i=1:size(filename,1)
        ftext(i,1)=strread(filename(i,:),'%s','whitespace','','delimiter','\n');
        ftext{i}(find(~isspace(ftext{i}),1,'last')+1:end)=[];
    end    
    % try then if it is an url
elseif (strfind(filename(1:min(10,end)), '://'))
    if (~usejava('jvm'))
        error('Bioinfo:NoJava','Reading from a URL requires Java.')
    end
    try
        ftext = urlread(filename);
    catch
        error('Bioinfo:CannotReadURL','Cannot read URL "%s".', filename);
    end
    ftext = strread(ftext,'%s','delimiter','\n');

    % try then if it is a valid filename
elseif  (exist(filename) == 2 || exist(fullfile(cd,filename)) == 2)
    ftext = textread(filename,'%s','delimiter','\n');

else  % must be a string with '\n', convert to cell
    ftext = strread(filename,'%s','delimiter','\n');
end

% it is possible that there will be multiple sequences
commentLines = strncmp(ftext,'>',1);

if ~any(commentLines)
    error('Bioinfo:FastaNotValid',...
        'Input does not exist or is not a valid FASTA file.')
end

numSeqs = sum(commentLines);
seqStarts = [find(commentLines); size(ftext,1)+1];
data(numSeqs).Header = '';

try
    for theSeq = 1:numSeqs
        % Check for > symbol ?
        data(theSeq).Header = ftext{seqStarts(theSeq)}(2:end);
        firstRow = seqStarts(theSeq)+1;
        lastRow = seqStarts(theSeq+1)-1;
        numChars = cellfun('length',ftext(firstRow:lastRow));
        numSymbols = sum(numChars);
        data(theSeq).Sequence = repmat(' ',1,numSymbols);
        pos = 1;
        for i=firstRow:lastRow,
            len =  cellfun('length',ftext(i));
            if len == 0
                break
            end
            data(theSeq).Sequence(pos:pos+len-1) = ftext{i};
            pos = pos+len;
        end
    end
    data(theSeq).Sequence = deblank(data(theSeq).Sequence);
    % in case of two ouputs
    if nargout == 2
        if numSeqs == 1
            seq = data.Sequence;
            data = data.Header;
        else
            seq = {data(:).Sequence};
            data = {data(:).Header};
        end
    end

catch
    error('Bioinfo:IncorrectDataFormat','Incorrect data format in fasta file')
end

