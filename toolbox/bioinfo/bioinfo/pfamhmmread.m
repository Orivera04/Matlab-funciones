function data=pfamhmmread(filename)
%PFAMHMMREAD reads in PFAM-HHM format data files.
%
%   S = PFAMHMMREAD(FILE) reads in a Hidden Markov Model described by the
%   PFAM format from FILE, and converts it to structure S, containing
%   fields corresponding to annotations and parameters of the model. For
%   more information about the model structure format see HMMPROFSTRUCT.
%   FILE can also be an URL or a MATLAB cell array that contains the text
%   of a PFAM format file.
%
%   Examples:
%
%       pfamhmmread('pf00002.ls')
%       site='http://www.sanger.ac.uk/';
%       pfamhmmread([site 'cgi-bin/Pfam/download_hmm.pl?id=7tm_2'])
%
%   See also GETHMMALIGNMENT, GETHMMPROF, HMMPROFALIGN, HMMPROFSTRUCT,
%   SHOWHMMPROF.

%   PFAMHMMREAD is based on the HMMER 2.0 file formats.

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.11.6.6 $   $Date: 2004/04/01 15:58:06 $

% constants in the hhmer2.0 file format
numX = 9 ;    %number of possible transitions within a state
scale = 1000; %scale used to recover probabilities from log-prob

% check input is char
if ~ischar(filename)
    error('Bioinfo:InvalidInput','Input must be a character array')
end

% See if we have a URL
if size(filename,1)>1  % is padded string
    for i=1:size(filename,1)
        pftext(i)=strread(filename(i,:),'%s','whitespace','');
        pftext{i}(max(find(~isspace(pftext{i})))+1:end)=[];
    end
    % try then if it is an url
elseif (strfind(filename(1:min(10,end)), '://'))
    if (~usejava('jvm'))
        error('Bioinfo:NoJava','Reading from a URL requires Java.')
    end
    try
        pftext = urlread(filename);
    catch
        error('Bioinfo:CannotReadURL','Cannot read URL "%s".', filename);
    end
    pftext = strread(pftext,'%s','delimiter','\n');

    % try then if it is a valid filename
elseif  (exist(filename) == 2 || exist(fullfile(cd,filename)) == 2)
    pftext = textread(filename,'%s','delimiter','\n');

else % must be a string with '\n', convert to cell
    pftext = strread(filename,'%s','delimiter','\n');
end

if ~iscell(pftext) || isempty(strfind(pftext{1},'HMMER2.0'))
    error('Bioinfo:PfamNotValid','Input is not a valid PFAM file.')
end

data=[];

try

    % finding closing markers of every record
    recordLimits =[1;strmatch('//',pftext,'extact')];
    numberRecords = length(recordLimits)-1;

    for count = 1:numberRecords
        pf = pftext(recordLimits(count)+1:recordLimits(count+1)-1);

        %%%%% READ ANNOTATION FIELDS %%%%%

        % Model Name -- Mandatory -- Saved in structure
        h=strmatch('NAME',pf);
        data(count).Name=pf{h}(7:end);

        % PFAM Accession Number -- Optional -- Saved in structure
        h=strmatch('ACC',pf);
        if isempty(h)
            data(count).PfamAccessionNumber=[];
        else
            data(count).PfamAccessionNumber=pf{h(1)}(7:end);
        end

        % HMM Model description -- Optional -- Saved in structure
        h=strmatch('DESC',pf);
        if isempty(h)
            data(count).ModelDescription=[];
        else
            data(count).ModelDescription=pf{h(1)}(7:end);
        end

        %%%%% READ LENGTH AND ALPHABET %%%%%

        % HMM Model length -- Mandatory -- Saved in structure
        h=strmatch('LENG',pf);
        profLength=str2num(pf{h(1)}(7:end));
        data(count).ModelLength=profLength;

        % Alphabet -- Mandatory -- Saved in structure
        data(count).Alphabet='AA';
        alphaLength=20;
        isAmino=true;
        h=strmatch('ALPH',pf);
        if strcmp('Nucleic',pf{h(1)}(7:end))
            data(count).Alphabet='NT';
            alphaLength=4;
            isAmino=false;
        end

        %%%%% READ OTHER ANNOTATIONS NOT STORED IN THE STRUCTURE %%%%%

        % Reference Annotation -- Optional -- Not used
        h=strmatch('RF',pf);
        if ~isempty(h) && strcmp('yes',pf{h(1)}(7:end))
            error('Bioinfo:AnnotationNotImplemented','Reference annotation not implemented in this pharser')
        end

        % Consensus Structure Annotation -- Optional -- Not used
        h=strmatch('CS',pf);
        if ~isempty(h) && strcmp('yes',pf{h(1)}(7:end))
            error('Bioinfo:AnnotationNotImplemented','Consensus structure annotation not implemented in this pharser')
        end

        % Map Annotation flag -- Optional -- Used to remap but not stored
        %                                    in structure
        remap = false;
        h=strmatch('MAP',pf);
        if ~isempty(h) && strcmp('yes',pf{h(1)}(7:end))
            remap=true;
        end

        % Gathering cutoff -- Optional -- Not used
        h=strmatch('GA',pf);
        if isempty(h)
            GatheringCutoff=zeros(0,2);
        else
            GatheringCutoff=str2num(pf{h(1)}(7:end));
            if ~all(size(GatheringCutoff)==[1 2])
                error('Bioinfo:IncorrectDataFormat','Incorrect data format in PFAM file')
            end
        end

        % Trusted cutoff -- Optional -- Not used
        h=strmatch('TC',pf);
        if isempty(h)
            TrustedCutoff=zeros(0,2);
        else
            TrustedCutoff=str2num(pf{h(1)}(7:end));
            if ~all(size(TrustedCutoff)==[1 2])
                error('Bioinfo:IncorrectDataFormat','Incorrect data format in PFAM file')
            end
        end

        % Noise cutoff -- Optional -- Not used
        h=strmatch('TC',pf);
        if isempty(h)
            NoiseCutoff=zeros(0,2);
        else
            NoiseCutoff=str2num(pf{h(1)}(7:end));
            if ~all(size(NoiseCutoff)==[1 2])
                error('Bioinfo:IncorrectDataFormat','Incorrect data format in PFAM file')
            end
        end

        %%%%% READ PROBABILITIES %%%%%

        % Special Transition Log-Probabilities -- Mandatory
        h=strmatch('XT',pf);
        XSpecial=str2num(pf{h(1)}(7:end));
        if ~all(size(XSpecial)==[1 8])
            error('Bioinfo:IncorrectDataFormat','Incorrect data format in PFAM file')
        end

        % Null Model Transition Log-Probabilities -- Mandatory
        h=strmatch('NULT',pf);
        NullTran=str2num(pf{h(1)}(7:end));
        if ~all(size(NullTran)==[1 2])
            error('Bioinfo:IncorrectDataFormat','Incorrect data format in PFAM file')
        end

        % Null Model Symbol Emission Log-Probabilities -- Mandatory
        % reorder at the end
        h=strmatch('NULE',pf);
        NullEmission=str2num(pf{h(1)}(7:end));
        if strcmp(data(count).Alphabet,'NT') && ~all(size(NullEmission)==[1 4])
            error('Bioinfo:IncorrectDataFormat','Incorrect data format in PFAM file')
        end
        if strcmp(data(count).Alphabet,'AA') && ~all(size(NullEmission)==[1 20])
            error('Bioinfo:IncorrectDataFormat','Incorrect data format in PFAM file')
        end

        % Extreme value distribution parameter -- Optional
        h=strmatch('EVD',pf);
        if isempty(h)
            ExtremeValue=zeros(0,2);
        else
            ExtremeValue=str2num(pf{h(1)}(7:end));
            if ~all(size(ExtremeValue)==[1 2])
                error('Bioinfo:IncorrectDataFormat','Incorrect data format in PFAM file')
            end
        end

        % Looks for the HMM flag -- Mandatory
        h=strmatch('HMM',pf);
        if length(h)~=1
            error('Bioinfo:IncorrectDataFormat','Incorrect data format in PFAM file')
        end

        % Alphabet order, re-order as aa2int (or nt2int) -- Mandatory
        % reorderAlpha is used later to read in the Symbol Emission lines
        if isAmino
            reorderAlpha=aa2int(removeallblanks(pf{h}(7:end)));
        else
            reorderAlpha=nt2int(removeallblanks(pf{h}(7:end)));
        end

        % Identify the state transitions in the header
        % reorderStateX is used later to read in the State Transition lines
        StateAlpha=('MIDBE')';
        StateAlphaI('MIDBE')=1:5;
        StateXMap =[1 1;1 2;1 3;1 5;2 1;2 2;3 1;3 3;4 1];
        temp=upper(pf{h+1}(any(repmat(upper(pf{h+1}),5,1)==repmat(StateAlpha,1,size(pf{h+1},2)))));
        [dump,reorderStateX]=sortrows(StateAlphaI(reshape(temp,2,length(temp)/2)'));

        % Transitions of the B state -- Mandatory
        XBState=CorrectStars(pf{h+2});
        h=h+3;

        % pre-allocate
        MatchEmission=zeros(profLength,alphaLength);
        InsertEmission=zeros(profLength,alphaLength);
        XState=zeros(profLength,numX);
        Map=zeros(profLength,1);

        for state = 1:profLength
            % Every state of the model is described by three lines

            % Match emision line
            p=CorrectStars(pf{h});
            MatchEmission(state,reorderAlpha)=p(2:alphaLength+1);
            if remap
                Map(state)=p(end);
            else
                Map(state)=p(1);
            end

            % Insert emission line
            p=CorrectStars(pf{h+1}(min(find(pf{h+1}=='-'))+1:end));
            InsertEmission(state,reorderAlpha)=p;

            % State transition line
            p=CorrectStars(pf{h+2}(min(find(pf{h+2}=='-'))+1:end));
            XState(state,:)=p(reorderStateX);

            h=h+3;

        end %for state

        NullEmission(reorderAlpha)=NullEmission;
        StateMap=Map;

        %%%RE-SCALE ALL PROBABILITIES AND UNDO LOGS

        %% NULL MODEL EMISSION PROB
        nep=(2.^(NullEmission/scale))/alphaLength;
        nep=nep/sum(nep);              %re-adjusting to sum one

        %% MATCH EMISSION PROB
        mep=(2.^(MatchEmission/scale))*diag(nep);
        mep=diag(1./sum(mep,2))*mep;   %re-adjusting to sum one

        %% INSERT EMISSION PROB
        iep=(2.^(InsertEmission/scale))*diag(nep);
        iep(~sum(iep,2),:)=1/alphaLength; %correct rows that sum zero
        iep=diag(1./sum(iep,2))*iep;   %re-adjusting to sum one

        %% NULL MODEL TRANSITION PROB
        nxp=2.^(NullTran([2,1])/scale);
        nxp=nxp/sum(nxp);             %re-adjusting to sum one
        
        %% BEGIN-[DEL_1-MATCH_X] TRANSITION PROB
        %% [B->D1, B->M1, B->M2, B->M3, B->M4 ... ]
        bxp=[2.^(XBState(3)/scale);2.^(XState(:,9)/scale)];
        bxp=bxp/sum(bxp);             %re-adjusting to sum one

        %% MATCH TRANSITION PROB
        mxp=2.^(XState(:,[1 2 3 4])/scale);
        mxp(~sum(mxp,2),:)=1/4;  %correct rows that sum zero
        mxp=diag(1./sum(mxp,2))*mxp;   %re-adjusting to sum one

        %% INSERT TRANSITION PROB
        ixp=2.^(XState(:,[5 6])/scale);
        ixp(~sum(ixp,2),:)=1/2;  %correct rows that sum zero
        ixp=diag(1./sum(ixp,2))*ixp;   %re-adjusting to sum one

        %% DELETE TRANSITION PROB
        dxp=2.^(XState(:,[7 8])/scale);
        dxp(~sum(dxp,2),:)=1/2;  %correct rows that sum zero
        dxp=diag(1./sum(dxp,2))*dxp;   %re-adjusting to sum one

        %% LEFT FLANKING INSERT TRANSITION PROB
        lixp=2.^(XSpecial([1,2])/scale);
        lixp=lixp/sum(lixp);          %re-adjusting to sum one

        %% RIGTH FLANKING INSERT TRANSITION PROB
        rixp=2.^(XSpecial([5,6])/scale);
        rixp=lixp/sum(rixp);          %re-adjusting to sum one
        
        %% LOOP INSERT TRANSITION PROB
        lxp=2.^(XSpecial([7,8])/scale);
        lxp=lxp/sum(lxp);          %re-adjusting to sum one
        
        %% END TRANSITION PROB
        %% [E->C, E->J]
        endxp=2.^(XSpecial([3,4])/scale);
        endxp=endxp/sum(endxp);          %re-adjusting to sum one

        %% Store data in structure
        data(count).MatchEmission = mep;
        data(count).InsertEmission = iep;
        data(count).NullEmission = nep;
        data(count).BeginX = bxp;
        data(count).MatchX = mxp(1:end-1,:); %last state is always [0 0 0 1]
        data(count).InsertX = ixp(1:end-1,:); %last state does not exist
        data(count).DeleteX = dxp(1:end-1,:); %last state always goes to E
        data(count).FlankingInsertX = [lixp;rixp]';
        data(count).LoopX = [endxp;lxp]';
        data(count).NullX = nxp';

    end %for count

catch
    error('Bioinfo:IncorrectDataFormat','Incorrect data format in PFAM file')
end

function str = removeallblanks(str)
% REMOVEBLANKS removes all blanks
str(isspace(str))=[];

function out = CorrectStars(in)
% CORRECTSTARS correct the string marked with '*' which represents Zero
% probabilities (i.e. -Inf log-Probabilities), returns the numeric array
c=find(in=='*'); out=['   ' in]; for k=1:length(c);
    out(c(k):c(k)+3)='-Inf';
end
out=str2num(out);
