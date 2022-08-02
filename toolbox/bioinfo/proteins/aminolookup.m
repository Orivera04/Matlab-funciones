function out = aminolookup(varargin)
%AMINOLOOKUP displays AA codes, integers, abbreviations, names, and codons.
%
%   AMINOLOOKUP displays a table of all amino acid codes, integers,
%   abbreviations, full names, and codons.  The integers follow the pattern
%   defined by AA2INT.
%
%   AMINOLOOKUP(AMINOACID) converts between three-letter abbreviations and
%   one-letter amino acid codes. If the input is a string of three-letter
%   abbreviations, then the output is a string of the corresponding one-
%   letter codes. If the input is a string of single-letter codes, then the
%   output is a string of three-letter abbreviations.
%
%   AMINOLOOKUP('CODE',CODE) displays the correspoding amino acid's
%   three-letter abbreviation and full name. The possible codes are
%   A R N D C Q E G H I L K M F P S T W Y V B Z X.
%
%   AMINOLOOKUP('ABBREVIATION',ABBREVIATION) displays the corresponding
%   amino acid's letter and full name. ABBREVIATION must be three letters.
%
%   AMINOLOOKUP('INTEGER',INTEGER) displays the corresponding amino acid's
%   code, three-letter abbreviation, and full name. INTEGER is the value
%   returned by the function AA2INT.
%
%   AMINOLOOKUP('NAME',NAME) displays the corresponding amino acid's code
%   and three-letter abbreviation.
%
%   Examples:
%
%      aminolookup('WKQAEDIRDIYDF')
%      aminolookup('name','proline')
%      aminolookup('MetAlaThrLeuAlaAsx')
%
%   See also AA2INT, AACOUNT, GENETICCODE, INT2AA, NT2AA, REVGENETICCODE.

%   Copyright 2003-2004 The MathWorks, Inc. 
%   $Revision: 1.12.6.6 $  $Date: 2004/03/14 15:31:46 $   

t=aminotable;
out='';
if nargin == 0  % figure out if the first input is an array of text
    out = sprintf('%s%-6s%-5s%-14s%-29s%-6s\n',out,'Code','Int','Abbreviation','Full Name','Codons');
    for i=1:length(t)
        out = sprintf('%s%-6s%-5i%-14s%-29s%s\n',out,t{i}{1},t{i}{2},t{i}{3},t{i}{4},t{i}{5});
    end
elseif nargin == 1
    % check if we have an array
    arg1 = varargin{1};
    if ~any(strcmpi(char(arg1(1)),{'letter','code','name'}))
        cellflag = false;
        if iscell(arg1)
            cellflag = true;
            arg1 = char(arg1);
        end
        for count = 1:23
            map.(t{count}{1}) = t{count}{3};
            map.(upper(t{count}{3})) = t{count}{1};
        end
        % special cases for end and gap symbols
        
        map.J = 'END';
        map.O = 'GAP';
        map.GAP = '-';
        map.END = '*';
        
        [rows,cols] = size(arg1);
        % easy cases
        % size is n*3 or n*1
        
        if (rows > 1 && cols == 3)  
            out = blanks(rows);
            for loop = 1:rows
                out(loop) = map.(upper(arg1(loop,:)));
            end
        elseif (rows > 1 && cols == 1)
            out = repmat(' ',rows,3);
            for loop = 1:numel(arg1)
                out(loop,:) = map.(upper(arg1(loop)));
            end
        elseif rows == 1
            tripletFlag = false;
            if rem(cols,3) == 0 % maybe have triplets
                out = blanks(cols/3);
                try
                    for loop = 1:(cols/3)
                        out(loop) = map.(upper(arg1(3*(loop-1)+1:3*(loop-1)+3)));
                    end      
                    tripletFlag = true;
                catch
                    out = [];
                end
            end
            if tripletFlag == false
                out = blanks(3*cols);
                checkArg1 = aa2int(arg1);
                arg1(checkArg1 ==0 ) = [];
                arg1 = strrep(arg1,'*','J');
                arg1 = strrep(arg1,'-','O');
                
                for loop = 1:numel(arg1)
                    out(3*(loop-1)+1:3*(loop-1)+3) = map.(upper(arg1(loop)));
                end
            end
        else  % assume single and output as cell array
            out = cell(rows,cols);
            for loop = 1:numel(arg1)
                out{loop} = map.(upper(arg1(loop)));
            end
        end 
        
        if cellflag
            out = cellstr(out);
        end
    end
    
    % now deal with individual requests
else
    if rem(nargin,2) ~= 0
        error('Bioinfo:IncorrectNumberOfArguments',...
            'Incorrect number of arguments to %s.',mfilename);
    end
    okargs = {'code','abbreviation','integer','name'};
    for j=1:2:nargin
        pname = varargin{j};
        pval = varargin{j+1};
        k = strmatch(lower(pname), okargs);%#ok
        if isempty(k)
            error('Bioinfo:UnknownParameterName','Unknown parameter name:  %s.',pname);
        elseif length(k)>1
            error('Bioinfo:AmbigousParameterName','Ambiguous parameter name:  %s.',pname);
        else
            switch(k)
                
                case 1 % code
                    for i=1:length(t)
                        if strcmpi(pval,t{i}{1})
                            out=sprintf('%s%s\t%s\n',out,t{i}{3},t{i}{4});
                            break;
                        elseif i==length(t)
                            error('Bioinfo:InvalidAminoAcidLetter',...
                                '%s is not a valid amino acid code',pval)
                        end
                    end
                case 2 % abbreviation
                    for i=1:length(t)
                        if strcmpi(pval,t{i}{3})
                            out=sprintf('%s%s\t%s\n',out,t{i}{1},t{i}{4});
                            break;
                        elseif i==length(t)
                            error('Bioinfo:InvalidAminoAcidCode',...
                                '%s is not a valid amino acid abbreviation',pval)
                        end
                    end
                case 3 %integer
                    for i=1:length(t)
                        if t{i}{2} == pval
                            out=sprintf('%s%s\t%s\t%s\n',out,t{i}{1},t{i}{3},t{i}{4});
                            break;
                        elseif i==length(t)
                            error('Bioinfo:InvalidAminoAcidName',...
                                '%s is not a valid amino acid name',pval)
                        end
                    end
                case 4 %name
                    for i=1:length(t)
                        if regexpi(t{i}{4},['\<' pval '\>'])
                            out=sprintf('%s%s\t%s\n',out,t{i}{1},t{i}{3});
                            break;
                        elseif i==length(t)
                            error('Bioinfo:InvalidAminoAcidName',...
                                '%s is not a valid amino acid name',pval)
                        end
                    end
            end
        end
    end   
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function t=aminotable
%AMINOTABLE returns cell array of amino acid symbol, integer, abbreviation,
%name and codons.
t = cell(25);
t{1}={'A',aa2int('A'),'Ala','Alanine','GCU GCC GCA GCG'};
t{2}={'R',aa2int('R'),'Arg','Arginine','CGU CGC CGA CGG AGA AGG'};
t{3}={'N',aa2int('N'),'Asn','Asparagine','AAU AAC'};
t{4}={'D',aa2int('D'),'Asp','Aspartic acid (Aspartate)','GAU GAC'};
t{5}={'C',aa2int('C'),'Cys','Cysteine','UGU UGC'};
t{6}={'Q',aa2int('Q'),'Gln','Glutamine','CAA CAG'};
t{7}={'E',aa2int('E'),'Glu','Glutamic acid (Glutamate)','GAA GAG'};
t{8}={'G',aa2int('G'),'Gly','Glycine','GGU GGC GGA GGG'};
t{9}={'H',aa2int('H'),'His','Histidine','CAU CAC'};
t{10}={'I',aa2int('I'),'Ile','Isoleucine','AUU AUC AUA'};
t{11}={'L',aa2int('L'),'Leu','Leucine','UUA UUG CUU CUC CUA CUG'};
t{12}={'K',aa2int('K'),'Lys','Lysine','AAA AAG'};
t{13}={'M',aa2int('M'),'Met','Methionine','AUG'};
t{14}={'F',aa2int('F'),'Phe','Phenylalanine','UUU UUC'};
t{15}={'P',aa2int('P'),'Pro','Proline','CCU CCC CCA CCG'};
t{16}={'S',aa2int('S'),'Ser','Serine','UCU UCC UCA UCG AGU AGC'};
t{17}={'T',aa2int('T'),'Thr','Threonine','ACU ACC ACA ACG'};
t{18}={'W',aa2int('W'),'Trp','Tryptophan','UGG'};
t{19}={'Y',aa2int('Y'),'Tyr','Tyrosine','UAU UAC'};
t{20}={'V',aa2int('V'),'Val','Valine','GUU GUC GUA GUG'};
t{21}={'B',aa2int('B'),'Asx','Aspartic acid or Asparagine','AAU AAC GAU GAC'};
t{22}={'Z',aa2int('Z'),'Glx','Glutamic acid or Glutamine','CAA CAG GAA GAG'};
t{23}={'X',aa2int('X'),'Xaa','Any amino acid','All'};
t{24}={'*',aa2int('*'),'END','Termination codon','UAA UAG UGA'};
t{25}={'-',aa2int('-'),'GAP','Gap of unknown length','---'};
%t{26}={'?',aa2int('?'),'???','Unknown amino acid','???'};
