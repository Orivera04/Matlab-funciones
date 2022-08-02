function ert_config_opt(model,configMode)
% ERT_CONFIG_OPT - Configuration file to set automatically the values that
% affect code generation. The values are chosen to optimize code efficiency.
% This function is called from ert_make_rtw_hook.m (the ERT target process
% hook file).  The argument configMode is set to 'optimized_fixed_point' or
% 'optimized_floating_point' for fixed and floating point code generation,
% respecitvely.
%
% Many options, not relevant to optimization, are included commented out
% for your convenience.
  
% Copyright 1994-2003 The MathWorks, Inc.
% $Revision: 1.1.6.1 $  $Date: 2003/12/31 19:42:56 $
  
% Output a display message during RTW build
  
  file  = 'ert_config_opt.m';
  hpath = fullfile(matlabroot,'toolbox','rtw','targets','ecoder',file);
  txt   = sprintf(['\n\n*** Auto configuring ''%s'' for model ''%s'' ',...
                   'as specified by: %s\n',...
                   '*** Overwriting model settings if they do not yield ',...
                   'optimized code.\n\n'], configMode, model, file);
  disp(txt);
  
  % Obtain the active configuration set
  
  cs = getActiveConfigSet(model);
  
  % Solver options
  
  %set_param(cs,'SolverType','Fixed-step');    % Type
  %set_param(cs,'Solver','FixedStepDiscrete'); % Solver
  %set_param(cs,'SolverMode','Auto');          % Tasking mode for periodic sample times
  %set_param(cs,'AutoInsertRateTranBlk','on'); % Automatically handle data transfers
                                               % between tasks (on Solver page)

  % Optimizations
  
  set_param(cs,'BlockReduction','on');               % Block reduction optimization
  set_param(cs,'ConditionallyExecuteInputs','on');   % Conditional input branch execution
  set_param(cs,'InlineParams','on');                 % Inline parameters
  set_param(cs,'BooleanDataType','on');              % Implement logic signals a boolean data
  set_param(cs,'OptimizeBlockIOStorage','on');       % Signal storage reuse
  set_param(cs,'InlinedParameterPlacement',...       % Parameter structure
               'NonHierarchical');                   
  set_param(cs,'LocalBlockOutputs','on');            % Enable local block outputs
  set_param(cs,'BufferReuse','on');                  % Reuse block outputs
  set_param(cs,'ExpressionFolding','on');            % Eliminate superfluous temporary variables
  set_param(cs,'EnforceIntegerDowncast','off');      % Ignore integer downcast in folded
                                                     % expressions (NOTE: inverted logic from UI)
  set_param(cs,'RollThreshold',5);                   % Loop unrolling threshold
  set_param(cs,'InlineInvariantSignals','on');       % Inline invariant signals
  set_param(cs,'ZeroExternalMemoryAtStartup','off'); % Remove root level I/O zero initialization
                                                     % (NOTE: inverted logic from UI)
  set_param(cs,'ZeroInternalMemoryAtStartup','off'); % Remove internal state zero initialization
                                                     % (NOTE: inverted logic from UI)
  set_param(cs,'InitFltsAndDblsToZero','off');       % Use memset to initialize floats and double
                                                     % to 0.0 (NOTE: inverted logic from UI)
  set_param(cs,'StateBitsets','on');                 % Use bitsets for storing state configuration
                                                     % (Stateflow)
  set_param(cs,'DataBitsets','on');                  % Use bitsets for storing boolean data
                                                     % (Stateflow)
  set_param(cs,'UseTempVars','on');                  % Minimize array reads using temporary
                                                     % variables (Stateflow)
  set_param(cs,'FoldNonRolledExpr','on');            % Non-UI
  set_param(cs,'ParameterPooling','on');             % Non-UI
  
  % Hadware Implementation
  
  %set_param(cs,'ProdHWDeviceType','Specified'); % Device type
  %set_param(cs,'ProdBitPerChar', 8);            % char number of bits
  %set_param(cs,'ProdBitPerShort', 16);          % short number of bits
  %set_param(cs,'ProdBitPerInt', 32);            % int number of bits
  %set_param(cs,'ProdBitPerLong', 32);           % long number of bits
  %set_param(cs,'ProdWordSize', 32);             % Native word size
  %set_param(cs,'ProdIntDivRoundTo', 'Floor');   % Integer division with negative operand
  %                                              % quotient rounds to
  %set_param(cs,'ProdShiftRightIntArith','on');  % Shift right on a signed integer as
  %                                              % arithmetic shift right
  %set_param(cs,'ProdEndianess','LittleEndian'); % Byte ordering
  %set_param(cs,'ProdEqTarget','on');            % None (literally 'None')
  
  % HTML Report
  
  %set_param(cs,'GenerateReport','on');           % Generate HTML report
  %set_param(cs,'IncludeHyperlinkInReport','on'); % Include hyperlinks to model
  %set_param(cs,'LaunchReport','on');             % Launch report
  
  % Comments
  
  %set_param(cs,'GenerateComments','on');         % Include comments
  %set_param(cs,'SimulinkBlockComments','on');    % Simulink block comments
  %set_param(cs,'ShowEliminatedStatement','off'); % Show eliminated statements
  %set_param(cs,'ForceParamTrailComments','off'); % Verbose comments for SimulinkGlobal
  %                                               % storage class
  %set_param(cs,'InsertBlockDesc','on');          % Simulink block descriptions
  %set_param(cs,'SimulinkDataObjDesc','on');      % Simulink data object descriptions
  %set_param(cs,'EnableCustomComments','off');    % Custom comments (MPT objects only)
  
  % Symbols
  
  %set_param(cs,'CustomSymbolStr','$R$N$M');         % Symbol format
  %set_param(cs,'MaxIdLength',31);                   % Maximum identifier length
  %set_param(cs,'InlinedPrmAccess','Literals');      % Generate scalar inlined paramters as
  %set_param(cs,'IgnoreCustomStorageClasses','off'); % Ignore custom storage classes
  %set_param(cs,'DefineNamingRule','None');          % #define naming
  %set_param(cs,'ParamNamingRule','None');           % Parameter naming
  %set_param(cs,'SignalNamingRule','None');          % Signal naming
  
  % Software Environment
  
  %set_param(cs,'GenFloatMathFcnCalls','ISO_C');     % Target floating point math environment
  if strcmp(configMode,'optimized_floating_point')
    set_param(cs,'PurelyIntegerCode','off');         % floating point numbers (Note: inverted
                                                     % logic from UI)
  elseif strcmp(configMode,'optimized_fixed_point')
    set_param(cs,'PurelyIntegerCode','on');          % floating point numbers (Note: inverted
                                                     % logic from UI)
  end
  %set_param(cs,'SupportNonFinite','off');           % non-finite numbers
  %set_param(cs,'SupportComplex','off');             % complex numbers
  %set_param(cs,'SupportAbsoluteTime','off');        % absolute time
  %set_param(cs,'LifeSpan','1');                     % Application lifespan (days)

  % Code interface
  
  set_param(cs,'IncludeMdlTerminateFcn','off');        % Terminate function required
  %set_param(cs,'MultiInstanceERTCode','off');         % Generate reusable code
  %set_param(cs,'MultiInstanceErrorCode','Error');     % Reusable code error diagnostic
  %set_param(cs,'RootIOFormat','Structure Reference'); % Pass root-level I/O as
  set_param(cs,'SuppressErrorStatus','on');            % Supress error status in real-time model
                                                       % data structure
  set_param(cs,'GRTInterface','off');                  % GRT compatible call interface
  set_param(cs,'CombineOutputUpdateFcns','on');        % Single output update

  
  % Data exchange
  
  set_param(cs,'RTWCAPIParams','off');               % Generate C-API for signals
  set_param(cs,'RTWCAPISignals','off');              % Generate C-API for parameters
  set_param(cs,'GenerateASAP2','off');               % Generate ASPA2 file
  set_param(cs,'ExtMode','off');                     % Generate External Mode interface

  % Templates
  
  %set_param(cs,'ERTCustomFileTemplate',...
  %             'example_file_process.tlc');   % File customization template
  %set_param(cs,'GenerateSampleERTMain',...    
  %             'on');                         % Generate an example main program
  %set_param(cs,'TargetOS',...                 
  %             'BareBoardExample');           % Target operating system
  %set_param(cs,'ERTSrcFileBannerTemplate',... 
  %             'ert_code_template.cgt');      % Source file (*.c) template (code)
  %set_param(cs,'ERTHdrFileBannerTemplate',...
  %             'ert_code_template.cgt');      % Source file (*.h) template (code)
  %set_param(cs,'ERTDataSrcFileTemplate',...
  %             'ert_code_template.cgt');      % Source file (*.c) template (data)
  %set_param(cs,'ERTDataHdrFileTemplate',...
  %             'ert_code_template.cgt');      % Source file (*.h) template (data)
  
  % Validation

  %set_param(cs,'GenerateErtSFunction','off');  % Create Simulink (S-Function) block
  set_param(cs,'MatFileLogging','off');         % MAT-file logging
  %set_param(cs,'SaveTime','off');              %   o Time
  %set_param(cs,'SaveOutput','off');            %   o States
  %set_param(cs,'SaveState','off');             %   o Output
  %set_param(cs,'SaveFinalState','off');        %   o File states

  % Build environment
  
  %set_param(cs,'RTWVerbose','off');           % Verbose build 
  %set_param(cs,'GenCodeOnly','off');          % Generate code only
  
