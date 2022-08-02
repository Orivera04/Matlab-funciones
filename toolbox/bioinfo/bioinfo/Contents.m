% Bioinformatics Toolbox
% Version 1.1 (R14) 05-May-2004
%
% File I/O
%   blastread       - Read an NCBI BLAST format report file.
%   emblread        - Read an EMBL format file.
%   fastaread       - Read a sequence from a FASTA format file or URL.
%   fastawrite      - Write a sequence to a FASTA format file.
%   genbankread     - Read a GenBank format file.
%   genpeptread     - Read a GenPept format file.
%   getblast        - Get a BLAST report from NCBI.
%   getembl         - Get sequence data from EMBL.
%   getgenbank      - Get sequence data from GenBank.
%   getgenpept      - Get sequence data from GenPept.
%   getpdb          - Get sequence data from PDB.
%   getpir          - Get sequence data from PIR-PSD.
%   multialignread  - Read a multiple sequence alignment file.
%   pdbread         - Read a PDB format file.
%   pirread         - Read a PIR format file.
%   scfread         - Read an SCF format trace file.
%
% Sequence Conversion
%   aa2int          - Convert from amino acid to integer representation.
%   aa2nt           - Convert a sequence of amino acids to nucleotides.
%   dna2rna         - Convert a sequence of DNA nucleotides to RNA.
%   int2aa          - Convert from integer to amino acid representation.
%   int2nt          - Convert from integer to nucleotide representation.
%   nt2aa           - Convert a sequence of nucleotides to amino acids.
%   nt2int          - Convert from nucleotide to integer representation.
%   rna2dna         - Convert a sequence of RNA nucleotides to DNA.
%   seq2regexp      - Convert a sequence that contains wildcards to a regular expression.
%   seqcomplement   - Calculate the complementary strand of a DNA sequence.
%   seqrcomplement  - Calculate the reverse complement of a DNA sequence.
%   seqreverse      - Reverse a sequence.
%
% Sequence Statistics
%   aacount         - Report amino acid counts in a sequence.
%   basecount       - Report nucleotide base counts in a sequence.
%   codoncount      - Report codon counts in a sequence.
%   dimercount      - Report dimer counts in a sequence.
%   nmercount       - Report n-mer counts in a sequence.
%   ntdensity       - Plot nucleotide density along the sequence.
%   seqshowwords    - Graphical display of words in a sequence.
%   seqwordcount    - Report word counts for a sequence.
%
% Sequence Utilities
%   aminolookup     - Lookup table for peptide symbols.
%   baselookup      - Lookup table for nucleotide symbols.
%   blastncbi       - Generate a remote NCBI BLAST request.
%   geneticcode     - Mapping for the genetic code.
%   joinseq         - Join two sequences.
%   palindromes     - Find palindromes in a sequence.
%   randseq         - Generate a random sequence from a finite alphabet.
%   restrict        - Split a sequence at a restriction site.
%   revgeneticcode  - Reverse mapping for the genetic code.
%   seqmatch        - Find matches for every string in a library.
%   seqdisp         - Format long sequences for easy viewing.
%   seqshoworfs     - Graphical display of Open Reading Frames in a sequence.
%
% Pairwise Sequence Alignment
%   nwalign         - Needleman-Wunsch global alignment.
%   seqdotplot      - Create a dotplot of two sequences.
%   showalignment   - Visualization of sequence alignment.
%   swalign         - Smith-Waterman local alignment.
%
% Protein Analysis
%   aacount         - Show the amino acid composition of a protein sequence.
%   aminolookup     - Lookup table for peptide symbols.
%   atomiccomp      - Calculate atomic composition of a protein.
%   cleave          - Cleave a protein with an enzyme.
%   isoelectric     - Estimate the isoelectric point of a protein sequence.
%   molweight       - Calculate molecular weight of a peptide sequence.
%   pdbdistplot     - Visualization of inter-molecular distances in a PDB file.
%   proteinplot     - GUI for protein analysis.
%   ramachandran    - Ramachandran plot for PDB data.
%
% Trace tools
%   scfread         - Read SCF format trace data.
%   traceplot       - View nucleotide trace plots.
%
% Profile Hidden Markov Models
%   gethmmalignment - Get a multiple alignment from the PFAM database.
%   gethmmprof      - Get a HMM from the PFAM database.
%   gethmmtree      - Get a phylogenetic tree from the PFAM database.
%   hmmprofalign    - Sequence alignment to a profile HMM.
%   hmmprofestimate - Estimate the parameters of a profile HMM.
%   hmmprofgenerate - Generate a random sequence from a profile HMM.
%   hmmprofmerge    - Align the output strings of several profile alignments.
%   hmmprofstruct   - Create a profile HMM structure.
%   pfamhmmread     - Read a PFAM format HMM profile.
%   showhmmprof     - Plot an HMM profile.
%
% Phylogenetic Tree Tools
%   phytreeread     - Read NEWICK tree formatted file.
%   phytreetool     - Interactive tool to explore/edit phylogenetic trees.
%   phytreewrite    - Save a phylogenetic tree object as a NEWICK format file.
%   seqlinkage      - Construct a phylogenetic tree from pairwise distances.
%   seqpdist        - Pairwise distance between sequences.
%
% Phylogenetic Tree Methods
%   phytree           - Phylogenetic tree object.
%   phytree/get       - Gets information about a phylogenetic tree object.
%   phytree/getbyname - Selects branches and leaves by name.
%   phytree/pdist     - Computes the pairwise patristic distance.
%   phytree/plot      - Renders a phylogenetic tree.
%   phytree/prune     - Reduces a phylogenetic tree by removing branch nodes.
%   phytree/select    - Selects tree leaves and branches.
%   phytree/view      - View a phylogenetic tree in phytreetool.
%
% Microarray File Formats
%   affyread        - Read Affymetrix GeneChip files. (Windows only)
%   imageneread     - Read ImaGene format results file.
%   galread         - Read GenePix GAL file.
%   geosoftread     - Read Gene Expression Omnibus (GEO) SOFT format data.
%   getgeodata      - Get Gene Expression Omnibus (GEO) data.
%   gprread         - Read GenePix GPR file.
%   sptread         - Read SPOT format file.
%
% Microarray Visualization
%   clustergram     - Clustergram plot.
%   maboxplot       - Box plot of microarray data.
%   maimage         - Pseudocolor plot of microarray spatial data.
%   mairplot        - Intensity plot of microarray signals.
%   maloglog        - Log-log plot of microarray data.
%   mapcaplot       - Principal Component plot of expression profile data.
%   redgreencmap    - Red and green colormap.
%
% Microarray Normalization and Filtering
%   exprprofrange     - Calculate range of expression profiles.
%   exprprofvar       - Calculate variance of expression profiles.
%   geneentropyfilter - Remove genes with entropy expression values.
%   genelowvalfilter  - Remove genes with low expression values.
%   generangefilter   - Remove genes with small expression ranges.
%   genevarfilter     - Remove genes with small expression variance.
%   malowess          - Lowess normalization.
%   mamadnorm         - Median Absolute Deviation (MAD) normalization.
%   mameannorm        - Global mean normalization.
%
% Scoring Matrices
%   blosum          - BLOSUM family of matrices.
%   dayhoff         - Dayhoff matrix.
%   gonnet          - Gonnet variation on PAM250.
%   nuc44           - Nuc44 nucleotide matrix.
%   pam             - PAM family of matrices.
%   
% Tutorials, demos and examples.
%   aligndemo        - Basic sequence alignment tutorial demo. 
%   alignscoringdemo - Tutorial showing the use of scoring matrices. 
%   alignsigdemo     - Demo of how to estimate the significance of alignments.
%   biclusterdemo    - Clustergram functionality examples.
%   biojavademo      - Example of calling BioJava functions.
%   bioperldemo      - Example of calling Bioperl functions.
%   biowebservicedemo - Example of using a SOAP based web service.
%   hmmprofdemo      - HMM profile alignment tutorial example.
%   hivdemo          - Analyzing the origin of the HIV with phylogenetic trees.
%   mousedemo        - Microarray normalization and visualization example.
%   primatesdemo     - Building a phylogenetic tree for the hominidae species.
%   seqstatsdemo     - Sequence statistics tutorial example.
%   yeastdemo        - Microarray data analysis example.
%

%   GenePix is a registered trademark of Axon Instruments, Inc. 
%   GeneChip and Affymetrix are registered trademark of Affymetrix, Inc. 

%   Copyright 2003-2004 The MathWorks, Inc. 
%   Generated from Contents.m_template revision 1.1.6.9  $Date: 2004/03/22 23:53:23 $

