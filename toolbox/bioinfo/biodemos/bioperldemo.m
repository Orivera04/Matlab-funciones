%% BIOPERLDEMO: Example of calling Bioperl functions in MATLAB
% This demonstration illustrates the interoperability between MATLAB and
% Bioperl - passing arguments from MATLAB to Perl scripts and pulling BLAST
% search data back to MATLAB.
%
% NOTE: Perl and the Bioperl modules must be installed to run the Perl
% scripts in this demonstration. See http://www.perl.com and
% http://bioperl.org/ for current release files and complete installation
% instructions.

%   Copyright 2003-2004 The MathWorks, Inc. 
%   $Revision: 1.1.6.6 $  $Date: 2004/04/10 23:12:18 $ 

if playbiodemo, return; end % Open in the editor or run step-by-step

%% Introduction
% Gleevec(tm) (STI571 or imatinib mesylate) was the first approved drug to
% specifically turn off the signal of a known cancer-causing protein.
% Initially approved to treat chronic myelogenous leukemia (CML), it is
% also effective for treatment of gastrointestinal stromal tumors (GIST).

% If you have access to the Internet, uncomment this line to learn more:
% web('http://www.cancer.gov/clinicaltrials/digestpage/gleevec')   

%%
% Research has identified several gene targets for Gleevec including:
% Proto-oncogene tyrosine-protein kinase ABL1 (NP_009297), Proto-oncogene
% tyrosine-protein kinase Kit (NP_000213), and Platelet-derived growth
% factor receptor alpha precursor (NP_006197).

target_ABL1 = 'NP_009297';
target_Kit = 'NP_000213';
target_PDGFRA = 'NP_006197';

%% Accessing Sequence Information
% You can load the sequence information for these proteins from local
% GenPept text files using *genpeptread*.

ABL1_seq = getfield(genpeptread('ABL1_gp.txt'), 'Sequence');
Kit_seq = getfield(genpeptread('Kit_gp.txt'), 'Sequence');
PDGFRA_seq = getfield(genpeptread('PDGFRA_gp.txt'), 'Sequence');

%%
% Alternatively, you can obtain protein information directly from the
% online GenPept database maintained by the National Center for
% Biotechnology Information (NCBI).

% Uncomment these lines to download data from NCBI:
% ABL1_seq = getgenpept(target_ABL1, 'SequenceOnly', true);
% Kit_seq = getgenpept(target_Kit, 'SequenceOnly', true);
% PDGFRA_seq = getgenpept(target_PDGFRA, 'SequenceOnly', true);

%%
% The MATLAB *whos* command gives information about the size of these
% sequences.

whos ABL1_seq
whos Kit_seq
whos PDGFRA_seq

%% Calling Perl Programs from MATLAB
% From MATLAB, you can harness existing Bioperl modules to run a BLAST
% search on these sequences. MW_BLAST.pl is a Perl program based on the
% RemoteBlast Bioperl module. It reads sequences from FASTA files, so
% start by creating a FASTA file for each sequence.

fastawrite('ABL1.fa', 'ABL1 Proto-oncogene tyrosine-protein kinase (NP_009297)', ABL1_seq);
fastawrite('Kit.fa', 'Kit Proto-oncogene tyrosine-protein kinase (NP_000213)', Kit_seq);
fastawrite('PDGFRA.fa', 'PDGFRA alpha precursor (NP_006197)', PDGFRA_seq);

%%
% BLAST searches can take a long time to return results, and the Perl
% program MW_BLAST includes a repeating sleep state to await the report.
% Sample results have been included with this demo, but if you have an
% Internet connection and want to try running the BLAST search with the
% three sequences, uncomment the following command. MW_BLAST.pl saves the
% BLAST results in three files on your disk, ABL1.out, Kit.out and
% PDGFRA.out. The process can take 15 minutes or more.

% perl('MW_BLAST.pl','blastp','pdb','1e-10','ABL1.fa','Kit.fa','PDGFRA.fa');

%%
% Here is the Perl code for MW_BLAST:

type MW_BLAST.pl

%%
% The next step is to parse the output reports and find scores >= 100. You
% can then identify hits found by more than one protein for further
% research, possibly identifying new targets for drug therapy.

protein_list = perl('MW_parse.pl', 'ABL1.out', 'Kit.out', 'PDGFRA.out')

%%
% This is the code for MW_parse:

type MW_parse.pl

%% Calling MATLAB Functions within Perl Programs
% If you are running on Windows, it is also possible to call MATLAB
% functions from Perl. You can launch MATLAB in an Automation Server mode
% by using the /Automation switch in the MATLAB startup command
% (D:\applications\matlab7\bin\matlab.bat /Automation).

% Now you're ready to make calls to MATLAB from any of your Perl scripts.
% Here's a simple script to illustrate the process.

type MATLAB_from_Perl.pl

%% Protein Analysis Tools in the Bioinformatics Toolbox
% MATLAB offers additional tools for protein analysis and further research
% with these proteins. For example, to access the sequences and run a full
% Smith-Waterman alignment on the tyrosine kinase domain of the human
% insulin receptor (pdb 1IRK) and the kinase domain of the human lymphocyte
% kinase (pdb 3LCK), load the sequence data:

IRK = pdbread('pdb1irk.ent');
LCK = pdbread('pdb3lck.ent');

% Uncomment these lines to bring the data from the Internet:
% IRK = getpdb('1IRK');
% LCK = getpdb('3LCK');

%%
% Now perform a local alignment with the Smith-Waterman algorithm. MATLAB
% uses BLOSUM 50 as the default scoring matrix for AA strings with a gap
% penalty of 8. Of course, you can change any of these parameters.

[Score, Alignment] = swalign(IRK, LCK, 'showscore', true);
%%
showalignment(Alignment);

%%
% MATLAB and the Bioinformatics Toolbox offer additional tools for
% investigating nucleotide and amino acid sequences. For example,
% *pdbdistplot* displays the distances between atoms and amino acids in a
% PDB structure, while *ramachandran* generates a plot of the torsion angle
% PHI and the torsion angle PSI of the protein sequence. The toolbox
% function *proteinplot* provides a graphical user interface (GUI) to
% easily import sequences and plot various properties such as
% hydrophobicity.
