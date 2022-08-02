function aa = nt2aa(nt,varargin)
% NT2AA converts a nucleotide sequence to a sequence of amino acids.
%
%   NT2AA(SEQ) converts nucleotide sequence SEQ to an amino acid sequence
%   using the Standard genetic code.
%
%   NT2AA(...,'FRAME',RF) converts a nucleotide sequence for the reading
%   frame RF to an amino acid sequence. Set RF to 'All' to convert all
%   three reading frames. In this case, the output is a 3x1 cell array. The
%   default FRAME is 1.
%
%   NT2AA(...,'ALTERNATIVESTARTCODONS',TF) is used to control the use of
%   alternative start codons. By default, if the first codon of a sequence
%   corresponds to a known alternative start codon, the codon is translated
%   to methionine. If this option is set to false, then alternative start
%   codons at the start of a sequence are translated to their corresponding
%   amino acids for the genetic code that is being used, which might not
%   necessarily be methionine.
%
%   See http://www.ncbi.nlm.nih.gov/Taxonomy/Utils/wprintgc.cgi?mode=t#SG1
%   for more details of alternative start codons.
%
%   NT2AA(...,'GENETICCODE',CODE) converts a nucleotide sequence to an amino
%   acid sequence using the genetic code CODE. CODE can be either a string
%   or an ID number from the list below. When a text string name is used,
%   it can be truncated to the first two characters of the name.
%   The Standard genetic code (ID = 1) is used by default.
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
%   Example:
%
%           nt2aa('ATGGCTACGCTAGCTCCT')
%
%   See also AA2NT, BASELOOKUP, GENETICCODE, REVGENETICCODE.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.15.6.5 $  $Date: 2004/03/14 15:31:30 $

code = 1;
frame = 1;
numFrames = 1;
alternativeStart = true;

% If the input is a structure then extract the Sequence data.
if isstruct(nt)
    try
        nt = seqfromstruct(nt);
    catch
        rethrow(lasterror);
    end
end

if nargin > 1
    if rem(nargin,2)== 0
        error('Bioinfo:IncorrectNumberOfArguments',...
            'Incorrect number of arguments to %s.',mfilename);
    end
    okargs = {'frame','geneticcode','alternativestartcodons'};
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
                case 1  % frame
                    if ~isnumeric(pval) || max(pval) > 3 || min(pval) < 1
                        if ischar(pval) && strcmpi(pval,'all')
                            pval = [1, 2, 3];
                        else
                            error('Bioinfo:BadFrameNumber',...
                                'Unrecognized frame number.')
                        end
                    end
                    frame = pval;
                    numFrames = length(frame);
                    if length(frame) > 1
                        outcell = cell(3,1);
                    end
                case 2  % genetic code
                    code = pval;
                case 3  % alternative start
                    alternativeStart = opttf(pval);
                    if isempty(alternativeStart)
                        error('Bioinfo:InputOptionNotLogical',...
                            '%s must be a logical value, true or false.',...
                            upper(char(okargs(k))));
                    end
            end
        end
    end
end

% convert to chars for the lookup
if ~ischar(nt)
    intFlag = true;
    nt = int2nt(nt);
else
    nt = upper(nt);
    intFlag = false;
end

% get our genetic code
code = geneticcode(code);

seqLen = length(nt);
for frameNum = frame

    numNts = seqLen +1 -frameNum;
    numCodons = floor(numNts/3);
    aa = blanks(numCodons);
    codon = 0;
    % loop through the codons looking up the AAs as we go
    for count =frameNum:3:(seqLen-2)
        codon = codon + 1;
        aa(codon) = code.(nt(count:count+2));
    end
    % deal with alternative start codons
    if alternativeStart && (seqLen >= frameNum+2)
        if ismember(nt(frameNum:frameNum+2),code.Starts)
            aa(1) = 'M';
        end
    end

    % convert back to ints if necessary
    if intFlag == true
        aa = aa2int(aa);
    end

    if numFrames > 1
        outcell{frameNum} = aa;
    end

end

% if we have multi frame output then use a cell array
if numFrames > 1
    aa = outcell;
end
