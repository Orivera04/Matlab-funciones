function model=hmmprofestimate(model,ma,varargin)
%HMMPROFESTIMATE estimates profile HMM parameters using pseudocounts.
%
%   HMMPROFESTIMATE(MODEL,MULTIPLE_ALIGNMENT) returns a structure with the
%   fields containing the updated estimated parameters of a profile HMM.
%   Symbol emission and state transition probabilities are estimated using
%   the real counts and weighted pseudocounts obtained with the background
%   probabilities. Default weight is A=20, the default background symbol
%   emission for match and insert states is taken from MODEL.NullEmission,
%   and the default background transition probabilities are the same as the
%   default transition probabilities returned by HMMPROFSTRUCT. 
%
%   Model construction: Multiple aligned sequences should contain uppercase
%   letters and dashes corresponding to the model MATCH and DELETE states
%   that agree with MODEL.ModelLength. If model state annotation is missing
%   but MULTIPLE_ALIGNMENT is space aligned, then a "maximum entropy"
%   criterion is used to select MODEL.ModelLength states.
%
%   Notes: Insert and Flank Insert transition probabilities are not
%   estimated, but can be modified afterwards using HMMPROFSTRUCT.
%   HMMPROFESTIMATE does not estimate 'fragment' profile models.
%
%   HMMPROFESTIMATE(...,'A',value) sets the pseudocount weight A to value
%   when estimating the symbol emission probabilities. The default value is
%   20. Note: for pure frequentist estimation use A = 0.
%
%   HMMPROFESTIMATE(...,'Ax',value) sets the pseudocount weight Ax to value
%   when estimating the transition probabilities. The default value is 20.
%   Note: for pure frequentist estimation use Ax = 0.
%
%   HMMPROFESTIMATE(...,'BE',value) sets the background symbol emission
%   probabilities. The default values are taken from MODEL.NullEmission. 
%
%   HMMPROFESTIMATE(...,'BMx',value) sets the background transition
%   probabilities from MATCH states ([M->M M->I M->D]). The default
%   values are [0.998 0.001 0.001]. M->E are not estimated by
%   HMMPROFESTIMATE. 
%
%   HMMPROFESTIMATE(...,'BDx',value) sets the background transition
%   probabilities from DELETE states ([D->M D->D]). The default values
%   are [0.5 0.5].
%
%   HMMPROFESTIMATE(...,'BIx',value) sets the background transition
%   probabilities from INSERT states ([I->M I->I]). The default values
%   are [0.5 0.5].
%
%   HMMPROFESTIMATE(...,'BBx',value) sets the background transition
%   probabilities from the BEGIN state ([B->D1 B->M1]). The default values
%   are [0.01 0.99]. B->M[2...end] are not estimated by HMMPROFESTIMATE.
%
%   Example:
%  
%       % Load a multiple alignment:
%       [headers,gagma] = multialignread('aagag.aln');
%       % Create a hmm profile structure of length 500:
%       gaghmm = hmmprofstruct(500);
%       % Estimate the model parameters given the multiple alignment:
%       gaghmm = hmmprofestimate(gaghmm,gagma)
%
%   See also HMMPROFSTRUCT, SHOWHMMPROF, HMMPROFALIGN

%   References:
%   R. Durbin, S. Eddy, A. Krogh, and G. Mitchison. Biological Sequence
%   Analysis. Cambridge UP, 1998.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.4.4.4 $  $Date: 2004/04/01 15:58:00 $

% defining some constants
parmNames = {'A','Ax','BE','BMx','BDx','BIx','BBx'};

% check varargin
if rem(nargin,2) == 1
    error('Bioinfo:IncorrectNumberOfArguments','Incorrect number of arguments to %s.',mfilename);
end
if nargin>2 && ~ischar([varargin{1:2:end}])
    error('Bioinfo:IncorrectParameterNames','Parameter names must be strings in %s.',mfilename);
end

%Defalut pseudocont constants
A=20; % for symbol emission, can be 5xR or other!
Ax=20; % for state transition

%Default background transtions
qabx=[0.01 0.99];
qadx=[.5 .5];
qaix=[.5 .5];
qamx=[0.998 0.001 0.001 0]; 

% Validate HMM model:
try   
    model = checkhmmprof(model);
catch 
    rethrow(lasterror);
end

% Validate multiple alignment:
if isstruct(ma)
    ma = fieldfromstruct(ma,'Sequence');
    if isempty(ma) || (iscell(ma)&&all(cellfun('isempty',ma)))
        error('Bioinfo:SequenceNotFoundInStructure',...
            'Sequence data was not found in the input structure.');
    end
end

profLength = model.ModelLength;
isamino = strcmpi(model.Alphabet,'AA');
alphaLength = 4 + isamino * 16;
qa = model.NullEmission; %default background symbol probability

if nargin > 2
    for j=1:2:nargin-2
        pname = varargin{j};
        pval = varargin{j+1};
        k = find(strcmp(lower(pname), lower(parmNames)));
        if numel(k) ~= 1
            k = strmatch(lower(pname), lower(parmNames));
        end
        if isempty(k)
            error('Bioinfo:UnknownParameterName',...
                'Unknown parameter name: %s.',pname);
        elseif length(k)>1
            error('Bioinfo:AmbiguousParameterName',...
                'Ambiguous parameter name: %s.',pname);
        else
            switch(k)
                case 1 % 'A' Pseudocount for Emission Probs.
                    if ~isnumeric(pval) || ~isreal(pval) || numel(pval)~=1 || pval<0 || pval>1e9
                        error('Bioinfo:IncorrectParameterValue',...
                              'Incorrect value for parameter %s.',pname)
                    end
                    A = pval;
                case 2 % 'Ax' Pseudocount for Tx Prob.
                    if ~isnumeric(pval) || ~isreal(pval) || numel(pval)~=1 || pval<0 || pval>1e9
                        error('Bioinfo:IncorrectParameterValue',...
                              'Incorrect value for parameter %s.',pname)
                    end
                    Ax = pval;
                case 3 % 'BE' Background Symbol Emission
                    if ~isnumeric(pval) || ~isreal(pval) || numel(pval)~=alphaLength || any(pval<0)
                        error('Bioinfo:IncorrectParameterValue',...
                              'Incorrect value for parameter %s.',pname)
                    end
                    qa = pval(:)'./sum(pval);
                case 4 % 'BMx' Background Math Tx Prob.
                    if ~isnumeric(pval) || ~isreal(pval) || numel(pval)~=3 || any(pval<0)
                        error('Bioinfo:IncorrectParameterValue',...
                              'Incorrect value for parameter %s.',pname)
                    end
                    qamx = [pval(:)' 0]./sum(pval);
                case 5 % 'BDx' Background Delete Tx Prob.
                    if ~isnumeric(pval) || ~isreal(pval) || numel(pval)~=2 || any(pval<0)
                        error('Bioinfo:IncorrectParameterValue',...
                              'Incorrect value for parameter %s.',pname)
                    end
                    qadx = pval(:)'./sum(pval);
                case 6 % 'BIx' Background Insert Tx Prob.
                    if ~isnumeric(pval) || ~isreal(pval) || numel(pval)~=2 || any(pval<0)
                        error('Bioinfo:IncorrectParameterValue',...
                              'Incorrect value for parameter %s.',pname)
                    end
                    qaix = pval(:)'./sum(pval);
                case 7 % 'BBx' Background Begin Tx Prob.
                    if ~isnumeric(pval) || ~isreal(pval) || numel(pval)~=2 || any(pval<0)
                        error('Bioinfo:IncorrectParameterValue',...
                              'Incorrect value for parameter %s.',pname)
                    end
                    qabx = pval(:)'./sum(pval);
            end
        end
    end
end


% check validity of the multiple alignment

% input sequences must be a vertical concatenation of strings or string
% cells
if iscell(ma)
   ma = char(ma{:});  
end
if ~ischar(ma)
   error('Bioinfo:IncorrectInputType','Sequences must be string cells or an array of chars')
end

% Do the multiple aligned sequence have annotated states ?
% Same number of Caps and dashes in all sequences
if all(sum((ma>='A' & ma<='Z') | ma=='-',2)==profLength)
    [ma,ptr] = hmmprofmerge(ma);
else
    %assign model states to maximum entropy columns
    if isamino 
        symCount=histc(aa2int(ma),1:20);
    else
        symCount=histc(nt2int(ma),1:4);
    end
    %check for empty columns
    h = find(~sum(symCount));
    if h
        ma(:,h)=[];symCount(:,h)=[];
    end
    symProb=symCount./repmat(sum(symCount),alphaLength,1);
    entropy=(sum(symProb.*log2(symProb+(~symProb))));
    [dump,h]=sortrows([-sum(symCount);-entropy]');
    ptr=sort(h(1:profLength));
end

numSeq = size(ma,1);

%uniformazing spaces before converting to ints
ma(:) = regexprep(ma(:)','[~\s\.]','-');
  
if (isamino && ~isaa(ma)) || (~isamino && ~isnt(ma))
   error('Bioinfo:IncorrectAlpha','Inconsistent alphabet in multiple alignment')
end

% Converting to int sequences
ima = zeros(size(ma));
for si=1:numSeq
    if isamino
        ima(si,:)=aa2int(ma(si,:));
        dashint=aa2int('-');
    else
        ima(si,:)=nt2int(ma(si,:));
        dashint=nt2int('-');
    end
end

% count symbols in the match states 
count=histc(ima(:,ptr),1:alphaLength);

% counts times it passed thru the match state
inMatch=ima(:,ptr)~=dashint;

% count symbols in the insert states
% and
% counts times it passed thru the insert state
icount=zeros(alphaLength,profLength);
inInsert=zeros(numSeq,profLength);
for pi=1:profLength-1
    insertptr=ptr(pi)+1:ptr(pi+1)-1;
    imat=ima(:,insertptr);
    if ~isempty(insertptr)
        icount(:,pi)=histc(imat(:),1:alphaLength);
        inInsert(:,pi)=sum(imat~=dashint,2);
    end
end
ixcount = [ sum(inInsert(:,1:profLength-1)>0) ;...         % i->m
            sum(max(0,inInsert(:,1:profLength-1)-1))]';  % i->i

% count transitions from match state, last state always to "end" and
% no possibility of fragment alignment
mxCount=[...
 sum(inMatch(:,1:end-1)&inMatch(:,2:end)&~inInsert(:,1:end-1)) ;... % m->m
 sum(inMatch(:,1:end-1)&inInsert(:,1:end-1)) ;...                   % m->i
 sum(inMatch(:,1:end-1)&~inMatch(:,2:end)&~inInsert(:,1:end-1)) ;...% m->d
 zeros(1,profLength-1) ]';                                          % m->end

% count transitions from delete state, last state is uninformative
dxCount=[...
 sum(~inMatch(:,1:end-1)&inMatch(:,2:end)&~inInsert(:,1:end-1)) ;... % d->m
 sum(~inMatch(:,1:end-1)&~inMatch(:,2:end)&~inInsert(:,1:end-1)) ]'; % d->d

% count transitions from Begin state
bxCount=[sum(~inMatch(:,1));sum(inMatch(:,1))]; 

% some counts may be zero, it is common to find "Divide by Zero" warnings
woff=warning('off');
    % Estimate match emission probabilities (pseudocount)
    mep=((count+A*repmat(qa',1,profLength))./repmat(sum(count)+A,alphaLength,1))';
    mep(isnan(mep))=1/alphaLength;
    % Estimate insert emission probabilities (pseudocount)
    iep=((icount+A*repmat(qa',1,profLength))./repmat(sum(icount)+A,alphaLength,1))';
    iep(isnan(iep))=1/alphaLength;
    % Estimate match transition probabilities (pseudocount)
    mxp=((mxCount+Ax*repmat(qamx,profLength-1,1))./repmat(sum(mxCount,2)+Ax,1,4));
    mxp(isnan(mxp))=0.25;
    % Estimate delete transition probabilities (pseudocount)
    dxp=((dxCount+Ax*repmat(qadx,profLength-1,1))./repmat(sum(dxCount,2)+Ax,1,2));
    dxp(isnan(dxp))=0.5;
    % Estimate insert transition probabilities (pseudocount) 
    ixp = ( Ax*qaix(2)*sum(ixcount,2) +  prod(ixcount,2) )...
      ./(Ax+ixcount(:,1)) ./ sum(ixcount,2);
    ixp(isnan(ixp))=0.5;
warning(woff);

% Estimate begin transition probabilities (pseudocount)
bxp=[(bxCount+Ax*qabx')/(sum(bxCount)+Ax);zeros(profLength-1,1)];

model.MatchEmission=mep;
model.InsertEmission=iep;
model.MatchX=mxp;
model.DeleteX=dxp;
model.InsertX=[1-ixp ixp];
model.BeginX=bxp;
