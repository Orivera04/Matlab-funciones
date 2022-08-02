function [regressionParams]=regressionParser(fileNameArray,sheetNameArray, assetName, OUTPUT_DIR_OVERRIDE_FLAG, varargin)

    p = inputParser;
    
    p.addRequired('spreadSheetDatabase');
    p.addRequired('sheetData');
   
    p.addParamValue('startDate',               -1,                          @(x) (ischar(x) && length(x)==5) || x==-1 || x==0);
    p.addParamValue('regressionDataSize',      30,                          @(x) isnumeric(x) && floor(x)==x && x>0);
    
    %Model Setup
    p.addParamValue('modelName',               'stepwise',                  @(x) any(strcmpi(x,{'stepwise','combination'})));
    p.addParamValue('errorTreatment',          'STANDARD',                  @(x) any(strcmpi(x,{'STANDARD','ROBUST'})));
    p.addParamValue('fitType',                 'LINEAR',                    @(x) any(strcmpi(x,{'LINEAR','LOGIT', 'PROBIT'})));
    p.addParamValue('forecastFitType',          [],                         @(x) any(strcmpi(x,{'LINEAR','LOGIT', 'PROBIT'})));
    
    %Some generic parameters
    p.addParamValue('runGroups',                'false',                    @(x) any(strcmpi(x,{'true','false'})));
    p.addParamValue('runPermanent',             'false',                    @(x) any(strcmpi(x,{'true','false'})));    
    
    p.addParamValue('fixedStartDate',           'false',                    @(x) any(strcmpi(x,{'true','false'})));
    
    p.addParamValue('forecastRegConstOnOff',     [],                        @(x) any(strcmpi(x,{'on','off'})));
    p.addParamValue('backtestRegConstOnOff',     [],                        @(x) any(strcmpi(x,{'on','off'})));
    
    p.addParamValue('startCarryingPrevMonth',   'false',                    @(x) any(strcmpi(x,{'true','false'})));
    p.addParamValue('corRetZeroOne',            'true',                     @(x) any(strcmpi(x,{'true','false'})));    
    
    %Filters
    p.addParamValue('betaConsistencyFilter',    'false',                    @(x) any(strcmpi(x,{'true','false'})));
    p.addParamValue('betaCstyFilterSignChange', 'false',                    @(x) any(strcmpi(x,{'true','false'})));
    p.addParamValue('betaCstyFilterNumChange',   0,                         @(x) isnumeric(x) && floor(x)==x && x>0);
    p.addParamValue('betaConsistencySize',       12,                        @(x) isnumeric(x) && floor(x)==x && x>0);
    
    p.addParamValue('correlationFilter',        'false',                    @(x) any(strcmpi(x,{'true','false'})));
    p.addParamValue('correlationFilterCutoff',   0.9,                       @(x) isnumeric(x) && x>0 && x<1);
    
    %Lag Indicators
    p.addParamValue('lagIndicators',            'false',                    @(x) any(strcmpi(x,{'true','false'})));
    
    % Combination Model Parameters
    p.addParamValue('indicatorChoiceSize',       5,                         @(x) isnumeric(x) && any(numel(x)==[1 2]) && all(floor(x)==x) && all(x>0));
    p.addParamValue('hitsWindowSize',            36,                        @(x) isnumeric(x) && floor(x)==x);
    
    %StepwiseModel Parameters
    p.addParamValue('MAX_ITER',                  40,                        @(x) isnumeric(x) && floor(x)==x && x>0);
    p.addParamValue('stepWiseIndicatorFit',      [3, 0.2, 0.4, 3, 10, 30],  @(x) (isreal(x) && size(x,2)>=6 && all(x([2 3])>0) && all(floor(x(4:6))==x(4:6)) && all(x([2 4])<=x([3 5]))));
    p.addParamValue('stepWiseIndicatorFitGroups',[],                        @(x) (isreal(x) && size(x,2)>=6 && all(x([2 3])>0) && all(floor(x(4:6))==x(4:6)) && all(x([2 4])<=x([3 5]))));
    p.addParamValue('OLD_STEPWISE_FLAG',         'false',                   @(x) any(strcmpi(x,{'true','false'})));
    
    %Stepwise Test Parameters
    p.addParamValue('statTest',                  {});
    p.addParamValue('statTestWeights',           []);
    p.addParamValue('betaBacktestSize',          24,                        @(x) isnumeric(x) && floor(x)==x && x>0);
 
    % Debug Parameters
    p.addParamValue('debugCommentsL1',           1);
    p.addParamValue('debugCommentsL2',           0);
    
    if OUTPUT_DIR_OVERRIDE_FLAG
        p.addParamValue('outputDir',                []);
    else
        p.addParamValue('outputDir',                [],                     @(x) isempty(x) || isdir(x));
    end
    
   p.parse(fileNameArray,sheetNameArray, varargin{:});
   regressionParams=p.Results;
   regressionParams.validTestTypes = {'pval','LL','fstat','betaConsistent'};
      
   regressionParams = fillRedundantParamaters(regressionParams);
   regressionParams = checkStatTests(regressionParams);
   regressionParams.assetName = assetName;

   if OUTPUT_DIR_OVERRIDE_FLAG || isempty(regressionParams.outputDir)
       regressionParams.outputDir = fileparts(getStrName(fileNameArray));
   end
   
   fprintf('\n -------------------- All INPUT PARAMETERS --------------------\n');
   disp(regressionParams);
   fprintf('-------------------- USING DEFAULT VALUES FOR -------------------- \n');
   disp(p.UsingDefaults')
   fprintf('--------------------------------------------------------------------------------\n');
   
end

function regressionParams = fillRedundantParamaters(regressionParams)
   if isempty(regressionParams.forecastFitType)
       regressionParams.forecastFitType = regressionParams.fitType;
   end
   if isempty(regressionParams.stepWiseIndicatorFitGroups)
       regressionParams.stepWiseIndicatorFitGroups = regressionParams.stepWiseIndicatorFit;
   end
   if isempty(regressionParams.backtestRegConstOnOff)
       if strcmpi(regressionParams.fitType,'LINEAR')
           regressionParams.backtestRegConstOnOff ='on';
       else
           regressionParams.backtestRegConstOnOff ='off';
       end
   end
   if isempty(regressionParams.forecastRegConstOnOff)
       if strcmpi(regressionParams.forecastFitType,'LINEAR')
           regressionParams.forecastRegConstOnOff ='on';
       else
           regressionParams.forecastRegConstOnOff ='off';
       end
   end
end

function regressionParams = checkStatTests(regressionParams)
   if isempty(regressionParams.statTest) && isempty(regressionParams.statTestWeights)
        if  strcmpi(regressionParams.fitType,'LOGIT') || strcmpi(regressionParams.fitType,'PROBIT')
            regressionParams.statTest = {'pval','LL'};
        else
            regressionParams.statTest = {'pval','fstat'};
        end
        regressionParams.statTestWeights = [0.5 0.5];
   end
   
   if ~all(size(regressionParams.statTestWeights)==size(regressionParams.statTest)) || isempty(regressionParams.statTest) || isempty(regressionParams.statTestWeights)
       error('Weights and Stats Array Should have same dimension and both should be either empty or both defined');
   end
   
   if size(regressionParams.statTest,1)>1, regressionParams.statTest=(regressionParams.statTest)'; end
   if size(regressionParams.statTestWeights,1)>1, regressionParams.statTestWeights=(regressionParams.statTestWeights)'; end
   
   if size(regressionParams.statTest,1)>1
       error('Weights and Stats Array should be a vector, not a Matrix');
   end
   
   [validRow testArray]=parseTestTypes(regressionParams.statTest , regressionParams.validTestTypes);
   temp = find(testArray(1,:));
   if ~any(testArray(1,:)), error(' None of the Stat test types specified are valid'); end
   if ~all(testArray(1,:)), fprintf('   Some test type are invalid. Only picking out valid statTest types'); end
   regressionParams.statTest = regressionParams.statTest(1,temp);
   regressionParams.statTestWeights = regressionParams.statTestWeights(1,temp);
   
   if ~any(strcmpi(regressionParams.statTest,'betaConsistent'))
       regressionParams.betaBacktestSize=0;
       regressionParams.betaConsistentFlag=0;
   else
       regressionParams.betaConsistentFlag=1;
   end
end
