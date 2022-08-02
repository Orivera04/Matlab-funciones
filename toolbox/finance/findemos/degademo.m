function [optimalParamaterEstimates , population , ...
          similarityRatio           , control]   = degademo(fitnessFunction    , nGenerations    , ...
                                                            nPopulationMembers , parameterRanges , ...
                                                            F     ,    CR      , similarityToleranceLimit)
%DEGADEMO Maximize an objective function with a Differential Evolutionary (DE) 
%         Genetic Algorithm (GA).
%
%   [PARAMETERS,POPULATION,RATIO] = DEGA(FITNESSFUNTION     , NGENERATIONS    , 
%                                        NPOPULATIONMEMBERS , PARAMETERRANGES , 
%                                        F , CR , SIMILARITYLIMIT) 
%
%   returns the evolutionary progression of a random population of individual 
%   parameter vectors. 
%
%   Required Input Arguments:
%   -------------------------
%   FITNESSFUNTION is a character string containing the objective 
%   function (with constraints, in most cases) to be maximized.
%
%   NGENERATIONS is the maximum number of generations for which the population 
%   is allowed to evolve; the algorithm will terminate after NGENERATIONS 
%   regardless of any termination/convergence criteria.
%
%   NPOPULATIONMEMBERS is the number of individuals, or members, in the 
%   parameter population at any time. Each individual represents a parameter 
%   vector and is a candidate for solving (maximizing) the objective function 
%   specified in FITNESSFUNTION.
%
%   PARAMETERRANGES is a matrix of size (NPARAMETERS x 2) specifying the 
%   minimum and maximum values between which each parameter in the initial 
%   population will be randomly selected. NPARAMETERS is the number of 
%   parameters in the solution vector (i.e., the number of parameters to 
%   estimate). The first column is the minimum value (lower bound), and the 
%   second column is the maximum value (upper bound). There must be NPARAMETERS
%   rows, in which the Ith row specifies the lower and upper bounds for the 
%   corresponding Ith parameter. Each parameter is uniformly drawn between it's
%   lower and upper bounds. 
%
%   Optional Input Arguments:
%   -------------------------
%   F is a positive scale factor, or weight, used to adjust the population 
%   based noise. F controls the amount of mutation, or perturbation, applied to 
%   the randomly selected parent vector. Typical values of F are between 
%   0.4 <= F <= 1.2. The default is F = 0.8.
%   
%   CR is a positive control parameter that mediates the crossover (i.e., 
%   recombination, or sexual reproduction) operation. During crossover, a 
%   uniform random sample (0,1) is generated for each of the NPARAMETERS genes.
%   If the Ith sample (I = 1,2,3...NPARAMETERS) is less than CR, then the child 
%   inherits the Ith gene from the randomly-selected/perturbed parent; if the 
%   Ith sample is greater than CR, then the child inherits the Ith from the 
%   deterministic target parent. Thus, CR is the probability that a particular 
%   gene is inherited from randomly-selected/perturbed parent. The code imposes
%   the constraint 0 <= CR <= 1. The default is CR = 0.5 (uniform crossover).
%
%   SIMILARITYLIMIT is a positive termination/convergence criteria based on the 
%   Schwarz inequality to test for population similarity. As the population 
%   evolves, the fittest members will tend to 'look alike'. This tolerance 
%   limit is used in a test to see if the ratio of the sum of the magnitudes to 
%   the magnitude of the sum is close to 1. The ratio will be 1 ONLY when 
%   sum(|x|) = |sum(x)|. Since the numerator ignores the phase of the parameter 
%   vectors in the population, and the denominator explicitly accounts for the 
%   phase information, the ratio R = sum(|x|) / |sum(x)| >= 1. The evolution
%   stops when (R - 1) <= SIMILARITYLIMIT. Note that there are many possible 
%   termination/convergence criteria (e.g., the fittest member has been alive 
%   for many generations, or the average population fitness has not improved 
%   in many generations). The default is SIMILARITYLIMIT = 0.001.
%
%   Output Arguments:
%   -----------------
%   PARAMETERS is a column vector of length NPARAMETERS of the optimal 
%   parameters that maximized the objective function FITNESSFUNTION.
%
%   POPULATION is a 3-D array of size (nPopulationMembers) x (nParameters + 4) 
%   x (nGenerations). Each page (the 3rd dimension) of POPULATION represents a 
%   successive generation in the evolutionary process. For a given generation, 
%   each row represents an individual member solution vector. For a given 
%   individual of a particular generation, the first 'nParameters' columns 
%   represent the parameter values encoded into the genes; the additional 
%   columns beyond 'nParameters' represent the fitness measure of that 
%   individual, followed by the individuals from the previous generation that 
%   were randomly selected to create the perturbed parent vector. 
%
%   RATIO is a column vector of length NGENERATIONS of the value of the 
%   termination convergence ratio R discussed in the SIMILARITYLIMIT definition 
%   above.
%
% See also DEGATOOL, GETSUMMARYINFO, DISPLAYSUMMARYINFO, RUNBUTTONCALLBACK.

% Author(s): R.A. Baker, 06/18/98
% Copyright 1995-2002 The MathWorks, Inc. 
% $Revision: 1.7 $   $Date: 2002/04/14 21:45:19 $

rand('state',0)

if ~exist('F') | isempty(F) | (F < 0)
   F  = 0.8;                           % Mutation perturbation scale factor
end

if ~exist('CR') | isempty(CR) | (CR < 0) | (CR > 1)
   CR = 0.5;                           % Crossover (a.k.a. recombination) constant
end

if ~exist('similarityToleranceLimit') | isempty(similarityToleranceLimit) | (similarityToleranceLimit < 0)
   similarityToleranceLimit =  0.001;  % Convergence limit for early termination prior to 'nGenerations'.
end


nParameters  =  size(parameterRanges , 1);     % # of parameters to estimate
NP           =  nPopulationMembers;            % # of members (i.e. individual parameter vectors of length 'nParameters') in the population

%
% Randomly create an initial population of 'nPopulationMembers' individual member 
% parameter vectors of length 'nParameters' and evaluate their fitness. Note that 
% the initial population is regarded as the first generation. The matrix 'population' 
% is a 3-D array of size 'nPopulationMembers' x 'nParameters + 4' x 'nGenerations'. 
% The last 3 columns of 'population' are the 'Xa', 'Xb', and 'Xc' individuals used 
% to create random parent vector 'XcPrime', and are included to allow post-processing 
% of geneology.
%

parameterMinimums  =  repmat(parameterRanges(:,1)' , nPopulationMembers , 1);
parameterMaximums  =  repmat(parameterRanges(:,2)' , nPopulationMembers , 1);

population                       =  zeros (nPopulationMembers , nParameters + 4 , nGenerations);
population(:,1:nParameters,1)    =  unifrnd(parameterMinimums , parameterMaximums);

population(:,nParameters + 1,1)  =  feval(fitnessFunction , population(:,1:nParameters,1));

targetVectorFitnessScores        =  population(: , nParameters + 1 , 1);

%
% Compute the initial population's similarity measure via the Schwarz inequality.
%

similarityRatio    =  zeros(nGenerations , 1);
parameterVectors   =  population(: , 1:nParameters , 1)';
similarityRatio(1) =  sum(sqrt(sum(parameterVectors.^2))) / norm(sum(parameterVectors')');

convergenceFlag    =  0;         % Initialize the early convergence/termination flag to FALSE.

%
% Initialize the generation just in case 'nGenerations' = 1 (i.e., we may be interested in
% simply seeding an initial population and examining the statistics). Initializing the 
% 'generation' variable now avoids an error message encountered later on.
%

generation  =  1;


for generation = 2:nGenerations          % Start the genetic/evolutionary process.

%
%   Pre-generate an (NP x 4) matrix used to create trial vectors via recombination/mutation.
%   The first column of this matrix is just the sequence {1,2,3,...NP}, and represents the 
%   target vectors X(i) for i=1,2,3,...NP. The other columns represent the 3 randomly-chosen 
%   vectors X(a), X(b), X(c) used to create the perturbation vector X'(c) = X(c) + F(X(a) - X(b)), 
%   which is then allowed to crossover (i.e. recombine, or 'sexually procreate') with the target
%   vector X(i) to produce the trial vector. The code segment below assures that all 4 vectors 
%   X(i), X(a), X(b), X(c) are unique, as required by the algorithm. From a MATLAB perspective, 
%   the first column of 'memberDraws' should be [1:NP]', and all 4 elements of every row should be
%   unique (integers) within the range 1,2,3,...NP.
%

    memberDraws        =  [[1:NP]'  unidrnd(NP ,  NP , 3)];

    uniqueMemberDraws  =  find( (memberDraws(:,1) ~= memberDraws(:,2)) & ...
                                (memberDraws(:,1) ~= memberDraws(:,3)) & ...
                                (memberDraws(:,1) ~= memberDraws(:,4)) & ...
                                (memberDraws(:,2) ~= memberDraws(:,3)) & ...
                                (memberDraws(:,2) ~= memberDraws(:,4)) & ...
                                (memberDraws(:,3) ~= memberDraws(:,4)) );

    while length(uniqueMemberDraws) ~= NP

        nonUniqueMemberDraws  =  setdiff([1:NP]' , uniqueMemberDraws);
        memberDraws           =  memberDraws(uniqueMemberDraws , :);
        memberDraws           =  [memberDraws ; nonUniqueMemberDraws  unidrnd(NP,length(nonUniqueMemberDraws),3)];

        [dummy , indices]     =  sort(memberDraws(:,1));
        memberDraws           =  memberDraws(indices,:);

        uniqueMemberDraws     =  find( (memberDraws(:,1) ~= memberDraws(:,2)) & ...
                                       (memberDraws(:,1) ~= memberDraws(:,3)) & ...
                                       (memberDraws(:,1) ~= memberDraws(:,4)) & ...
                                       (memberDraws(:,2) ~= memberDraws(:,3)) & ...
                                       (memberDraws(:,2) ~= memberDraws(:,4)) & ...
                                       (memberDraws(:,3) ~= memberDraws(:,4)) );
    end

%
%   Form the randomly-selected/perturbed parent vector X'(c) = X(c) + F(X(a) - X(b)).
%
    Xa  =  population(memberDraws(:,2) , 1:nParameters , generation - 1);
    Xb  =  population(memberDraws(:,3) , 1:nParameters , generation - 1);
    Xc  =  population(memberDraws(:,4) , 1:nParameters , generation - 1);

    XcPrime  =  Xc  +  F*(Xa - Xb);

%
%   The target vectors are simply the individuals already in the current population.
%   Note that any given target vector is not only pitted against a randomly-generated
%   trial vector in a tournament-style selection, but is also one of the trial's parents.
%
    targetVectors  =  population(: , 1:nParameters , generation - 1);

%
%   Generate the random samples for the binomial comparisons which determine which genes
%   (i.e., parameters) will be inherited from which parent. These random samples are then
%   compared with the crossover contant CR = P{parameter(i) inherited from X'(c)} for
%   i = 1,2,...nParameters.

    crossoverSamples   =  rand(NP , nParameters);
    randomVectorGenes  =  find(crossoverSamples < CR);     % Parameter #'s inherited from X'(c)

%
%   For starters, simply assign the target vectors directly to the trial vectors. 
%
    trialVectors  =  targetVectors;

%
%   Now over-write the parameters of the targets with the parameters selected from the trials with probability CR.
%
    trialVectors(randomVectorGenes)  =  XcPrime(randomVectorGenes);

%
%   Identify which parameter, or gene, will be deterministically inherited from the
%   randomly-selected/perturbed vector X'(c) = X(c) + F(X(a) - X(b)). For each individual
%   in the current generation, the parameters to be inherited from X'(c) are randomly 
%   chosen, but then deterministically assigned to the trial vector is the sense that 
%   no binomial comparison is made with respect to the crossover contant CR.
%
    deterministicGenes  =  unidrnd(nParameters ,  NP , 1);

%
%   Now force the trial vectors to deterministically inherit the randomly-selected parameters from X'(c).
%
    deterministicGeneIndices                =  (deterministicGenes - 1)*NP + [1:NP]';
    trialVectors(deterministicGeneIndices)  =  XcPrime(deterministicGeneIndices);

%
%   Score the trial vectors for comparison with their target parents.
%
    trialVectorFitnessScores  =  feval(fitnessFunction , trialVectors);

%
%   Perform fitness selection to determine which individual population members move on to the
%   next generation. This represents a type of tournament selection process in which the trial
%   is deterministically compared to its target vector (the target is also one its parents!).
%

    fitterChildren  =  find(targetVectorFitnessScores < trialVectorFitnessScores);

    population(      :        , : , generation)  =  population(: , : , generation - 1);

    if ~isempty(fitterChildren)    % Needed to avoid an error message.
       population(fitterChildren , : , generation)  = [trialVectors(fitterChildren , :)  trialVectorFitnessScores(fitterChildren)   memberDraws(fitterChildren , 2:4)];
    end
%
%   Assign the newly-updated fitness measures for comparison with the next generation.
%
    targetVectorFitnessScores  =  population(: , nParameters + 1 , generation);

%
%   Invoke the Schwarz Inequality to test for population similarity. This condition checks to see 
%   if the individual population members in the current generation are sufficiently 'in phase'. 
%   Mathematically, the test checks to see if the ratio of the sum of the magnitudes to the magnitude
%   of the sum is close to 1. The ratio will be 1 ONLY when sum(|x|) = |sum(x)|. Since the numerator
%   ignores the phase of the parameter vectors in the population, and the denominator explicitly
%   accounts for the phase information, the ratio  R = sum(|x|) / |sum(x)| >= 1.
%
    parameterVectors             =  population(: , 1:nParameters , generation)';
    similarityRatio(generation)  =  sum(sqrt(sum(parameterVectors.^2))) / norm(sum(parameterVectors')');

    if (similarityRatio(generation) - 1) <= similarityToleranceLimit
       convergenceFlag  =  1;
       break                     % Early convergence occurred, so terminate the evolution.
    end

end

if convergenceFlag
   disp(' ')
   disp(['  SUCCESS: Convergence criteria was satisfied on generation ' num2str(generation,'%5d') '.'])
else 
   disp(' ')
   disp( '  WARNING: Convergence criteria was NOT satisfied; Optimal parameter estimates MAY be inaccurate.')
end

%
% Find the fitness of the best (i.e., most fit) member in the final generation. Note that, due 
% to the nature in which the child of the 'XcPrime' vector and the target parent vector is 
% pitted against the target parent vector in a winner-take-all fitness comparison, the fittest
% individual alive in the last generation is the fittest individual that has ever been alive!
% For this reason, I ignore previous generations. Depending on the selection criteria for a
% DE/GA algorithm, this may not be the case.
%

maximumFitness             =  max(population(: , nParameters + 1 , generation));
iOptimalVector             =  find(population(: , nParameters + 1 , generation) == maximumFitness);
optimalParamaterEstimates  =  population(iOptimalVector , 1:nParameters , generation)';

disp   (' ')
fprintf('  Maximum Fitness Obtained: %-20.10f\n\n' , maximumFitness)
disp   ('  Optimal Parameter Estimates:') , disp(' ')
fprintf('%6d: %15.10g\n' , [[1:nParameters]' optimalParamaterEstimates]')

%
% Save some interesting results and the control information required to reproduce the results
%

control.convergenceFlag           =  convergenceFlag;
control.generation                =  generation;
control.maximumFitness            =  maximumFitness;

control.fitnessFunction           =  fitnessFunction;
control.nGenerations              =  nGenerations;
control.nPopulationMembers        =  nPopulationMembers;
control.nParameters               =  nParameters;
control.parameterRanges           =  parameterRanges;
control.F                         =  F;
control.CR                        =  CR;
control.similarityToleranceLimit  =  similarityToleranceLimit;
