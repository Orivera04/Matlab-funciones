function code = revgeneticcode(id,varargin)
%REVGENETICCODE creates a structure of inverse mappings for the genetic code.
%
%   MAP = REVGENETICCODE returns a structure containing the inverse mapping
%   for the Standard genetic code.
%
%   REVGENETICCODE(ID) returns a structure of the inverse mapping for
%   alternate genetic codes, where ID is either the transl_table ID from
%   the NCBI Genetic Codes Web page
%   (http://www.ncbi.nlm.nih.gov/Taxonomy/Utils/wprintgc.cgi?mode=c)
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
% 	6	Ciliate, Dasycladacean, and Hexamita Nuclear
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
%   REVGENETICCODE(ID,..., 'ALPHABET', A) determines which nucleotide
%   alphabet - 'DNA' or 'RNA' - to use. The default value is 'DNA'.
%
%   REVGENETICCODE(ID,..., 'THREELETTERCODES', true) returns the mapping
%   structure with the three-letter amino acid codes as field names instead
%   of the default single-letter codes.
%
%   Examples:
%
%       moldcode = revgeneticcode(4, 'ALPHABET', 'RNA')
%       wormcode = revgeneticcode('Flatworm Mitochondrial',...
%           'THREELETTERCODES', true)
%
%   See also AA2NT, BASELOOKUP, GENETICCODE, NT2AA.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.7.4.4 $  $Date: 2004/03/14 15:31:38 $

if nargin == 0
    id = 1;
end
ThreeLetterCodes = false;
useRNA = false;
if nargin > 1
    
    if rem(nargin,2) == 0
        error('Bioinfo:IncorrectNumberOfArguments',...
            'Incorrect number of arguments to %s.',mfilename);
    end
    okargs = {'threelettercodes','alphabet'};
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
                case 1  % ThreeLetterCodes
                    ThreeLetterCodes = opttf(pval);
                    if isempty(ThreeLetterCodes)
                        error('Bioinfo:InputOptionNotLogical','%s must be a logical value, true or false.',...
                            upper(char(okargs(k))));
                    end
                case 2  % Alphabet
                    if strcmpi(pval,'rna')
                        useRNA = true;
                    end
            end
        end
    end
    
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
        
        code.A = {'GCT','GCC','GCA','GCG'};
        code.R = {'CGT','CGC','CGA','CGG','AGA','AGG'};
        code.N = {'AAT','AAC'};
        code.D = {'GAT','GAC'};
        code.C = {'TGT','TGC'};
        code.Q = {'CAA','CAG'};
        code.E = {'GAA','GAG'};
        code.G = {'GGT','GGC','GGA','GGG'};
        code.H = {'CAT','CAC'};
        code.I = {'ATT','ATC','ATA'};
        code.L = {'TTA','TTG','CTT','CTC','CTA','CTG'};
        code.K = {'AAA','AAG'};
        code.M = {'ATG'};
        code.F = {'TTT','TTC'};
        code.P = {'CCT','CCC','CCA','CCG'};
        code.S = {'TCT','TCC','TCA','TCG','AGT','AGC'};
        code.T = {'ACT','ACC','ACA','ACG'};
        code.W = {'TGG'};
        code.Y = {'TAT','TAC'};
        code.V = {'GTT','GTC','GTA','GTG'};
        code.Starts = {'TAA','TAG','TGA'};
        
        
    case 2, %Vertebrate Mitochondrial
        % base1  = 'TTTTTTTTTTTTTTTTCCCCCCCCCCCCCCCCAAAAAAAAAAAAAAAAGGGGGGGGGGGGGGGG'
        % base2  = 'TTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGG'
        % base3  = 'TCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAG'
        % code   = 'FFLLSSSSYY**CCWWLLLLPPPPHHQQRRRRIIMMTTTTNNKKSS**VVVVAAAADDEEGGGG'
        % starts = '--------------------------------MMMM---------------M------------'
        
        code.Name   = 'Vertebrate Mitochondrial';
        
        code.A = {'GCT','GCC','GCA','GCG'};
        code.R = {'CGT','CGC','CGA','CGG'};
        code.N = {'AAT','AAC'};
        code.D = {'GAT','GAC'};
        code.C = {'TGT','TGC'};
        code.Q = {'CAA','CAG'};
        code.E = {'GAA','GAG'};
        code.G = {'GGT','GGC','GGA','GGG'};
        code.H = {'CAT','CAC'};
        code.I = {'ATT','ATC'};
        code.L = {'TTA','TTG','CTT','CTC','CTA','CTG'};
        code.K = {'AAA','AAG'};
        code.M = {'ATA','ATG'};
        code.F = {'TTT','TTC'};
        code.P = {'CCT','CCC','CCA','CCG'};
        code.S = {'TCT','TCC','TCA','TCG','AGT','AGC'};
        code.T = {'ACT','ACC','ACA','ACG'};
        code.W = {'TGA','TGG'};
        code.Y = {'TAT','TAC'};
        code.V = {'GTT','GTC','GTA','GTG'};
        code.Starts = {'TAA','TAG','AGA','AGG'};
        
        
    case 3, %Yeast Mitochondrial
        % base1  = 'TTTTTTTTTTTTTTTTCCCCCCCCCCCCCCCCAAAAAAAAAAAAAAAAGGGGGGGGGGGGGGGG'
        % base2  = 'TTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGG'
        % base3  = 'TCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAG'
        % code   = 'FFLLSSSSYY**CCWWTTTTPPPPHHQQRRRRIIMMTTTTNNKKSSRRVVVVAAAADDEEGGGG'
        % starts = '----------------------------------MM----------------------------'
        
        code.Name   = 'Yeast Mitochondrial';
        
        code.A = {'GCT','GCC','GCA','GCG'};
        code.R = {'CGT','CGC','CGA','CGG','AGA','AGG'};
        code.N = {'AAT','AAC'};
        code.D = {'GAT','GAC'};
        code.C = {'TGT','TGC'};
        code.Q = {'CAA','CAG'};
        code.E = {'GAA','GAG'};
        code.G = {'GGT','GGC','GGA','GGG'};
        code.H = {'CAT','CAC'};
        code.I = {'ATT','ATC'};
        code.L = {'TTA','TTG'};
        code.K = {'AAA','AAG'};
        code.M = {'ATA','ATG'};
        code.F = {'TTT','TTC'};
        code.P = {'CCT','CCC','CCA','CCG'};
        code.S = {'TCT','TCC','TCA','TCG','AGT','AGC'};
        code.T = {'CTT','CTC','CTA','CTG','ACT','ACC','ACA','ACG'};
        code.W = {'TGA','TGG'};
        code.Y = {'TAT','TAC'};
        code.V = {'GTT','GTC','GTA','GTG'};
        code.Starts = {'TAA','TAG'};
        
        
    case 4, %Mold, Protozoan, and Coelenterate Mitochondrial and Mycoplasma/Spiroplasma
        % base1  = 'TTTTTTTTTTTTTTTTCCCCCCCCCCCCCCCCAAAAAAAAAAAAAAAAGGGGGGGGGGGGGGGG'
        % base2  = 'TTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGG'
        % base3  = 'TCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAG'
        % code   = 'FFLLSSSSYY**CCWWLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG'
        % starts = '--MM---------------M------------MMMM---------------M------------'
        
        code.Name   = 'Mold, Protozoan, and Coelenterate Mitochondrial and Mycoplasma/Spiroplasma';
        
        code.A = {'GCT','GCC','GCA','GCG'};
        code.R = {'CGT','CGC','CGA','CGG','AGA','AGG'};
        code.N = {'AAT','AAC'};
        code.D = {'GAT','GAC'};
        code.C = {'TGT','TGC'};
        code.Q = {'CAA','CAG'};
        code.E = {'GAA','GAG'};
        code.G = {'GGT','GGC','GGA','GGG'};
        code.H = {'CAT','CAC'};
        code.I = {'ATT','ATC','ATA'};
        code.L = {'TTA','TTG','CTT','CTC','CTA','CTG'};
        code.K = {'AAA','AAG'};
        code.M = {'ATG'};
        code.F = {'TTT','TTC'};
        code.P = {'CCT','CCC','CCA','CCG'};
        code.S = {'TCT','TCC','TCA','TCG','AGT','AGC'};
        code.T = {'ACT','ACC','ACA','ACG'};
        code.W = {'TGA','TGG'};
        code.Y = {'TAT','TAC'};
        code.V = {'GTT','GTC','GTA','GTG'};
        code.Starts = {'TAA','TAG'};
        
        
    case 5, %Invertebrate Mitochondrial
        % base1  = 'TTTTTTTTTTTTTTTTCCCCCCCCCCCCCCCCAAAAAAAAAAAAAAAAGGGGGGGGGGGGGGGG'
        % base2  = 'TTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGG'
        % base3  = 'TCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAG'
        % code   = 'FFLLSSSSYY**CCWWLLLLPPPPHHQQRRRRIIMMTTTTNNKKSSSSVVVVAAAADDEEGGGG'
        % starts = '---M----------------------------MMMM---------------M------------'
        
        code.Name   = 'Invertebrate Mitochondrial';
        
        code.A = {'GCT','GCC','GCA','GCG'};
        code.R = {'CGT','CGC','CGA','CGG'};
        code.N = {'AAT','AAC'};
        code.D = {'GAT','GAC'};
        code.C = {'TGT','TGC'};
        code.Q = {'CAA','CAG'};
        code.E = {'GAA','GAG'};
        code.G = {'GGT','GGC','GGA','GGG'};
        code.H = {'CAT','CAC'};
        code.I = {'ATT','ATC'};
        code.L = {'TTA','TTG','CTT','CTC','CTA','CTG'};
        code.K = {'AAA','AAG'};
        code.M = {'ATA','ATG'};
        code.F = {'TTT','TTC'};
        code.P = {'CCT','CCC','CCA','CCG'};
        code.S = {'TCT','TCC','TCA','TCG','AGT','AGC','AGA','AGG'};
        code.T = {'ACT','ACC','ACA','ACG'};
        code.W = {'TGA','TGG'};
        code.Y = {'TAT','TAC'};
        code.V = {'GTT','GTC','GTA','GTG'};
        code.Starts = {'TAA','TAG'};
        
        
    case 6, %Ciliate, Dasycladacean and Hexamita Nuclear
        % base1  = 'TTTTTTTTTTTTTTTTCCCCCCCCCCCCCCCCAAAAAAAAAAAAAAAAGGGGGGGGGGGGGGGG'
        % base2  = 'TTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGG'
        % base3  = 'TCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAG'
        % code   = 'FFLLSSSSYYQQCC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG'
        % starts = '-----------------------------------M----------------------------'
        
        code.Name   = 'Ciliate, Dasycladacean and Hexamita Nuclear';
        
        code.A = {'GCT','GCC','GCA','GCG'};
        code.R = {'CGT','CGC','CGA','CGG','AGA','AGG'};
        code.N = {'AAT','AAC'};
        code.D = {'GAT','GAC'};
        code.C = {'TGT','TGC'};
        code.Q = {'TAA','TAG','CAA','CAG'};
        code.E = {'GAA','GAG'};
        code.G = {'GGT','GGC','GGA','GGG'};
        code.H = {'CAT','CAC'};
        code.I = {'ATT','ATC','ATA'};
        code.L = {'TTA','TTG','CTT','CTC','CTA','CTG'};
        code.K = {'AAA','AAG'};
        code.M = {'ATG'};
        code.F = {'TTT','TTC'};
        code.P = {'CCT','CCC','CCA','CCG'};
        code.S = {'TCT','TCC','TCA','TCG','AGT','AGC'};
        code.T = {'ACT','ACC','ACA','ACG'};
        code.W = {'TGG'};
        code.Y = {'TAT','TAC'};
        code.V = {'GTT','GTC','GTA','GTG'};
        code.Starts = {'TGA'};
        
        
    case 9, %Echinoderm Mitochondrial
        % base1  = 'TTTTTTTTTTTTTTTTCCCCCCCCCCCCCCCCAAAAAAAAAAAAAAAAGGGGGGGGGGGGGGGG'
        % base2  = 'TTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGG'
        % base3  = 'TCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAG'
        % code   = 'FFLLSSSSYY**CCWWLLLLPPPPHHQQRRRRIIIMTTTTNNNKSSSSVVVVAAAADDEEGGGG'
        % starts = '-----------------------------------M---------------M------------'
        
        code.Name   = 'Echinoderm Mitochondrial';
        
        code.A = {'GCT','GCC','GCA','GCG'};
        code.R = {'CGT','CGC','CGA','CGG'};
        code.N = {'AAT','AAC','AAA'};
        code.D = {'GAT','GAC'};
        code.C = {'TGT','TGC'};
        code.Q = {'CAA','CAG'};
        code.E = {'GAA','GAG'};
        code.G = {'GGT','GGC','GGA','GGG'};
        code.H = {'CAT','CAC'};
        code.I = {'ATT','ATC','ATA'};
        code.L = {'TTA','TTG','CTT','CTC','CTA','CTG'};
        code.K = {'AAG'};
        code.M = {'ATG'};
        code.F = {'TTT','TTC'};
        code.P = {'CCT','CCC','CCA','CCG'};
        code.S = {'TCT','TCC','TCA','TCG','AGT','AGC','AGA','AGG'};
        code.T = {'ACT','ACC','ACA','ACG'};
        code.W = {'TGA','TGG'};
        code.Y = {'TAT','TAC'};
        code.V = {'GTT','GTC','GTA','GTG'};
        code.Starts = {'TAA','TAG'};
        
        
    case 10, %Euplotid Nuclear
        % base1  = 'TTTTTTTTTTTTTTTTCCCCCCCCCCCCCCCCAAAAAAAAAAAAAAAAGGGGGGGGGGGGGGGG'
        % base2  = 'TTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGG'
        % base3  = 'TCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAG'
        % code   = 'FFLLSSSSYY**CCCWLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG'
        % starts = '-----------------------------------M----------------------------'
        
        code.Name   = 'Euplotid Nuclear';
        
        code.A = {'GCT','GCC','GCA','GCG'};
        code.R = {'CGT','CGC','CGA','CGG','AGA','AGG'};
        code.N = {'AAT','AAC'};
        code.D = {'GAT','GAC'};
        code.C = {'TGT','TGC','TGA'};
        code.Q = {'CAA','CAG'};
        code.E = {'GAA','GAG'};
        code.G = {'GGT','GGC','GGA','GGG'};
        code.H = {'CAT','CAC'};
        code.I = {'ATT','ATC','ATA'};
        code.L = {'TTA','TTG','CTT','CTC','CTA','CTG'};
        code.K = {'AAA','AAG'};
        code.M = {'ATG'};
        code.F = {'TTT','TTC'};
        code.P = {'CCT','CCC','CCA','CCG'};
        code.S = {'TCT','TCC','TCA','TCG','AGT','AGC'};
        code.T = {'ACT','ACC','ACA','ACG'};
        code.W = {'TGG'};
        code.Y = {'TAT','TAC'};
        code.V = {'GTT','GTC','GTA','GTG'};
        code.Starts = {'TAA','TAG'};
        
        
    case 11, %Bacterial and Plant Plastid
        % base1  = 'TTTTTTTTTTTTTTTTCCCCCCCCCCCCCCCCAAAAAAAAAAAAAAAAGGGGGGGGGGGGGGGG'
        % base2  = 'TTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGG'
        % base3  = 'TCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAG'
        % code   = 'FFLLSSSSYY**CC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG'
        % starts = '---M---------------M------------MMMM---------------M------------'
        
        code.Name   = 'Bacterial and Plant Plastid';
        
        code.A = {'GCT','GCC','GCA','GCG'};
        code.R = {'CGT','CGC','CGA','CGG','AGA','AGG'};
        code.N = {'AAT','AAC'};
        code.D = {'GAT','GAC'};
        code.C = {'TGT','TGC'};
        code.Q = {'CAA','CAG'};
        code.E = {'GAA','GAG'};
        code.G = {'GGT','GGC','GGA','GGG'};
        code.H = {'CAT','CAC'};
        code.I = {'ATT','ATC','ATA'};
        code.L = {'TTA','TTG','CTT','CTC','CTA','CTG'};
        code.K = {'AAA','AAG'};
        code.M = {'ATG'};
        code.F = {'TTT','TTC'};
        code.P = {'CCT','CCC','CCA','CCG'};
        code.S = {'TCT','TCC','TCA','TCG','AGT','AGC'};
        code.T = {'ACT','ACC','ACA','ACG'};
        code.W = {'TGG'};
        code.Y = {'TAT','TAC'};
        code.V = {'GTT','GTC','GTA','GTG'};
        code.Starts = {'TAA','TAG','TGA'};
        
        
    case 12, %Alternative Yeast Nuclear
        % base1  = 'TTTTTTTTTTTTTTTTCCCCCCCCCCCCCCCCAAAAAAAAAAAAAAAAGGGGGGGGGGGGGGGG'
        % base2  = 'TTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGG'
        % base3  = 'TCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAG'
        % code   = 'FFLLSSSSYY**CC*WLLLSPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG'
        % starts = '-------------------M---------------M----------------------------'
        
        code.Name   = 'Alternative Yeast Nuclear';
        
        code.A = {'GCT','GCC','GCA','GCG'};
        code.R = {'CGT','CGC','CGA','CGG','AGA','AGG'};
        code.N = {'AAT','AAC'};
        code.D = {'GAT','GAC'};
        code.C = {'TGT','TGC'};
        code.Q = {'CAA','CAG'};
        code.E = {'GAA','GAG'};
        code.G = {'GGT','GGC','GGA','GGG'};
        code.H = {'CAT','CAC'};
        code.I = {'ATT','ATC','ATA'};
        code.L = {'TTA','TTG','CTT','CTC','CTA'};
        code.K = {'AAA','AAG'};
        code.M = {'ATG'};
        code.F = {'TTT','TTC'};
        code.P = {'CCT','CCC','CCA','CCG'};
        code.S = {'TCT','TCC','TCA','TCG','CTG','AGT','AGC'};
        code.T = {'ACT','ACC','ACA','ACG'};
        code.W = {'TGG'};
        code.Y = {'TAT','TAC'};
        code.V = {'GTT','GTC','GTA','GTG'};
        code.Starts = {'TAA','TAG','TGA'};
        
        
    case 13, %Ascidian Mitochondrial
        % base1  = 'TTTTTTTTTTTTTTTTCCCCCCCCCCCCCCCCAAAAAAAAAAAAAAAAGGGGGGGGGGGGGGGG'
        % base2  = 'TTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGG'
        % base3  = 'TCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAG'
        % code   = 'FFLLSSSSYY**CCWWLLLLPPPPHHQQRRRRIIMMTTTTNNKKSSGGVVVVAAAADDEEGGGG'
        % starts = '-----------------------------------M----------------------------'
        
        code.Name   = 'Ascidian Mitochondrial';
        
        code.A = {'GCT','GCC','GCA','GCG'};
        code.R = {'CGT','CGC','CGA','CGG'};
        code.N = {'AAT','AAC'};
        code.D = {'GAT','GAC'};
        code.C = {'TGT','TGC'};
        code.Q = {'CAA','CAG'};
        code.E = {'GAA','GAG'};
        code.G = {'AGA','AGG','GGT','GGC','GGA','GGG'};
        code.H = {'CAT','CAC'};
        code.I = {'ATT','ATC'};
        code.L = {'TTA','TTG','CTT','CTC','CTA','CTG'};
        code.K = {'AAA','AAG'};
        code.M = {'ATA','ATG'};
        code.F = {'TTT','TTC'};
        code.P = {'CCT','CCC','CCA','CCG'};
        code.S = {'TCT','TCC','TCA','TCG','AGT','AGC'};
        code.T = {'ACT','ACC','ACA','ACG'};
        code.W = {'TGA','TGG'};
        code.Y = {'TAT','TAC'};
        code.V = {'GTT','GTC','GTA','GTG'};
        code.Starts = {'TAA','TAG'};
        
        
    case 14, %Flatworm Mitochondrial
        % base1  = 'TTTTTTTTTTTTTTTTCCCCCCCCCCCCCCCCAAAAAAAAAAAAAAAAGGGGGGGGGGGGGGGG'
        % base2  = 'TTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGG'
        % base3  = 'TCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAG'
        % code   = 'FFLLSSSSYYY*CCWWLLLLPPPPHHQQRRRRIIIMTTTTNNNKSSSSVVVVAAAADDEEGGGG'
        % starts = '-----------------------------------M----------------------------'
        
        code.Name   = 'Flatworm Mitochondrial';
        
        code.A = {'GCT','GCC','GCA','GCG'};
        code.R = {'CGT','CGC','CGA','CGG'};
        code.N = {'AAT','AAC','AAA'};
        code.D = {'GAT','GAC'};
        code.C = {'TGT','TGC'};
        code.Q = {'CAA','CAG'};
        code.E = {'GAA','GAG'};
        code.G = {'GGT','GGC','GGA','GGG'};
        code.H = {'CAT','CAC'};
        code.I = {'ATT','ATC','ATA'};
        code.L = {'TTA','TTG','CTT','CTC','CTA','CTG'};
        code.K = {'AAG'};
        code.M = {'ATG'};
        code.F = {'TTT','TTC'};
        code.P = {'CCT','CCC','CCA','CCG'};
        code.S = {'TCT','TCC','TCA','TCG','AGT','AGC','AGA','AGG'};
        code.T = {'ACT','ACC','ACA','ACG'};
        code.W = {'TGA','TGG'};
        code.Y = {'TAT','TAC','TAA'};
        code.V = {'GTT','GTC','GTA','GTG'};
        code.Starts = {'TAG'};
        
        
    case 15, %Blepharisma Nuclear;
        % base1  = 'TTTTTTTTTTTTTTTTCCCCCCCCCCCCCCCCAAAAAAAAAAAAAAAAGGGGGGGGGGGGGGGG'
        % base2  = 'TTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGG'
        % base3  = 'TCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAG'
        % code   = 'FFLLSSSSYY*QCC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG'
        % starts = '-----------------------------------M----------------------------'
        
        code.Name   = 'Blepharisma Nuclear;';
        
        code.A = {'GCT','GCC','GCA','GCG'};
        code.R = {'CGT','CGC','CGA','CGG','AGA','AGG'};
        code.N = {'AAT','AAC'};
        code.D = {'GAT','GAC'};
        code.C = {'TGT','TGC'};
        code.Q = {'TAG','CAA','CAG'};
        code.E = {'GAA','GAG'};
        code.G = {'GGT','GGC','GGA','GGG'};
        code.H = {'CAT','CAC'};
        code.I = {'ATT','ATC','ATA'};
        code.L = {'TTA','TTG','CTT','CTC','CTA','CTG'};
        code.K = {'AAA','AAG'};
        code.M = {'ATG'};
        code.F = {'TTT','TTC'};
        code.P = {'CCT','CCC','CCA','CCG'};
        code.S = {'TCT','TCC','TCA','TCG','AGT','AGC'};
        code.T = {'ACT','ACC','ACA','ACG'};
        code.W = {'TGG'};
        code.Y = {'TAT','TAC'};
        code.V = {'GTT','GTC','GTA','GTG'};
        code.Starts = {'TAA','TGA'};
        
        
    case 16, %Chlorophycean Mitochondrial
        % base1  = 'TTTTTTTTTTTTTTTTCCCCCCCCCCCCCCCCAAAAAAAAAAAAAAAAGGGGGGGGGGGGGGGG'
        % base2  = 'TTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGG'
        % base3  = 'TCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAG'
        % code   = 'FFLLSSSSYY*LCC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG'
        % starts = '-----------------------------------M----------------------------'
        
        code.Name   = 'Chlorophycean Mitochondrial';
        
        code.A = {'GCT','GCC','GCA','GCG'};
        code.R = {'CGT','CGC','CGA','CGG','AGA','AGG'};
        code.N = {'AAT','AAC'};
        code.D = {'GAT','GAC'};
        code.C = {'TGT','TGC'};
        code.Q = {'CAA','CAG'};
        code.E = {'GAA','GAG'};
        code.G = {'GGT','GGC','GGA','GGG'};
        code.H = {'CAT','CAC'};
        code.I = {'ATT','ATC','ATA'};
        code.L = {'TTA','TTG','TAG','CTT','CTC','CTA','CTG'};
        code.K = {'AAA','AAG'};
        code.M = {'ATG'};
        code.F = {'TTT','TTC'};
        code.P = {'CCT','CCC','CCA','CCG'};
        code.S = {'TCT','TCC','TCA','TCG','AGT','AGC'};
        code.T = {'ACT','ACC','ACA','ACG'};
        code.W = {'TGG'};
        code.Y = {'TAT','TAC'};
        code.V = {'GTT','GTC','GTA','GTG'};
        code.Starts = {'TAA','TGA'};
        
        
    case 21, %Trematode Mitochondrial
        % base1  = 'TTTTTTTTTTTTTTTTCCCCCCCCCCCCCCCCAAAAAAAAAAAAAAAAGGGGGGGGGGGGGGGG'
        % base2  = 'TTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGG'
        % base3  = 'TCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAG'
        % code   = 'FFLLSSSSYY**CCWWLLLLPPPPHHQQRRRRIIMMTTTTNNNKSSSSVVVVAAAADDEEGGGG'
        % starts = '-----------------------------------M---------------M------------'
        
        code.Name   = 'Trematode Mitochondrial';
        
        code.A = {'GCT','GCC','GCA','GCG'};
        code.R = {'CGT','CGC','CGA','CGG'};
        code.N = {'AAT','AAC','AAA'};
        code.D = {'GAT','GAC'};
        code.C = {'TGT','TGC'};
        code.Q = {'CAA','CAG'};
        code.E = {'GAA','GAG'};
        code.G = {'GGT','GGC','GGA','GGG'};
        code.H = {'CAT','CAC'};
        code.I = {'ATT','ATC'};
        code.L = {'TTA','TTG','CTT','CTC','CTA','CTG'};
        code.K = {'AAG'};
        code.M = {'ATA','ATG'};
        code.F = {'TTT','TTC'};
        code.P = {'CCT','CCC','CCA','CCG'};
        code.S = {'TCT','TCC','TCA','TCG','AGT','AGC','AGA','AGG'};
        code.T = {'ACT','ACC','ACA','ACG'};
        code.W = {'TGA','TGG'};
        code.Y = {'TAT','TAC'};
        code.V = {'GTT','GTC','GTA','GTG'};
        code.Starts = {'TAA','TAG'};
        
        
    case 22, %Scenedesmus obliquus mitochondrial
        % base1  = 'TTTTTTTTTTTTTTTTCCCCCCCCCCCCCCCCAAAAAAAAAAAAAAAAGGGGGGGGGGGGGGGG'
        % base2  = 'TTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGG'
        % base3  = 'TCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAG'
        % code   = 'FFLLSS*SYY*LCC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG'
        % starts = '-----------------------------------M----------------------------'
        
        code.Name   = 'Scenedesmus obliquus mitochondrial';
        
        code.A = {'GCT','GCC','GCA','GCG'};
        code.R = {'CGT','CGC','CGA','CGG','AGA','AGG'};
        code.N = {'AAT','AAC'};
        code.D = {'GAT','GAC'};
        code.C = {'TGT','TGC'};
        code.Q = {'CAA','CAG'};
        code.E = {'GAA','GAG'};
        code.G = {'GGT','GGC','GGA','GGG'};
        code.H = {'CAT','CAC'};
        code.I = {'ATT','ATC','ATA'};
        code.L = {'TTA','TTG','TAG','CTT','CTC','CTA','CTG'};
        code.K = {'AAA','AAG'};
        code.M = {'ATG'};
        code.F = {'TTT','TTC'};
        code.P = {'CCT','CCC','CCA','CCG'};
        code.S = {'TCT','TCC','TCG','AGT','AGC'};
        code.T = {'ACT','ACC','ACA','ACG'};
        code.W = {'TGG'};
        code.Y = {'TAT','TAC'};
        code.V = {'GTT','GTC','GTA','GTG'};
        code.Starts = {'TCA','TAA','TGA'};
        
        
    case 23, %Thraustochytrium Mitochondrial
        % base1  = 'TTTTTTTTTTTTTTTTCCCCCCCCCCCCCCCCAAAAAAAAAAAAAAAAGGGGGGGGGGGGGGGG'
        % base2  = 'TTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGGTTTTCCCCAAAAGGGG'
        % base3  = 'TCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAGTCAG'
        % code   = 'FF*LSSSSYY**CC*WLLLLPPPPHHQQRRRRIIIMTTTTNNKKSSRRVVVVAAAADDEEGGGG'
        % starts = '--------------------------------M--M---------------M------------'
        
        code.Name   = 'Thraustochytrium Mitochondrial';
        
        code.A = {'GCT','GCC','GCA','GCG'};
        code.R = {'CGT','CGC','CGA','CGG','AGA','AGG'};
        code.N = {'AAT','AAC'};
        code.D = {'GAT','GAC'};
        code.C = {'TGT','TGC'};
        code.Q = {'CAA','CAG'};
        code.E = {'GAA','GAG'};
        code.G = {'GGT','GGC','GGA','GGG'};
        code.H = {'CAT','CAC'};
        code.I = {'ATT','ATC','ATA'};
        code.L = {'TTG','CTT','CTC','CTA','CTG'};
        code.K = {'AAA','AAG'};
        code.M = {'ATG'};
        code.F = {'TTT','TTC'};
        code.P = {'CCT','CCC','CCA','CCG'};
        code.S = {'TCT','TCC','TCA','TCG','AGT','AGC'};
        code.T = {'ACT','ACC','ACA','ACG'};
        code.W = {'TGG'};
        code.Y = {'TAT','TAC'};
        code.V = {'GTT','GTC','GTA','GTG'};
        code.Starts = {'TTA','TAA','TAG','TGA'};
        
    otherwise
        error('Bioinfo:UnknownGeneticCode','Unknown code number: %d.\nValid codes are 1,2,3,4,5,6,9,10,11,12,13,14,15,16,21,22,23',id);
end

if ThreeLetterCodes
    for count = 1:20
        theLetter = int2aa(count);
        tlc = strtok(aminolookup('code',theLetter));
        code.(tlc) = code.(theLetter);
        code = rmfield(code,theLetter);
    end
    code.temp = code.Starts;
    code = rmfield(code,'Starts');
    code.Starts = code.temp;
    code = rmfield(code,'temp');
end
if useRNA
    for count = 1:20
        theLetter = int2aa(count);
        numcodons = length(code.(theLetter));
        for inner = 1:numcodons
            
            code.(theLetter){inner} = dna2rna(code.(theLetter){inner});
        end
    end
    numcodons = length(code.Starts);
    for inner = 1:numcodons
        
        code.Starts{inner} = dna2rna(code.Starts{inner});
    end
end
