function [A,ptr]=hmmprofmerge(ta,names,scores,varargin)
%HMMPROFMERGE aligns the output strings of several profile alignments.
%
%   HMMPROFMERGE(SEQUENCES) displays a set of prealigned SEQUENCES to an
%   HMM model profile. The output is aligned according to the HMM states as
%   follows.
%      Match states: Uppercase letters
%      Insert states: Lowercase letters or dots
%      Delete states: Dashes
%   Note that dots are added at positions corresponding to inserts in other
%   sequences. The input sequences must have the same number of profile
%   states, that is, the joint count of capital letters and dashes must be
%   the same. 
%
%   HMMPROFMERGE(SEQUENCES,NAMES) labels the sequences with NAMES.
%
%   HMMPROFMERGE(SEQUENCES,NAMES,SCORES) sorts the displayed sequences
%   using SCORES. 
%
%   HMMPROFMERGE(STRUCTURE) first input may also be a structure array with
%   the aligned sequences in the fields 'Aligned' or 'Sequence' and the
%   names (optional) in the field 'Header' or 'Name'.
%
%   Example:
%
%       load('hmm_model_examples','model_7tm_2')  %load model
%       load('hmm_model_examples','sequences')  %load sequences
%   
%       for ind =1:length(sequences)
%         [scores(ind), sequences(ind).Aligned]=hmmprofalign(model_7tm_2,sequences(ind).Sequence);
%       end
%
%       hmmprofmerge(sequences,scores)
%
%   See also HMMPROFALIGN, HMMPROFSTRUCT.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.16.4.5 $  $Date: 2004/04/01 15:58:02 $

noHelpBrowserFlag = false;
% the only allowable extra arg in is the noDisplay
if (nargin==5) && strcmpi(varargin{1},'noDisplay')
   noHelpBrowserFlag = varargin{2}==true;
   trueNargin = 3;
elseif (nargin==4) &&  ischar(scores) && strcmpi(scores,'noDisplay')
   noHelpBrowserFlag = varargin{1}==true;
   trueNargin = 2;
elseif (nargin==3) &&  ischar(names) && strcmpi(names,'noDisplay')
   noHelpBrowserFlag = scores==true;
   trueNargin = 1;
elseif (nargin>3)
   error('Bioinfo:TooManyInputs','Too many input arguments.')
else 
   trueNargin = nargin;
end

% Validate multiple sequences in first input:
namesProvidedinStructure = false;
if isstruct(ta)
    namesProvidedinStructure = true;
    headers = fieldfromstruct(ta,'Header');
    if isempty(headers) || (iscell(headers)&&all(cellfun('isempty',headers)))
        headers = fieldfromstruct(ta,'Name'); 
    end 
    if isempty(headers) || (iscell(headers)&&all(cellfun('isempty',headers)))
        namesProvidedinStructure = false;
    end
end

if isstruct(ta)
    a = fieldfromstruct(ta,'Aligned');
    if isempty(a) || (iscell(a)&&all(cellfun('isempty',a)))
        a = fieldfromstruct(ta,'Sequence');
    end
    if isempty(a) || (iscell(a)&&all(cellfun('isempty',a)))
        error('Bioinfo:SequenceNotFoundInStructure',...
              'Sequence data was not found in the input structure.');
    end
else
    a = ta;
end

% input sequences must be a vertical concatenation of strings or string
% cells
if iscell(a)
    a = strvcat(a{:});
end

if ~ischar(a)
    error('Bioinfo:IncorrectInputType',...
    'Sequences must be a cell array of strings, an array of chars, or an array of structures.')
end

numseq = size(a,1);
% pre keeps the preformatted char array to display
pre = [num2str((1:numseq)') repmat(' ',numseq,1)];

% at this point NAMES could contain the headers or the scores or may not
% exist and and HEADERS may exist or not.

% first check if NAMES can be the scores, and if it can then SCORES=NAMES
namesProvidedinSecondInput = false;
scoresProvidedinSecondInput = false;
if trueNargin>1
    namesProvidedinSecondInput = true;
    if iscell(names)
        probableScores = [names{:}]';
    else
        probableScores = names(:);
    end
    if (numel(probableScores)==numseq) && isnumeric(probableScores)
        scores = names;
        namesProvidedinSecondInput = false;
        scoresProvidedinSecondInput = true;
    end
end

% now choose either NAMES or HEADERS
if namesProvidedinStructure 
    if namesProvidedinSecondInput 
        warning('Bioinfo:StructureContainedHeaders',...
        ['Headers were found in SEQUENCES, however NAMES '...
         'will be used instead.']); 
    else
        names = headers;
    end
end

% at this point the only valid headers are those in NAMES (if it exist)
% input names must be a vertical concatenation of strings or string cells
if namesProvidedinStructure || namesProvidedinSecondInput 
    if iscell(names)
        names = strvcat(names{:});
    end
    if ~ischar(names)
        error('Bioinfo:IncorrectInputType','Names must be string cells or an array of chars')
    end
    if size(names,1)~=numseq
        error('Bioinfo:IncorrectInputSize','Incorrect number of names')
    end
    pre = [pre names repmat(' ',numseq,1)];
end

% input scores must be an array of numbers or numeric cells
if trueNargin==3 || scoresProvidedinSecondInput
    if iscell(scores)
        scores=[scores{:}]';
    end

    if length(scores)~=numseq
        error('Bioinfo:IncorrectInputSize','Incorrect number of scores')
    end
    pre = [pre num2str(scores(:),'%10.3f') repmat(' ',numseq,1)];
else
    scores = numseq:-1:1;
end

% finding symbols that belong to match and delete states
inds = (a <= 90 & a >= 65) | (a == '-');
% the number of states for every sequence
proflengths = sum(inds,2);
proflength = mode(proflengths);
% checking if any input alignment has a different number of states
proflengthdiff = find(proflength~=proflengths);
% and purging it out if necesary
if proflengthdiff
    warnState = warning('off','backtrace');
    warning('Bioinfo:inconsistentMultipleAlignment',...
        'Sequence(s) (%s)  with different profile length purged out', ...
        num2str(proflengthdiff'))
    warning(warnState);
    a(proflengthdiff,:) = [];
    pre(proflengthdiff,:) = [];
    inds(proflengthdiff,:) = [];
    scores(proflengthdiff) = [];
    numseq=size(a,1);
end

% finding the length of the input alignments (different length alignments
% were padded with spaces)
seqlengths = sum(a~=' ',2);
spcs = zeros(numseq,proflength+1);
for si = 1:numseq
    spcs(si,:) = diff([0 find(inds(si,:)) seqlengths(si)]);
end
mspc=max(spcs,[],1);

% copying individual alignments to the output aligned matrix (A)
% ptr indicates were the profile states are
A = char(zeros(numseq,sum(mspc)));
A(:) = '.'; % dots are used to fill-up the alignments
ptr = zeros(proflength,1);

for si = 1:numseq
    iA = 1;
    ia = 1;
    for pi = 1:proflength
        iaNew = ia+spcs(si,pi);
        iANew = iA+mspc(pi);
        A(si,iANew-spcs(si,pi):iANew-1) = a(si,ia:iaNew-1);
        ptr(pi) = iANew-1;
        ia = iaNew;
        iA = iANew;
    end
    A(si,iA:iA+spcs(si,end)-1) = a(si,ia:seqlengths(si));
end

% sort output by scores
[dump,indexes] = sort(-scores);
A = A(indexes,:);

% format to html
if nargout==0 || noHelpBrowserFlag
    % re-order also the pre-amble
    pre = pre(indexes,:);
    % prepare top row
    toprow = repmat(' ',1,size(A,2)+2);
    for st = 10:10:proflength
        toins = num2str(st);
        toprow(ptr(st):ptr(st)+length(toins)-1) = toins;
    end
    toprow = [repmat(' ',1,size(pre,2)-1) '0' toprow '<br>'];
    % prepare bottom row
    bottomrow = repmat(' ',1,size(A,2)+2);
    for st=1:proflength
        bottomrow(ptr(st)) = '*';
    end
    bottomrow = [repmat(' ',1,size(pre,2)) bottomrow '<br>'];
    % concatenate all info
    A = strvcat(toprow,[pre A repmat('  <br>',numseq,1)],bottomrow);
    % spaces mess-up the html page
    %A(A == ' ' ) = 160;
    str = sprintf('text://<html><title>Aligned Sequences</title><body><tt><pre>%s</pre></tt></body></html>',A');

    if noHelpBrowserFlag
        A=str;
    else
        clear A
        web(str)
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function out = mode(x)
[dump,out] = max(sparse(x,1,1));
