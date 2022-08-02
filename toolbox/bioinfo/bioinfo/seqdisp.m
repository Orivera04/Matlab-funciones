function display = seqdisp(seq,varargin)
%SEQDISP formats long sequence output for easy viewing.
%
%   SEQDISP(SEQ) prints the sequence, SEQ in rows with a default row
%   length of 60 and column width of 10. SEQ can be any of several input
%   types - a character array, a FASTA file name, a MATLAB structure with
%   Sequence and Header fields, or a MATLAB structure with fields from
%   GenBank or GenPept. Multiple sequences are allowed, and header
%   information is displayed when available.
%
%   SEQDISP(..., 'ROW', length) defines the length of each row of the
%   displayed sequence. The default length is 60.
%
%   SEQDISP(..., 'COLUMN', width) defines the column width of data for
%   the displayed sequence. The default column width is 10.
%
%   SEQDISP(..., 'SHOWNUMBERS', false) turns the position numbers at the
%   start of each row off. The default is 'true'.
%
%   Example:
%
%       % Read in sequence information from a GenBank file, then display it
%       % in rows of 50 with column widths of 10.
%       M10051 = genbankread('HGENBANKM10051.GBK')
%       seqdisp(M10051, 'row', 50)
%
%       % Create and save a FASTA file with 2 sequences.
%       hdr = ['Sequence A';'Sequence B']
%       seq = ['TAGCTGRCCAAGGCCAAGCGAGCTTN';'ATCGACYGGTTCCGGTTCGCTCGAAN']
%       fastawrite('local.fa',hdr,seq);
%       % Now display it with SEQDISP
%       seqdisp('local.fa', 'SHOWNUMBERS', false)
%
%   See also MULTIALIGNREAD, SEQSHOWORFS, SEQSHOWWORDS.

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.1.6.4 $   $Date: 2004/04/01 15:58:53 $

% set default parameters
rowLength = 60;
columnWidth = 10;
showNum = true;

if nargin > 1
    if rem(nargin,2) == 0
        error('Bioinfo:IncorrectNumberOfArguments',...
            'Incorrect number of arguments to %s.',mfilename);
    end
    okargs = {'row','column','shownumbers'};
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
                case 1  % row
                    rowLength = pval;
                case 2  % column
                    columnWidth = pval;
                case 3  % show numbers
                    showNum = pval == true;
            end
        end
    end
end

if rem(rowLength,columnWidth) ~= 0
    error('Bioinfo:InvalidcolumnWidth',...
        'The row length (%d) must be evenly divisible by column width (%d).',...
        rowLength, columnWidth);
end

% determine the format of the sequence
if isstruct(seq)
    try     %try to extract the header and sequence
        name = fieldfromstruct(seq,'Header');
        if isempty(char(name))
            gi = fieldfromstruct(seq,'GI');
            if ~isempty(char(gi))
                gi = ['gi|' char(gi) '|'];
            end
            ref = fieldfromstruct(seq,'Version');
            if ~isempty(char(ref))
                ref = ['gb|' char(ref) '|'];
            end
            def = fieldfromstruct(seq,'Definition');
            if ~isempty(char(def))
                def = [' ' char(def)];
            end
            name = [gi ref def];
        end
        seqtext = fieldfromstruct(seq,'Sequence');
    catch
        rethrow(lasterror);
    end
elseif iscell(seq)
    seqtext = char(seq');
elseif exist(seq,'file')
    try     %try as a FASTA file
        [name, seqtext] = fastaread(seq);
    catch
        error('Bioinfo:InvalidFASTAfile',...
            'File does not exist or is not a valid FASTA file.')
    end
else
    seqtext = seq;  %true for a sequence string
end
if iscell(seqtext)
    seqtext = char(seqtext);
end
if exist('name','var') && iscell(name)
    name = char(name);
end

% work in uppercase
seqtext = upper(seqtext);

display = '';
% repeat as needed for multiple sequences
num_sequences = size(seqtext,1);
maxlength = size(seqtext,2);
format = sprintf('%%%dd  ',ceil(log10(maxlength)));

for i=1:num_sequences
    currseq = deblank(seqtext(i,:));
    seqlength = numel(currseq);
    if seqlength == 0
        continue
    end
    % calculate array dimensions and padding
    arrayrows = ceil(seqlength/rowLength);
    if rem(seqlength,rowLength) == 0
        padding = '';
    else
        padding = blanks(rowLength - rem(seqlength,rowLength));
    end
    
    % insert space between columns
    currseq = regexprep([currseq padding],['([\w\?\*\-\. ]{' num2str(columnWidth) '})'],'$1 ');
    extras = rowLength/columnWidth;
    
    % reshape the results
    currdisp = reshape(currseq,rowLength+extras,arrayrows)';
    
    % if names are available from a FASTA file, get them
    if exist('name','var') && ~isempty(name)
        currname = ['>' deblank(name(i,:))];
    else
        currname = '';
    end
    
    % add row position numbers and clean up extra blank space
    if showNum
        rownum = sprintf(format,1:rowLength:seqlength);
        rownum = reshape(rownum,numel(rownum)/arrayrows,arrayrows)';
        currdisp = jointext(currname,[rownum currdisp]);
    else
        currdisp = jointext(currname,currdisp);
    end
    finalLength = size(currdisp,2) - 1;
    display = jointext(display,currdisp(:,1:finalLength));
    if i ~= num_sequences
        display = [display' blanks(size(display,2))']';
    end
end

%----------------------------------
function result = jointext(text1,text2)
%JOINTEXT sizes text1 to match text2 and prepends it to text2.

maxlength = size(text2(1,:),2);
if isempty(text1)
    result = text2;
    return;
end
length1 = size(text1(1,:),2);
if length1 <= maxlength
    text1 = [text1 blanks(maxlength-length1)];
else
    text1 = [text1(1:maxlength-4) '... '];
end
result = [text1' text2']';
