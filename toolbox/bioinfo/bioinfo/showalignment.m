function output = showalignment(alignment,varargin)
%SHOWALIGNMENT colored display of an alignment.
%
%   SHOWALIGNMENT(ALIGNMENT) displays an alignment string, ALIGNMENT, in
%   the Help Browser. Matches and similar residues are highlighted.
%   ALIGNMENT will usually be the output from one of the alignment
%   functions NWALIGN or SWALIGN.
%
%   SHOWALIGNMENT(...,'STARTPOINTERS',STARTAT) specifies the starting
%   indices in the original sequences of a local alignment. STARTAT is the
%   two element vector returned as the third output of the SWALIGN
%   function.
%
%   SHOWALIGNMENT(...,'MATCHCOLOR',COLOR) selects the color used to
%   highlight the matches in the output display. The default color is red.
%
%   SHOWALIGNMENT(...,'SIMILARCOLOR',COLOR) selects the color used to
%   highlight similar residues that are not exact matches.
%   The default color is magenta.
%
%   Colors can be either a 1x3 RGB vector specifying the intensity (0-255)
%   of the red, green and blue component of the color, or a character from
%   the following list:
%
%            'b'     blue
%            'g'     green
%            'r'     red
%            'c'     cyan
%            'm'     magenta
%            'y'     yellow
%
%   SHOWALIGNMENT(...,'COLUMNS',COLS) specifies how many columns per line to
%   use in the output. The default is 64.
%
%       Example:
%
%       [score, alignment] = nwalign('VSPAGMASGYD','IPGKASYD');
%       showalignment(alignment);
%
%   See also NWALIGN, SWALIGN.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.16.6.6 $  $Date: 2004/01/24 09:19:08 $

% work in upper case
alignment = upper(alignment);

% we expect alignment to be three rows, seq1 , pipes to show exact matches
% and seq2.

numRows = size(alignment,1);
alignmentLen = size(alignment,2);
% if only two rows we'll create the alignment pipes

if numRows < 2 || numRows > 3
    error('Bioinfo:BadAlignmentFormat','Alignment is not in the right format.')
end

if numRows == 2
    matches = (alignment(1,:) == alignment(2,:));
    matchString = blanks(alignmentLen);
    matchString(matches) = '|';
    alignment = [alignment(1,:);matchString;alignment(2,:);];
    totalSimilar = 0;
else % if we have three rows then check that the matches are correct
    matches = ( alignment(1,:) == alignment(3,:));
    if ~all((alignment(2,:) == '|') == matches)
        warning('Bioinfo:InconsistentAlignment','Alignment appears to be inconsistent.');
    end
    similar = (alignment(2,:) == ':');
    totalSimilar = sum(similar);
end
totalMatches = sum(matches);


% now deal with any options
wrap = 64;

fontname = 'monospaced';

color =  'ff0000';
simcolor = 'ff00ff';
startat = [1;1];

noDisplay = false;  % use this for testing

if nargin > 1
    if rem(nargin,2) == 0
        error('Bioinfo:IncorrectNumberOfArguments',...
            'Incorrect number of arguments to %s.',mfilename);
    end
    okargs = {'matchcolor','columns','nodisplay',...
                    'similarcolor','startpointers'};
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

                case 1 %match color
                    color = setcolorpref(pval);
                case 2% wrap
                    wrap = pval;

                case 3% noDisplay
                    noDisplay = pval;
                case 4 %similar color
                    simcolor = setcolorpref(pval);
                case 5 %startat
                    startat = pval(:);
                    if ~isnumeric(startat) || numel(startat) > 2
                       error('Bioinfo:BadStartPointers',...
                         'Starting pointers should be a two element numeric array.'); 
                    elseif numel(startat) == 1
                        startat = [startat;startat];
                    end
            end
        end
    end
end

% use a @ to mask the space in font color
colorString  = repmat(sprintf('<font@color="#%s">',color),3,1); %'</font>' ?
simcolorString = repmat(sprintf('<font@color="#%s">',simcolor),3,1);
closeString = repmat('</font>',3,1);
colLen = length(colorString);
simcolLen = length(simcolorString);
closeLen = length(closeString);

% figure out how many times we have to wrap

numWraps = floor((alignmentLen-1)/wrap);

% pad alignment to be a full multiple of wraps
alignment = [alignment repmat(' ',3,wrap - rem(alignmentLen,wrap))];

subString = cell(numWraps+1,1);

% use the tag to indicate where to add the line counts
if numWraps == 0 && isequal(startat,[1;1])
    tag = [];
else
    tag = ('+^$')';
end
% format for the line counts
format = sprintf('%%%dd  ',ceil(log10(alignmentLen+max(startat))));
numWrapSpaces = length(sprintf(format,1));
topLetters = startat(1);
bottomLetters = startat(2);
% now work on the strings
for theRow = 0:numWraps

    % Work in chunks
    chunk = alignment(:,(theRow*wrap)+1:((theRow+1)*(wrap)));
    newtopLetters = sum(chunk(1,:)~='-');
    newbottomLetters = sum(chunk(3,:)~='-');
    matches = (chunk(2,:) == '|');
    similar = (chunk(2,:) == ':');
    numMatches = sum(matches);
    spaceNeeded = wrap + (numMatches *  (colLen + closeLen -1));
    newRows = repmat(blanks(spaceNeeded),3,1);
    % add in the color string to all rows
    pos = 1;
    for count = 1:wrap
        if(matches(count))
            newRows(:,pos:pos+colLen+closeLen) = [colorString chunk(:,count) closeString];
            pos = pos+colLen+closeLen+1;
        elseif similar(count)
            newRows(:,pos:pos+simcolLen+closeLen) = [simcolorString chunk(:,count) closeString];
            pos = pos+colLen+closeLen+1;
        else
            newRows(:,pos) = chunk(:,count);
            pos = pos + 1;
        end
    end

    % clean up any extra space
    newRows = deblank(newRows);

    % add line breaks and then turn into a single row
    chunk =  [tag,newRows, repmat('<br>',size(newRows,1),1)] ;
    chunk = reshape(chunk',1,numel(chunk));

    %now put in the count on the appropriate line
    chunk = strrep(chunk,'+',sprintf(format,topLetters));
    chunk = strrep(chunk,'$',sprintf(format,bottomLetters));
    topLetters = topLetters + newtopLetters;
    bottomLetters = bottomLetters + newbottomLetters;
    chunk = strrep(chunk,'^',repmat(' ',1,numWrapSpaces));
    % turn this in to real HTML
    chunk = strrep(chunk,' ','&nbsp;');
    % clean up the font@color
    chunk = strrep(chunk,'@',' ');

    subString{theRow+1} = [chunk '<br>'];
end


% create a string saying what percentage of matches there are.
% calculate percentage of matches
percentMatch = 100*totalMatches/alignmentLen;
if totalSimilar > 0
    totalSimilar = totalMatches + totalSimilar;
    matchString = sprintf('Identities = %d/%d (%2.f%%), Positives = %d/%d (%2.f%%)<br>',...
        totalMatches,alignmentLen,percentMatch,totalSimilar,alignmentLen,100*totalSimilar/alignmentLen);
else
    matchString = sprintf('Identities = %d/%d (%2.f%%)<br>',numMatches,alignmentLen,percentMatch);
end
newalignment = sprintf('text://<html><title>Aligned Sequences</title><body><font face="%s">%s%s</body></html>',...
    fontname,matchString,strcat(subString{:}));

if ~noDisplay
    web(newalignment)
end
if nargout > 0
    output = newalignment;
end

