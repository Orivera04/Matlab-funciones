function [score, alignment, startat] = nwalign(seq1,seq2,varargin)
%NWALIGN performs Needleman-Wunsch global alignment of two sequences.
%
%   NWALIGN(SEQ1, SEQ2) returns the score (in bits) for the optimal
%   alignment. Note: The scale factor used to calculate the score is
%   provided by the scoring matrix info (see below). If this is not
%   defined, then NWALIGN returns the raw score.
%
%   [SCORE, ALIGNMENT] = NWALIGN(SEQ1, SEQ2) returns a string showing an
%   optimal global alignment of amino acid (or nucleotide) sequences SEQ1
%   and SEQ2.
%
%   [SCORE, ALIGNMENT, STARTAT] = NWALIGN(SEQ1, SEQ2)  returns a 2x1 vector
%   with the starting point indices indicating the starting point of the
%   alignment in the two sequences. Note: this output is for consistency
%   with SWALIGN and will always be [1;1] because this is a global
%   alignment.
%
%   NWALIGN(..., 'ALPHABET', A) specifies whether the sequences are
%   amino acids ('AA') or nucleotides ('NT'). The default is AA.
%
%   NWALIGN(..., 'SCORINGMATRIX', matrix) defines the scoring matrix to be
%   used for the alignment. The default is BLOSUM50 for AA or NUC44 for NT.
%
%   NWALIGN(..., 'SCALE' ,scale) indicates the scale factor of the scoring
%   matrix to return the score using arbitrary units. If the scoring matrix
%   Info also provides a scale factor, then both are used.
%
%   NWALIGN(..., 'GAPOPEN', penalty) defines the penalty for opening a gap
%   in the alignment. The default gap open penalty is 8.
%
%   NWALIGN(..., 'EXTENDGAP', penalty) defines the penalty for extending a
%   gap in the alignment. If EXTENDGAP is not specified, then extensions to
%   gaps are scored with the same value as GAPOPEN.
%
%   NWALIGN(..., 'SHOWSCORE', true) displays the scoring space and the
%   winning path.
%
%
%   Examples:
%
%       % Return the score in bits and the global alignment using the
%       % default scoring matrix (BLOSUM50).
%       [score, align] = nwalign('VSPAGMASGYD', 'IPGKASYD')
%
%       % Use user-specified scoring matrix and "gap open" penalty.
%       [score, align] = nwalign('IGRHRYHIGG', 'SRYIGRG',...
%                               'scoringmatrix', 'pam250', 'gapopen',5)
%
%       % Return the score in nat units (nats).
%       [align, score] = nwalign('HEAGAWGHEE', 'PAWHEAE', 'scale', log(2))
%
%       % Display the scoring space and the winning path.
%       nwalign('VSPAGMASGYD', 'IPGKASYD', 'showscore', true) 
%
%   See also BLOSUM, NT2AA, PAM, SEQDOTPLOT, SHOWALIGNMENT, SWALIGN.

%   References:
%   R. Durbin, S. Eddy, A. Krogh, and G. Mitchison. Biological Sequence
%   Analysis. Cambridge UP, 1998.
%   Needleman, S. B., Wunsch, C. D., J. Mol. Biol. (1970) 48:443-453


%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.22.6.7 $  $Date: 2004/01/24 09:17:48 $


gapopen = -8;
gapextend = -8;
setGapExtend = false;
showscore=false;
isAminoAcid = true;
scale=1;

% If the input is a structure then extract the Sequence data.
if isstruct(seq1)
    try
        seq1 = seqfromstruct(seq1);
    catch
        rethrow(lasterror);
    end
end
if isstruct(seq2)
    try
        seq2 = seqfromstruct(seq2);
    catch
        rethrow(lasterror);
    end
end
if nargin > 2
    if rem(nargin,2) == 1
        error('Bioinfo:IncorrectNumberOfArguments',...
            'Incorrect number of arguments to %s.',mfilename);
    end
    okargs = {'scoringmatrix','gapopen','extendgap','alphabet','scale','showscore'};
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
                case 1  % scoring matrix
                    if isnumeric(pval)
                        ScoringMatrix = pval;
                    else
                        if ischar(pval)
                            pval = lower(pval);
                        end
                        try
                            [ScoringMatrix,ScoringMatrixInfo] = feval(pval);
                        catch
                            error('Bioinfo:InvalidScoringMatrix','Invalid scoring matrix.');
                        end
                    end
                case 2 %gap open penalty
                    gapopen = -pval;
                case 3 %gap extend penalty
                    gapextend = -pval;
                    setGapExtend = true;
                case 4 %if sequence is nucleotide
                    if strcmpi(pval,'nt')
                        isAminoAcid = false;
                    end
                case 5 % scale
                    scale=pval;
                case 6 % showscore
                    showscore = pval == true;
            end
        end
    end
end

% setting the default scoring matrix
if ~exist('ScoringMatrix','var')
    if isAminoAcid
        [ScoringMatrix,ScoringMatrixInfo] = blosum50;
    else
        [ScoringMatrix,ScoringMatrixInfo] = nuc44;
    end
end


% getting the scale from ScoringMatrixInfo, if it exists
if exist('ScoringMatrixInfo') && isfield(ScoringMatrixInfo,'Scale')
    scale=scale*ScoringMatrixInfo.Scale;
end

% handle properly "?" characters typically found in pdb files
if isAminoAcid
    if ischar(seq1)
        seq1 = strrep(seq1,'?','X');
    else
        seq1(seq1 == 26) = 23;
    end
    if ischar(seq2)
        seq2 = strrep(seq2,'?','X');
    else
        seq2(seq2 == 26) = 23;
    end
end

% check input sequences
if (isAminoAcid && ~(isaa(seq1) && isaa(seq2))) || (~isAminoAcid && ~(isnt(seq1) && isnt(seq2)))
    error('Bioinfo:InvalidInputSequences','Both sequences must be either amino acids or nucleotides');
end

% use numerical arrays for easy indexing
if ischar(seq1)
    seq1=upper(seq1); %the output alignment will be all uppercase
    if isAminoAcid
        intseq1 = aa2int(seq1);
    else
        intseq1 = nt2int(seq1);
    end
else
    intseq1=seq1;
    if isAminoAcid
        seq1 = int2aa(intseq1);
    else
        seq1 = int2nt(intseq1);
    end
end
if ischar(seq2)
    seq2=upper(seq2); %the output alignment will be all uppercase
    if isAminoAcid
        intseq2 = aa2int(seq2);
    else
        intseq2 = nt2int(seq2);
    end
else
    intseq2=seq2;
    if isAminoAcid
        seq2 = int2aa(intseq2);
    else
        seq2 = int2nt(intseq2);
    end
end


m = length(seq1);
n = length(seq2);
if ~n||~m
    error('Bioinfo:InvalidLengthSequences','Length of input sequences must be greater than 0');
end

% If unknown, ambiguous or gaps appear in the sequence, we need to make
% sure that ScoringMatrix can handle them.

% possible values are
% B  Z  X  *  -  ?
% 21 22 23 24 25 26

scoringMatrixSize = size(ScoringMatrix,1);

highestVal = max([intseq1, intseq2]);
if highestVal > scoringMatrixSize
    % if the matrix contains the 'Any' we map to that
    if isAminoAcid
        anyVal = aa2int('X');
    else
        anyVal = nt2int('N');
    end
    if scoringMatrixSize >= anyVal
        intseq1(intseq1>scoringMatrixSize) = anyVal;
        intseq2(intseq2>scoringMatrixSize) = anyVal;
    else
        error('Bioinfo:InvalidSymbolsInInputSequeces',...
            'Sequences contain symbols that cannot be handled by the given scoring matrix.');
    end
end

if setGapExtend  % call more complicated algorithm if we have
    [F, pointer] = affinegap(intseq1,m,intseq2,n,ScoringMatrix,gapopen,gapextend);
else
    [F, pointer] = simplegap(intseq1,m,intseq2,n,ScoringMatrix,gapopen);
end

% trace back through the pointer matrix
halfn=ceil((n+1)/2);
halfm=ceil((m+1)/2);

i = n+1; j = m+1;
path = repmat([j,i],m+n,1);
step = 1;

score =  max(F(n+1,m+1,:));

if setGapExtend

    if F(n+1,m+1,3)==score      % favor with left-gap
        laststate=3;
    elseif F(n+1,m+1,2)==score  % then with up-gap
        laststate=2;
    else                        % at last with match
        laststate=1;
    end

    while (i>halfn || j>halfm) % in the rigth half favor gaps when several
        % paths lead to the highest score
        state=laststate;
        if bitget(pointer(i,j,state),3)
            laststate=3;
        elseif bitget(pointer(i,j,state),2)
            laststate=2;
        else
            laststate=1;
        end

        switch state
            case 1 % is diagonal
                j = j - 1;
                i = i - 1;
            case 2 % is up
                i = i - 1;
            case 3 % is left
                j = j - 1;
        end
        step = step +1;
        path(step,:) = [j,i];
    end

    while (i>1 || j>1)          % in the rigth half favor matchs when several
        % paths lead to the highest score
        state=laststate;
        if bitget(pointer(i,j,state),1)
            laststate=1;
        elseif bitget(pointer(i,j,state),2)
            laststate=2;
        else
            laststate=3;
        end

        switch state
            case 1 % is diagonal
                j = j - 1;
                i = i - 1;
            case 2 % is up
                i = i - 1;
            case 3 % is left
                j = j - 1;
        end
        step = step +1;
        path(step,:) = [j,i];
    end

else % ~setGapExtend

    while (i > 1 || j > 1)

        switch pointer(i,j)
            case 1 % diagonal only
                j = j - 1;
                i = i - 1;
            case 2 % up only
                i = i - 1;
            case 4 % left only
                j = j - 1;
            case 6 % up or left --> up (favors gaps in seq2)
                j = j - 1;
            otherwise %3 diagonal or up         --> diagonal (favors no gaps)
                %4 diagonal or left       --> diagonal (favors no gaps)
                %7 diagonal or left or up --> diagonal (favors no gaps)
                j = j - 1;
                i = i - 1;
        end
        step = step +1;
        path(step,:) = [j,i];
    end

end % if setGapExtend

% re-scaling the output score
score = scale * score;

path(step+1:end,:) = [];

% create the alignment string
mask = [1,1;-diff(path)];
seq1 = ['-',seq1];
seq2 = ['-',seq2];
path = flipud(path);
mask = flipud(mask);
alignment1 = seq1(path(2:end,1));
alignment2 = seq2(path(2:end,2));
alignment = [alignment1;alignment2];
alignment(~mask') = '-';

startat = path(1,:)';

% find locations where there are no gaps
h=find(all(mask(1:end-1,:)'));
if isAminoAcid
    noGaps1=aa2int(alignment(1,h));
    noGaps2=aa2int(alignment(2,h));
else
    noGaps1=nt2int(alignment(1,h));
    noGaps2=nt2int(alignment(2,h));
end

% erasing symbols that can not be scored
htodel=max([noGaps1;noGaps2])>scoringMatrixSize;
h(htodel)=[];
noGaps1(htodel)=[];
noGaps2(htodel)=[];
% score no-gap pairs
value=zeros(length(noGaps1),1);
for i=1:length(noGaps1);
    value(i)=ScoringMatrix(noGaps1(i),noGaps2(i));
end

% create and set the match string
matchString = blanks(size(alignment,2));
matchString(h(value>=0))=':';
if isAminoAcid
    matchString((alignment(1,:)==alignment(2,:)) & (aa2int(alignment(1,:))<=scoringMatrixSize))='|';
else
    matchString((alignment(1,:)==alignment(2,:)) & (nt2int(alignment(1,:))<=scoringMatrixSize))='|';
end
alignment = [alignment(1,:);matchString;alignment(2,:);];

if showscore
    figure
    F=scale.*max(F(2:end,2:end,:),[],3);
    clim=max(max(max(abs(F(~isinf(F))))),eps);
    imagesc(F,[-clim clim]);
    colormap(privateColorMap(1));
    set(colorbar,'YLim',[min([F(:);-eps]) max([F(:);eps])])
    title('Score for best path')
    xlabel('Sequence 1')
    ylabel('Sequence 2')
    hold on
    plot(path(:,1),path(:,2),'k.')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [F, pointer] = simplegap(intseq1,m,intseq2,n,ScoringMatrix,gap)
% Standard Needleman-Wunsch algorithm

% set up storage for dynamic programming matrix
F = zeros(n+1,m+1);
F(2:end,1) = gap * (1:n)';
F(1,2:end) = gap * (1:m);

% and for the back tracing matrix
pointer= repmat(uint8(4),n+1,m+1);
pointer(:,1) = 2;  % up
pointer(1,1) = 1;  


% initialize buffers to the first column
ptr = pointer(:,2); % ptr(1) is always 4
currentFColumn = F(:,1);

% main loop runs through the matrix looking for maximal scores
for outer = 2:m+1

    % score current column
    scoredMatchColumn = ScoringMatrix(intseq2,intseq1(outer-1));
    % grab the data from the matrices and initialize some values
    lastFColumn    = currentFColumn;
    currentFColumn = F(:,outer);
    best = currentFColumn(1);
    
    for inner = 2:n+1
        % score the three options
        up       = best + gap;
        left     = lastFColumn(inner) + gap;
        diagonal = lastFColumn(inner-1) + scoredMatchColumn(inner-1);

        % max could be used here but it is quicker to use if statements
        if up > left
            best = up;
            pos = 2;
        else
            best = left;
            pos = 4;
        end

        if diagonal >= best
            best = diagonal;
            ptr(inner) = 1;
        else
            ptr(inner) = pos;
        end
        currentFColumn(inner) = best;

    end % inner
    % put back updated columns
    F(:,outer)   = currentFColumn;
    % save columns of pointers
    pointer(:,outer)  = ptr;
end % outer
    



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [F,pointer] = affinegap(intseq1,m,intseq2,n,ScoringMatrix,gapopen,gapextend)
% Needleman-Wunsch algorithm modified to handle affine gaps

% Set states
inAlign =   1;
inGapUp =   2;
inGapLeft = 3;
numStates = 3;

% Set up storage for dynamic programming matrix:
% for keeping the maximum scores for every state

F =  zeros(n+1,m+1,numStates);
F(:,1,:) = -inf;
F(1,:,:) = -inf;
F(1,1,inAlign) = 0;

F(2:end,1,inGapUp)   = gapopen + gapextend * (0:n-1)';
F(1,2:end,inGapLeft) = gapopen + gapextend * (0:m-1);

% and for the back tracing pointers
pointer(n+1,m+1,numStates) = uint8(0);
pointer(2:end,1,inGapUp)   = 2;  % up
pointer(1,2:end,inGapLeft) = 4;  % left

% initialize buffers to the first column
ptrA = pointer(:,1,inAlign);
ptrU = pointer(:,1,inGapLeft);
ptrL = pointer(:,1,inGapUp);

currentFColumnA = F(:,1,inAlign);
currentFColumnU = F(:,1,inGapUp);
currentFColumnL = F(:,1,inGapLeft);

% main loop runs through the matrix looking for maximal scores
for outer = 2:m+1
    % score current column
    scoredMatchColumn = ScoringMatrix(intseq2,intseq1(outer-1));
    % grab the data from the matrices and initialize some values for the
    % first row the most orderly possible
    lastFColumnA    = currentFColumnA;
    currentFColumnA = F(:,outer,inAlign);
    bestA           = currentFColumnA(1);
    currentinA      = lastFColumnA(1);
    
    lastFColumnU    = currentFColumnU;
    currentFColumnU = F(:,outer,inGapUp);
    bestU           = currentFColumnU(1);
    
    lastFColumnL    = currentFColumnL;
    currentFColumnL = F(:,outer,inGapLeft);
    currentinGL     = lastFColumnL(1);
    
    for inner = 2:n+1
        
        % grab the data from the columns the most orderly possible
        upOpen      = bestA + gapopen; 
        inA         = currentinA;
        currentinA  = lastFColumnA(inner);
        leftOpen    = currentinA + gapopen;
        
        inGL        = currentinGL;
        currentinGL = lastFColumnL(inner);
        leftExtend  = currentinGL + gapextend;
        
        upExtend = bestU + gapextend;
        inGU     = lastFColumnU(inner-1);
        
         % operate state 'inGapUp'
            
        if upOpen > upExtend
            bestU = upOpen; ptr = 1;   % diagonal
        elseif upOpen < upExtend
            bestU = upExtend; ptr = 2; % up
        else % upOpen == upExtend
            bestU = upOpen; ptr = 3;   % diagonal and up
        end
        currentFColumnU(inner)=bestU;
        ptrU(inner)=ptr;

        % operate state 'inGapLeft'
        
        if leftOpen > leftExtend
            bestL = leftOpen; ptr = 1;   % diagonal
        elseif leftOpen < leftExtend
            bestL = leftExtend; ptr = 4; % left
        else % leftOpen == leftExtend
            bestL = leftOpen; ptr = 5;   % diagonal and left
        end
        currentFColumnL(inner) = bestL;
        ptrL(inner) = ptr;

        % operate state 'inAlign'
                
        if  inA > inGU
            if inA > inGL
                bestA = inA; ptr = 1;  % diagonal
            elseif inGL > inA
                bestA = inGL; ptr = 4; % left
            else
                bestA = inA; ptr = 5;  % diagonal and left
            end
        elseif inGU > inA
            if inGU > inGL
                bestA = inGU; ptr = 2; % up
            elseif inGL > inGU
                bestA = inGL; ptr = 4; % left
            else
                bestA = inGU; ptr = 6; % up & left
            end
        else
            if inA > inGL
                bestA = inA; ptr = 3;  % diagonal & up
            elseif inGL > inA
                bestA = inGL; ptr = 4; % left
            else
                bestA = inA; ptr = 7;  % all
            end
        end

        bestA = bestA + scoredMatchColumn(inner-1);
        currentFColumnA(inner) = bestA;
        ptrA(inner) = ptr;
                
    end %inner
    
    % put back updated columns
    F(:,outer,inGapLeft) = currentFColumnL;
    F(:,outer,inGapUp)   = currentFColumnU;
    F(:,outer,inAlign)   = currentFColumnA;
    % save columns of pointers
    pointer(:,outer,inAlign)  = ptrA;
    pointer(:,outer,inGapUp)  = ptrU;
    pointer(:,outer,inGapLeft)= ptrL;
end %outer


function pcmap = privateColorMap(selection)
%PRIVATECOLORMAP returns a custom color map
switch selection
    case 1, pts = [0 0 .3 20;
            0 .1 .8 25;
            0 .9 .5 15;
            .9 1 .9 8;
            1 1 0 26;
            1 0 0 26;
            .4 0 0 0];
    otherwise, pts = [0 0 0 128; 1 1 1 0];
end
xcl=1;
for i=1:size(pts,1)-1
    xcl=[xcl,i+1/pts(i,4):1/pts(i,4):i+1];
end
pcmap = interp1(pts(:,1:3),xcl);
