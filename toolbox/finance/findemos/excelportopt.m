function PortfOptResults = excelportopt(AssetExpectedReturns, AssetStandardDeviations, AssetCorrelationMatrix, AssetUpperLowerBounds, AssetGroupConstraintMatrix, FrontierReturns, PlotFlag)
%EXCELPORTOPT Calculate the mean-variance efficient frontier.
%   PortfOptResults = EXCELPORTOPT(AssetExpectedReturns, AssetStandardDeviations,...
%   AssetCorrelationMatrix, AssetUpperLowerBounds, AssetGroupConstraintMatrix,...
%   FrontierReturns, PlotFlag) calculates the mean-variance efficient frontier 
%   for a set of assets, given the expected returns, standard deviations and 
%   a correlation matrix for the assets. Other optional inputs include upper 
%   and lower bounds on the asset weights, and upper and lower bounds on linear 
%   combinations of asset weights.
%
%   EXCELPORTOPT is a version of PORTOPT that is intended only to be called 
%   by the Portfolio Optimizer application.
%
%   Inputs: 
%     AssetExpectedReturns is a vector containing the expected return
%       for each asset.
%     AssetStandardDeviations is a vector containing the standard deviation
%	    for each asset.
%	  AssetCorrelationMatrix is the historical correlation matrix for the 
%		assets.
%     AssetUpperLowerBounds is a matrix containing the upper and lower bound
%		on the weight of each asset (Nx2, where N is the number of assets).
%	  AssetGroupConstraintMatrix is a matrix containing specifications for
%		upper and lower bounds on linear combinations of asset weights.
%	  FrontierReturns (optional) is a vector of expected returns at which
%	    to evaluate the frontier function.
%
%   Note: 
%     The ROWS of the AssetGroupConstraintMatrix indicate whether or not
%	  an asset appears in a constraint (1 means the asset is included,
%	  0 means it is not included). Asset-Rows are assumed to occur in the
%	  same order in which expected returns and standard deviations are given.
%     If there are fewer rows than assets, a value of 0 is used for assets
%	  beyond the last row.
%
%   Outputs: 
%     PortfolioOptimizationResults is a matrix containing the expected returns,
%     standard deviations and weights corresponding to points on the frontier.
%

%   Author(s) : D. Eiler, 09-30-96
%   Copyright 1995-2002 The MathWorks, Inc. 
%	 $Revision: 1.10 $   $Date: 2002/04/14 21:42:32 $

% Check for input errors.

if nargin < 3
	opterror('Too few inputs were entered to PORTFOPT.');
	return;
end

AER = AssetExpectedReturns;
if size(AER, 2) > 1, AER = AER'; end
if size(AER, 2) > 1, opterror('The expected returns entered are not and Nx1 vector.'); return; end
if min(AER) <= 0, opterror('An expected return of 0 or less has been entered.'); return; end
NumAssets = size(AER, 1);

ASD = AssetStandardDeviations;
if size(ASD, 2) > 1, ASD = ASD'; end
if size(ASD, 2) > 1, opterror('The standard deviations entered are not an Nx1 vector.'); return; end
if size(ASD, 1) ~= NumAssets, opterror(['The number of standard deviations does not equal ',...
	'the number of expected returns.']); return; end

RHO = AssetCorrelationMatrix;
if size(RHO, 1) ~= NumAssets | size(RHO, 2) ~= NumAssets
	opterror('The size of the correlation matrix entered is not (number of assets)x(number of assets).');
	return;
end

AGCMEntered = 0;
if nargin > 4
	if ~isempty(AssetGroupConstraintMatrix)
		AGCMEntered = 1;
	end
end

if AGCMEntered
	AGCM = AssetGroupConstraintMatrix;

	if size(AGCM, 1) - 2 < 1 | size(AGCM, 1) - 2 > NumAssets
		opterror('The linear (group) constraint matrix is incorrectly given.');
	end

	NumLinearConstraints = size(AGCM, 2);
	NumAssetsIn = size(AGCM, 1) - 2;
	B = AGCM(NumAssetsIn+1:NumAssetsIn+2, :);
	B(1, :) = -B(1, :);
	B = reshape(B', 2*NumLinearConstraints, 1);

	A = AGCM(1:NumAssetsIn, :);

	if NumAssetsIn < NumAssets
		A = [A; zeros(NumAssets-NumAssetsIn, NumLinearConstraints)]';
	else
		A = A';
	end

	A = [-A;A];
else
	AGCM = [];
	A = [];
	B = [];
end

A = [ones(1, NumAssets); A];
B = [1; B];


GenericBounds = [0 1];
AULBEntered = 0;
if nargin > 3
	if ~isempty(AssetUpperLowerBounds)
		AULBEntered = 1;
	end
end
if AULBEntered
	AULB = AssetUpperLowerBounds;
	if size(AULB, 2) ~= 2, AULB = AULB'; end
	if size(AULB, 2) ~= 2, opterror('The bounds entered are not an Nx2 vector.'); return; end
	if size(AULB, 1) < NumAssets
		AULB = [AULB; GenericBounds(ones(NumAssets-size(AULB, 1), 1), :)];
	end
	TrivialInd = find(AULB(:, 1)==0 & AULB(:, 2) == 0);
	NumTrivial = length(TrivialInd);
	if NumTrivial ~= 0
		if NumTrivial == NumAssets
			opterror('You have only 1 asset with non-zero weight constraints.');
			return;
		end
		NonTrivialInd = find(AULB(:, 1)~=0 | AULB(:, 2) ~= 0);
		AER = AER(NonTrivialInd);
		ASD = ASD(NonTrivialInd);
		RHO = RHO(NonTrivialInd, NonTrivialInd);
		A = A(:, NonTrivialInd);
		AULB = AULB(NonTrivialInd, :);
		NumAssets = NumAssets - NumTrivial;
	end
else
	AULB = GenericBounds(ones(NumAssets, 1), :);
	NumTrivial = 0;
end


% Calculate the variance-covariance matrix, from the entered standard deviations and
% correlation matrix.
C = ASD*ASD'.*RHO;


% If FrontierReturns have been entered, check them for legality relative to constraints.
% If FrontierReturns have not been entered, construct the default return range.
W0 = ones(NumAssets, 1)/NumAssets;
N = 1;


% Find the maximum expected return achievable, given the individual asset expected
% returns and all the various constraints.
[MaxReturnWeights, Lamda, ErrorFlag] = lp(-AER, A, B, AULB(:,1), AULB(:, 2), W0, N, -1);

if length(ErrorFlag) > 2
	opterror('Warning: A solution is not feasible. Your constraints are likely invalid');
	return;
end

MaxReturn = dot(MaxReturnWeights, AER);


% Find the minimum variance return. X=QP(H,f,A,b,VLB,VUB,X0,N)
F = zeros(NumAssets, 1);
[MinVarWeights, Lamda, ErrorFlag] = qp(C, F, A, B, AULB(:, 1), AULB(:, 2), W0, N, -1);

if length(ErrorFlag) > 2
	opterror('Warning: A solution was not feasible for the minimum variance portfolio.');
	return;
end

MinVarReturn = dot(MinVarWeights, AER);

FREntered = 0;
if nargin > 5
	if ~isempty(FrontierReturns)
		FREntered = 1;
	end
end

if FREntered
	FR = FrontierReturns;
	if (min(FR) < MinVarReturn) | (max(FR) > MaxReturn)
		opterror('Frontier returns requested are outside the feasible bounds.');
		return;
	else
		NumFrontPoints = length(FR);
		PortfOptResults = zeros(NumFrontPoints, 2+NumAssets);
		StartPoint = 1;
	end
else
	MinVarStd = sqrt(MinVarWeights'*C*MinVarWeights);

	NumFrontPoints = 41;
	ReturnInterval = 1/(NumFrontPoints - 1);

	DeltaReturn = (MaxReturn - MinVarReturn)*ReturnInterval;
	FR = [MinVarReturn:DeltaReturn:MaxReturn];

	FR(NumFrontPoints) = FR(NumFrontPoints)-100*eps;

	PortfOptResults = zeros(NumFrontPoints, 2+NumAssets);
	PortfOptResults(1, :) = [MinVarReturn MinVarStd MinVarWeights(:)'];
	StartPoint = 2;
end

FrontPointConstraint = AER';
A = [FrontPointConstraint; A];
B = [0; B];
N = 2;
Weights = MinVarWeights;
for Point = StartPoint:NumFrontPoints
	B(1) = FR(Point);
	[Weights, Lamda, ErrorFlag] = qp(C, F, A, B, AULB(:, 1), AULB(:, 2), Weights, N, -1);
	if length(ErrorFlag) > 2
		PortfOptResults(Point, :) = [B(1) nan*ones(1, NumAssets+1)];
	else
		Return = dot(Weights, AER);
		Std = sqrt(Weights'*C*Weights);
		PortfOptResults(Point, :) = [Return Std Weights(:)'];
	end
end

if NumTrivial ~= 0
	PaddedWeights = zeros(size(PortfOptResults, 1), NumAssets+NumTrivial);
	PaddedWeights(:, NonTrivialInd) = PortfOptResults(:, 3:NumAssets+2);
	PortfOptResults = [PortfOptResults(:, 1:2) PaddedWeights];
end

ErrorIndex = find(isnan(PortfOptResults(:, 2)));
if ~isempty(ErrorIndex)
	NumErrors = num2str(length(ErrorIndex));
	opterror(['Warning: A solution was not feasible for ', NumErrors, ' expected return(s).']);
end

if nargin > 6
	if PlotFlag
		frontplt(PortfOptResults(:, 1:2));
	end
end




function opterror(MessageString)
%OPTERROR Subroutine of EXCELPORTOPT 

if (length(findobj('Type','figure','Tag','OPTErrorWin')) == 0)

	ErrorHandle = figure;
	ErrorWin = figure(ErrorHandle);

	set(ErrorWin,'MenuBar','none');
	set(ErrorWin,'Units','normalized','Position',[0 .75 .5 .2]);
	set(ErrorWin,'NumberTitle','off');
	set(ErrorWin,'Name','Portfolio Optimization Message');
	set(ErrorWin,'Resize','off');
	set(ErrorWin,'Color','red');
	set(ErrorWin,'Tag','OPTErrorWin');

	ErrorMessage = uicontrol(ErrorHandle, 'Style', 'Text',...
					'Units', 'Normalized', ...
					'Position', [0 0 1 1], ...
					'BackgroundColor', 'c');

	set(ErrorMessage, 'Tag', 'OPTErrorMessage');

else %The error window already exists
	figure(findobj('Type','figure','Tag','OPTErrorWin'));
end

set(findobj('Type', 'uicontrol', 'Tag', 'OPTErrorMessage'), ...
   'String', MessageString);




function frontplt(FrontPoints)
%FRONTPLT Subroutine of EXCELPORTOPT 

	if (length(findobj('Type','figure','Tag','FrontWin')) == 0)

		FrontHandle = figure;
		FrontWin = figure(FrontHandle);

		set(FrontWin,'MenuBar','none');
		set(FrontWin,'Units','normalized','Position',[0 .4 .6 .5]);
		set(FrontWin,'NumberTitle','off');
		set(FrontWin,'Name','Efficient Frontier');
		set(FrontWin,'Resize','on');

		set(FrontWin,'Tag','FrontWin');
	else %The plot window already exists
		figure(findobj('Type','figure','Tag','FrontWin'));
		cla;
	end
	drawnow;

	SuccessIndex = find(~isnan(FrontPoints(:, 2)));

	plot(FrontPoints(SuccessIndex, 2), FrontPoints(SuccessIndex, 1), '*');

	hold off;

	title('Mean-Variance Efficient Frontier');
	xlabel('Standard Deviation');
	ylabel('Expected Return');
	grid on;


