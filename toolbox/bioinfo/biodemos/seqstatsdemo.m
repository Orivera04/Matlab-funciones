%% SEQSTATSDEMO Example of sequence statistics with MATLAB
% This demonstration looks at some statistics about the DNA content of the
% human mitochondrial genome.

%   Copyright 2003-2004 The MathWorks, Inc. 
%   $Revision: 1.10.4.5 $  $Date: 2004/04/01 15:58:47 $ 

if playbiodemo, return; end % Open in the editor or run step-by-step

%% Introduction
% Mitochondria are generally the major energy production center in
% eukaryotes. The Genome repository at the NCBI contains more interesting
% information about the human mitochondrial genome. 

web('http://www.ncbi.nlm.nih.gov/genomes/framik.cgi?db=Genome&gi=12188')   

%%
% The consensus sequence of the human mitochondria genome has accession
% number NC_001807. The whole GenBank entry is quite large and this example
% only uses the nucleotide sequence, so you can use the *getgenbank*
% function with the 'SequenceOnly' flag to read just the sequence
% information into the MATLAB workspace.

mitochondria = getgenbank('NC_001807','SequenceOnly',true);

%%
% If you don't have a live web connection, you can load the data from a
% MAT-file using the command

% load mitochondria     % <== Uncomment this if no internet connection

%%
% The MATLAB *whos* command gives information about the size of the
% sequence.

whos mitochondria

%%
% You will use some of the sequence statistics function in the
% Bioinformatics Toolbox to look at various properties of this sequence.
% You can look at the composition of the nucleotides with the *ntdensity*
% function. 

ntdensity(mitochondria)

%% Composition of the mitochondrial genome.
% This shows that the genome is A-T rich. You can get more specific
% information with the *basecount* function.

basecount(mitochondria)

%%
% These are on the 5'-3' strand. You can look at the reverse complement
% using the *seqrcomplement* function.

basecount(seqrcomplement(mitochondria))

%%
% As expected, the base counts on the reverse complement strand are
% complementary to the counts on the 5'-3' strand.  
%%
% You can use the chart option to *basecount* to display a pie chart of the
% distribution of the bases.

figure
basecount(mitochondria,'chart','pie');

%%
% Now look at the dimers in the sequence and display the information in a
% bar chart using *dimercount*.

figure
dimercount(mitochondria,'chart','bar')

%%
% You can look at codons using *codoncount*. The function *dimercount*
% simply counts all adjacent nucleotides; however *codoncount* counts the
% codons on a particular reading frame. With no options, the function shows
% the codon counts on the first reading frame. 

codoncount(mitochondria)

%%
% Using a loop you can also look at all the other reading frames:

for frame = 1:3
    figure
    subplot(2,1,1); codoncount(mitochondria,'frame',frame,'figure',true);
    title(sprintf('Codons for frame %d',frame));
    subplot(2,1,2); codoncount(mitochondria,'reverse',true,'frame',frame,'figure',true); 
    title(sprintf('Codons for reverse frame %d',frame));
end

%% Exploring the Open Reading Frames (ORFs)
% In a nucleotide sequence an obvious thing to look for is if there are any
% open reading frames. The function *seqshoworfs* can be used to visualize
% ORFs in a sequence. 
% Note: In the HTML tutorial only the first 7500 bases of the first reading
% frame are shown, however when running the demo you will be able to
% inspect the complete mitochondrial genome with the aid of the *Help
% Browser* .

seqshoworfs(mitochondria);

%%
% If you compare this output to the genes shown on the NCBI page there seem
% to be slightly fewer ORFs, and hence fewer genes, than expected.
% Vertebrate mitochondria do not use the Standard genetic code so some
% codons have different meaning in mitochondrial genomes. For more
% information about using different genetic codes in MATLAB see the help
% for the function *geneticcode*.

help geneticcode

%%
% The 'GeneticCode' option to the *seqshoworfs* function allows you to look
% at the ORFs again but this time with the vertebrate mitochondrial genetic
% code. 
% Notice that there are now two much larger ORFs on the first reading
% frame: One starting at position 4471 and the other starting at 5905.
% These correspond to the ND2 (NADH dehydrogenase subunit 2) and COX1
% (cytochrome c oxidase subunit I) genes. 

orfs = seqshoworfs(mitochondria,'GeneticCode','Vertebrate Mitochondrial',...
        'alternativestart',true)

%% Extracting and analyzing the ND2 protein
% The ORF of interest starts at position 4471, the following commands can
% be used to find the corresponding stop codon:

ND2Start = 4471;
startIndex = find(orfs(1).Start == ND2Start)
ND2Stop = orfs(1).Stop(startIndex)

%%
% Once the positions are known, MATLAB indexing can be used to extract the
% region of interest. 

ND2Seq = mitochondria(ND2Start:ND2Stop);

%%
% If you look at the *codoncount* for this gene we see a lot of CTA and ATC
% codons. 

codoncount(ND2Seq) 

%%
% For those of you who have not memorized the genetic code you can easily
% check what amino acids these codons get translated into using the *nt2aa*
% and *aminolookup* functions.  

aminolookup('code',nt2aa('CTA')) 
aminolookup('code',nt2aa('ATC'))

%%
% The *nt2aa* function converts the nucleotide sequence to the
% corresponding amino acid sequence. Again the 'GeneticCode' option must be
% used to specify the vertebrate mitochondrial genetic code.

ND2 = nt2aa(ND2Seq,'GeneticCode','Vertebrate Mitochondria');

%%
% You can get a more complete picture of the amino acid content with
% *aacount*. 

figure
aacount(ND2,'chart','bar')

%%
% Notice the high leucine, threonine and isoleucine content and also the
% lack of cysteine or aspartic acid.

%%
% You can use the *atomiccomp* and *molweight* functions to find out more
% about the ND2 protein.

atomiccomp(ND2)
molweight(ND2)

%%
% For further investigation of the properties of the ND2 protein, try using
% *proteinplot*. This is a graphical user interface (GUI) that allows you
% to easily create plots of various properties, such as hydrophobicity, of
% a protein sequence. Click on the "Help" menu in the GUI for more
% information on how to use the tool. 

proteinplot(ND2)

