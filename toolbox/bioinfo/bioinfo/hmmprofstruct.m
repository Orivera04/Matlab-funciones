function [model]=hmmprofstruct(model,varargin)
%HMMPROFSTRUCT creates a profile HMM structure.
%
%   HMMPROFSTRUCT without input and output arguments displays this help.
%
%   HMMPROFSTRUCT(LENGTH) returns a structure with the fields containing
%   the required parameters of a profile HMM. LENGTH specifies the number
%   of MATCH states in the model. All other mandatory model parameters are
%   initialized to default values.
%
%   HMMPROFSTRUCT(LENGTH,'field1',VALUE1,'field2',VALUE2,...) creates a
%   profile HMM using the specified fields and parameters. All other
%   mandatory model parameters are initialized to default values.
%
%   HMMPROFSTRUCT(MODEL,'field1',VALUES1,'field2',VALUES2,...) returns the
%   updated profile HMM with the specified fields and parameters. All other
%   mandatory model parameters are taken from the reference MODEL.
%
%   HMM PROFILE STRUCTURE FORMAT:
%
%   1. Model parameters fields (mandatory)
%      All probability values are in the range [0 1].
%
%   ModelLength:    Length of the profile (number of MATCH states)
%   Alphabet:       'AA' or 'NT',  default='AA'
%   MatchEmission:  Symbol emission probabilities in the MATCH states.
%                      Size is [ModelLength x AlphaLength]
%                      Note: sum(S.MatchEmission,2) = [1;1;1; ... ;1]
%                      Default = 1/AlphaLength
%   InsertEmission: Symbol emission probabilities in the INSERT stated.
%                      Size is [ModelLength x AlphaLength]
%                      Note: sum(S.InsertEmission,2) = [1;1;1; ... ;1]
%                      Default = 1/AlphaLength
%   NullEmission:   Symbol emission probabilities in the MATCH and INSERT
%                   states for the NULL model. The NULL model is used to
%                   compute the log-odds ratio at every state and avoid
%                   overflow when propagating the probabilities through
%                   the model.
%                      Size is [1 x AlphaLength]
%                      Note: sum(S.NullEmission) = 1
%                      Default = 1/AlphaLength
%   BeginX:         BEGIN state transition probabilities
%                      Format is [B->D1 B->M1 B->M2 B->M3 .... B->Mend]
%                      Notes: sum(S.BeginX) = 1
%                             For fragment profiles sum(S.BeginX(3:end)) = 0
%                      Default = [0.01 0.99 0 0 ... 0];
%   MatchX:         MATCH state transition probabilities
%                      Format is  [M1->M2 M2->M3 ... M[end-1]->Mend      ;
%                                  M1->I1 M2->I2 ... M[end-1]->I[end-1]  ;
%                                  M1->D2 M2->D3 ... M[end-1]->Dend      ;
%                                  M1->E  M2->E  ... M[end-1]->E         ]
%                      Notes: sum(S.MatchX) = [ 1 1 ... 1 ]
%                             For fragment profiles sum(S.MatchX(4,:)) = 0
%                      Default is repmat([0.998 0.001 0.001 0],profLength-1,1)
%   InsertX:        INSERT state transition probabilities
%                      Format is [I1->M2 I2->M3 ... I[end-1]->Mend     ;
%                                [I1->I1 I2->I2 ... I[end-1]->I[end-1] ]
%                      Note: sum(S.InsertX) = [ 1 1 ... 1 ]
%                      Default is repmat([0.5 0.5],profLength-1,1)
%   DeleteX:        DELETE state transition probabilities
%                      Format is [D1->M2 D2->M3 ... D[end-1]->Mend  ;
%                                [D1->D2 D2->D3 ... D[end-1]->Dend  ]
%                      Note: sum(S.DeleteX) = [ 1 1 ... 1 ]
%                      Default is repmat([0.5 0.5],profLength-1,1)
%   FlankingInsertX: Flanking insert states (N and C) used for LOCAL profile
%                   alignment
%                      Format is  [N->B  C->T ;
%                                  N->N  C->C ]
%                      Notes: sum(S.FlankingInsertsX) = [1 1],
%                             to force global alignment use
%                             S.FlankingInsertsX = [1 1; 0 0]
%                      Default is [0.01 0.01; 0.99 0.99]
%   LoopX:          Loop states transition probabilities used for multiple
%                   hits alignment 
%                      Format is [E->C  J->B ;
%                                 E->J  J->J ]
%                      Note: sum(S.LoopX) = [1 1]
%                      Default is [0.5 0.01; 0.5 0.99]
%   NullX:          Null transition probabilities used to provide scores
%                   with log-odds values also for state transitions.
%                      Format is [G->F ; G->G]
%                      Note: sum(S.NullX) = 1
%                      Default is [0.01; 0.99]
%
%   2. Annotation fields (optional)
%
%   Name:                 Model name
%   IDNumber:             Identification Number
%   Description:          Short description of the model
%
%   Example:
%      hmmprofstruct(100,'Alphabet','AA')
%
%   See also GETHMMPROF, HMMPROFALIGN, HMMPROFESTIMATE, HMMPROFGENERATE,
%   HMMPROFMERGE, PFAMHMMREAD, SHOWHMMPROF.

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.9.4.5 $   $Date: 2004/04/01 15:58:03 $

if (nargin==0) && (nargout==0)
    help hmmprofstruct
    return
end

% defining some constants
fieldKeys = {'ModelLength','Alphabet','MatchEmission','InsertEmission','NullEmission',...
    'BeginX','MatchX','InsertX','DeleteX','FlankingInsertX','LoopX','NullX',...
    'XB','XM','XI','XD','XF','XL','XN'};

% check varargin
if rem(nargin,2) == 0
    error('Bioinfo:IncorrectNumberOfArguments','Incorrect number of arguments to %s.',mfilename);
end
if nargin>1 && ~ischar([varargin{1:2:end}])
    error('Bioinfo:IncorrectParameterNames','Parameter names must be strings in %s.',mfilename);
end

% first input, reference model or model length ?
if isstruct(model)
    % Validate HMM model:
    try   
        model = checkhmmprof(model);
    catch 
        rethrow(lasterror);
    end
    profLength = model.ModelLength;
    referenceModel = true;
elseif  isnumeric(model) && numel(model)==1 && ismember(model,2:10000)
    profLength = model;
    referenceModel = false;
else
    error('Bioinfo:NoValidInput',...
          ['Not valid first input to HMMPROFSTRUCT.\n'...
           'It is neither a reference model or an allowed numeric value.']);
end

% Now setting the alphabet
if referenceModel % take from ref and ignore any 'alphabet' varargin
    isamino = strcmpi(model.Alphabet,'AA');
else
    isamino = true; %default value 'alphabet' varargin
    for j=1:2:nargin-1 % look for
        pname = varargin{j};
        if strmatch(lower(pname),lower(fieldKeys))==2
            isamino = strcmpi(varargin{j+1},'AA');
        end
    end
end
alphaLength = 4 + isamino * 16;

% Set the default model (if no reference was given)
if ~referenceModel
    model.ModelLength = profLength;
    if isamino
        model.Alphabet = 'AA';
    else
        model.Alphabet = 'NT';
    end
    model.MatchEmission = ones(profLength,alphaLength)/alphaLength;
    model.InsertEmission = ones(profLength,alphaLength)/alphaLength;
    model.NullEmission = ones(1,alphaLength)/alphaLength;
    model.BeginX = [0.01;0.99;zeros(profLength-1,1)];
    model.MatchX = repmat([0.998 0.001 0.001 0],profLength-1,1);
    model.InsertX = repmat([0.5 0.5],profLength-1,1);
    model.DeleteX = repmat([0.5 0.5],profLength-1,1);
    model.FlankingInsertX = [0.01 0.01; 0.99 0.99];
    model.LoopX = [0.5 0.01; 0.5 0.99];
    model.NullX = [0.01; 0.99];
end

% now updating structure depending on the remaining varargin
for j=1:2:nargin-2
    pname = varargin{j};
    pval = varargin{j+1};
    k = strmatch(lower(pname), lower(fieldKeys));
    if isempty(k)
        error('Bioinfo:UnknownParameterName',...
            'Unknown parameter name: %s.',pname);
    elseif length(k)>1
        error('Bioinfo:AmbigousParameterName',...
            'Ambiguous parameter name: %s.',pname);
    else % length(k)==1
        switch(k)
            case 1 %'ModelLength'
                error('Bioinfo:IncorrectParameterName','Model Length is set only by the first input');
            case 2 %'Alphabet'
                if strcmpi(pval,'AA')~=isamino
                    error('Bioinfo:IncorrectParameterName','Can not change Alphabet in reference model');
                    %else ignore, already taken care of
                end
            otherwise
                % convenient to set the distributions using aacount or basecount
                if isstruct(pval)
                    pval=cell2mat(struct2cell(pval));
                end
                if ~isnumeric(pval)
                    error('Bioinfo:NonNumericParameter','%s is not numeric',fieldKeys{k})
                end
                if ~all(pval(:)>=0 & pval(:)<inf)
                    error('Bioinfo:OutOfRangeParameter','%s is out of range',fieldKeys{k})
                end
                switch(k)
                    case 3 %'MatchEmission'
                        if numel(pval)== alphaLength
                            model.MatchEmission=repmat(pval(:)'/sum(pval),profLength,1);
                        elseif all(size(pval)==[profLength alphaLength])
                            pval=diag(1./sum(pval,2))*pval;
                            model.MatchEmission=pval;
                        else
                            error('Bioinfo:InconsistentSize','%s has inconsistent size',fieldKeys{k})
                        end
                    case 4 %'InsertEmission'
                        if numel(pval)== alphaLength
                            model.InsertEmission=repmat(pval(:)'/sum(pval),profLength,1);
                        elseif all(size(pval)==[profLength alphaLength])
                            pval=diag(1./sum(pval,2))*pval;
                            model.InsertEmission=pval;
                        else
                            error('Bioinfo:InconsistentSize','%s has inconsistent size',fieldKeys{k})
                        end
                    case 5 %'NullEmission'
                        if numel(pval)== alphaLength
                            model.NullEmission=pval(:)'/sum(pval);
                        else
                            error('Bioinfo:InconsistentSize','%s has inconsistent size',fieldKeys{k})
                        end
                    case {6,13} %'BeginX'
                        if numel(pval)== (profLength+1)
                            model.BeginX=pval(:)/sum(pval);
                        elseif numel(pval)==2
                            model.BeginX=[pval(:)/sum(pval);zeros(profLength-1,1)];
                        else
                            error('Bioinfo:InconsistentSize','%s has inconsistent size',fieldKeys{k})
                        end
                    case {7,14} %'MatchX'
                        if numel(pval)==4
                            model.MatchX=repmat(pval(:)'/sum(pval),profLength-1,1);
                        elseif numel(pval)==3
                            model.MatchX=repmat([pval(:)' 0]/sum(pval),profLength-1,1);
                        elseif all(size(pval)==[profLength-1 4])
                            pval=diag(1./sum(pval,2))*pval;
                            model.MatchX=pval;
                        elseif all(size(pval)==[profLength-1 3])
                            pval=diag(1./sum(pval,2))*pval;
                            model.MatchX=[pval;zeros(profLength-1,1)];
                        else
                            error('Bioinfo:InconsistentSize','%s has inconsistent size',fieldKeys{k})
                        end
                    case {8,15} %'InsertX'
                        if numel(pval)==2
                            model.InsertX=repmat(pval(:)'/sum(pval),profLength-1,1);
                        elseif all(size(pval)==[profLength-1 2])
                            pval=diag(1./sum(pval,2))*pval;
                            model.InsertX=pval;
                        else
                            error('Bioinfo:InconsistentSize','%s has inconsistent size',fieldKeys{k})
                        end
                    case {9,16} %'DeleteX'
                        if numel(pval)==2
                            model.DeleteX=repmat(pval(:)'/sum(pval),profLength-1,1);
                        elseif all(size(pval)==[profLength-1 2])
                            pval=diag(1./sum(pval,2))*pval;
                            model.DeleteX=pval;
                        else
                            error('Bioinfo:InconsistentSize','%s has inconsistent size',fieldKeys{k})
                        end
                    case {10,17} %'FlankingInsertX'
                        if numel(pval)==2
                            model.FlankingInsertX=repmat(pval(:)/sum(pval),1,2);
                        elseif all(size(pval)==[2 2])
                            pval=pval*diag(1./sum(pval));
                            model.FlankingInsertX=pval;
                        else
                            error('Bioinfo:InconsistentSize','%s has inconsistent size',fieldKeys{k})
                        end
                    case {11,18} %'LoopX'
                        if numel(pval)==2
                            model.LoopX=repmat(pval(:)/sum(pval),1,2);
                        elseif all(size(pval)==[2 2])
                            pval=pval*diag(1./sum(pval));
                            model.LoopX=pval;
                        else
                            error('Bioinfo:InconsistentSize','%s has inconsistent size',fieldKeys{k})
                        end
                    case {12,19} %'NullX'
                        if numel(pval)==2
                            model.NullX=pval(:)/sum(pval);
                        else
                            error('Bioinfo:InconsistentSize','%s has inconsistent size',fieldKeys{k})
                        end
                end %second switch
        end % first switch
    end %if length(k)==1
end % for all varargin
