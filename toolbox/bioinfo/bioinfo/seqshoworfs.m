function [orfOutput, wholestring] = seqshoworfs(seq,varargin)
%SEQSHOWORFS highlights the open reading frames (ORFs) in a sequence.
%
%   SEQSHOWORFS(SEQ) displays the sequence SEQ in the Help Browser, with
%   all ORFs highlighted. SEQSHOWORFS returns a structure of the start and
%   stop positions of the ORFs in each reading frame. The Standard genetic
%   code is used with start codon 'AUG' and stop codons 'UAA','UAG','UGA'.
%
%   SEQSHOWORFS(...,'FRAMES',READINGFRAMES) specifies the reading frames to
%   display. READINGFRAMES can be any of 1,2,3,-1,-2,-3. Frames -1, -2, and
%   -3 correspond to the first, second, and third reading frames of the
%   reverse complement of SEQ. To display multiple frames at once,
%   use a vector of the frames to be displayed, or use 'all' to show all
%   frames at once. The default is [1 2 3].
%
%   SEQSHOWORFS(...,'GENETICCODE',CODE) specifies the genetic code to be
%   used for finding open reading frames. Code can be either an ID or text
%   string. See help for geneticcode for the full list of supported IDs and
%   names.
%
%   SEQSHOWORFS(...,'MINIMUMLENGTH',L) sets the minimum number of codons
%   for an ORF to be considered valid. The default is 10.
%
%   SEQSHOWORFS(...,'ALTERNATIVESTARTCODONS',true) uses alternative start
%   codons. For example in the Human Mitochondrial Genetic Code, AUA and
%   AUU are known to be alternative start codons.
%
%   See http://www.ncbi.nlm.nih.gov/Taxonomy/Utils/wprintgc.cgi?mode=t#SG1
%   for more details of alternative start codons.
%
%   SEQSHOWORFS(...,'COLOR',COLOR) selects the color used to highlight the
%   open reading frames in the output display. The default color scheme is
%   blue for the first reading frame, red for the second, and green for the
%   third frame. COLOR can be either a 1x3 RGB vector specifying the
%   intensity (0-255) of the red, green, and blue components of the color, or
%   a character from the following list:
%
%            'b'     Blue
%            'g'     Green
%            'r'     Red
%            'c'     Cyan
%            'm'     Magenta
%            'y'     Yellow
%
%   To specify different colors for the three reading frames, use a 1x3
%   cell array of color values. If you are displaying reverse complement
%   reading frames, then COLOR should be a 1x6 cell array of color values.
%
%   SEQSHOWORFS(...,'COLUMNS',COLS) specifies how many columns per line to
%   use in the output. The default is 64.
%
%   Example:
%
%       HLA_DQB1 = getgenbank('NM_002123');
%       seqshoworfs(HLA_DQB1.Sequence);
%
%   See also CODONCOUNT, GENETICCODE, REGEXP, SEQDISP, SEQSHOWWORDS,
%   SEQWORDCOUNT.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.14.6.8 $  $Date: 2004/03/14 15:31:42 $

% set up some defaults
wrap = 64;
dispFrames = [1 2 3 -1 -2 -3];
theFrames = 1:3;
revComp = false;
startCodons = 'A[TU]G|C[TU]G|[TU][TU]G';
stopCodons = '[TU]A[AG]|[TU]GA';
minLength = 10;

%fontname = 'monospaced';

colors = {'0000FF','FF0000','00BB00','0000FF','FF0000','00BB00'};
alternativestartcodons = false;
noDisplay = false;

% If the input is a structure then extract the Sequence data.
if isstruct(seq)
    try
        seq = seqfromstruct(seq);
    catch
        rethrow(lasterror);
    end
end

% deal with the various inputs
if nargin > 1
    if rem(nargin,2) == 0
        error('Bioinfo:IncorrectNumberOfArguments',...
            'Incorrect number of arguments to %s.',mfilename);
    end
    okargs = {'color','columns','geneticcode','alternativestartcodons','frames','nodisplay','minimumlength'};
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
                case 1 %color
                    if ~iscell(pval)
                        pval = {pval,pval,pval,pval,pval,pval};
                    end
                    for count = 1:length(pval)
                        val = pval{count};
                        if isnumeric(val)
                            colors{count} = sprintf('%02x%02x%02x',val(1), val(2),val(3));
                        elseif ischar(val)
                            switch val(1)
                                case 'r'
                                    colors{count} = 'FF0000';
                                case 'g'
                                    colors{count} = '00CC00';
                                case 'b'
                                    colors{count} = '0000FF';
                                case 'm'
                                    colors{count} = 'FF00FF';
                                case 'c'
                                    colors{count} = '00FFFF';
                                case 'y'
                                    colors{count} = 'CCCC00';
                            end
                        else
                            error('Bioinfo:BadColor','Color parameter is not valid.');
                        end
                    end
                case 2% wrap
                    wrap = pval;
                case 3 % genetic code
                    try
                        gc = geneticcode(pval);
                    catch
                        if isnumeric(pval)
                            error('Bioinfo:BadGeneticCodeID','%s is not a valid Genetic Code ID',num2str(pval))
                        else
                            error('Bioinfo:BadGeneticCode','%s is not a valid Genetic Code',pval)
                        end
                    end
                    startCodons = gc.Starts{1};
                    for startcount = 2:length(gc.Starts)
                        startCodons = [startCodons '|' gc.Starts{startcount}];
                    end
                    startCodons = strrep(startCodons,'T','[TU]');

                    stopCodons = '';
                    map = 'ACGT';
                    for outer = 1:4
                        for mid = 1:4
                            for inner = 1:4
                                if strcmp(gc.([map(outer) map(mid) map(inner)]),'*')
                                    stopCodons = [stopCodons map(outer) map(mid) map(inner) '|'];
                                end
                            end
                        end
                    end
                    if stopCodons(end) == '|'
                        stopCodons(end) = '';
                    end
                    stopCodons = strrep(stopCodons,'T','[TU]');
                case 4 % use alternative start codons
                    alternativestartcodons = opttf(pval);
                    if isempty(alternativestartcodons)
                        error('Bioinfo:InputOptionNotLogical','%s must be a logical value, true or false.',...
                            upper(char(okargs(k))));
                    end
                case 5  %frames
                    if isnumeric(pval)
                        theFrames = double(pval);
                        % dispFrames = theFrames;
                        if ~all(ismember(theFrames,[1,2,3,-1,-2,-3]))
                            error('Bioinfo:InvalidReadingFrame','Invalid reading frame specified. Valid frame numbers are 1,2,3,-1,-2,-3.');
                        end
                    elseif ischar(pval)
                        if strcmpi(pval,'all')
                            theFrames = [1 2 3 -1 -2 -3];
                            %      dispFrames = theFrames;
                        else
                            error('Bioinfo:InvalidReadingFrame','Invalid reading frame specified. Valid frame numbers are 1,2,3,-1,-2,-3.');
                        end
                    end
                    if any(theFrames < 0) % need rcomplement
                        revComp = true;
                        theFrames(theFrames<0) = 3-theFrames(theFrames<0);
                    end
                case 6 % nodisplay -- use this for testing with second output
                    noDisplay = opttf(pval);
                    if isempty(noDisplay)
                        error('Bioinfo:InputOptionNotLogical','%s must be a logical value, true or false.',...
                            upper(char(okargs(k))));
                    end
                case 7 % minimum length
                    if isnumeric(pval) && pval > 0
                        minLength = pval;
                    else
                        error('Bioinfo:MinimumLengthNotPositiveInt',...
                            'MinimumLength must be a postive number.');
                    end
            end
        end
    end
end

seqLen = length(seq);

if seqLen * length(theFrames) > 1000000  % large display will mess up the help browser's memory
    error('Bioinfo:ShowORFSLimit','SEQSHOWORFS can only display at most 1000000 symbols. Please use a shorter sub-sequence or fewer reading frames.')
end

% set up output
orfOutput.Start = [];
orfOutput.Stop = [];
orfOutput = repmat(orfOutput,1,max(theFrames));

% set default startCodons
if alternativestartcodons == false
    startCodons = 'A[TU]G';
end

% if we need to do reverse complement then make a copy

if revComp
    rseq = seqrcomplement(seq);
    rstarts = regexpi(rseq,startCodons);
    rstops = regexpi(rseq,stopCodons);
    fstarts = regexpi(seq,startCodons);
    fstops = regexpi(seq,stopCodons);
    fseq = seq;
else
    starts = regexpi(seq,startCodons);
    stops = regexpi(seq,stopCodons);
    clear fseq;
end

wholestring = repmat(' ',1,(length(theFrames)*seqLen*2));
wholePoint = 1;
string = 'text://<html><title>Open reading frames</title><body><pre>';

for frame = theFrames
    if revComp  % need to deal with switching between two directions
        if frame < 4
            starts = fstarts;
            stops = fstops;
            seq = fseq;
        else
            starts = rstarts;
            stops = rstops;
            seq = rseq;
        end
    end

    % We now have to deal with figuring out which starts and stops are in
    % this frame.
    framestarts = [starts(rem(starts,3)==rem(frame,3)) inf];
    framestops = [stops(rem(stops,3)==rem(frame,3))  inf];
    framestartcodons = starts(rem(starts,3)==rem(frame,3));
    framestopcodons = stops(rem(stops,3)==rem(frame,3));


    % and we only care about stops after a start and starts after a stop
    % so we need to throw away any stops not in ORF and any starts inside
    % an already open reading frame.
    stopsAndStart = union(framestartcodons,framestopcodons);
    [dummy StartIndices ] = ismember(framestartcodons,stopsAndStart);
    [dummy StopIndices ] = ismember(framestopcodons,stopsAndStart);
    StartDiffs = diff([-1 StartIndices]);
    StopDiffs = diff([0 StopIndices]);

    frameStart = framestartcodons(StartDiffs ~= 1);
    frameStop = framestopcodons(StopDiffs ~= 1);

    % look for small ORFs and remove them
    if ~isempty(frameStop)
        smallORFs = find((frameStop-frameStart(1:numel(frameStop)))< minLength*3);
        frameStart(smallORFs) = [];
        frameStop(smallORFs) = [];
    end
    % clean up empty results
    if isempty(frameStart)
        frameStart = [];
    end
    if isempty(frameStop)
        frameStop = [];
    end
    % save the output
    orfOutput(frame).Start = frameStart;
    orfOutput(frame).Stop = frameStop;

    % add on an extra holding place just to make sure that frameStop is as
    % long as frameStart.
    frameStop(end+1) = seqLen+1;

    % create the HTML string

    openFrame = false;
    string = [string sprintf('<p>Frame %d</p><br>',dispFrames(frame))];

    % wholestring is a big allocated chunk of space
    wholestring(wholePoint:wholePoint+length(string)-1) = string;
    wholePoint = wholePoint+length(string);
    string = '';

    currentColor = colors{frame};
    colorString  = sprintf('<b><font color="#%s">',currentColor);

    % we build up the string one row at a time
    numRows = floor(seqLen/wrap);
    lineString = cell(1,numRows+1);
    if isempty(frameStop)
        frameStop = seqLen;
    end
    if isempty(frameStart)
        frameStart = seqLen;
    end

    % figure out if we have change of state in a particular row
    [startBuckets startIndices] = histc(frameStart,[1:wrap:seqLen seqLen]);
    [stopBuckets stopIndices] = histc(frameStop,[1:wrap:seqLen seqLen]);
    endLine = 0;

    % run through the rows except the last row which may be short
    for lineNum = 1:numRows
        beginLine = endLine+1;
        endLine = beginLine + wrap -1;
        theLine = seq(beginLine:endLine);

        lineStarts = frameStart(startIndices == lineNum);
        lineStops = frameStop(stopIndices == lineNum);
        lineStarts = rem(lineStarts,wrap);
        lineStops = rem(lineStops,wrap);
        % create the line of text
        if frame > 3
            dispLineNum = seqLen -beginLine +1;
        else
            dispLineNum = beginLine;
        end
        [lineString{lineNum}, openFrame] = htmlline(theLine, openFrame, lineStarts, lineStops, colorString ,dispLineNum);
    end

    % last line is probably shorter than wrap length so we have to deal
    % with it in a special way
    beginLine = endLine+1;
    endLine = seqLen;
    if beginLine < endLine
        theLine = seq(beginLine:endLine);
        lineStarts = frameStart(startIndices == numRows+1);
        lineStops = frameStop(stopIndices == numRows+1);
        lineStarts = rem(lineStarts,wrap);
        lineStops = rem(lineStops,wrap);
        if frame > 3
            dispLineNum = seqLen -beginLine +1;
        else
            dispLineNum = beginLine;
        end
        % [lineString{end}, openFrame] = htmlline(theLine, openFrame, lineStarts, lineStops, colorString ,dispLineNum);
        lineString{end} = htmlline(theLine, openFrame, lineStarts, lineStops, colorString ,dispLineNum);
    end

    % stick all lines into wholestring
    string =  [string lineString{:}];
    wholestring(wholePoint:wholePoint+length(string)-1) = string;
    wholePoint = wholePoint+length(string);
    string = '';

    string = [string '</p><br><br>'];
    wholestring(wholePoint:wholePoint+length(string)-1) = string;
    wholePoint = wholePoint+length(string);
    string = '';
end

string = [string '</p></pre></body></html>'];
wholestring(wholePoint:wholePoint+length(string)-1) = string;
wholePoint = wholePoint+length(string);
wholestring(wholePoint:end) = '';

if ~noDisplay
    web(wholestring)
end

%--------------------------------------------------------------------------
function [newline, inORF] = htmlline(line, inORF, starts, stops, color ,linenum)
%HTMLLINE creates HTML for one row of the output.
% returns the line as a string and the current ORF state.
numChanges = length([starts stops]);

header = sprintf('<br>%06d    ',linenum);
closeFont = '</font></b>';

% simple case -- whole line is in frame or in ORF
if numChanges == 0
    if inORF
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
    if inORF
        newline = [header,color,line(1:stops-1),closeFont,line(stops:end)];
    else
        newline = [header,line(1:starts-1),color,line(starts:end),closeFont];
    end
    inORF = ~inORF;

    return
end

% deal with complex lines by running along the line one chunk at a time
if inORF
    newline = [header,color];
    firstChange = stops(1);
else
    newline = header;
    firstChange = starts(1);
end
newline = [newline line(1:firstChange-1)];
count = firstChange;
% run through changes toggling between ORF and not ORF
while(numChanges)
    if inORF
        newline = [newline closeFont];
        stops(1) = [];
        numChanges = numChanges -1;
        inORF = false;
        if numChanges
            firstChange = starts(1);
        end
    else
        newline = [newline,color];
        starts(1) = [];
        numChanges = numChanges -1;
        inORF = true;
        if numChanges
            firstChange = stops(1);
        end
    end
    newline = [newline line(count:firstChange-1)];
    count = firstChange;
end

newline = [newline line(count:end)];

if inORF
    newline = [newline,closeFont];
end

