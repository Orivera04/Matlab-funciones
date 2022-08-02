function out = baselookup(varargin)
%BASELOOKUP displays nucleotide codes, integers, names, and complements.
%
%   BASELOOKUP displays a table of all nucleotide codes, integers,
%   meanings, full names, and complements. The integers follow the
%   pattern defined by NT2INT.
%
%   BASELOOKUP('COMPLEMENT', SEQUENCE) displays the complementary
%   nucleotide sequence. SEQUENCE can be a single nucleotide sequence,
%   a cell array of sequences, or a two-dimensional character array of
%   sequences. The complement for each sequence is determined
%   independently.
%
%   BASELOOKUP('CODE', CODE) displays the corresponding nucleotide's
%   meaning and full name. CODE can also be a cell array or a two-
%   dimensional character array. The possible codes are
%   G A T C R Y M K S W H B V D N.
%
%   BASELOOKUP('INTEGER', INTEGER) displays the corresponding nucleotide's
%   code, name, and meaning. INTEGER is the value returned for a given
%   nucleotide by the function NT2INT.
%
%   BASELOOKUP('NAME', NAME) displays the corresponding nucleotide's code
%   and meaning. NAME can be a single name, a cell array, or a two-
%   dimensional character array.
%
%   Examples:
%
%      baselookup('COMPLEMENT', 'TAGCTGRCCAAGGCCAAGCGAGCTTN')
%      baselookup('name','cytosine')
%
%   See also BASECOUNT, CODONCOUNT, DIMERCOUNT, GENETICCODE, NT2AA, NT2INT,
%   REVGENETICCODE.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/01/24 09:17:14 $

t=basetable;
out='';
if nargin == 0
    % no arguments prints the table
    out = sprintf('%s%-6s%-5s%-9s%-32s%-6s\n',out,'Code','Int','Meaning','Full Name','Complement');
    for i=1:length(t)
        if i == 17
            out = sprintf('%s%s\n',out,'Nonstandard, but supported codes for DNA');
        end
        out = sprintf('%s%-6s%-5i%-9s%-32s%s\n',out,t{i}{1},t{i}{2},t{i}{3},t{i}{4},t{i}{5});
    end
    out = sprintf('%s\n%s\n',out,'Note: In a few cases, the complement is the same as the code');
else
    if rem(nargin,2) ~= 0
        error('Bioinfo:IncorrectNumberOfArguments',...
            'Incorrect number of arguments to %s.',mfilename);
    end
    okargs = {'complement','code','integer','name'};
    for j=1:2:nargin
        pname = varargin{j};
        pval = varargin{j+1};
        [rows,cols] = size(pval);
        if rows ~= 1 % convert a matrix into a cell array
            pval = cellstr(pval)';
            [rows,cols] = size(pval);
            count = rows*cols;
        else % convert a single text value into a cell array
            if iscell(pval)
                count = rows*cols;
            else
                count = 1;
            end
            if isnumeric(pval)
                pval = int2nt(pval);
            end
            pval = cellstr(pval);
        end
        k = strmatch(lower(pname), okargs);%#ok
        if isempty(k)
            error('Bioinfo:UnknownParameterName','Unknown parameter name:  %s.',pname);
        elseif length(k)>1
            error('Bioinfo:AmbigousParameterName','Ambiguous parameter name:  %s.',pname);
        else
            for i=1:count
                switch(k)
                
                    case 1 % complement
                        if regexpi(pval{i},'[EFIJLOPQZ]')
                            bad_code = regexpi(pval{i},'[EFIJLOPQZ]','match','once');
                            error('Bioinfo:InvalidBaseCode',...
                                    '%s is not a valid nucleotide code', bad_code)
                        end
                        code = lower(pval{i});
                        for j=1:length(t)
                            code = strrep(code,lower(t{j}{1}),t{j}{5});
                        end
                        out = sprintf('%s%s\n',out,code);
                        
                    case 2 %code
                        for j=1:length(t)
                            if strcmpi(pval{i},t{j}{1})
                                out=sprintf('%s%s\t%s\n',out,t{j}{3},t{j}{4});
                                break;
                            elseif j==length(t)
                                error('Bioinfo:InvalidBaseCode',...
                                    '%s is not a valid nucleotide code',pval{i})
                            end
                        end
                        
                    case 3 %integer
                        for j=1:length(t)
                            if int2nt(t{j}{2}) == pval{i}
                                out=sprintf('%s%s\t%s - %s\n',out,t{j}{1},t{j}{3},t{j}{4});
                                break;
                            elseif j==length(t)
                                error('Bioinfo:InvalidBaseInteger',...
                                    '%s is not a valid nucleotide integer',pval{i})
                            end
                        end
                        
                    case 4 %name
                        for j=1:length(t)
                            if regexpi(t{j}{4},['^\<' pval{i} '\>'])
                                out=sprintf('%s%s\t%s - %s\n',out,t{j}{1},t{j}{3},t{j}{4});
                                break;
                            elseif j==length(t)
                                error('Bioinfo:InvalidBaseName',...
                                    '%s is not a valid nucleotide name',pval{i})
                            end
                        end
                    end
            end
        end
    end   
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function t=basetable
%BASETABLE returns cell array of nucleotide code, abbreviation, name and
%complement.
t = cell(18);
t{1}={'A',nt2int('A'),'A','Adenine','T'};
t{2}={'C',nt2int('C'),'C','Cytosine','G'};
t{3}={'G',nt2int('G'),'G','Guanine','C'};
t{4}={'T',nt2int('T'),'T','Thymine','A'};
t{5}={'R',nt2int('R'),'G|A','puRine','Y'};
t{6}={'Y',nt2int('Y'),'T|C','pYrimidine','R'};
t{7}={'K',nt2int('K'),'G|T','Keto','M'};
t{8}={'M',nt2int('M'),'A|C','aMino','K'};
t{9}={'S',nt2int('S'),'G|C','Strong interaction (3 H bonds)','S'};
t{10}={'W',nt2int('W'),'A|T','Weak interaction (2 H bonds)','W'};
t{11}={'B',nt2int('B'),'G|T|C','not-A (B follows A)','V'};
t{12}={'D',nt2int('D'),'G|A|T','not-C (D follows C)','H'};
t{13}={'H',nt2int('H'),'A|T|C','not-G (H follows G)','D'};
t{14}={'V',nt2int('V'),'G|A|C','not-T (or U) (V follows U)','B'};
t{15}={'N',nt2int('N'),'G|A|T|C','aNy nucleotide','N'};
t{16}={'-',nt2int('-'),'GAP','Gap of unknown length','-'};
%Nonstandard, but supported codes for DNA
t{17}={'U',nt2int('U'),'T','Thymine','A'};
t{18}={'X',nt2int('X'),'G|A|T|C','aNy nucleotide','N'};
