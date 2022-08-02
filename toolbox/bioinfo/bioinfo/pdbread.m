function PDB_struct = pdbread(pdbfile)
%PDBREAD reads a Protein Data Bank file into a structure.
%
%   PDBSTRUCT = PDBREAD(FILENAME) reads the file corresponding to FILENAME
%   and stores the information contained in this file in PDBSTRUCT.
%
%   The data stored in each record of the PDB file is converted, where
%   appropriate, to a MATLAB structure. For example, the ATOM records in a
%   PDB file are converted to an array of structures with the following
%   fields:  AtomSerNo, AtomName, altLoc, resName, chainID, resSeq, iCode,
%   X, Y, Z, occupancy, tempFactor, segID, element, charge.
%
%   The sequence information from the PDB file is stored in the Sequence
%   field of PDBSTRUCT. The sequence information is itself a structure with
%   fields NumOfResidues, ChainID, ResidueNames, and Sequence. The
%   ResidueNames field contains the three-letter codes for the sequence
%   residues. The Sequence field contains the single-letter codes for the
%   sequence. If the sequence has modified residues, then the ResidueNames
%   field might not correspond to the standard three-letter amino acid
%   codes, in which case the Sequence field will contain a ? in the
%   position corresponding to the modified residue.
%
%   For more information about the PDB format, see
%   http://www.rcsb.org/pdb/docs/format/pdbguide2.2/guide2.2_frame.html .
%
%   Example:
%
%       % Get the Green Fluorescent protein PDB data and save it to a file.
%       gfl = getpdb('1GFL','TOFILE','1gfl.pdb');
%       % In subsequent MATLAB sessions you can use pdbread to access the
%       % local copy from disk instead of accessing it from the PDB web site.
%       gfl = pdbread('1gfl.pdb')
%
%   See also GENPEPTREAD, GETGENPEPT, GETPDB, PIRREAD.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.11.4.7 $  $Date: 2004/04/08 20:44:17 $

%  The example file 'collagen.pdb' was obtained from the following web
%  site.
%  http://cmm.info.nih.gov/modeling/pdb_at_a_glance.html


useTempFile = true;

if exist(pdbfile,'file');
    filename = pdbfile;
    useTempFile = false;
elseif ~isempty(pdbfile) && ~isempty(strfind(pdbfile(1,:),'HEADER')) && ~isempty(strfind(pdbfile(end,:),'END'))
    filename = savetempfile(pdbfile);
elseif (strfind(pdbfile, '://'))
    if (~usejava('jvm'))
        error('Bioinfo:NoJava','Reading from a URL requires Java.')
    end
    % must be a URL
    pdbfile = urlread(pdbfile);
    % clean up any &amp s
    pdbfile=strrep(pdbfile,'&amp;','&');
    filename = savetempfile(pdbfile);
else
    error('Bioinfo:BadPDBFile','File does not exist or does not contain valid PDB data.')
end

fid=fopen(filename,'r');

if fid == -1,
    if ~useTempFile
        error('Bioinfo:CouldNotOpenFile','Could not open file %s.', filename);
    else
        error('Bioinfo:CouldNotOpenTempFile','Could not open temporary file %s.',filename);
    end
else
    PDB_struct = [];

    % Following are some of the initializations necessary for various record types mentioned in the comments
    Journal_Entry = 1; % This is the count for the number of the JRNL records in the PDB file
%     JournalSubRecords = zeros(1,6); % The array of flags for the subrecords. JRNLSubRecords(1)=AUTH, JRNLSubRecords(2)=TITL, JRNLSubRecords(3)=EDIT
    %                                        JRNLSubRecords(4)=REF, JRNLSubRecords(5)=PUBL , JRNLSubRecords(6)=REFN
%     OldNumKeywds = 0; % KEYDS
%     OldNumEntries = 0; % OBSLTE
%     OldNumAuthors = 0; % AUTHOR
    NumOfRevisionDate = 0; % REVDAT
    NumOfDBReferences = 0; % DBREF
    NumOfSequenceConflicts = 0; % SEQADV
    NumOfModifiedResidues = 0; % MODRES
    NumOfHeterogen = 0; % HET
    NumOfHeterogenName = 0; % HETNAM
    NumOfHelix = 0; % HELIX
    NumOfSheet = 0; % SHEET
    NumOfTurn = 0; %TURN
    NumOfSSBond = 0; % SSBOND
    NumOfLink = 0; % LINK
    NumOfHydrogenBond = 0; % HYDBND
    NumOfSaltBridge =0; % SLTBRG
    NumOfCISPeptides = 0; % CISPEP
    NumOfTranslationVector = 0; % TVECT
    NumOfConnectivity = 0; % CONECT
    NumOfAtomSD = 0; % SIGATM
    NumOfAnisotropicTemp = 0; % ANISOU
    NumOfAnisotropicTempSD = 0; % SIGUIJ
    NumOfAtom = 0; % Atom
    NumOfHeterogenSynonym = 0; % HETSYN
    NumOfFormula = 0; % FORMUL
    NumOfHeterogenAtom = 0; % HETATM
    NumOfModel = 0; % MODEL
    NumOfTerminal = 0; % TER
    NumResChain = 0;
    JournalAuth = 0;

%     ModelFlag = 0; % This is the flag to mark the beginning of the MODEL record.
    % This will be set when MODEL record appears and will be reset to 0 when ENDMDL record appears

%     CurRes = '';
    PrevRes = '';

%     CurSiteName = '';
    PrevSiteName = '';

%     CurHetIDHeterogenSynonym = '';
    PrevHetIDHeterogenSynonym = '';

%     CurHetIDFormula = '';
    PrevHetIDFormula = '';

%     CurHetIDHeterogenName = '';
    PrevHetIDHeterogenName = '';

%     CurRemark = 0;
    PrevRemark = 0;

%     CurFtnote = 0;
    PrevFtnote = 0;

    TmpStruct = struct('ResName',{},'ChainID',{''},'ResSeqNo',{},'InsCode',{''}); % This is for SITE record
end

fullText = fread(fid,'char=>char')';
totalNumberOfAtoms = numel(strfind(fullText,'ATOM'));
totalNumberOfHetAtoms = numel(strfind(fullText,'HETATM'));
clear('fulltext');
fseek(fid,0,-1);

blank = blanks(80);

while 1

    tline = fgetl(fid);

    if ~ischar(tline)
        break; % For end of file recognition
    end
    len = length(tline);
    if len == 0 % Omit the empty lines to avoid error of invalid matrix index.
        continue
    end

    tline = [tline blank(len+1:80)]; % RCSB web site format requires each line to have 80 characters. This avoids exceeding the matrix dimension for lines with
    % less than 80 characters.
    Record_name = upper(tline(1:6));
    Record_name = deblank(Record_name); % Assuming that the record name will be left alligned (as mentioned in the RCSB file format doc,remove trailing blanks

    if strncmp(Record_name,'ORIGX',5) || strncmp(Record_name,'SCALE',5) || strncmp(Record_name,'MTRIX',5) % This is done to take care of ORIGX1,ORIGX2,ORIGX3
        % and similarly for SCALE and MTRIX
        Record_name = Record_name(1:5);
    end

    switch Record_name
        %Single/Mandatory
        case 'HEADER'
            PDB_struct.Header = struct('classification',{deblank(tline(11:50))},'depDate',{tline(51:59)},'idCode',{tline(63:66)});

        %Single Continued/Optional : mandatory in withdrawn entries
        case 'OBSLTE'
            if strcmp(tline(9:10),'  ') %check for continuation
                PDB_struct.Obsolete = struct('repDate',{tline(12:20)},'idCode',{tline(22:25)},'rIdCode',{strtrim(tline(32:70))});
            else
                PDB_struct.Obsolete.rIdCode = strvcat(PDB_struct.Obsolete.rIdCode,strtrim(tline(32:70))); %#ok
            end

        %Single Continued/Mandatory
        case 'TITLE'
            if strcmp(tline(9:10),'  ') %check for continuation
                PDB_struct.Title = strtrim(tline(11:70));
            else
                PDB_struct.Title = strvcat(PDB_struct.Title,strtrim(tline(11:70))); %#ok
            end

        %Single Continued/Optional
        case 'CAVEAT'
            if strcmp(tline(9:10),'  ') %check for continuation
                PDB_struct.Caveat =  struct('idCode',{tline(12:15)},'comment',{strtrim(tline(20:70))});
            else
                PDB_struct.Caveat.comment = strvcat(PDB_struct.Caveat.comment,strtrim(tline(20:70))); %#ok
            end

        %Single Continued/Mandatory
        case 'COMPND'
            if strcmp(tline(9:10),'  ') %check for continuation
                PDB_struct.Compound = strtrim(tline(11:70));
            else
                PDB_struct.Compound = strvcat(PDB_struct.Compound,strtrim(tline(11:70))); %#ok
            end

        %Single Continued/Mandatory
        case 'SOURCE'
            if strcmp(tline(9:10),'  ') %check for continuation
                PDB_struct.Source = strtrim(tline(11:70));
            else
                PDB_struct.Source = strvcat(PDB_struct.Source,strtrim(tline(11:70))); %#ok
            end
            
        %Single Continued/Mandatory
        case 'KEYWDS'
            if strcmp(tline(9:10),'  ') %check for continuation
                PDB_struct.Keywords = strtrim(tline(11:70));
            else
                PDB_struct.Keywords = strvcat(PDB_struct.Keywords,strtrim(tline(11:70))); %#ok
            end

        %Single Continued/Mandatory
        case 'EXPDTA'
            if strcmp(tline(9:10),'  ') %check for continuation
                PDB_struct.ExperimentData = strtrim(tline(11:70));
            else
                PDB_struct.ExperimentData = strvcat(PDB_struct.ExperimentData,strtrim(tline(11:70))); %#ok
            end

        %Single Continued/Mandatory
        case 'AUTHOR'
            if strcmp(tline(9:10),'  ') %check for continuation
                PDB_struct.Authors = strtrim(tline(11:70));
            else
                PDB_struct.Authors = strvcat(PDB_struct.Authors,strtrim(tline(11:70))); %#ok
            end
            
        %Multiple/Mandatory
        case 'REVDAT'
            NumOfRevisionDate = NumOfRevisionDate+1;
            PDB_struct.RevisionDate(NumOfRevisionDate) = struct('modNum',{str2double(tline(8:10))},'modDate',{tline(14:22)},'modId',{tline(24:28)},...
                'modType',{str2double(tline(32))},'record',{strtrim(tline(40:66))});

        %Single Continued/Optional
        case 'SPRSDE'
            if strcmp(tline(9:10),'  ') %check for continuation
                PDB_struct.Superseded = struct('Supersededdate',{tline(12:20)},'idCode',{tline(22:25)},'sIdCode',{strtrim(tline(32:70))});
            else
                PDB_struct.Superseded.sIdCode = strvcat(PDB_struct.Superseded.sIdCode,strtrim(tline(32:70))); %#ok
            end

        %Other/Optional : This record has following sub-records: AUTH,TITL,EDIT,REF,PUBL,REFN
        case 'JRNL'
            SubRecord = tline(13:16);
            SubRecord = deblank(SubRecord); % Remove the trailing blanks. Needed for REF

            switch SubRecord

                case 'AUTH'
                    if ~JournalAuth
                        JournalAuth = 1;
                        PDB_struct.Journal(Journal_Entry) = struct('Author',{''},'Title',{''},'Editor',{''},'Reference',{''},'Publisher',{''},'CitationReference',{''});
                        PDB_struct.Journal(Journal_Entry).Author = strvcat(PDB_struct.Journal(Journal_Entry).Author,strtrim(tline(20:70))); %#ok
                    else
                        PDB_struct.Journal(Journal_Entry).Author = strvcat(PDB_struct.Journal(Journal_Entry).Author,strtrim(tline(20:70))); %#ok
                    end

                case 'TITL'
                    PDB_struct.Journal(Journal_Entry).Title = strvcat(PDB_struct.Journal(Journal_Entry).Title,strtrim(tline(20:70))); %#ok

                case 'EDIT'
                    PDB_struct.Journal(Journal_Entry).Editor = strvcat(PDB_struct.Journal(Journal_Entry).Editor,strtrim(tline(20:70))); %#ok

                case 'REF'
                    PDB_struct.Journal(Journal_Entry).Reference = strvcat(PDB_struct.Journal(Journal_Entry).Reference,strtrim(tline(20:70))); %#ok

                case 'PUBL'
                    PDB_struct.Journal(Journal_Entry).Publisher = strvcat(PDB_struct.Journal(Journal_Entry).Publisher,strtrim(tline(20:70))); %#ok

                case 'REFN'
                    PDB_struct.Journal(Journal_Entry).CitationReference = strvcat(PDB_struct.Journal(Journal_Entry).CitationReference,strtrim(tline(20:70))); %#ok
                    Journal_Entry = Journal_Entry+1; % REFN is the last subrecord and it is a single line record
                    JournalAuth = 0;

                otherwise
                    %disp('Invalid subrecord type');
            end

            %  PDB_struct.Journal.NumJournals = Journal_Entry-1;

        % Some of the Remark records are mandatory and some are optional
        case 'REMARK'
            RemarkNo = str2double(tline(7:10));

            %Other/Optional
            if RemarkNo == 1
                CurRemark = RemarkNo;
                if CurRemark ~= PrevRemark
                    PDB_struct.Remark1 = '';
                    PrevRemark = CurRemark;
                end
                if strcmp(tline(12:20),'REFERENCE')
                    PDB_struct.Remark1.NumJournals = str2double(tline(22:70));
                    PDB_struct.Remark1.JournalEntry(PDB_struct.Remark1.NumJournals) = struct('Author',{''},'Title',{''},'Editor',{''},'Reference',{''},'Publisher',{''},'CitationReference',{''});
                else
                    SubRecord = tline(13:16);
                    SubRecord = deblank(SubRecord); % Remove the trailing blanks. Needed for REF

                    switch SubRecord

                        case 'AUTH'
                            PDB_struct.Remark1.JournalEntry(PDB_struct.Remark1.NumJournals).Author = strvcat(PDB_struct.Remark1.JournalEntry(PDB_struct.Remark1.NumJournals).Author,... 
                                strtrim(tline(20:70))); %#ok

                        case 'TITL'
                            PDB_struct.Remark1.JournalEntry(PDB_struct.Remark1.NumJournals).Title = strvcat(PDB_struct.Remark1.JournalEntry(PDB_struct.Remark1.NumJournals).Title,...
                                strtrim(tline(20:70)));  %#ok

                        case 'EDIT'
                            PDB_struct.Remark1.JournalEntry(PDB_struct.Remark1.NumJournals).Editor = strvcat(PDB_struct.Remark1.JournalEntry(PDB_struct.Remark1.NumJournals).Editor,...
                                strtrim(tline(20:70)));  %#ok

                        case 'REF'
                            PDB_struct.Remark1.JournalEntry(PDB_struct.Remark1.NumJournals).Reference = strvcat(PDB_struct.Remark1.JournalEntry(PDB_struct.Remark1.NumJournals).Reference,...
                                strtrim(tline(20:70)));  %#ok

                        case 'PUBL'
                            PDB_struct.Remark1.JournalEntry(PDB_struct.Remark1.NumJournals).Publisher = strvcat(PDB_struct.Remark1.JournalEntry(PDB_struct.Remark1.NumJournals).Publisher,...
                                strtrim(tline(20:70)));  %#ok

                        case 'REFN'
                            PDB_struct.Remark1.JournalEntry(PDB_struct.Remark1.NumJournals).CitationReference = strvcat(PDB_struct.Remark1.JournalEntry(PDB_struct.Remark1.NumJournals).CitationReference,...
                                strtrim(tline(20:70)));  %#ok

                        otherwise
                            %disp('Invalid subrecord type');
                    end

                end

            % Other/Mandatory
            elseif RemarkNo == 2
                CurRemark = RemarkNo;
                if CurRemark ~= PrevRemark
                    PDB_struct.Remark2 = '';
                    PrevRemark = CurRemark;
                end
                if strcmp(tline(12:22),'RESOLUTION.')

                    if strcmp(tline(29:38),'ANGSTROMS.')
                        PDB_struct.Remark2.Resolution = str2double(tline(23:27));
                    else
                        PDB_struct.Remark2.Detail = strtrim(tline(12:70)); %#ok
                    end

                else
                    if isequal(tline(12:22),blanks(11))
                        PDB_struct.Remark2.Detail = '';
                    else
                        PDB_struct.Remark2.Detail = strvcat(PDB_struct.Remark2.Detail, strtrim(tline(12:70)));  %#ok
                    end
                end
                PDB_struct.Remark3.Refinement = '';

            % Other/Mandatory:  Following code assumes a single occurance of the Remark3 record type
            elseif RemarkNo == 3
                CurRemark = RemarkNo;
                if CurRemark ~= PrevRemark
                    PDB_struct.Remark3.Refinement = '';
                    PrevRemark = CurRemark;
                else
                    PDB_struct.Remark3.Refinement = strvcat(PDB_struct.Remark3.Refinement,strtrim(tline(12:70))); %#ok
                end
                
            % Other/Optional    
            else
                CurRemark = RemarkNo;
                tmpRemark = sprintf('%d',CurRemark);

                if CurRemark ~= PrevRemark
                    PDB_struct.(['Remark' tmpRemark]) = tline(12:70);
                    PrevRemark = CurRemark;
                else
                    PDB_struct.(['Remark' tmpRemark])  = ...
                        strvcat(PDB_struct.(['Remark' tmpRemark]) ,tline(12:70)); %#ok
                end


            end

        %Multiple/Optional
        case 'DBREF'
            NumOfDBReferences = NumOfDBReferences+1;
            PDB_struct.DBReferences(NumOfDBReferences) = struct('idCode',{tline(8:11)},'chainID',{tline(13)},'seqBegin',{str2double(tline(15:18))},...
                'insertBegin',{tline(19)},'seqEnd',{str2double(tline(21:24))},'insertEnd',{tline(25)},'database',{tline(27:32)},...
                'dbAccession',{tline(34:41)},'dbIdCode',{tline(43:54)},'dbseqBegin',{str2double(tline(56:60))},'idbnsBeg',{tline(61)},...
                'dbseqEnd',{str2double(tline(63:67))},'dbinsEnd',{tline(68)});
            %Multiple/Optional
        case 'SEQADV'
            NumOfSequenceConflicts = NumOfSequenceConflicts+1;
            PDB_struct.SequenceConflicts(NumOfSequenceConflicts) = struct('idCode',{tline(8:11)},'resName',{tline(13:15)},'chainID',{tline(17)},'seqNum',{str2double(tline(19:22))},...
                'iCode',{tline(23)},'database',{tline(25:28)},'dbIdCode',{tline(30:38)},'dbRes',{tline(40:42)},'dbSeq',{str2double(tline(44:48))},...
                'conflict',{strtrim(tline(50:70))});
            %Multiple/Optional
        case 'SEQRES'

            if isspace(tline(12))
                CurRes = sprintf('%d',str2double(tline(14:17)));
            else
                CurRes = tline(12);
            end

            if ~isequal(CurRes,PrevRes)
                NumResChain = NumResChain + 1;
                PDB_struct.Sequence(NumResChain).NumOfResidues = str2double(tline(14:17));
                PDB_struct.Sequence(NumResChain).ChainID = tline(12);
                PDB_struct.Sequence(NumResChain).ResidueNames = tline(20:70);
                PDB_struct.Sequence(NumResChain).Sequence = strtrim(GetSequence(tline(20:70)));
                PrevRes = CurRes;
            else
                PDB_struct.Sequence(NumResChain).ResidueNames = strcat(PDB_struct.Sequence(NumResChain).ResidueNames,[' ',tline(20:70)]);
                PDB_struct.Sequence(NumResChain).Sequence = strcat(PDB_struct.Sequence(NumResChain).Sequence,GetSequence(tline(20:70)));
            end

        %Multiple/Optional
        case 'MODRES'
            NumOfModifiedResidues = NumOfModifiedResidues+1;
            PDB_struct.ModifiedResidues(NumOfModifiedResidues) = struct('idCode',{tline(8:11)},'resName',{tline(13:15)},'chainID',{tline(17)},'seqNum',{str2double(tline(19:22))},...
                'iCode',{tline(23)},'stdRes',{tline(25:27)},'comment',{strtrim(tline(30:70))});

        %Multiple/Optional
        case 'HET'
            NumOfHeterogen = NumOfHeterogen +1;
            PDB_struct.Heterogen(NumOfHeterogen) = struct('hetID',{tline(8:10)},'ChainID',{tline(13)},'seqNum',{str2double(tline(14:17))},'iCode',{tline(18)},...
                'numHetAtoms',{str2double(tline(21:25))},'text',{strtrim(tline(31:70))});

        %Multiple Continued/Optional
        case 'HETNAM'
            CurHetIDHeterogenName = tline(12:14);

            if ~strcmp(CurHetIDHeterogenName,PrevHetIDHeterogenName)
                NumOfHeterogenName = NumOfHeterogenName + 1;
                PDB_struct.HeterogenName(NumOfHeterogenName).hetID = CurHetIDHeterogenName;
                PDB_struct.HeterogenName(NumOfHeterogenName).ChemName = strtrim(tline(16:70));
                PrevHetIDHeterogenName = CurHetIDHeterogenName;
            else
                PDB_struct.HeterogenName(NumOfHeterogenName).ChemName = strvcat(PDB_struct.HeterogenName(NumOfHeterogenName).ChemName,strtrim(tline(16:70))); %#ok
            end

        %Multiple/Optional
        case 'HETSYN'
            CurHetIDHeterogenSynonym = tline(12:14);

            if ~strcmp(CurHetIDHeterogenSynonym,PrevHetIDHeterogenSynonym)
                NumOfHeterogenSynonym = NumOfHeterogenSynonym+1;
                PDB_struct.HeterogenSynonym(NumOfHeterogenSynonym).hetID = CurHetIDHeterogenSynonym;
                PDB_struct.HeterogenSynonym(NumOfHeterogenSynonym).hetSynonyms = {strtrim(tline(16:70))};
                PrevHetIDHeterogenSynonym = CurHetIDHeterogenSynonym;
            else
                PDB_struct.HeterogenSynonym(NumOfHeterogenSynonym).hetSynonyms = strvcat(PDB_struct.HeterogenSynonym(NumOfHeterogenSynonym).hetSynonyms,strtrim(tline(16:70))); %#ok
            end

        %Multiple Continued/Optional
        case 'FORMUL'
            CurHetIDFormula = tline(13:15);

            if ~strcmp(CurHetIDFormula,PrevHetIDFormula)
                NumOfFormula = NumOfFormula+1;
                PDB_struct.Formula(NumOfFormula).CompNo = str2double(tline(9:10));
                PDB_struct.Formula(NumOfFormula).hetID = tline(13:15);
                PDB_struct.Formula(NumOfFormula).ChemForm = strtrim(tline(19:70));
                PrevHetIDFormula = CurHetIDFormula;
            else
                PDB_struct.Formula(NumOfFormula).ChemForm = strvcat(PDB_struct.Formula(NumOfFormula).ChemForm,strtrim(tline(19:70))); %#ok
            end

        %Multiple/Optional
        case 'HELIX'
            NumOfHelix = NumOfHelix+1;
            PDB_struct.Helix(NumOfHelix) = struct('serNum',{str2double(tline(8:10))},'helixID',{tline(12:14)},'initResName',{tline(16:18)},...
                'initChainID',{tline(20)},'initSeqNum',{str2double(tline(22:25))},'initICode',{tline(26)},'endResName',{tline(28:30)},...
                'endChainID',{tline(32)},'endSeqNum',{str2double(tline(34:37))},'endICode',{tline(38)},'helixClass',{str2double(tline(39:40))},...
                'comment',{tline(41:70)},'length',{str2double(tline(72:76))});

        %Multiple/Optional
        case 'SHEET'
            NumOfSheet = NumOfSheet+1;
            PDB_struct.Sheet(NumOfSheet) = struct('strand',{str2double(tline(8:10))},'sheetID',{tline(12:14)},'numStrands',{str2double(tline(15:16))},...
                'initResName',{tline(18:20)},'initChainID',{tline(22)},'initSeqNum',{str2double(tline(23:26))},'initICode',{tline(27)},...
                'endResName',{tline(29:31)},'endChainID',{tline(33)},'endSeqNum',{str2double(tline(34:37))},'endICode',{tline(38)},...
                'sense',{str2double(tline(39:40))},'curAtom',{tline(42:45)},'curResName',{tline(46:48)},'curChainId',{tline(50)},...
                'curResSeq',{str2double(tline(51:54))},'curICode',{tline(55)},'prevAtom',{tline(57:60)},'prevResName',{tline(61:63)},...
                'prevChainId',{tline(65)},'prevResSeq',{str2double(tline(66:69))},'prevICode',{tline(70)});


        %Multiple/Optional
        case 'TURN'
            NumOfTurn = NumOfTurn+1;
            PDB_struct.Turn(NumOfTurn) = struct('seq',{str2double(tline(8:10))},'turnId',{tline(12:14)},'initResName',{tline(16:18)},'initSeqNum',{str2double(tline(21:24))},...
                'initICode',{tline(25)},'endResName',{tline(27:29)},'endSeqNum',{str2double(tline(32:35))},'endICode',{tline(36)},'comment',{tline(41:70)});

        %Multiple/Optional
        case 'SSBOND'
            NumOfSSBond = NumOfSSBond+1;
            PDB_struct.SSBond(NumOfSSBond) = struct('serNum',{str2double(tline(8:10))},'resName1',{tline(12:14)},'chainID1',{tline(16)},'seqNum1',{str2double(tline(18:21))},...
                'icode1',{tline(22)},'resName2',{tline(26:28)},'chainID2',{tline(30)},'seqNum2',{str2double(tline(32:35))},...
                'icode2',{tline(36)},'sym1',{tline(60:65)},'sym2',{tline(67:72)});

        %Multiple/Optional
        case 'LINK'
            NumOfLink = NumOfLink+1;
            PDB_struct.Link(NumOfLink) = struct('remove1',{tline(13:16)},'altLoc1',{tline(17)},'resName1',{tline(18:20)},'chainID1',{tline(22)},...
                'resSeq1',{str2double(tline(23:26))},'iCode1',{tline(27)},'AtomName2',{tline(43:46)},'altLoc2',{tline(47)},'resName2',{tline(48:50)},...
                'chainID2',{tline(52)},'resSeq2',{str2double(tline(53:56))},'iCode2',{tline(57)},'sym1',{tline(60:65)},'sym2',{tline(67:72)});


        %Multiple/Optional
        case 'HYDBND'
            NumOfHydrogenBond = NumOfHydrogenBond+1;
            PDB_struct.HydrogenBond(NumOfHydrogenBond) = struct('AtomName1',{tline(13:16)},'altLoc1',{tline(17)},'resName1',{tline(18:20)},'Chain1',{tline(22)},...
                'resSeq1',{str2double(tline(23:27))},'ICode1',{tline(28)},'nameH',{tline(30:33)},'altLocH',{tline(34)},'ChainH',{tline(36)},...
                'resSeqH',{str2double(tline(37:41))},'iCodeH',{tline(42)},'name2',{tline(44:47)},'altLoc2',{tline(48)},'resName2',{tline(49:51)},...
                'chainID2',{tline(53)},'resSeq2',{str2double(tline(54:58))},'iCode2',{tline(59)},'sym1',{tline(60:65)},'sym2',{tline(67:72)});

        %Multiple/Optional
        case 'SLTBRG'
            NumOfSaltBridge = NumOfSaltBridge+1;
            PDB_struct.SaltBridge(NumOfSaltBridge) = struct('AtomName1',{tline(13:16)},'altLoc1',{tline(17)},'resName1',{tline(18:20)},'chainID1',{tline(22)},...
                'resSeq1',{str2double(tline(23:26))},'iCode1',{tline(27)},'AtomName2',{tline(43:46)},'altLoc2',{tline(47)},'resName2',{tline(48:50)},...
                'chainID2',{tline(52)},'resSeq2',{str2double(tline(53:56))},'iCode2',{tline(57)},'sym1',{tline(60:65)},'sym2',{tline(67:72)});

        %Multiple/Optional
        case 'CISPEP'
            NumOfCISPeptides = NumOfCISPeptides+1;
            PDB_struct.CISPeptides(NumOfCISPeptides) = struct('serNum',{str2double(tline(8:10))},'ResName1',{tline(12:14)},'chainID1',{tline(16)},'seqNum1',{str2double(tline(18:21))},...
                'icode1',{tline(22)},'ResName2',{tline(26:28)},'chainID2',{tline(30)},'seqNum2',{tline(32:35)},'icode2',{tline(36)},...
                'modNum',{str2double(tline(44:46))},'measure',{str2double(tline(54:59))});

        %Multiple/Optional
        case 'SITE'
            CurSiteName = tline(12:14);

            if ~strcmp(CurSiteName,PrevSiteName)
                ResNos = 0;
                PDB_struct.Site.SiteNumber = PDB_struct.Site.SiteNumber+1;
                PDB_struct.Site.SiteDetail(PDB_struct.Site.SiteNumber).SiteName = strtrim(tline(12:14));
                PDB_struct.Site.SiteDetail(PDB_struct.Site.SiteNumber).NumRes = str2double(tline(16:17));
                [PDB_struct.Site.SiteDetail(PDB_struct.Site.SiteNumber).ResDet ResNos] = GetResidueStruct(TmpStruct,tline(19:61),ResNos);
                PrevSiteName = CurSiteName;
            else
                [PDB_struct.Site.SiteDetail(PDB_struct.Site.SiteNumber).ResDet ResNos] = GetResidueStruct(PDB_struct.Site.SiteDetail(PDB_struct.Site.SiteNumber).ResDet,...
                    tline(19:61),ResNos);
            end

        %Single/Mandatory
        case 'CRYST1' %Fields in this record: Header(record name), a,b,c (all 3 in Angstrom),alpha,beta,gamma(all 3 in degrees),sGroup,z
            PDB_struct.Cryst1=struct('a',{str2double(tline(7:15))},'b',{str2double(tline(16:24))},'c',{str2double(tline(25:33))},...
                'alpha',{str2double(tline(34:40))},'beta',{str2double(tline(41:47))},'gamma',{str2double(tline(48:54))},...
                'sGroup',{tline(56:66)},'z',{str2double(tline(67:70))});

        %Single/Mandatory
        case 'ORIGX' %Fields in this record: Header(record name), O[n][1](O11), O[n][2](O12), O[n][3](O13), T[n](T1)
            OrigNum = str2double(tline(6));
            PDB_struct.OriginX(OrigNum).On1 = str2double(tline(11:20));
            PDB_struct.OriginX(OrigNum).On2 = str2double(tline(21:30));
            PDB_struct.OriginX(OrigNum).On3 = str2double(tline(31:40));
            PDB_struct.OriginX(OrigNum).Tn = str2double(tline(46:55));

        %Single/Mandatory
        case 'SCALE'
            ScaleNum = str2double(tline(6));
            PDB_struct.Scale(ScaleNum).Sn1 = str2double(tline(11:20));
            PDB_struct.Scale(ScaleNum).Sn2 = str2double(tline(21:30));
            PDB_struct.Scale(ScaleNum).Sn3 = str2double(tline(31:40));
            PDB_struct.Scale(ScaleNum).Un = str2double(tline(46:55));

        %Single/Optional: Mandatory if the complete unit must be generated from the given coordinates using non-crystallographic symmetry
        case 'MTRIX'
            Matrix_num = str2double(tline(6));
            PDB_struct.Matrix(Matrix_num).SerNo = str2double(tline(8:10));
            PDB_struct.Matrix(Matrix_num).Mn1 = str2double(tline(11:20));
            PDB_struct.Matrix(Matrix_num).Mn2 = str2double(tline(21:30));
            PDB_struct.Matrix(Matrix_num).Mn3 = str2double(tline(31:40));
            PDB_struct.Matrix(Matrix_num).Vn = str2double(tline(46:55));
            PDB_struct.Matrix(Matrix_num).iGiven = str2double(tline(60));

        %Multiple/Optional
        case 'TVECT'
            NumOfTranslationVector = NumOfTranslationVector+1;
            PDB_struct.TranslationVector(NumOfTranslationVector) = struct('SerNo',{str2double(tline(8:10))},'t1',{str2double(tline(11:20))},'t2',{str2double(tline(21:30))},...
                't3',{str2double(tline(31:40))},'text',{tline(41:70)});

        % Group/Optional
        case 'MODEL'
            NumOfModel = NumOfModel+1;
            PDB_struct.Model(NumOfModel) = struct('MDLSerNo',{str2double(tline(11:14))});
 
        %Multiple/Optional
        case 'ATOM'
            if NumOfAtom == 0
                PDB_struct.Atom(totalNumberOfAtoms) = allocateAtoms;
            end
            NumOfAtom = NumOfAtom+1;
            PDB_struct.Atom(NumOfAtom) = struct('AtomSerNo',{str2int(tline(7:11))},'AtomName',{strtrim(tline(13:16))},'altLoc',{strtrim(tline(17))},...
                'resName',{strtrim(tline(18:20))},...
                'chainID',{tline(22)},'resSeq',{str2int(tline(23:26))},'iCode',{strtrim(tline(27))},'X',{str2float(tline(31:38))},...
                'Y',{str2float(tline(39:46))},'Z',{str2float(tline(47:54))},'occupancy',{str2int(tline(55:60))},'tempFactor',{str2float(tline(61:66))},...
                'segID',{tline(73:76)},'element',{strtrim(tline(77:78))},'charge',{tline(79:80)});

        %Multiple/Optional
        case 'SIGATM'
            NumOfAtomSD = NumOfAtomSD+1;
            PDB_struct.AtomSD(NumOfAtomSD) = struct('AtomSerNo',{str2double(tline(7:11))},'AtomName',{tline(13:16)},'altLoc',{tline(17)},'resName',{tline(18:20)},...
                'chainID',{tline(22)},'resSeq',{str2double(tline(23:26))},'iCode',{tline(27)},'sigX',{str2double(tline(31:38))},...
                'sigY',{str2double(tline(39:46))},'sigZ',{str2double(tline(47:54))},'sigOcc',{str2double(tline(55:60))},'sigTemp',{str2double(tline(61:66))},...
                'segID',{tline(73:76)},'element',{tline(77:78)},'charge',{tline(79:80)});

        %Multiple/Optional
        case 'ANISOU'
            NumOfAnisotropicTemp = NumOfAnisotropicTemp+1;
            PDB_struct.AnisotropicTemp(NumOfAnisotropicTemp) = struct('AtomSerNo',{str2double(tline(7:11))},'AtomName',{tline(13:16)},'altLoc',{tline(17)},'resName',{tline(18:20)},...
                'chainID',{tline(22)},'resSeq',{str2double(tline(23:26))},'iCode',{tline(27)},'U00',{str2double(tline(29:35))},'U11',{str2double(tline(36:42))},...
                'U22',{str2double(tline(43:49))},'U01',{str2double(tline(50:56))},'U02',{str2double(tline(57:63))},'U12',{str2double(tline(64:70))},...
                'segID',{tline(73:76)},'element',{tline(77:78)},'charge',{tline(79:80)});

        %Multiple/Optional
        case 'SIGUIJ'
            NumOfAnisotropicTempSD = NumOfAnisotropicTempSD+1;
            PDB_struct.AnisotropicTempSD(NumOfAnisotropicTempSD) = struct('AtomSerNo',{str2double(tline(7:11))},'AtomName',{tline(13:16)},'altLoc',{tline(17)},'resName',{tline(18:20)},...
                'chainID',{tline(22)},'resSeq',{str2double(tline(23:26))},'iCode',{tline(27)},'SIG11',{str2double(tline(29:35))},'SIG22',{str2double(tline(36:42))},...
                'SIG33',{str2double(tline(43:49))},'SIG12',{str2double(tline(50:56))},'SIG13',{str2double(tline(57:63))},'SIG23',{str2double(tline(64:70))},...
                'segID',{tline(73:76)},'element',{tline(77:78)},'charge',{tline(79:80)});

        % Group/Optional
        case 'TER'
            NumOfTerminal = NumOfTerminal + 1;
            PDB_struct.Terminal(NumOfTerminal) = struct('SerialNo',{str2double(tline(7:11))},'resName',{strtrim(tline(18:20))},'chainID',{strtrim(tline(22))},'resSeq',{str2double(tline(23:26))},...
                'iCode',{strtrim(tline(27))});


        %Multiple Continued/Optional
        case 'HETATM'
            if NumOfHeterogenAtom == 0
                PDB_struct.HeterogenAtom(totalNumberOfHetAtoms) = allocateAtoms;
            end
            NumOfHeterogenAtom = NumOfHeterogenAtom+1;
            PDB_struct.HeterogenAtom(NumOfHeterogenAtom) = struct('AtomSerNo',{str2int(tline(7:11))},'AtomName',{strtrim(tline(13:16))},'altLoc',{strtrim(tline(17))},'resName',{strtrim(tline(18:20))},...
                'chainID',{tline(22)},'resSeq',{str2double(tline(23:26))},'iCode',{strtrim(tline(27))},'X',{str2double(tline(31:38))},...
                'Y',{str2double(tline(39:46))},'Z',{str2double(tline(47:54))},'occupancy',{str2double(tline(55:60))},'tempFactor',{str2double(tline(61:66))},...
                'segID',{tline(73:76)},'element',{strtrim(tline(77:78))},'charge',{tline(79:80)});

        % Group/Optional
        case 'ENDMDL'
            % End of model
            
        %Multiple/Optional
        case 'CONECT'
            NumOfConnectivity = NumOfConnectivity+1;
            temp_a = str2double(tline(7:11));
            temp_b = GetAtomList(tline(12:31));
            temp_c = GetAtomList([tline(32:41) char(32) tline(47:56)]);
            temp_d = GetAtomList([tline(42:46) char(32) tline(57:61)]);
            PDB_struct.Connectivity (NumOfConnectivity) = struct('AtomSerNo',{temp_a},'BondAtomList',{temp_b},'HydrogenAtomList',{temp_c},...
                'SaltBridgeAtom',{temp_d});

        %Single/Mandatory
        case 'MASTER'
            % PDB_struct.Master = struct('numREMARK',{str2double(tline(11:15))},'numHET',{str2double(tline(21:25))},'numHelix',{str2double(tline(26:30))},...
            %     'numSheet',{str2double(tline(31:35))},'numTurn',{str2double(tline(36:40))},'numSite',{str2double(tline(41:45))},'numXform',{str2double(tline(46:50))},...
            %     'numCoord',{str2double(tline(51:55))},'numTer',{str2double(tline(56:60))},'numConect',{str2double(tline(61:65))},'numSeq',{str2double(tline(66:70))});

        %Single/Mandatory
        case 'END'
            % Found end of file

        %Multiple/Optional
        case 'FTNOTE'
            FtnoteNo = str2double(tline(7:10));
            CurFtnote = FtnoteNo;
            tmpFtnote = sprintf('%d',CurFtnote);
            
            if CurFtnote ~= PrevFtnote
                PDB_struct.(['Footnote' tmpFtnote]) = tline(12:70);
                PrevFtnote = CurFtnote;
            else
                PDB_struct.(['Footnote' tmpFtnote])  = ...
                    strvcat(PDB_struct.(['Footnote' tmpFtnote]) ,tline(12:70)); %#ok
            end

        otherwise
            %disp('The file contains invalid record type');

    end % for the SWITCH statement

end % for the WHILE loop

% clean up unneeded Atom structs.
PDB_struct.Atom(NumOfAtom+1:end) = [];
if NumOfHeterogenAtom > 0
    PDB_struct.HeterogenAtom(NumOfHeterogenAtom+1:end) = [];
end

fclose(fid);

if useTempFile
    delete(filename);
end


function OutList = GetAtomList(InString)
str = strtrim(InString);
OutList = [];
if ~isempty(str)
    try
        OutList = strread(str,'%d')';
    catch
        OutList = [];
    end
end
function OutAcid = GetSequence(InAcid)
if isnt(InAcid(~isspace(InAcid)))
    OutAcid = InAcid(~isspace(InAcid));
    return
end
OutAcid = strrep(upper(InAcid),'ALA','a');
OutAcid = strrep(OutAcid,'ARG','r');
OutAcid = strrep(OutAcid,'ASN','n');
OutAcid = strrep(OutAcid,'ASP','d');
OutAcid = strrep(OutAcid,'ASX','b');
OutAcid = strrep(OutAcid,'CYS','c');
OutAcid = strrep(OutAcid,'GLN','q');
OutAcid = strrep(OutAcid,'GLU','e');
OutAcid = strrep(OutAcid,'GLX','z');
OutAcid = strrep(OutAcid,'GLY','g');
OutAcid = strrep(OutAcid,'HIS','h');
OutAcid = strrep(OutAcid,'ILE','i');
OutAcid = strrep(OutAcid,'LEU','l');
OutAcid = strrep(OutAcid,'LYS','k');
OutAcid = strrep(OutAcid,'MET','m');
OutAcid = strrep(OutAcid,'PHE','f');
OutAcid = strrep(OutAcid,'PRO','p');
OutAcid = strrep(OutAcid,'SER','s');
OutAcid = strrep(OutAcid,'THR','t');
OutAcid = strrep(OutAcid,'TRP','w');
OutAcid = strrep(OutAcid,'TYR','y');
OutAcid = strrep(OutAcid,'VAL','v');
OutAcid = strrep(OutAcid,'UNK','x');
OutAcid = regexprep(OutAcid,'[A-Z][A-Z][A-Z]','?');
OutAcid = upper(OutAcid(~isspace(OutAcid)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [OutStruct,OutNum] = GetResidueStruct(TmpStruct,InString,InNum)

a=1; b=10;
Count = 0;
sz = size(InString);

while b <= sz(2)
    test_str = strtrim(InString(a:b));
    InNum = InNum + 1;
    while size(test_str)>0
        [token,rem] = strtok(test_str); %#ok
        token = strtrim(token);
        rem = strtrim(rem);
        Count = Count + 1;

        if Count==1
            TmpStruct(InNum).ResName = {token};
        elseif Count==2
            TmpStruct(InNum).ChainID = {token};
        elseif Count==3
            TmpStruct(InNum).ResSeqNo = {str2double(token)};
        else
            TmpStruct(InNum).InsCode = {token};
        end

        test_str = rem;
    end
    a=a+11;
    b=b+11;
    Count = 0;
end

OutNum = InNum;
OutStruct = TmpStruct;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function filename = savetempfile(pdbtext)

filename =  [tempname '.spt'];
fid=fopen(filename,'wb');

rows = size(pdbtext,1);

for rcount=1:rows-1,
    fprintf(fid,'%s\n',pdbtext(rcount,:));
end

fprintf(fid,'%s',pdbtext(rows,:));
fclose(fid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function val = str2int(str)
val = sscanf(str,'%d');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function val = str2float(str)
val = sscanf(str,'%e');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Atom = allocateAtoms

Atom = struct('AtomSerNo',{0},'AtomName',{''},'altLoc',{''},...
    'resName',{''},...
    'chainID',{''},'resSeq',{0},'iCode',{''},'X',{0},...
    'Y',{0},'Z',{0},'occupancy',{0},'tempFactor',{0},...
    'segID',{''},'element',{''},'charge',{''});
