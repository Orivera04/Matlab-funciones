%% ALIGNSCORINGDEMO Scoring matrices and evolution distance
% This example shows how to handle *Scoring Matrices* with the sequence
% alignment tools. The example uses proteins associated with
% retinoblastoma, a disease caused by a tumor which develops from the
% immature retina.

%   Copyright 2003-2004 The MathWorks, Inc. 
%   $Revision: 1.6.4.3 $  $Date: 2004/04/01 15:57:30 $
 
if playbiodemo, return; end % Open in the editor or run step-by-step

%% Accessing the NCBI website and database
% More information on retinoblastoma can be found at 

web('http://www.ncbi.nlm.nih.gov/books/bv.fcgi?call=bv.View..ShowSection&rid=gnd.section.129');

%%
% The "BLink" link on the left side of this page shows related sequences in
% different organisms. 
% Download a few of these into the MATLAB workspace.

human = getgenpept('RBHU','SequenceOnly',true);
chicken = getgenpept('CAA51019','SequenceOnly',true);
trout = getgenpept('AAD13390','SequenceOnly',true);
xenopus = getgenpept('AAB23173','SequenceOnly',true);

%%
% If you don't have a live web connection, you can load the data from a
% MAT-file using the command 

% load retinoblastoma        % <== Uncomment this if no live connection.

%% Aligning RBHU (human protein) to CAA51019 (chicken protein)
% One approach to study the relationship between these two proteins is to
% use a global alignment with the *nwalign* function. 

[sc,hvc] = nwalign(human,chicken);
showalignment(hvc)

%%
% In this alignment the function used the default scoring matrix, BLOSUM62. 
% Different scoring matrices can give different alignments. How can you find
% the best alignment? One approach is to try different scoring matrices
% and look for the highest score. When the score from the alignment
% functions is in the same scale (in this case, bits) you can compare
% different alignments to see which gives the highest score. 

%%
% This example uses the PAM family of matrices, though the approach used
% could also be used with the BLOSUM family of scoring matrices.
% The PAM family of matrices in the Bioinformatics Toolbox consists of 50
% matrices, PAM10, PAM20,..., PAM490, PAM500. 

%%
% Take the two sequences (RBHU and CAA51019) and align them with each
% member of the PAM family and then look for the highest score. 

score = zeros(1,50);
alignments = cell(1,50);
fprintf('Trying different PAM matrices ')
for step = 1:50
   fprintf('.')
   PamNumber = step * 10;
   [matrix,info] = pam(PamNumber);
   score(step) = nwalign(human,chicken,'scoringmatrix',matrix,'scale',info.Scale);
end

%% Plotting the scores
% You can use the *plot* function to create a graph of the results.

x = 10:10:500;
plot(x,score)
legend('Human vs. Chicken');
xlabel('PAM matrix');ylabel('Score (bits)');

%% Finding the best score
% You can use *max* with two outputs to find the highest score and the
% index in the results vector where the highest value occurred. In this
% case the highest score occurred with the third matrix, that is PAM30.

[bestScore, idx] = max(score)


%% Aligning to other organisms
% Repeat this with different organisms: xenopus and rainbow trout.

xenopusScore = zeros(1,50);
xenopusAlignments = cell(1,50);
troutScore = zeros(1,50);
troutAlignments = cell(1,50);
fprintf('Trying different PAM matrices ')
for step = 1:50
   fprintf('.')
   PamNumber = step * 10;
   [matrix,info] = pam(PamNumber);
   xenopusScore(step) = nwalign(human,xenopus,'scoringmatrix',matrix,'scale',info.Scale);
   troutScore(step) = nwalign(human,trout,'scoringmatrix',matrix,'scale',info.Scale);
end

%% Adding more lines to the same plot.
% You can use the command *hold on* to tell MATLAB to add new plots to the
% existing figure. Once you have finished doing this you must remember to
% disable this feature by using *hold off*.

hold on
plot(x,xenopusScore,'g')
plot(x,troutScore,'r')
legend({'Human vs. Chicken','Human vs. Xenopus','Human vs. Trout'});box on
xlabel('PAM matrix');ylabel('Score (bits)');
hold off

%% Finding the best scores 
% You will see that different matrices give the highest scores for the
% different organisms. For human and xenopus, the best score is with PAM40
% and for human and trout the best score is PAM50.

[bestXScore, Xidx] = max(xenopusScore)
[bestTScore, Tidx] = max(troutScore)

%%
% The PAM scoring matrix giving the best alignment for two sequences is an
% indicator of the relative evolutionary interval since the organisms
% diverged: The smaller the PAM number, the more closely related the
% organisms. Since organisms, and protein families across organisms, evolve
% at widely varying rates, there is no simple correlation between PAM
% distance and evolutionary time. However, for an analysis of a specific
% protein family across multiple species, the corresponding PAM matrices
% will provide a relative evolutionary distance between the species and
% allow accurate phylogenetic mapping.
% In this example, the results indicate that the human sequence is more
% closely related to the chicken sequence than to the frog sequence, which
% in turn is more closely related than the trout sequence.

