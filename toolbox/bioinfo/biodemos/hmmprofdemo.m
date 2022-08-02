%% HMMPROFDEMO Hidden Markov Model for profile analysis of a protein family
% Sequence comparison is a key tool in bioinformatics. The objective of a
% HMM profile is to statistically model patterns in biological sequences by
% identifying combinations of matches, in-dels, and gaps in the alignment
% of a query sequence to a profile model. HMM profile analysis can be used
% for multiple sequence alignment, for a database search, to analyze
% sequence composition and pattern segmentation, and to predict protein
% structure and locate genes by predicting open reading frames. This
% demonstration shows how HMM profiles are used to characterize protein
% families.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.10.4.6 $  $Date: 2004/04/14 23:57:04 $

if playbiodemo, return; end % Open in the editor or run step-by-step

%% Accessing PFAM databases
% Starting with an already built HMM of a protein family, retrieve the
% model for the well-known 7-fold transmembrane receptor from the Sanger 
% Institute database. The PFAM key number is PF00002. Also retrieve the
% pre-aligned sequences used to train this model. More information 
% about the PFAM database can be found at http://www.sanger.ac.uk/.

hmm_7tm = gethmmprof(2)
seqs = gethmmalignment(2,'type','seed');

%%
% Models and alignments can also be stored and parsed in later directly
% from the files. 

hmm_7tm = pfamhmmread('pf00002.ls');     %<-- HMMER 2.0 formatted file
seqs = fastaread('pf00002.fa');          %<-- FASTA formatted file

%%
% If the Sanger site is not accessible, mirror sites can be accessed using
% their complete URL.

pfamhmmread('http://pfam.wustl.edu/cgi-bin/gethmm?name=7tm_2&type=fs');

%%
% Display the names and contents of the loaded sequences using the *disp*
% command.

disp([char(seqs.Header) char(seqs.Sequence)])

%% Profile HMM alignment
% To test the profile HMM alignment tool, first erase the periods in
% sequences used to format the downloaded aligned sequences. Doing this
% removes the alignment information from the sequences.

for sn = 1:length(seqs)
    ind = seqs(sn).Sequence ~= '.';
    seqs(sn).Sequence = seqs(sn).Sequence(ind);
end     
 
%%
% Now align all the proteins to the HMM profile.
fprintf('Aligning sequences ')
scores = zeros(length(seqs),1);
for sn=1:length(seqs)
    fprintf('.')
    [scores(sn),seqs(sn).Aligned]=hmmprofalign(hmm_7tm,seqs(sn).Sequence);
end

%%
% Next, send the results to the Help Browser to better explore the new
% multiple alignment. Columns marked with * at the bottom indicate when 
% the model was in a "match" or "delete" state.

hmmprofmerge(seqs,scores)

%% Looking for evidence with sequence comparison
% Having a profile HHM which describes this family has several advantages
% over plain sequence comparison. Suppose that you have a new
% oligonucleotide that you want to relate to the 7-transmembrane receptor
% family. For this example, get a nucleotide sequence from NCBI and
% translate it to an amino acid sequence.

accs='NM_175642.2';
nts=getgenbank(accs,'sequenceonly',true);

%%
% If you don't have a live web connection you can load the data from the
% GeneBank formatted file: (uncomment the following lines)

% GBOUT = genbankread('nm175642.2.txt');
% nts = GBOUT.Sequence; 

NM1756422=nt2aa(nts,'frame',1);
NM1756422(NM1756422 == '*') = [];
seqdisp(NM1756422)

%%
% Try to relate it to the first sequence in the 7tm_2 multiple alignment
% using dot plots. Is there any evidence that they are related?

Q9YHC6 = seqs(1).Sequence;
seqdotplot(Q9YHC6,NM1756422)
ylabel(seqs(1).Header);xlabel('NM 175642.2');
set(gca,'Position',[0.05,0.02,0.92,0.75]);

%%
% One way of testing this is to use a sliding window dot plot.

seqdotplot(Q9YHC6,NM1756422,7,2)
ylabel(seqs(1).Header);xlabel('NM 175642.2');
set(gca,'Position',[0.05,0.02,0.92,0.75]);

%%
% Dot plots only take exact matches into account. The Smith-Waterman
% algorithm can make use of scoring matrices. Scoring matrices can capture
% the probability of substitution of symbols. The sequences in this example
% are known to be only distantly related, so BLOSUM30 is a good choice for
% the scoring matrix.

[score, alignment] = swalign(Q9YHC6,NM1756422,'ScoringMatrix','blosum30')

%%
% perhaps also allowing gap extensions

[score, alignment] = swalign(Q9YHC6,NM1756422,'ScoringMatrix','blosum30','gapopen',5,'extendgap',3)

%%
% Is either of these two alignments enough evidence to affirm that these
% sequences are related? One way to test this is to randomly create a fake
% sequence with the same distribution of aminoacids and see how it aligns
% to the family.  Notice that the scores from the local alignment are not
% significantly lower than those for the real protein. 

fakeSeq = randseq(1000,'FROMSTRUCTURE',aacount(Q9YHC6));
[score, alignment] = swalign(Q9YHC6,fakeSeq,'ScoringMatrix','blosum30')
[score, alignment] = swalign(Q9YHC6,fakeSeq,'ScoringMatrix','blosum30','gapopen',5,'extendgap',3)

%%
% Align both sequences to the family using the profile HMM and see the 
% difference

[score_aa,align_aa] = hmmprofalign(hmm_7tm,NM1756422)
[score_fk,align_fk] = hmmprofalign(hmm_7tm,fakeSeq)

%%
% Put both sequences into the multiple alignment and compare with the rest
% of the members of the family using the Help Browser.

numofseq = numel(seqs);
seqs(numofseq+1).Sequence = NM1756422;
seqs(numofseq+1).Header = accs;
seqs(numofseq+1).Aligned = align_aa;
scores(numofseq+1) = score_aa;

seqs(numofseq+2).Sequence = fakeSeq;
seqs(numofseq+2).Header = 'Fake Sequence';
seqs(numofseq+2).Aligned = align_fk;
scores(numofseq+2) = score_fk;

hmmprofmerge(seqs,scores)

%% Exploring profile HMM alignment options
% You can compare the recent alignments graphically using the 'showscore'
% option to the *hmmprofalign* function.

%% 
% Display NM_175642.2 aligned to the 7tm_2 family.
[score_aa,align_aa,ptrs_aa] = hmmprofalign(hmm_7tm,NM1756422,'showscore',true);

%% 
% Display the "fake" sequence aligned to the 7tm_2 family.
[score_fk,align_fk,ptrs_fk] = hmmprofalign(hmm_7tm,fakeSeq,'showscore',true);

%%
% Display NM_175642.2 globally aligned to the 7tm_2 family.
aa=NM1756422;
seq = aa(min(ptrs_aa):max(ptrs_aa));
[score,align] = hmmprofalign(hmm_7tm,seq,'showscore',true);

%%
% Display flanking insertions when aligning NM_175642.2 to the 7tm_2 family
[score,align] = hmmprofalign(hmm_7tm,aa,'flanks',true)

%%
% Align tandemly repeated domains.
repeats = randseq(1000,'FROMSTRUCTURE',aacount(aa)); %artificial example
repeats(201:200+length(aa(876:1154))) = aa(876:1154);
repeats(501:500+length(aa(876:1154))) = aa(876:1154);
repeats(701:700+length(aa(876:1154))) = aa(876:1154); 
[score,align] = hmmprofalign(hmm_7tm,repeats,'showscore',true);

%% Searching for fragment domains
% There are two options for searching for fragment domains: (1) download the
% respective profile HMM for fragment alignments from the PFAM database,

hmm_7tm_f = gethmmprof(2,'mode','fs')

%%
% or (2) manually activate the *B->M* and *M->E* transition probabilities:
hmm_7tm_f = hmm_7tm;
hmm_7tm_f.BeginX(3:end)=.002;
hmm_7tm_f.MatchX(1:end-1,4)=.002;

%%
% Create a random sequence, or fragment model, with a small insertion of
% the NM_175642.2 protein:
fragment = randseq(1000,'FROMSTRUCTURE',aacount(aa));
fragment(501:550) = aa(901:950);

%%
% Try aligning both models, the global and fragment model:
[score,align] = hmmprofalign(hmm_7tm,fragment,'showscore',true);
[score,align] = hmmprofalign(hmm_7tm_f,fragment,'showscore',true);

%% Exploring the profile HMMs
% The function *showhmmprof* is an interactive tool to explore the profile
% HMM. Try right and left mouse clicks over the model figures. There are
% three plots for each model (global and fragment domains): (1) the symbol
% emission probabilities in the *Match* states, (2) the symbol emission
% probabilities in the *Insert* states, and (3) the *Transition*
% probabilities.
showhmmprof(hmm_7tm,'scale','logodds')
showhmmprof(hmm_7tm_f,'scale','logodds')

%%
% More information regarding how to store the profile HMM information in a
% MATLAB structure is found in *hmmprofstruct*.
hmmprofstruct

%% Profile Estimation
% Finally, profile HMMs can also be estimated from a multiple alignment, as
% new sequences related to the family are found, it is possible to
% re-estimate the model parameters. 

seqs(end)= [];  % exclude the fake sequence !
hmm_7tm_new = hmmprofestimate(hmm_7tm,char(seqs.Aligned))
showhmmprof(hmm_7tm_new ,'scale','logodds')

%%
% Align all sequences to the new model and show them in the Help Browser.
fprintf('Aligning sequences ')
scores = zeros(length(seqs),1);
for sn=1:length(seqs)
    fprintf('.')
    [scores(sn),seqs(sn).Aligned]=hmmprofalign(hmm_7tm_new,seqs(sn).Sequence);
end

hmmprofmerge(seqs,scores)

