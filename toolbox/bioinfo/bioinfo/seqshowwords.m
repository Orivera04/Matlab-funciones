function [wordOutput, wholestring] =seqshowwords(seq,word,varargin)
%SEQSHOWWORDS displays a sequence with selected words highlighted.
%
%   SEQSHOWWORDS(SEQ,WORD) displays the sequence, SEQ, in the Help Browser,
%   with all occurrences of the word WORD highlighted. SEQSHOWWORDS returns
%   a structure of the start and stop positions of all occurrences of WORD
%   in SEQ. WORD can be a regular expression.
%
%   SEQSHOWWORDS(...,'COLOR',COLOR) selects the color used to highlight the
%   words in the output display. The default color is red. COLOR can be
%   either a 1x3 RGB vector specifying the intensity (0-255) of the red,
%   green, and blue component of the color, or a character from the
%   following list:
%
%            'b'     blue
%            'g'     green
%            'r'     red
%            'c'     cyan
%            'm'     magenta
%            'y'     yellow
%
%   SEQSHOWWORDS(...,'COLUMNS',COLS) specifies how many columns per line
%   to use in the output. The default is 64.
%
%   SEQWORDCOUNT(...,'ALPHABET',A) specifies that SEQ and WORD are
%   amino acids ('AA') or nucleotides ('NT'). The default is NT.
%
%   If WORD contains nucleotide or amino acid symbols that represent
%   multiple possible symbols, then SEQSHOWWORDS shows all matches.
%   For example, the symbol R represents either G or A (purines). If WORD
%   is 'ART', then SEQSHOWWORDS shows occurrences of both 'AAT' and 'AGT'.
%
%   Example:
%
%       seqshowwords('GCTAGTAACGTATATATAAT','BART');
%       shows two matches  ('TAGT' and 'TAAT')
%
%   SEQSHOWWORDS does not highlight overlapping patterns multiple times.
%
%   Example:
%
%       seqshowwords('GCTATAACGTATATATATA','TATA');
%
%       % This highlights two places, the first occurrence of 'TATA' and the
%       % 'TATATATA' immediately after 'CG'. The final 'TA' is not
%       % highlighted because the preceding 'TA' is part of an already
%       % matched pattern. To highlight all multiple repeats of TA, use the
%       % regular expression 'TA(TA)*TA'.
%
%       seqshowwords('GCTATAACGTATATATATA','TA(TA)*TA');
%
%   See also PALINDROMES, REGEXP, RESTRICT, SEQDISP, SEQSHOWORFS,
%   SEQWORDCOUNT, STRFIND.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.12.4.5 $  $Date: 2004/03/14 15:31:43 $

wrap = 64;
origword = word;
useRegexp = true;
alphabet = {};
fontname = 'monospaced';

color = 'FF0000';
noDisplay = false;
if nargin > 2
    if rem(nargin,2) == 1
        error('Bioinfo:IncorrectNumberOfArguments',...
            'Incorrect number of arguments to %s.',mfilename);
    end
    okargs = {'fontname','color','columns','exact','nodisplay','alphabet'};
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
                case 1  % font
                    fontname = pval;
                case 2 %color
                    if isnumeric(pval)
                        color = sprintf('%02x%02x%02x',pval(1), pval(2),pval(3));
                    elseif ischar(pval)
                        switch pval(1)
                            case 'r'
                                color = 'FF0000';
                            case 'g'
                                color = '00CC00';
                            case 'b'
                                color = '0000FF';
                            case 'm'
                                color = 'FF00FF';
                            case 'c'
                                color = '00FFFF';
                            case 'y'
                                color = 'CCCC00';
                                %                             case 'w'
                                %                                 color = 'FFFFFF';
                                %                             case 'k'
                                %                                 color = '000000';
                        end
                    end
                case 3% wrap
                    wrap = pval;
                case 4% no regexp
                    useRegexp = pval;
                case 5% noDisplay
                    noDisplay = pval;
                case 6 % alphabet
                    alphabet = pval;
                    if strcmpi(pval,'aa')
                        alphabet = 'aa';
                    end
            end
        end
    end
end


if useRegexp && ((isnt(word) && isnt(seq)) || (isaa(word) &&isaa(seq)))
    if isempty(alphabet)
        word = seq2regexp(word);
    else
        word = seq2regexp(word,'ALPHABET',alphabet);
    end
end

seqLen = length(seq);
if seqLen  > 500000  % large display will mess up the help browser's memory
    error('Bioinfo:ShowWordsLimit','SEQSHOWWORDS can only display at most 500000 symbols. Please use a shorter sub-sequence.')
end

% regexp struggles with more than 4 or 5 [ ] groups

numGroups = sum(word == '[');
if seqLen > 20000 && numGroups > 4
    warning('Bioinfo:RegexpMayTakeTime','This search may take a long time...');
end

[starts,stops] = regexpi(seq,word);

% save the output
wordOutput.Start = starts;
wordOutput.Stop = stops;

stops = stops +1;

wholestring = repmat(' ',1,(seqLen*2));
wholePoint = 1;

string = sprintf('text://<html><title>Occurrences of %s</title><body><font face="%s">',origword,fontname);

% create the HTML string

inWord = false;
%string = [string sprintf('<p>Frame %d</p><br>',frame)];

% wholestring is a big allocated chunk of space
wholestring(wholePoint:wholePoint+length(string)-1) = string;
wholePoint = wholePoint+length(string);
string = '';

currentColor = color;
colorString  = sprintf('<b><font color="#%s">',currentColor);

% we build up the string one row at a time
numRows = floor(seqLen/wrap);
lineString = cell(1,numRows+1);
if isempty(stops)
    stops = seqLen;
end
if isempty(starts)
    starts = seqLen;
end

% figure out if we have change of state in a particular row
[startBuckets, startIndices] = histc(starts,[1:wrap:seqLen seqLen]);
[stopBuckets, stopIndices] = histc(stops,[1:wrap:seqLen seqLen]);
endLine = 0;
% run through the rows except the last row which may be short
for lineNum = 1:numRows
    beginLine = endLine+1;
    endLine = beginLine + wrap -1;
    theLine = seq(beginLine:endLine);

    lineStarts = starts(startIndices == lineNum);
    lineStops = stops(stopIndices == lineNum);
    lineStarts = rem(lineStarts,wrap);
    lineStops = rem(lineStops,wrap);
    % create the line of text
    [lineString{lineNum}, inWord] = htmlline(theLine, inWord, lineStarts, lineStops, colorString ,beginLine);
end
% last line is probably shorter than wrap length so we have to deal
% with it in a special way
beginLine = endLine+1;
endLine = seqLen;
if beginLine < endLine
    theLine = seq(beginLine:endLine);
    lineStarts = starts(startIndices == numRows+1);
    lineStops = stops(stopIndices == numRows+1);
    lineStarts = rem(lineStarts,wrap);
    lineStops = rem(lineStops,wrap);
    lineString{end} = htmlline(theLine, inWord, lineStarts, lineStops, colorString ,beginLine);
end
% stick all lines into wholestring
string =  [string lineString{:}];
wholestring(wholePoint:wholePoint+length(string)-1) = string;
wholePoint = wholePoint+length(string);
string = '';


string = [string '</p></body></html>'];
wholestring(wholePoint:wholePoint+length(string)-1) = string;
%wholePoint = wholePoint+length(string);
%string = '';
if ~noDisplay
   web(wholestring)
end

%--------------------------------------------------------------------------
function [newline, inWord] = htmlline(line, inWord, starts, stops, color ,linenum)
%HTMLLINE creates HTML for one row of the output.
% returns the line as a string and the current ORF state.
numChanges = length([starts stops]);

header = sprintf('<br>%06d    ',linenum);
closeFont = '</font></b>';

% simple case -- whole line is in frame or in WORD
if numChanges == 0
    if inWord
        newline = [header,color,line,closeFont];
    else
        newline = [,header,line];
    end
    return
end

% now deal with case of one transition
if any(stops == 0)
    stops(stops == 0 ) = length(line);
end
if any(starts == 0)
    starts(starts == 0 ) = length(line);
end

if numChanges == 1
    if inWord
        newline = [header,color,line(1:stops-1),closeFont,line(stops:end)];
    else
        newline = [header,line(1:starts-1),color,line(starts:end),closeFont];
    end
    inWord = ~inWord;

    return
end

% deal with complex lines by running along the line one chunk at a time
if inWord
    newline = [header,color];
    firstChange = stops(1);
else
    newline = header;
    firstChange = starts(1);
end
newline = [newline line(1:firstChange-1)];
count = firstChange;
% run through changes toggling between inWord and not inWord
while(numChanges)
    if inWord
        newline = [newline closeFont];
        stops(1) = [];
        numChanges = numChanges -1;
        inWord = false;
        if numChanges
            firstChange = starts(1);
        end
    else
        newline = [newline,color];
        starts(1) = [];
        numChanges = numChanges -1;
        inWord = true;
        if numChanges
            firstChange = stops(1);
        end
    end
    newline = [newline line(count:firstChange-1)];
    count = firstChange;
end

newline = [newline line(count:end)];

if inWord
    newline = [newline,closeFont];
end
