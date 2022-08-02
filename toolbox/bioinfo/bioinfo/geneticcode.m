function code = geneticcode(id)
%GENETICCODE returns a structure containing mappings for the genetic code.
%
%   MAP = GENETICCODE returns a structure containing mapping for the Standard
%   genetic code.
%
%   GENETICCODE(ID) returns a structure of the mapping for alternate genetic
%   codes, where ID is either the transl_table ID from the NCBI Genetics web
%   page (http://www.ncbi.nlm.nih.gov/Taxonomy/Utils/wprintgc.cgi?mode=c)
%   or one of the following supported names. NAME can be truncated to the
%   first two characters of the name.
%
%   ID  Name
%
% 	1	Standard
% 	2	Vertebrate Mitochondrial
% 	3	Yeast Mitochondrial
% 	4	Mold, Protozoan, and Coelenterate Mitochondrial and Mycoplasma/Spiroplasma
% 	5	Invertebrate Mitochondrial
% 	6	Ciliate, Dasycladacean and Hexamita Nuclear
% 	9	Echinoderm Mitochondrial
% 	10	Euplotid Nuclear
% 	11	Bacterial and Plant Plastid
% 	12	Alternative Yeast Nuclear
% 	13	Ascidian Mitochondrial
% 	14	Flatworm Mitochondrial
% 	15	Blepharisma Nuclear
% 	16	Chlorophycean Mitochondrial
% 	21	Trematode Mitochondrial
% 	22	Scenedesmus Obliquus Mitochondrial
% 	23	Thraustochytrium Mitochondrial
%
%   Examples:
%
%       moldcode = geneticcode(4)
%       wormcode = geneticcode('Flatworm Mitochondrial')
%
%   See also AA2NT, BASELOOKUP, NT2AA, REVGENETICCODE, SEQSHOWORFS.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.8.4.3 $  $Date: 2004/03/14 15:31:19 $

if nargin == 0
    id = 1;
end


if ischar(id)
    validcodes = {...  % use char(n) as place holder
            'Standard',... %1
            'Vertebrate Mitochondrial'  ,...    %2
            'Yeast Mitochondrial',...   %3
            'Mold, Protozoan, and Coelente rate Mitochondrial and Mycoplasma/Spiroplasma',... %4
            'Invertebrate Mitochondrial'  ,... %5
            'Ciliate, Dasycladacean and Hexamita Nuclear'  ,... %6
            char(7),... %7
            char(8),... %8
            'Echinoderm Mitochondrial'  ,... %9
            'Euplotid Nuclear'  ,... %10
            'Bacterial and Plant Plastid'  ,... %11
            'Alternative Yeast Nuclear'  ,... %12
            'Ascidian Mitochondrial'  ,... %13
            'Flatworm Mitochondrial'  ,... %14
            'Blepharisma Nuclear'  ,... %15
            'Chlorophycean Mitochondrial',... %16
            char(17),...  %17
            char(18),...  %18
            char(19),...  %19
            char(20),...  %20
            'Trematode Mitochondrial'  ,... %21
            'Scenedesmus Obliquus Mitochondrial',... %22
            'Thraustochytrium Mitochondrial'...  %23
        };
    codenum = strmatch(lower(id(1:min(2,numel(id)))),lower(validcodes));
    if isempty(codenum)
        error('Bioinfo:UnknownGeneticCodeName','Unknown code name: %s.',id);
    elseif length(codenum)>1
        error('Bioinfo:AmbiguousGeneticCodeName','Ambiguous code name: %s.',id);
    end
else
    
    codenum = id;
end
switch(codenum)
    
    case 1, %Standard
        % base1  = 'TTTTTTTTTTTTTTTTCCCCCCCCCCCCCCCCAAAAAAAAAAAAAAAAGGGGGGGGGGGGGGGG'
        % base2  = 'TTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGG'
        % base3  = 'TCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAG'
        % code   = 'FFLLSSSSYY**CC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG'
        % starts = '---M---------------M---------------M----------------------------'
        
        code.Name   = 'Standard';
        
        code.AAA = 'K';  code.AAC = 'N';  code.AAG = 'K';  code.AAT = 'N';
        code.ACA = 'T';  code.ACC = 'T';  code.ACG = 'T';  code.ACT = 'T';
        code.AGA = 'R';  code.AGC = 'S';  code.AGG = 'R';  code.AGT = 'S';
        code.ATA = 'I';  code.ATC = 'I';  code.ATG = 'M';  code.ATT = 'I';
        code.CAA = 'Q';  code.CAC = 'H';  code.CAG = 'Q';  code.CAT = 'H';
        code.CCA = 'P';  code.CCC = 'P';  code.CCG = 'P';  code.CCT = 'P';
        code.CGA = 'R';  code.CGC = 'R';  code.CGG = 'R';  code.CGT = 'R';
        code.CTA = 'L';  code.CTC = 'L';  code.CTG = 'L';  code.CTT = 'L';
        code.GAA = 'E';  code.GAC = 'D';  code.GAG = 'E';  code.GAT = 'D';
        code.GCA = 'A';  code.GCC = 'A';  code.GCG = 'A';  code.GCT = 'A';
        code.GGA = 'G';  code.GGC = 'G';  code.GGG = 'G';  code.GGT = 'G';
        code.GTA = 'V';  code.GTC = 'V';  code.GTG = 'V';  code.GTT = 'V';
        code.TAA = '*';  code.TAC = 'Y';  code.TAG = '*';  code.TAT = 'Y';
        code.TCA = 'S';  code.TCC = 'S';  code.TCG = 'S';  code.TCT = 'S';
        code.TGA = '*';  code.TGC = 'C';  code.TGG = 'W';  code.TGT = 'C';
        code.TTA = 'L';  code.TTC = 'F';  code.TTG = 'L';  code.TTT = 'F';
        
        code.Starts = { 'ATG','CTG','TTG'};
        
        
    case 2, %Vertebrate Mitochondrial
        % base1  = 'TTTTTTTTTTTTTTTTCCCCCCCCCCCCCCCCAAAAAAAAAAAAAAAAGGGGGGGGGGGGGGGG'
        % base2  = 'TTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGG'
        % base3  = 'TCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAG'
        % code   = 'FFLLSSSSYY**CCWWLLLLPPPPHHQQRRRRIIMMTTTTNNKKSS**VVVVAAAADDEEGGGG'
        % starts = '--------------------------------MMMM---------------M------------'
        
        code.Name   = 'Vertebrate Mitochondrial';
        
        code.AAA = 'K';  code.AAC = 'N';  code.AAG = 'K';  code.AAT = 'N';
        code.ACA = 'T';  code.ACC = 'T';  code.ACG = 'T';  code.ACT = 'T';
        code.AGA = '*';  code.AGC = 'S';  code.AGG = '*';  code.AGT = 'S';
        code.ATA = 'M';  code.ATC = 'I';  code.ATG = 'M';  code.ATT = 'I';
        code.CAA = 'Q';  code.CAC = 'H';  code.CAG = 'Q';  code.CAT = 'H';
        code.CCA = 'P';  code.CCC = 'P';  code.CCG = 'P';  code.CCT = 'P';
        code.CGA = 'R';  code.CGC = 'R';  code.CGG = 'R';  code.CGT = 'R';
        code.CTA = 'L';  code.CTC = 'L';  code.CTG = 'L';  code.CTT = 'L';
        code.GAA = 'E';  code.GAC = 'D';  code.GAG = 'E';  code.GAT = 'D';
        code.GCA = 'A';  code.GCC = 'A';  code.GCG = 'A';  code.GCT = 'A';
        code.GGA = 'G';  code.GGC = 'G';  code.GGG = 'G';  code.GGT = 'G';
        code.GTA = 'V';  code.GTC = 'V';  code.GTG = 'V';  code.GTT = 'V';
        code.TAA = '*';  code.TAC = 'Y';  code.TAG = '*';  code.TAT = 'Y';
        code.TCA = 'S';  code.TCC = 'S';  code.TCG = 'S';  code.TCT = 'S';
        code.TGA = 'W';  code.TGC = 'C';  code.TGG = 'W';  code.TGT = 'C';
        code.TTA = 'L';  code.TTC = 'F';  code.TTG = 'L';  code.TTT = 'F';
        
        code.Starts = {'ATG', 'ATA','ATC','ATT','GTG'};
        
        
    case 3, %Yeast Mitochondrial
        % base1  = 'TTTTTTTTTTTTTTTTCCCCCCCCCCCCCCCCAAAAAAAAAAAAAAAAGGGGGGGGGGGGGGGG'
        % base2  = 'TTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGG'
        % base3  = 'TCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAG'
        % code   = 'FFLLSSSSYY**CCWWTTTTPPPPHHQQRRRRIIMMTTTTNNKKSSRRVVVVAAAADDEEGGGG'
        % starts = '----------------------------------MM----------------------------'
        
        code.Name   = 'Yeast Mitochondrial';
        
        code.AAA = 'K';  code.AAC = 'N';  code.AAG = 'K';  code.AAT = 'N';
        code.ACA = 'T';  code.ACC = 'T';  code.ACG = 'T';  code.ACT = 'T';
        code.AGA = 'R';  code.AGC = 'S';  code.AGG = 'R';  code.AGT = 'S';
        code.ATA = 'M';  code.ATC = 'I';  code.ATG = 'M';  code.ATT = 'I';
        code.CAA = 'Q';  code.CAC = 'H';  code.CAG = 'Q';  code.CAT = 'H';
        code.CCA = 'P';  code.CCC = 'P';  code.CCG = 'P';  code.CCT = 'P';
        code.CGA = 'R';  code.CGC = 'R';  code.CGG = 'R';  code.CGT = 'R';
        code.CTA = 'T';  code.CTC = 'T';  code.CTG = 'T';  code.CTT = 'T';
        code.GAA = 'E';  code.GAC = 'D';  code.GAG = 'E';  code.GAT = 'D';
        code.GCA = 'A';  code.GCC = 'A';  code.GCG = 'A';  code.GCT = 'A';
        code.GGA = 'G';  code.GGC = 'G';  code.GGG = 'G';  code.GGT = 'G';
        code.GTA = 'V';  code.GTC = 'V';  code.GTG = 'V';  code.GTT = 'V';
        code.TAA = '*';  code.TAC = 'Y';  code.TAG = '*';  code.TAT = 'Y';
        code.TCA = 'S';  code.TCC = 'S';  code.TCG = 'S';  code.TCT = 'S';
        code.TGA = 'W';  code.TGC = 'C';  code.TGG = 'W';  code.TGT = 'C';
        code.TTA = 'L';  code.TTC = 'F';  code.TTG = 'L';  code.TTT = 'F';
        
        code.Starts = {'ATG', 'ATA'};
        
        
    case 4, %Mold, Protozoan, and Coelenterate Mitochondrial and Mycoplasma/Spiroplasma
        % base1  = 'TTTTTTTTTTTTTTTTCCCCCCCCCCCCCCCCAAAAAAAAAAAAAAAAGGGGGGGGGGGGGGGG'
        % base2  = 'TTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGG'
        % base3  = 'TCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAG'
        % code   = 'FFLLSSSSYY**CCWWLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG'
        % starts = '--MM---------------M------------MMMM---------------M------------'
        
        code.Name   = 'Mold, Protozoan, and Coelenterate Mitochondrial and Mycoplasma/Spiroplasma';
        
        code.AAA = 'K';  code.AAC = 'N';  code.AAG = 'K';  code.AAT = 'N';
        code.ACA = 'T';  code.ACC = 'T';  code.ACG = 'T';  code.ACT = 'T';
        code.AGA = 'R';  code.AGC = 'S';  code.AGG = 'R';  code.AGT = 'S';
        code.ATA = 'I';  code.ATC = 'I';  code.ATG = 'M';  code.ATT = 'I';
        code.CAA = 'Q';  code.CAC = 'H';  code.CAG = 'Q';  code.CAT = 'H';
        code.CCA = 'P';  code.CCC = 'P';  code.CCG = 'P';  code.CCT = 'P';
        code.CGA = 'R';  code.CGC = 'R';  code.CGG = 'R';  code.CGT = 'R';
        code.CTA = 'L';  code.CTC = 'L';  code.CTG = 'L';  code.CTT = 'L';
        code.GAA = 'E';  code.GAC = 'D';  code.GAG = 'E';  code.GAT = 'D';
        code.GCA = 'A';  code.GCC = 'A';  code.GCG = 'A';  code.GCT = 'A';
        code.GGA = 'G';  code.GGC = 'G';  code.GGG = 'G';  code.GGT = 'G';
        code.GTA = 'V';  code.GTC = 'V';  code.GTG = 'V';  code.GTT = 'V';
        code.TAA = '*';  code.TAC = 'Y';  code.TAG = '*';  code.TAT = 'Y';
        code.TCA = 'S';  code.TCC = 'S';  code.TCG = 'S';  code.TCT = 'S';
        code.TGA = 'W';  code.TGC = 'C';  code.TGG = 'W';  code.TGT = 'C';
        code.TTA = 'L';  code.TTC = 'F';  code.TTG = 'L';  code.TTT = 'F';
        
        code.Starts = {'ATG', 'ATA','ATC','ATT','CTG','GTG','TTA','TTG'};
        
        
    case 5, %Invertebrate Mitochondrial
        % base1  = 'TTTTTTTTTTTTTTTTCCCCCCCCCCCCCCCCAAAAAAAAAAAAAAAAGGGGGGGGGGGGGGGG'
        % base2  = 'TTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGG'
        % base3  = 'TCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAG'
        % code   = 'FFLLSSSSYY**CCWWLLLLPPPPHHQQRRRRIIMMTTTTNNKKSSSSVVVVAAAADDEEGGGG'
        % starts = '---M----------------------------MMMM---------------M------------'
        
        code.Name   = 'Invertebrate Mitochondrial';
        
        code.AAA = 'K';  code.AAC = 'N';  code.AAG = 'K';  code.AAT = 'N';
        code.ACA = 'T';  code.ACC = 'T';  code.ACG = 'T';  code.ACT = 'T';
        code.AGA = 'S';  code.AGC = 'S';  code.AGG = 'S';  code.AGT = 'S';
        code.ATA = 'M';  code.ATC = 'I';  code.ATG = 'M';  code.ATT = 'I';
        code.CAA = 'Q';  code.CAC = 'H';  code.CAG = 'Q';  code.CAT = 'H';
        code.CCA = 'P';  code.CCC = 'P';  code.CCG = 'P';  code.CCT = 'P';
        code.CGA = 'R';  code.CGC = 'R';  code.CGG = 'R';  code.CGT = 'R';
        code.CTA = 'L';  code.CTC = 'L';  code.CTG = 'L';  code.CTT = 'L';
        code.GAA = 'E';  code.GAC = 'D';  code.GAG = 'E';  code.GAT = 'D';
        code.GCA = 'A';  code.GCC = 'A';  code.GCG = 'A';  code.GCT = 'A';
        code.GGA = 'G';  code.GGC = 'G';  code.GGG = 'G';  code.GGT = 'G';
        code.GTA = 'V';  code.GTC = 'V';  code.GTG = 'V';  code.GTT = 'V';
        code.TAA = '*';  code.TAC = 'Y';  code.TAG = '*';  code.TAT = 'Y';
        code.TCA = 'S';  code.TCC = 'S';  code.TCG = 'S';  code.TCT = 'S';
        code.TGA = 'W';  code.TGC = 'C';  code.TGG = 'W';  code.TGT = 'C';
        code.TTA = 'L';  code.TTC = 'F';  code.TTG = 'L';  code.TTT = 'F';
        
        code.Starts = {'ATG', 'ATA','ATC','ATT','GTG','TTG'};
        
        
    case 6, %Ciliate, Dasycladacean and Hexamita Nuclear
        % base1  = 'TTTTTTTTTTTTTTTTCCCCCCCCCCCCCCCCAAAAAAAAAAAAAAAAGGGGGGGGGGGGGGGG'
        % base2  = 'TTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGG'
        % base3  = 'TCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAG'
        % code   = 'FFLLSSSSYYQQCC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG'
        % starts = '-----------------------------------M----------------------------'
        
        code.Name   = 'Ciliate, Dasycladacean and Hexamita Nuclear';
        
        code.AAA = 'K';  code.AAC = 'N';  code.AAG = 'K';  code.AAT = 'N';
        code.ACA = 'T';  code.ACC = 'T';  code.ACG = 'T';  code.ACT = 'T';
        code.AGA = 'R';  code.AGC = 'S';  code.AGG = 'R';  code.AGT = 'S';
        code.ATA = 'I';  code.ATC = 'I';  code.ATG = 'M';  code.ATT = 'I';
        code.CAA = 'Q';  code.CAC = 'H';  code.CAG = 'Q';  code.CAT = 'H';
        code.CCA = 'P';  code.CCC = 'P';  code.CCG = 'P';  code.CCT = 'P';
        code.CGA = 'R';  code.CGC = 'R';  code.CGG = 'R';  code.CGT = 'R';
        code.CTA = 'L';  code.CTC = 'L';  code.CTG = 'L';  code.CTT = 'L';
        code.GAA = 'E';  code.GAC = 'D';  code.GAG = 'E';  code.GAT = 'D';
        code.GCA = 'A';  code.GCC = 'A';  code.GCG = 'A';  code.GCT = 'A';
        code.GGA = 'G';  code.GGC = 'G';  code.GGG = 'G';  code.GGT = 'G';
        code.GTA = 'V';  code.GTC = 'V';  code.GTG = 'V';  code.GTT = 'V';
        code.TAA = 'Q';  code.TAC = 'Y';  code.TAG = 'Q';  code.TAT = 'Y';
        code.TCA = 'S';  code.TCC = 'S';  code.TCG = 'S';  code.TCT = 'S';
        code.TGA = '*';  code.TGC = 'C';  code.TGG = 'W';  code.TGT = 'C';
        code.TTA = 'L';  code.TTC = 'F';  code.TTG = 'L';  code.TTT = 'F';
        
        code.Starts = { 'ATG'};
        
        
    case 9, %Echinoderm Mitochondrial
        % base1  = 'TTTTTTTTTTTTTTTTCCCCCCCCCCCCCCCCAAAAAAAAAAAAAAAAGGGGGGGGGGGGGGGG'
        % base2  = 'TTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGG'
        % base3  = 'TCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAG'
        % code   = 'FFLLSSSSYY**CCWWLLLLPPPPHHQQRRRRIIIMTTTTNNNKSSSSVVVVAAAADDEEGGGG'
        % starts = '-----------------------------------M---------------M------------'
        
        code.Name   = 'Echinoderm Mitochondrial';
        
        code.AAA = 'N';  code.AAC = 'N';  code.AAG = 'K';  code.AAT = 'N';
        code.ACA = 'T';  code.ACC = 'T';  code.ACG = 'T';  code.ACT = 'T';
        code.AGA = 'S';  code.AGC = 'S';  code.AGG = 'S';  code.AGT = 'S';
        code.ATA = 'I';  code.ATC = 'I';  code.ATG = 'M';  code.ATT = 'I';
        code.CAA = 'Q';  code.CAC = 'H';  code.CAG = 'Q';  code.CAT = 'H';
        code.CCA = 'P';  code.CCC = 'P';  code.CCG = 'P';  code.CCT = 'P';
        code.CGA = 'R';  code.CGC = 'R';  code.CGG = 'R';  code.CGT = 'R';
        code.CTA = 'L';  code.CTC = 'L';  code.CTG = 'L';  code.CTT = 'L';
        code.GAA = 'E';  code.GAC = 'D';  code.GAG = 'E';  code.GAT = 'D';
        code.GCA = 'A';  code.GCC = 'A';  code.GCG = 'A';  code.GCT = 'A';
        code.GGA = 'G';  code.GGC = 'G';  code.GGG = 'G';  code.GGT = 'G';
        code.GTA = 'V';  code.GTC = 'V';  code.GTG = 'V';  code.GTT = 'V';
        code.TAA = '*';  code.TAC = 'Y';  code.TAG = '*';  code.TAT = 'Y';
        code.TCA = 'S';  code.TCC = 'S';  code.TCG = 'S';  code.TCT = 'S';
        code.TGA = 'W';  code.TGC = 'C';  code.TGG = 'W';  code.TGT = 'C';
        code.TTA = 'L';  code.TTC = 'F';  code.TTG = 'L';  code.TTT = 'F';
        
        code.Starts = { 'ATG','GTG'};
        
        
    case 10, %Euplotid Nuclear
        % base1  = 'TTTTTTTTTTTTTTTTCCCCCCCCCCCCCCCCAAAAAAAAAAAAAAAAGGGGGGGGGGGGGGGG'
        % base2  = 'TTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGG'
        % base3  = 'TCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAG'
        % code   = 'FFLLSSSSYY**CCCWLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG'
        % starts = '-----------------------------------M----------------------------'
        
        code.Name   = 'Euplotid Nuclear';
        
        code.AAA = 'K';  code.AAC = 'N';  code.AAG = 'K';  code.AAT = 'N';
        code.ACA = 'T';  code.ACC = 'T';  code.ACG = 'T';  code.ACT = 'T';
        code.AGA = 'R';  code.AGC = 'S';  code.AGG = 'R';  code.AGT = 'S';
        code.ATA = 'I';  code.ATC = 'I';  code.ATG = 'M';  code.ATT = 'I';
        code.CAA = 'Q';  code.CAC = 'H';  code.CAG = 'Q';  code.CAT = 'H';
        code.CCA = 'P';  code.CCC = 'P';  code.CCG = 'P';  code.CCT = 'P';
        code.CGA = 'R';  code.CGC = 'R';  code.CGG = 'R';  code.CGT = 'R';
        code.CTA = 'L';  code.CTC = 'L';  code.CTG = 'L';  code.CTT = 'L';
        code.GAA = 'E';  code.GAC = 'D';  code.GAG = 'E';  code.GAT = 'D';
        code.GCA = 'A';  code.GCC = 'A';  code.GCG = 'A';  code.GCT = 'A';
        code.GGA = 'G';  code.GGC = 'G';  code.GGG = 'G';  code.GGT = 'G';
        code.GTA = 'V';  code.GTC = 'V';  code.GTG = 'V';  code.GTT = 'V';
        code.TAA = '*';  code.TAC = 'Y';  code.TAG = '*';  code.TAT = 'Y';
        code.TCA = 'S';  code.TCC = 'S';  code.TCG = 'S';  code.TCT = 'S';
        code.TGA = 'C';  code.TGC = 'C';  code.TGG = 'W';  code.TGT = 'C';
        code.TTA = 'L';  code.TTC = 'F';  code.TTG = 'L';  code.TTT = 'F';
        
        code.Starts = { 'ATG'};
        
        
    case 11, %Bacterial and Plant Plastid
        % base1  = 'TTTTTTTTTTTTTTTTCCCCCCCCCCCCCCCCAAAAAAAAAAAAAAAAGGGGGGGGGGGGGGGG'
        % base2  = 'TTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGG'
        % base3  = 'TCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAG'
        % code   = 'FFLLSSSSYY**CC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG'
        % starts = '---M---------------M------------MMMM---------------M------------'
        
        code.Name   = 'Bacterial and Plant Plastid';
        
        code.AAA = 'K';  code.AAC = 'N';  code.AAG = 'K';  code.AAT = 'N';
        code.ACA = 'T';  code.ACC = 'T';  code.ACG = 'T';  code.ACT = 'T';
        code.AGA = 'R';  code.AGC = 'S';  code.AGG = 'R';  code.AGT = 'S';
        code.ATA = 'I';  code.ATC = 'I';  code.ATG = 'M';  code.ATT = 'I';
        code.CAA = 'Q';  code.CAC = 'H';  code.CAG = 'Q';  code.CAT = 'H';
        code.CCA = 'P';  code.CCC = 'P';  code.CCG = 'P';  code.CCT = 'P';
        code.CGA = 'R';  code.CGC = 'R';  code.CGG = 'R';  code.CGT = 'R';
        code.CTA = 'L';  code.CTC = 'L';  code.CTG = 'L';  code.CTT = 'L';
        code.GAA = 'E';  code.GAC = 'D';  code.GAG = 'E';  code.GAT = 'D';
        code.GCA = 'A';  code.GCC = 'A';  code.GCG = 'A';  code.GCT = 'A';
        code.GGA = 'G';  code.GGC = 'G';  code.GGG = 'G';  code.GGT = 'G';
        code.GTA = 'V';  code.GTC = 'V';  code.GTG = 'V';  code.GTT = 'V';
        code.TAA = '*';  code.TAC = 'Y';  code.TAG = '*';  code.TAT = 'Y';
        code.TCA = 'S';  code.TCC = 'S';  code.TCG = 'S';  code.TCT = 'S';
        code.TGA = '*';  code.TGC = 'C';  code.TGG = 'W';  code.TGT = 'C';
        code.TTA = 'L';  code.TTC = 'F';  code.TTG = 'L';  code.TTT = 'F';
        
        code.Starts = {'ATG', 'ATA','ATC','ATT','CTG','GTG','TTG'};
        
        
    case 12, %Alternative Yeast Nuclear
        % base1  = 'TTTTTTTTTTTTTTTTCCCCCCCCCCCCCCCCAAAAAAAAAAAAAAAAGGGGGGGGGGGGGGGG'
        % base2  = 'TTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGG'
        % base3  = 'TCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAG'
        % code   = 'FFLLSSSSYY**CC*WLLLSPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG'
        % starts = '-------------------M---------------M----------------------------'
        
        code.Name   = 'Alternative Yeast Nuclear';
        
        code.AAA = 'K';  code.AAC = 'N';  code.AAG = 'K';  code.AAT = 'N';
        code.ACA = 'T';  code.ACC = 'T';  code.ACG = 'T';  code.ACT = 'T';
        code.AGA = 'R';  code.AGC = 'S';  code.AGG = 'R';  code.AGT = 'S';
        code.ATA = 'I';  code.ATC = 'I';  code.ATG = 'M';  code.ATT = 'I';
        code.CAA = 'Q';  code.CAC = 'H';  code.CAG = 'Q';  code.CAT = 'H';
        code.CCA = 'P';  code.CCC = 'P';  code.CCG = 'P';  code.CCT = 'P';
        code.CGA = 'R';  code.CGC = 'R';  code.CGG = 'R';  code.CGT = 'R';
        code.CTA = 'L';  code.CTC = 'L';  code.CTG = 'S';  code.CTT = 'L';
        code.GAA = 'E';  code.GAC = 'D';  code.GAG = 'E';  code.GAT = 'D';
        code.GCA = 'A';  code.GCC = 'A';  code.GCG = 'A';  code.GCT = 'A';
        code.GGA = 'G';  code.GGC = 'G';  code.GGG = 'G';  code.GGT = 'G';
        code.GTA = 'V';  code.GTC = 'V';  code.GTG = 'V';  code.GTT = 'V';
        code.TAA = '*';  code.TAC = 'Y';  code.TAG = '*';  code.TAT = 'Y';
        code.TCA = 'S';  code.TCC = 'S';  code.TCG = 'S';  code.TCT = 'S';
        code.TGA = '*';  code.TGC = 'C';  code.TGG = 'W';  code.TGT = 'C';
        code.TTA = 'L';  code.TTC = 'F';  code.TTG = 'L';  code.TTT = 'F';
        
        code.Starts = { 'ATG','CTG'};
        
        
    case 13, %Ascidian Mitochondrial
        % base1  = 'TTTTTTTTTTTTTTTTCCCCCCCCCCCCCCCCAAAAAAAAAAAAAAAAGGGGGGGGGGGGGGGG'
        % base2  = 'TTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGG'
        % base3  = 'TCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAG'
        % code   = 'FFLLSSSSYY**CCWWLLLLPPPPHHQQRRRRIIMMTTTTNNKKSSGGVVVVAAAADDEEGGGG'
        % starts = '-----------------------------------M----------------------------'
        
        code.Name   = 'Ascidian Mitochondrial';
        
        code.AAA = 'K';  code.AAC = 'N';  code.AAG = 'K';  code.AAT = 'N';
        code.ACA = 'T';  code.ACC = 'T';  code.ACG = 'T';  code.ACT = 'T';
        code.AGA = 'G';  code.AGC = 'S';  code.AGG = 'G';  code.AGT = 'S';
        code.ATA = 'M';  code.ATC = 'I';  code.ATG = 'M';  code.ATT = 'I';
        code.CAA = 'Q';  code.CAC = 'H';  code.CAG = 'Q';  code.CAT = 'H';
        code.CCA = 'P';  code.CCC = 'P';  code.CCG = 'P';  code.CCT = 'P';
        code.CGA = 'R';  code.CGC = 'R';  code.CGG = 'R';  code.CGT = 'R';
        code.CTA = 'L';  code.CTC = 'L';  code.CTG = 'L';  code.CTT = 'L';
        code.GAA = 'E';  code.GAC = 'D';  code.GAG = 'E';  code.GAT = 'D';
        code.GCA = 'A';  code.GCC = 'A';  code.GCG = 'A';  code.GCT = 'A';
        code.GGA = 'G';  code.GGC = 'G';  code.GGG = 'G';  code.GGT = 'G';
        code.GTA = 'V';  code.GTC = 'V';  code.GTG = 'V';  code.GTT = 'V';
        code.TAA = '*';  code.TAC = 'Y';  code.TAG = '*';  code.TAT = 'Y';
        code.TCA = 'S';  code.TCC = 'S';  code.TCG = 'S';  code.TCT = 'S';
        code.TGA = 'W';  code.TGC = 'C';  code.TGG = 'W';  code.TGT = 'C';
        code.TTA = 'L';  code.TTC = 'F';  code.TTG = 'L';  code.TTT = 'F';
        
        code.Starts = { 'ATG'};
        
        
    case 14, %Flatworm Mitochondrial
        % base1  = 'TTTTTTTTTTTTTTTTCCCCCCCCCCCCCCCCAAAAAAAAAAAAAAAAGGGGGGGGGGGGGGGG'
        % base2  = 'TTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGG'
        % base3  = 'TCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAG'
        % code   = 'FFLLSSSSYYY*CCWWLLLLPPPPHHQQRRRRIIIMTTTTNNNKSSSSVVVVAAAADDEEGGGG'
        % starts = '-----------------------------------M----------------------------'
        
        code.Name   = 'Flatworm Mitochondrial';
        
        code.AAA = 'N';  code.AAC = 'N';  code.AAG = 'K';  code.AAT = 'N';
        code.ACA = 'T';  code.ACC = 'T';  code.ACG = 'T';  code.ACT = 'T';
        code.AGA = 'S';  code.AGC = 'S';  code.AGG = 'S';  code.AGT = 'S';
        code.ATA = 'I';  code.ATC = 'I';  code.ATG = 'M';  code.ATT = 'I';
        code.CAA = 'Q';  code.CAC = 'H';  code.CAG = 'Q';  code.CAT = 'H';
        code.CCA = 'P';  code.CCC = 'P';  code.CCG = 'P';  code.CCT = 'P';
        code.CGA = 'R';  code.CGC = 'R';  code.CGG = 'R';  code.CGT = 'R';
        code.CTA = 'L';  code.CTC = 'L';  code.CTG = 'L';  code.CTT = 'L';
        code.GAA = 'E';  code.GAC = 'D';  code.GAG = 'E';  code.GAT = 'D';
        code.GCA = 'A';  code.GCC = 'A';  code.GCG = 'A';  code.GCT = 'A';
        code.GGA = 'G';  code.GGC = 'G';  code.GGG = 'G';  code.GGT = 'G';
        code.GTA = 'V';  code.GTC = 'V';  code.GTG = 'V';  code.GTT = 'V';
        code.TAA = 'Y';  code.TAC = 'Y';  code.TAG = '*';  code.TAT = 'Y';
        code.TCA = 'S';  code.TCC = 'S';  code.TCG = 'S';  code.TCT = 'S';
        code.TGA = 'W';  code.TGC = 'C';  code.TGG = 'W';  code.TGT = 'C';
        code.TTA = 'L';  code.TTC = 'F';  code.TTG = 'L';  code.TTT = 'F';
        
        code.Starts = { 'ATG'};
        
        
    case 15, %Blepharisma Nuclear;
        % base1  = 'TTTTTTTTTTTTTTTTCCCCCCCCCCCCCCCCAAAAAAAAAAAAAAAAGGGGGGGGGGGGGGGG'
        % base2  = 'TTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGG'
        % base3  = 'TCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAG'
        % code   = 'FFLLSSSSYY*QCC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG'
        % starts = '-----------------------------------M----------------------------'
        
        code.Name   = 'Blepharisma Nuclear;';
        
        code.AAA = 'K';  code.AAC = 'N';  code.AAG = 'K';  code.AAT = 'N';
        code.ACA = 'T';  code.ACC = 'T';  code.ACG = 'T';  code.ACT = 'T';
        code.AGA = 'R';  code.AGC = 'S';  code.AGG = 'R';  code.AGT = 'S';
        code.ATA = 'I';  code.ATC = 'I';  code.ATG = 'M';  code.ATT = 'I';
        code.CAA = 'Q';  code.CAC = 'H';  code.CAG = 'Q';  code.CAT = 'H';
        code.CCA = 'P';  code.CCC = 'P';  code.CCG = 'P';  code.CCT = 'P';
        code.CGA = 'R';  code.CGC = 'R';  code.CGG = 'R';  code.CGT = 'R';
        code.CTA = 'L';  code.CTC = 'L';  code.CTG = 'L';  code.CTT = 'L';
        code.GAA = 'E';  code.GAC = 'D';  code.GAG = 'E';  code.GAT = 'D';
        code.GCA = 'A';  code.GCC = 'A';  code.GCG = 'A';  code.GCT = 'A';
        code.GGA = 'G';  code.GGC = 'G';  code.GGG = 'G';  code.GGT = 'G';
        code.GTA = 'V';  code.GTC = 'V';  code.GTG = 'V';  code.GTT = 'V';
        code.TAA = '*';  code.TAC = 'Y';  code.TAG = 'Q';  code.TAT = 'Y';
        code.TCA = 'S';  code.TCC = 'S';  code.TCG = 'S';  code.TCT = 'S';
        code.TGA = '*';  code.TGC = 'C';  code.TGG = 'W';  code.TGT = 'C';
        code.TTA = 'L';  code.TTC = 'F';  code.TTG = 'L';  code.TTT = 'F';
        
        code.Starts = { 'ATG'};
        
        
    case 16, %Chlorophycean Mitochondrial
        % base1  = 'TTTTTTTTTTTTTTTTCCCCCCCCCCCCCCCCAAAAAAAAAAAAAAAAGGGGGGGGGGGGGGGG'
        % base2  = 'TTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGG'
        % base3  = 'TCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAG'
        % code   = 'FFLLSSSSYY*LCC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG'
        % starts = '-----------------------------------M----------------------------'
        
        code.Name   = 'Chlorophycean Mitochondrial';
        
        code.AAA = 'K';  code.AAC = 'N';  code.AAG = 'K';  code.AAT = 'N';
        code.ACA = 'T';  code.ACC = 'T';  code.ACG = 'T';  code.ACT = 'T';
        code.AGA = 'R';  code.AGC = 'S';  code.AGG = 'R';  code.AGT = 'S';
        code.ATA = 'I';  code.ATC = 'I';  code.ATG = 'M';  code.ATT = 'I';
        code.CAA = 'Q';  code.CAC = 'H';  code.CAG = 'Q';  code.CAT = 'H';
        code.CCA = 'P';  code.CCC = 'P';  code.CCG = 'P';  code.CCT = 'P';
        code.CGA = 'R';  code.CGC = 'R';  code.CGG = 'R';  code.CGT = 'R';
        code.CTA = 'L';  code.CTC = 'L';  code.CTG = 'L';  code.CTT = 'L';
        code.GAA = 'E';  code.GAC = 'D';  code.GAG = 'E';  code.GAT = 'D';
        code.GCA = 'A';  code.GCC = 'A';  code.GCG = 'A';  code.GCT = 'A';
        code.GGA = 'G';  code.GGC = 'G';  code.GGG = 'G';  code.GGT = 'G';
        code.GTA = 'V';  code.GTC = 'V';  code.GTG = 'V';  code.GTT = 'V';
        code.TAA = '*';  code.TAC = 'Y';  code.TAG = 'L';  code.TAT = 'Y';
        code.TCA = 'S';  code.TCC = 'S';  code.TCG = 'S';  code.TCT = 'S';
        code.TGA = '*';  code.TGC = 'C';  code.TGG = 'W';  code.TGT = 'C';
        code.TTA = 'L';  code.TTC = 'F';  code.TTG = 'L';  code.TTT = 'F';
        
        code.Starts = { 'ATG'};
        
        
    case 21, %Trematode Mitochondrial
        % base1  = 'TTTTTTTTTTTTTTTTCCCCCCCCCCCCCCCCAAAAAAAAAAAAAAAAGGGGGGGGGGGGGGGG'
        % base2  = 'TTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGG'
        % base3  = 'TCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAG'
        % code   = 'FFLLSSSSYY**CCWWLLLLPPPPHHQQRRRRIIMMTTTTNNNKSSSSVVVVAAAADDEEGGGG'
        % starts = '-----------------------------------M---------------M------------'
        
        code.Name   = 'Trematode Mitochondrial';
        
        code.AAA = 'N';  code.AAC = 'N';  code.AAG = 'K';  code.AAT = 'N';
        code.ACA = 'T';  code.ACC = 'T';  code.ACG = 'T';  code.ACT = 'T';
        code.AGA = 'S';  code.AGC = 'S';  code.AGG = 'S';  code.AGT = 'S';
        code.ATA = 'M';  code.ATC = 'I';  code.ATG = 'M';  code.ATT = 'I';
        code.CAA = 'Q';  code.CAC = 'H';  code.CAG = 'Q';  code.CAT = 'H';
        code.CCA = 'P';  code.CCC = 'P';  code.CCG = 'P';  code.CCT = 'P';
        code.CGA = 'R';  code.CGC = 'R';  code.CGG = 'R';  code.CGT = 'R';
        code.CTA = 'L';  code.CTC = 'L';  code.CTG = 'L';  code.CTT = 'L';
        code.GAA = 'E';  code.GAC = 'D';  code.GAG = 'E';  code.GAT = 'D';
        code.GCA = 'A';  code.GCC = 'A';  code.GCG = 'A';  code.GCT = 'A';
        code.GGA = 'G';  code.GGC = 'G';  code.GGG = 'G';  code.GGT = 'G';
        code.GTA = 'V';  code.GTC = 'V';  code.GTG = 'V';  code.GTT = 'V';
        code.TAA = '*';  code.TAC = 'Y';  code.TAG = '*';  code.TAT = 'Y';
        code.TCA = 'S';  code.TCC = 'S';  code.TCG = 'S';  code.TCT = 'S';
        code.TGA = 'W';  code.TGC = 'C';  code.TGG = 'W';  code.TGT = 'C';
        code.TTA = 'L';  code.TTC = 'F';  code.TTG = 'L';  code.TTT = 'F';
        
        code.Starts = { 'ATG','GTG'};
        
        
    case 22, %Scenedesmus obliquus mitochondrial
        % base1  = 'TTTTTTTTTTTTTTTTCCCCCCCCCCCCCCCCAAAAAAAAAAAAAAAAGGGGGGGGGGGGGGGG'
        % base2  = 'TTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGG'
        % base3  = 'TCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAG'
        % code   = 'FFLLSS*SYY*LCC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG'
        % starts = '-----------------------------------M----------------------------'
        
        code.Name   = 'Scenedesmus obliquus mitochondrial';
        
        code.AAA = 'K';  code.AAC = 'N';  code.AAG = 'K';  code.AAT = 'N';
        code.ACA = 'T';  code.ACC = 'T';  code.ACG = 'T';  code.ACT = 'T';
        code.AGA = 'R';  code.AGC = 'S';  code.AGG = 'R';  code.AGT = 'S';
        code.ATA = 'I';  code.ATC = 'I';  code.ATG = 'M';  code.ATT = 'I';
        code.CAA = 'Q';  code.CAC = 'H';  code.CAG = 'Q';  code.CAT = 'H';
        code.CCA = 'P';  code.CCC = 'P';  code.CCG = 'P';  code.CCT = 'P';
        code.CGA = 'R';  code.CGC = 'R';  code.CGG = 'R';  code.CGT = 'R';
        code.CTA = 'L';  code.CTC = 'L';  code.CTG = 'L';  code.CTT = 'L';
        code.GAA = 'E';  code.GAC = 'D';  code.GAG = 'E';  code.GAT = 'D';
        code.GCA = 'A';  code.GCC = 'A';  code.GCG = 'A';  code.GCT = 'A';
        code.GGA = 'G';  code.GGC = 'G';  code.GGG = 'G';  code.GGT = 'G';
        code.GTA = 'V';  code.GTC = 'V';  code.GTG = 'V';  code.GTT = 'V';
        code.TAA = '*';  code.TAC = 'Y';  code.TAG = 'L';  code.TAT = 'Y';
        code.TCA = '*';  code.TCC = 'S';  code.TCG = 'S';  code.TCT = 'S';
        code.TGA = '*';  code.TGC = 'C';  code.TGG = 'W';  code.TGT = 'C';
        code.TTA = 'L';  code.TTC = 'F';  code.TTG = 'L';  code.TTT = 'F';
        
        code.Starts = { 'ATG'};
        
        
    case 23, %Thraustochytrium Mitochondrial
        % base1  = 'TTTTTTTTTTTTTTTTCCCCCCCCCCCCCCCCAAAAAAAAAAAAAAAAGGGGGGGGGGGGGGGG'
        % base2  = 'TTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGG'
        % base3  = 'TCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAG'
        % code   = 'FF*LSSSSYY**CC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG'
        % starts = '--------------------------------M--M---------------M------------'
        
        code.Name   = 'Thraustochytrium Mitochondrial';
        
        code.AAA = 'K';  code.AAC = 'N';  code.AAG = 'K';  code.AAT = 'N';
        code.ACA = 'T';  code.ACC = 'T';  code.ACG = 'T';  code.ACT = 'T';
        code.AGA = 'R';  code.AGC = 'S';  code.AGG = 'R';  code.AGT = 'S';
        code.ATA = 'I';  code.ATC = 'I';  code.ATG = 'M';  code.ATT = 'I';
        code.CAA = 'Q';  code.CAC = 'H';  code.CAG = 'Q';  code.CAT = 'H';
        code.CCA = 'P';  code.CCC = 'P';  code.CCG = 'P';  code.CCT = 'P';
        code.CGA = 'R';  code.CGC = 'R';  code.CGG = 'R';  code.CGT = 'R';
        code.CTA = 'L';  code.CTC = 'L';  code.CTG = 'L';  code.CTT = 'L';
        code.GAA = 'E';  code.GAC = 'D';  code.GAG = 'E';  code.GAT = 'D';
        code.GCA = 'A';  code.GCC = 'A';  code.GCG = 'A';  code.GCT = 'A';
        code.GGA = 'G';  code.GGC = 'G';  code.GGG = 'G';  code.GGT = 'G';
        code.GTA = 'V';  code.GTC = 'V';  code.GTG = 'V';  code.GTT = 'V';
        code.TAA = '*';  code.TAC = 'Y';  code.TAG = '*';  code.TAT = 'Y';
        code.TCA = 'S';  code.TCC = 'S';  code.TCG = 'S';  code.TCT = 'S';
        code.TGA = '*';  code.TGC = 'C';  code.TGG = 'W';  code.TGT = 'C';
        code.TTA = '*';  code.TTC = 'F';  code.TTG = 'L';  code.TTT = 'F';
        
        code.Starts = { 'ATG','ATT','GTG'};
        
    otherwise
        error('Bioinfo:UnknownGeneticCode',...
            'Unknown code number: %d.\nValid codes are 1,2,3,4,5,6,9,10,11,12,13,14,15,16,21,22,23',id);
        
end
