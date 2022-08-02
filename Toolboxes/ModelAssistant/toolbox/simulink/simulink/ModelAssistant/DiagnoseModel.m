function htmlSource = DiagnoseModel(scope)
% given model(or subsystem), it will diagnose model on certain criteria and
% generate a html based report.

%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $ $Date: 2002/11/27 17:40:14 $

%  read template file
htmlSource = fileread(HTMLattic('AtticData', 'DiagnoseTemplatePage'));
passString = '<p><font color="#008000">Passed</font>';

% preprocess page
javascript = fileread([HTMLattic('AtticData', 'cmdRoot') filesep 'Advisortranslate.js']);
htmlSource = strrep(htmlSource, '<!--Insert Javascript template-->', javascript);
htmlSource = strrep(htmlSource, '<!--start system template-->', HTMLattic('AtticData', 'StartInSystemTemplate'));

model  = bdroot(scope);
hScope = get_param(scope, 'Handle');
hModel = get_param(model, 'Handle');

% Prompt user to close SimParam dialog if it is open
l_closeSimPrmDlg(hModel);

% Model setup for deployment:

% Compile model has been moved inside Tasking mode detection, so for all
% other diagnose we won't require compile model

% - Check for questionable blocks in the current scope
if HTMLattic('AtticData', 'CheckQuestionBlock')==1
    BlockDataTypeTable = createBlockDataTypeTable;
    subTemplate = '';
    
    % check blocks not supproted by ERT
    uBlocks = [];
    for i=1:length(BlockDataTypeTable)
        if ~BlockDataTypeTable(i).RTWenable
            paramName = 'BlockType';
            bufferType = BlockDataTypeTable(i).BlockType;
            if strcmpi(bufferType, 'SubSystem') % we'll go further if the block is a subsystem
                paramName = 'ReferenceBlock';
                bufferType = BlockDataTypeTable(i).ReferenceBlock;
                if isempty(bufferType)  % we'll use MaskType when ReferenceBlock is empty
                    paramName = 'MaskType';
                    bufferType = BlockDataTypeTable(i).MaskType;
                end
            end
            uBlocks = union(uBlocks, find_system(hScope, ...
                'LookUnderMasks', 'on', ...
                paramName, bufferType));
        end
    end
    % save block list into HTML attic
    startPos = savefoundObjects(uBlocks);
    if ~isempty(uBlocks)
        subTemplate = [subTemplate 'The following blocks are not supported by Real-Time Workshop Embedded Coder.  ', ...
                'Consider replacing these blocks with equivalent blocks (e.g., a discrete-time equivalent, ', ...
                'a combination of primitive blocks, or a custom S-Function.)'];
        % get htmlhypelink list
        for i=1:length(uBlocks)
            subTemplate = [subTemplate '<p>' getHiliteHyperlink(startPos+i)];
        end
    end

    % check blocks not supproted inside a triggered subsystem (caveats C1)
    uBlocks = [];
    for i=1:length(BlockDataTypeTable)
        if BlockDataTypeTable(i).C1
            paramName = 'BlockType';
            bufferType = BlockDataTypeTable(i).BlockType;
            if strcmpi(bufferType, 'SubSystem')
                paramName = 'ReferenceBlock';
                bufferType = BlockDataTypeTable(i).ReferenceBlock;
                if isempty(bufferType)
                    paramName = 'MaskType';
                    bufferType = BlockDataTypeTable(i).MaskType;
                end                
            end
            bufferBlocks = find_system(hScope, ...
                'LookUnderMasks', 'on', ...
                paramName, bufferType);
            for i=1:length(bufferBlocks)
                hParentSystem = get_param(bufferBlocks(i), 'Handle');
                while ~(hParentSystem ==hScope)
                    hParentSystem = get_param(get_param(hParentSystem, 'Parent'), 'Handle'); % get parent's handle
                    allfields = get_param(hParentSystem, 'ObjectParameters');
                    if isfield(allfields, 'PortHandles')
                        ph = get_param(hParentSystem, 'PortHandles');
                        if ~isempty(getfield(ph, 'Trigger'))         % it's a triggered subsystem 
                            uBlocks = union(uBlocks, bufferBlocks(i));
                            break;
                        end
                    end
                end
            end
        end
    end
    % save block list into HTML attic
    startPos = savefoundObjects(uBlocks);
    if ~isempty(uBlocks)
        subTemplate = [subTemplate '<p>The following blocks are not supported inside a triggered subsystem.  ', ...
                'Consider replacing them with a combination of primitive blocks or a custom S-Function.'];
        % get htmlhypelink list
        for i=1:length(uBlocks)
            subTemplate = [subTemplate '<p>' getHiliteHyperlink(startPos+i)];
        end
    end
    
    % check blocks depends on absolute time when inside a triggered
    % subsystem (caveats C3)
    uBlocks = [];
    for i=1:length(BlockDataTypeTable)
        if BlockDataTypeTable(i).C3
            paramName = 'BlockType';
            bufferType = BlockDataTypeTable(i).BlockType;
            if strcmpi(bufferType, 'SubSystem')
                paramName = 'ReferenceBlock';
                bufferType = BlockDataTypeTable(i).ReferenceBlock;
                if isempty(bufferType)
                    paramName = 'MaskType';
                    bufferType = BlockDataTypeTable(i).MaskType;
                end                
            end
            bufferBlocks = find_system(hScope, ...
                'LookUnderMasks', 'on', ...
                paramName, bufferType);
            for i=1:length(bufferBlocks)
                hParentSystem = get_param(bufferBlocks(i), 'Handle');
                while ~(hParentSystem ==hModel)
                    hParentSystem = get_param(get_param(hParentSystem, 'Parent'), 'Handle'); % get parent's handle
                    allfields = get_param(hParentSystem, 'ObjectParameters');
                    if isfield(allfields, 'PortHandles')
                        ph = get_param(hParentSystem, 'PortHandles');
                        if ~isempty(getfield(ph, 'Trigger'))         % it's a triggered subsystem 
                            uBlocks = union(uBlocks, bufferBlocks(i));
                            break;
                        end
                    end
                end
            end
        end
    end
    % save block list into HTML attic
    startPos = savefoundObjects(uBlocks);
    if ~isempty(uBlocks)
        subTemplate = [subTemplate '<p>The following blocks depend on absolute time when inside a triggered subsystem.  ', ...
                'You can often factor out time from a block by using a combination of primitive blocks.  For example, ', ...
                'a discrete integrator can be constructed using a combination of product, sum and delay blocks.'];
        % get htmlhypelink list
        for i=1:length(uBlocks)
            subTemplate = [subTemplate '<p>' getHiliteHyperlink(startPos+i)];
        end
    end

    % check blocks not suitable for production deployment when configured
    % for time-based (caveats C2)
    uBlocks = [];
    for i=1:length(BlockDataTypeTable)
        if BlockDataTypeTable(i).C2
            paramName = 'BlockType';
            bufferType = BlockDataTypeTable(i).BlockType;
            if strcmpi(bufferType, 'SubSystem') % we'll go further if the block is a subsystem
                paramName = 'ReferenceBlock';
                bufferType = BlockDataTypeTable(i).ReferenceBlock;
                if isempty(bufferType)  % we'll use MaskType when ReferenceBlock is empty
                    paramName = 'MaskType';
                    bufferType = BlockDataTypeTable(i).MaskType;
                end
            end
            bufferBlocks = find_system(hScope, ...
                'LookUnderMasks', 'on', ...
                paramName, bufferType, ...
                BlockDataTypeTable(i).C2ParamName, BlockDataTypeTable(i).C2ParamValue);
            uBlocks = union(uBlocks, bufferBlocks);
        end
    end
    % save block list into HTML attic
    startPos = savefoundObjects(uBlocks);
    if ~isempty(uBlocks)
        subTemplate = [subTemplate '<p>The following blocks are not recommended since they depend on absolute time.  ', ...
                'Consider using blocks that do not have this dependency.'];
        % get htmlhypelink list
        for i=1:length(uBlocks)
            subTemplate = [subTemplate '<p>' getHiliteHyperlink(startPos+i)];
        end
    end
    
    if isempty(subTemplate)
        subTemplate = [subTemplate passString];
    end
    %  fill into the main html source
    htmlSource = strrep(htmlSource, '<!--continuous block template-->', subTemplate);
else
    % uncheck checkbox
    htmlSource = strrep(htmlSource, 'name="CheckQuestionBlock" value="ON" checked', 'name="CheckQuestionBlock" value="ON"');
end


%contBlocksInScope = [];
%numContStatesInModel = modelSimSizes(1);
%if HTMLattic('AtticData', 'CheckQuestionBlock')==1
%    for i = 1:numContStatesInModel
%        if (strncmp(blocksWithState{i}, scope, length(scope)))
%            %contBlocksInScope{end+1,1} = blocksWithState{i};
%            contBlocksInScope(end+1) = get_param(blocksWithState{i}, 'handle');
%        end
%    end
%    % save continuous block list into HTML attic
%    startPos = savefoundObjects(contBlocksInScope);
%    
%    subTemplate = '';
%    if ~isempty(contBlocksInScope)
%        subTemplate = [subTemplate 'Following is the list of blocks with continuous states which are not supported by the Embedded-C code format.'];
%        % get htmlhypelink list
%        for i=1:length(contBlocksInScope)
%            subTemplate = [subTemplate '<p>' getHiliteHyperlink(startPos+i)];
%        end
%    else
%        subTemplate = [subTemplate passString];
%    end
%    %  fill into the main html source
%    htmlSource = strrep(htmlSource, '<!--continuous block template-->', subTemplate);
%else
%    % uncheck checkbox
%    htmlSource = strrep(htmlSource, 'name="CheckQuestionBlock" value="ON" checked', 'name="CheckQuestionBlock" value="ON"');
%end

% - Unconnected lines/inputs/outputs
if HTMLattic('AtticData', 'CheckUnconnectedObj') == 1
    uLines = [find_system(hScope, ...
            'Findall', 'on', ...
            'LookUnderMasks', 'on', ...
            'Type', 'line', ...
            'SrcPortHandle', -1);
        find_system(hScope, ...
            'Findall', 'on', ...
            'LookUnderMasks', 'on', ...
            'Type', 'line', ...
            'DstPortHandle', -1)];
    
    uPorts = find_system(hScope, ...
        'Findall', 'on', ...
        'LookUnderMasks', 'on', ...
        'Type', 'port', ...
        'Line', -1);
    uPortBlocks = get_param(get_param(uPorts, 'Parent'), 'Handle');
    if (length(uPorts) > 1)
        uPortBlocks = [uPortBlocks{:}]';
    end
    
    % because hilite_system will use the line that they are connected to for
    % port objects, we need use parents of them to get correct hilite behaviour
    if ~isempty(uPorts)
        for i=1:length(uPorts)
            uPorts(i) = get_param(get_param(uPorts(i), 'Parent'), 'Handle');
        end
    end
    % save unconnected lines/inputs/outputs list into HTML attic
    unconnectedObj = union(uLines, uPorts);
    startPos = savefoundObjects(unconnectedObj);
    
    subTemplate = '';
    if ~isempty(unconnectedObj)
        subTemplate = [subTemplate 'The following list of unconnected lines and/or ports are likely to ', ...
                'cause problems propagating signal attributes (e.g., data type, sample time, dimensions).  ', ...
                'Note that ports connected to ground/terminator blocks will pass this check.'];
        % get htmlhypelink list
        for i=1:length(unconnectedObj)
            subTemplate = [subTemplate '<p>' getHiliteHyperlink(startPos+i)];
        end
    else
        subTemplate = [subTemplate passString];
    end
    %  fill into the main html source
    htmlSource = strrep(htmlSource, '<!--unconnected block template-->', subTemplate);
else
    % uncheck checkbox
    htmlSource = strrep(htmlSource, 'name="CheckUnconnectedObj" value="ON" checked', 'name="CheckUnconnectedObj" value="ON"');
end

% - Model root level inports (dimension/sample time/data type/signal type/storage class)
% NOTE: We don't have to worry about subsystem Inports because as long as the
%       system is connected to appropriate inputs and is generated by RT-click, 
%       this info will be added automatically.
if HTMLattic('AtticData', 'CheckRootLevelInports')==1
    hInports = find_system(hScope, 'SearchDepth', 1, 'BlockType', 'Inport');
    hUnsetPorts = [...
            find_system(hInports, 'PortDimensions', '-1'); ...
            find_system(hInports, 'SampleTime',     '-1'); ...
            find_system(hInports, 'DataType',       'auto'); ...
            %find_system(hInports, 'SignalType',     'auto'); ...
            %find_system(hInports, 'SamplingMode',   'frame-based')
            ];
    hUnsetPorts = unique(hUnsetPorts);
    % save unconnected lines/inputs/outputs list into HTML attic
    startPos = savefoundObjects(hUnsetPorts);
    
    subTemplate = '';
    if ~isempty(hUnsetPorts)
        subTemplate = [subTemplate 'Simulink back-propagates unspecified source attributes, which may lead to ', ...
                'undesired results.  Therefore, it is ', ...
                'recommended that you explicitly define inport dimensions, sample time, and data type ', ...
                'of system inports when generating code.  ', ...
                'The following system inports are not fully defined:'];
        % get htmlhypelink list
        for i=1:length(hUnsetPorts)
            subTemplate = [subTemplate '<p>' getHiliteHyperlink(startPos+i)];
        end
    else
        subTemplate = [subTemplate passString];
    end
    %  fill into the main html source
    htmlSource = strrep(htmlSource, '<!--undefined inports template-->', subTemplate);
else
    % uncheck checkbox
    htmlSource = strrep(htmlSource, 'name="CheckRootLevelInports" value="ON" checked', 'name="CheckRootLevelInports" value="ON"');
end


% - Solver (Fixed-step & discrete)
if HTMLattic('AtticData', 'CheckSolver')==1
    thisSolver = get_param(hModel, 'Solver');
    subTemplate = '';
    if (hScope == hModel)
        switch thisSolver
            case {'FixedStepDiscrete', 'ode5', 'ode4', 'ode3', 'ode2', 'ode1'}
                % No action
                % NOTE: Fixed-step continuous solvers are treated as FixedStepDiscrete because  
                %       the Embedded-Code format does not support blocks with continuous states.
                subTemplate = [subTemplate passString];
            case {'VariableStepDiscrete','ode45','ode23','ode113','ode15s','ode23s','ode23t','ode23tb'}
                subTemplate = [subTemplate 'You are currently using a variable step solver (', thisSolver, ').  ', ...
                        'A fixed-step solver is automatically selected when you (right-click) build a subsystem.  ', ...
                        'If you plan to generate code for the root model, you''ll need to change to a fixed-step ', ...
                        'discrete solver before invoking Real-Time Workshop Embedded Coder.'];
                %subTemplate = [subTemplate '<p>Do you want to use fixed-step discrete solver instead? '];
                %subTemplate = [subTemplate '<select size="1" name="updateSolver"><option selected>Yes</option><option>No</option></select>'];
                %if (numContStatesInModel==0)
                %else
                    % Model has continuous states, can not change to fixed-step solver
                    % No action
                %end
            otherwise
                error(['Unrecognized solver: ' thisSolver]);
        end
    else % we don't check solver for subsystem
        subTemplate = [subTemplate passString];
    end
    %  fill into the main html source
    htmlSource = strrep(htmlSource, '<!--fixed-step & discrete solver template-->', subTemplate);
else
    % uncheck checkbox
    htmlSource = strrep(htmlSource, 'name="CheckSolver" value="ON" checked', 'name="CheckSolver" value="ON"');    
end

% - Identify blocks that generate expensive saturate and rounding code
if HTMLattic('AtticData', 'CheckExpensiveBlocks')==1
%    hBlocks = find_system(hModel, 'Findall', 'on', ...
 %           'LookUnderMasks', 'on', ...
  %          'Type', 'block');
    hBlocks = [...
            find_system(hScope, 'SaturateOnIntegerOverflow', 'on'); ...
            find_system(hScope, 'RndMeth',     'Nearest'); ...
            find_system(hScope, 'RndMeth',     'Ceiling'); ...
            find_system(hScope, 'RndMeth',     'Zero'); ...
            ];
    hBlocks = unique(hBlocks);
    % save expensive block list into HTML attic
    startPos = savefoundObjects(hBlocks);
    
    subTemplate = '';
    if ~isempty(hBlocks)
        subTemplate = [subTemplate 'Selecting software saturation, overflow and rounding options for a block ', ...
                'produces significant code instrumentation (ROM) ', ...
                'that may not be required for your application.  For the most efficient implementation of a block, ', ...
                'do not select the "Saturate on integer overflow" option, and configure the "Round integer calculations ', ...
                'toward" option to floor.  This task is easily performed using the Frequent Tasks section of the ', ...
                'Search and Modify component.  Be sure to confirm the saturation and rounding mode for these blocks:'];
        % get htmlhypelink list
        for i=1:length(hBlocks)
            subTemplate = [subTemplate '<p>' getHiliteHyperlink(startPos+i)];
        end
    else
        subTemplate = [subTemplate passString];
    end
    %  fill into the main html source
    htmlSource = strrep(htmlSource, '<!--expensive block template-->', subTemplate);
else
    % uncheck checkbox
    htmlSource = strrep(htmlSource, 'name="CheckExpensiveBlocks" value="ON" checked', 'name="CheckExpensiveBlocks" value="ON"');
end

% compile model once either CheckTaskingMode or CheckFixedPoint selected
if (HTMLattic('AtticData', 'CheckTaskingMode')==1) || (HTMLattic('AtticData', 'CheckFixedPoint')==1)
    % Compile model before we go any further:
    [modelSimSizes, ICs, blocksWithState] = l_compileModel(model);
    if isempty(modelSimSizes)
        errordlg(sprintf(['Error during model compilation:\n\n%s'],lasterr));
    end
end

% - Single/MultiTasking

% Multi-rate --> NO --> [Auto] --> Generate code
%     |
%     | YES
%     V                                        [Trick SL to generate separate functions:
% Generate rate monotonic scheduler --> NO --> [Separate into atomic subsystems called
%     |                                        [by fcn-call triggers at same sample rate]
%     | YES (recommended)
%     V
% Multi-tasking --> NO --> [Single-tasking] --> Generate code    
%     |
%     | YES
%     V
% Invalid rate transitions --> NO --> Generate code
%     |
%     | YES
%     V
% Manually/automatically resolve invalid rate transitions

% Get number of discrete sample times in the system being generated
% Put model into 'compiled' mode
% Returns SIMSIZES:
% - nContinuousStates
% - nDiscreteStates
% - nOutputs
% - nInputs
% - RESERVED
% - isDirectFeedThrough
% - nSampleTimes
% NOTE: This doesn't work, because it includes continuous & constant sample times
% if (hScope = hModel)
%   nTs = modelSimSizes(7);
% else
if HTMLattic('AtticData', 'CheckTaskingMode')==1

    hBlks = find_system(hScope, 'LookUnderMasks', 'on', 'FollowLinks', 'on', 'Type', 'block');
    compiledTs = get_param(hBlks, 'CompiledSampleTime');
    if length(hBlks) > 1
        compiledTs = [compiledTs{:}]';
        compiledTs = [compiledTs(1:2:end), compiledTs(2:2:end)];
    end
    nTs = 0;
    
    % Remove blocks with sample time same as base sample time
    if hModel==hScope
        baseTs = get_param(hModel, 'FixedStep');
    else
        baseTs = get_param(hScope, 'CompiledSampleTime');
        baseTs = baseTs(1);
    end
    if ~strcmp(baseTs, 'auto')
        if hModel==hScope
            compiledTs(compiledTs(:,1)==evalin('base', baseTs) & compiledTs(:,2)==0,:) = [];
        else
            compiledTs(compiledTs(:,1)==baseTs & compiledTs(:,2)==0,:) = [];
        end
        nTs = nTs+1;
    end
    
    % Remove constant & continuous sample times:
    compiledTs(compiledTs(:,1)==Inf,:) = [];
    compiledTs(compiledTs(:,1)==0,  :) = [];
    
    while ~isempty(compiledTs)
        compiledTs(compiledTs(:,1)==compiledTs(1,1) & compiledTs(:,2)==compiledTs(1,2),:) = [];
        nTs = nTs+1;
    end
    
    subTemplate = '';
    % Setting SolverMode:
    thisSolverMode = get_param(hModel, 'SolverMode');
    if (nTs==1) % Single rate
        % SolverMode = 'MultiRate' but there is only one sample time
        if strcmp(thisSolverMode, 'MultiTasking')
            % NOTE: This code is needed in cases where:
            % - SolverMode = 'MultiTasking'
            % - the model has multiple sample times
            % - the subsystem under consideration only has a single sample time.
            set_param(hModel, 'SolverMode', 'Auto');
            subTemplate = [subTemplate 'This is a single rate system, setting SolverMode to ''Auto''.'];
        else
            subTemplate = [subTemplate passString];
        end
    else % Multi-rate
        subTemplate = [subTemplate 'This is a multi-rate system and the model is not configured for multitasking.  ', ...
                'To improve the real-time performance of the generated code, consider configuring the model ', ...
                'for multitasking operation.'];
        %subTemplate = [subTemplate 'Do you want to generate a rate monotonic scheduler?'];
        %subTemplate = [subTemplate '<p><input type="radio" value="multi" checked name="updateScheduler">Yes, and employ a multitasking scheduler</p>'];
        %subTemplate = [subTemplate '<p><input type="radio" value="single" name="updateScheduler">Yes, and employ a singletasking scheduler</p>'];
        %subTemplate = [subTemplate '<p><input type="radio" value="noupdate" name="updateScheduler">No'];
    end
    %  fill into the main html source
    htmlSource = strrep(htmlSource, '<!--single multiTasking template-->', subTemplate);
    % check checkbox 
    htmlSource = strrep(htmlSource, 'name="CheckTaskingMode" value="ON"', 'name="CheckTaskingMode" value="ON" checked');
else
    % uncheck checkbox
    htmlSource = strrep(htmlSource, 'name="CheckTaskingMode" value="ON" checked', 'name="CheckTaskingMode" value="ON"');        
end

% - System target file (ert.tlc) and target environment
if HTMLattic('AtticData', 'CheckSystemTLC')==1
    subTemplate = '';
    ERT_TargetFile = 'ert.tlc';
    thisTargetFile = get_param(hModel, 'RTWSystemTargetFile');
    if ~strncmp(thisTargetFile, ERT_TargetFile, length(ERT_TargetFile))
        sysTargetFiles = systlc_browse(matlabroot, path);
        % Get information for ERT_Target
        for i = 1:length(sysTargetFiles)
            if strcmp(sysTargetFiles(i).shortName, ERT_TargetFile)
                if ~isempty(which('ert_default_tmf'))
                    ERT_MakeFile = 'ert_default_tmf';
                else
                    ERT_MakeFile = sysTargetFiles(i).tmf;
                end
                ERT_MakeCmd  = sysTargetFiles(i).makeCmd;
            end
            %if strcmp(sysTargetFiles(i).shortName, thisTargetFile)
            %    this_MakeFile = sysTargetFiles(i).tmf;
            %    this_MakeCmd  = sysTargetFiles(i).makeCmd;
            %end            
        end
        this_MakeFile = get_param(hModel, 'RTWTemplateMakefile'); % could be different from sysTargetFiles(i).tmf
        this_MakeCmd  = get_param(hModel, 'RTWMakeCommand');
        % pre-record STF update info
        updateSTFRecord = '';
        updateSTFRecord.thisTargetFile = thisTargetFile;
        updateSTFRecord.ERT_TargetFile = ERT_TargetFile;
        updateSTFRecord.ERT_MakeFile = ERT_MakeFile;
        updateSTFRecord.ERT_MakeCmd = ERT_MakeCmd;
        updateSTFRecord.this_MakeFile = this_MakeFile;
        updateSTFRecord.this_MakeCmd = this_MakeCmd;
        HTMLattic('AtticData', 'updateSTFRecord', updateSTFRecord);
        
        
        subTemplate = '';
        subTemplate = [subTemplate 'Your current system target file is <font color=#FF0000>' thisTargetFile '</font>.'];
        subTemplate = [subTemplate '&nbsp;&nbsp;Please confirm your intention (i.e., consider using ert.tlc or an ', ...
                'ERT-based target such as mpc555_exp.tlc)'];
        %subTemplate = [subTemplate '<select size="1" name="updateSTF"><option selected>Yes</option><option>No</option></select>'];
        %subTemplate = [subTemplate '<p>NOTE: The following changes will also be made:'];
        %subTemplate = [subTemplate '<p>- Template makefile: ' ERT_MakeFile];
        %subTemplate = [subTemplate '<p>- Make command:      ' ERT_MakeCmd];
        
        %set_param(hModel, ...
        %   'RTWSystemTargetFile', ERT_TargetFile, ...
        %   'RTWTemplateMakefile', ERT_MakeFile, ...
        %   'RTWMakeCommand',      ERT_MakeCmd);
    end
    % validate target environment
    wordlengths = rtwwordlengths(model);
    % read ProdHWWordLengths
    paramValue = readparameter(model,'NewValue_ProdHWWordLengths'); % get '8,16,32,15' style string
    [token, paramValue] = strtok(paramValue, ',');
    wordlengths2.CharNumBits = str2num(token);
    [token, paramValue] = strtok(paramValue, ',');
    wordlengths2.ShortNumBits = str2num(token);
    [token, paramValue] = strtok(paramValue, ',');
    wordlengths2.IntNumBits = str2num(token);
    [token, paramValue] = strtok(paramValue, ',');
    wordlengths2.LongNumBits = str2num(token);
    systemTargetFile = get_param(model, 'RTWSystemTargetFile');
    rtwInfoHookFile = [strtok(systemTargetFile, '.') '_rtw_info_hook'];

    if (wordlengths.CharNumBits == wordlengths2.CharNumBits) && (wordlengths.ShortNumBits == wordlengths2.ShortNumBits) ...
            && (wordlengths.IntNumBits == wordlengths2.IntNumBits) && (wordlengths.LongNumBits == wordlengths2.LongNumBits)
        % word size do match
        subTemplate = [subTemplate '<p><p>Target specification is consistent. '];
    else
        % word size do not match
        subTemplate = [subTemplate '<p><p>Simulink and Real-Time Workshop require two sets of target specification. The first set'];
        subTemplate = [subTemplate ' describes the final intended production target. The second set describes the currently selected target.'];
        subTemplate = [subTemplate ' If the configurations do not match, Real-Time Workshop generates extra code to emulate the behavior '];
        subTemplate = [subTemplate 'of the production target. This allows you, for example, to emulate the behavior of a 16-bit '];
        subTemplate = [subTemplate ' production microprocessor on a 32-bit rapid-prototyping microprocessor.'];
        subTemplate = [subTemplate '<p>It is extremely important that the configurations sets agree for final code deployment.'];
    end
    subTemplate = [subTemplate '<p>Currently, using the following specification ']; 
    if ~exist(rtwInfoHookFile)
        subTemplate = [subTemplate '<font color="#FF0000">(note: ' rtwInfoHookFile '.m not found)</font>'];
    end

    if strcmpi(get_param(model, 'ProdHWDeviceType'), 'Microprocessor')
        wordlengths3.CharNumBits = num2str(double(wordlengths2.CharNumBits));
        wordlengths3.ShortNumBits = num2str(double(wordlengths2.ShortNumBits));
        wordlengths3.IntNumBits = num2str(double(wordlengths2.IntNumBits));
        wordlengths3.LongNumBits = num2str(double(wordlengths2.LongNumBits));
    else
        wordlengths3.CharNumBits = 'Unconstrained';
        wordlengths3.ShortNumBits = 'Unconstrained';
        wordlengths3.IntNumBits = 'Unconstrained';
        wordlengths3.LongNumBits = 'Unconstrained';
    end
    
    cImplementation = rtw_implementation_props(model);
    subTemplate = [subTemplate '<table border="0" width="100%">'];
    subTemplate = [subTemplate '  <tr>'];
    subTemplate = [subTemplate '    <td width="33%" align="center"> </td>'];
    subTemplate = [subTemplate '    <td width="33%" align="center"><a href="matlab: openSimprmAdvancedPage ">Production hardware Characteristics<br> (simulation and code generation)</a></td>'];
    if exist([rtwInfoHookFile '.m'])
        subTemplate = [subTemplate '    <td width="34%" align="center"><a href="matlab: edit ' rtwInfoHookFile '">Selected Target: ' strtok(get_param(model, 'RTWSystemTargetFile'), ' ') ' <br>(code generation)</a></td>'];
    else
        subTemplate = [subTemplate '    <td width="34%" align="center">Selected Target: ' strtok(get_param(model, 'RTWSystemTargetFile'), ' ') ' <br>(code generation)</td>'];    
    end
    subTemplate = [subTemplate '  </tr>'];
    subTemplate = [subTemplate '  <tr>'];
    subTemplate = [subTemplate '    <td width="33%" align="left">C Type char (bits)</td>'];
    if strcmpi(num2str(double(wordlengths.CharNumBits)), wordlengths3.CharNumBits)
        subTemplate = [subTemplate '    <td width="33%" align="center">' wordlengths3.CharNumBits '</td>'];
        subTemplate = [subTemplate '    <td width="34%" align="center">' num2str(double(wordlengths.CharNumBits)) '</td>'];
    else
        subTemplate = [subTemplate '    <td width="33%" align="center"><font color=#FF0000>' wordlengths3.CharNumBits '</font></td>'];
        subTemplate = [subTemplate '    <td width="34%" align="center"><font color=#FF0000>' num2str(double(wordlengths.CharNumBits)) '</font></td>'];
    end
    subTemplate = [subTemplate '  </tr>'];
    subTemplate = [subTemplate '  <tr>'];
    subTemplate = [subTemplate '    <td width="33%" align="left">C Type short (bits)</td>'];
    if strcmpi(num2str(double(wordlengths.ShortNumBits)), wordlengths3.ShortNumBits)
        subTemplate = [subTemplate '    <td width="33%" align="center">' wordlengths3.ShortNumBits '</td>'];
        subTemplate = [subTemplate '    <td width="34%" align="center">' num2str(double(wordlengths.ShortNumBits)) '</td>'];
    else
        subTemplate = [subTemplate '    <td width="33%" align="center"><font color=#FF0000>' wordlengths3.ShortNumBits '</font></td>'];
        subTemplate = [subTemplate '    <td width="34%" align="center"><font color=#FF0000>' num2str(double(wordlengths.ShortNumBits)) '</font></td>'];
    end
    subTemplate = [subTemplate '  </tr>'];
    subTemplate = [subTemplate '  <tr>'];
    subTemplate = [subTemplate '    <td width="33%" align="left">C Type int (bits)</td>'];
    if strcmpi(num2str(double(wordlengths.IntNumBits)), wordlengths3.IntNumBits)
        subTemplate = [subTemplate '    <td width="33%" align="center">' wordlengths3.IntNumBits '</td>'];
        subTemplate = [subTemplate '    <td width="34%" align="center">' num2str(double(wordlengths.IntNumBits)) '</td>'];
    else
        subTemplate = [subTemplate '    <td width="33%" align="center"><font color=#FF0000>' wordlengths3.IntNumBits '</font></td>'];
        subTemplate = [subTemplate '    <td width="34%" align="center"><font color=#FF0000>' num2str(double(wordlengths.IntNumBits)) '</font></td>'];
    end
    subTemplate = [subTemplate '  </tr>'];
    subTemplate = [subTemplate '  <tr>'];
    subTemplate = [subTemplate '    <td width="33%" align="left">C Type long (bits)</td>'];
    if strcmpi(num2str(double(wordlengths.LongNumBits)), wordlengths3.LongNumBits)
        subTemplate = [subTemplate '    <td width="33%" align="center">' wordlengths3.LongNumBits '</td>'];
        subTemplate = [subTemplate '    <td width="34%" align="center">' num2str(double(wordlengths.LongNumBits)) '</td>'];
    else
        subTemplate = [subTemplate '    <td width="33%" align="center"><font color=#FF0000>' wordlengths3.LongNumBits '</font></td>'];
        subTemplate = [subTemplate '    <td width="34%" align="center"><font color=#FF0000>' num2str(double(wordlengths.LongNumBits)) '</font></td>'];
    end
    subTemplate = [subTemplate '  </tr>'];
    subTemplate = [subTemplate '  <tr>'];
    subTemplate = [subTemplate '    <td width="33%" align="left">Shift right on signed integer is implemented as arithmetic shift?</td>'];
    subTemplate = [subTemplate '    <td width="33%" align="center">Not required</td>'];
    subTemplate = [subTemplate '    <td width="34%" align="center">' num2booleanString(cImplementation.ShiftRightIntArith) '</td>'];
    subTemplate = [subTemplate '  </tr>'];
    subTemplate = [subTemplate '  <tr>'];
    subTemplate = [subTemplate '    <td width="33%" align="left">Conversion from float to integer automatically saturates?</td>'];
    subTemplate = [subTemplate '    <td width="33%" align="center">Not required</td>'];
    subTemplate = [subTemplate '    <td width="34%" align="center">'  num2booleanString(cImplementation.Float2IntSaturates) '</td>'];
    subTemplate = [subTemplate '  </tr>'];
    subTemplate = [subTemplate '  <tr>'];
    subTemplate = [subTemplate '    <td width="33%" align="left">Integer addition automatically saturate on overflows?</td>'];
    subTemplate = [subTemplate '    <td width="33%" align="center">Not required</td>'];
    subTemplate = [subTemplate '    <td width="34%" align="center">' num2booleanString(cImplementation.IntPlusIntSaturates) '</td>'];
    subTemplate = [subTemplate '  </tr>'];
    subTemplate = [subTemplate '  <tr>'];
    subTemplate = [subTemplate '    <td width="33%" align="left">Integer multiplication automatically saturate on overflows?</td>'];
    subTemplate = [subTemplate '    <td width="33%" align="center">Not required</td>'];
    subTemplate = [subTemplate '    <td width="34%" align="center">' num2booleanString(cImplementation.IntTimesIntSaturates) '</td>'];
    subTemplate = [subTemplate '  </tr>  '];
    subTemplate = [subTemplate '</table>'];
    
    if isempty(subTemplate)
        subTemplate = [subTemplate passString];
    end
    %  fill into the main html source
    htmlSource = strrep(htmlSource, '<!--ert.tlc template-->', subTemplate);
else
    % uncheck checkbox
    htmlSource = strrep(htmlSource, 'name="CheckSystemTLC" value="ON" checked', 'name="CheckSystemTLC" value="ON"');        
end


% check Simulink/StateflowInterface
if HTMLattic('AtticData', 'CheckStateflowInterface')==1
    subTemplate = '';
    % look for stateflow charts in the model
    rt = sfroot;
    m = rt.find('-isa', 'Stateflow.Machine', '-and', 'Name',getfullname(scope));
    for i=1:length(m)
        chart = m(i).findDeep('Chart');
        for j=1:length(chart)
            if chart(j).StrongDataTypingWithSimulink == 0
                % save block list into HTML attic
                startPos = savefoundObjects(chart(j).up.handle);
                subTemplate = [subTemplate '<p>' getHiliteHyperlink(startPos+1)];
            end
        end
    end
    if ~isempty(subTemplate)
        explainStr = ['Stateflow charts using a weak data type specification for their Simulink I/O have been detected.  ', ...
            'This leads to very inefficient code.'];
        explainStr = [explainStr '&nbsp;&nbsp;Please consider updating the following charts to use strong data typing for their I/O.  ', ...
                'Note that you may need to adjust the data types in your model after the Stateflow option ', ...
                '"Use Strong Data Typing with Simulink I/O" is selected, however, this is strongly ', ...
                'recommended for generating efficient code.'];
        subTemplate = [explainStr subTemplate];
    else
        subTemplate = [subTemplate passString];
    end
    %  fill into the main html source
    htmlSource = strrep(htmlSource, '<!--CheckStateflowInterface template-->', subTemplate);
    % check checkbox
    htmlSource = strrep(htmlSource, 'name="CheckStateflowInterface" value="ON"', 'name="CheckStateflowInterface" value="ON" checked');
else
    % uncheck checkbox
    htmlSource = strrep(htmlSource, 'name="CheckStateflowInterface" value="ON" checked', 'name="CheckStateflowInterface" value="ON"');
end

% check costly data initialization
if HTMLattic('AtticData', 'CheckDataInitialization')==1
    subTemplate = '';
    % check data initialization option
    value1 = readparameter(model, 'NewValue_rtwoption_ZeroExternalMemoryAtStartup');
    value2 = readparameter(model, 'NewValue_rtwoption_ZeroInternalMemoryAtStartup');
    value3 = readparameter(model, 'NewValue_rtwoption_InitFltsAndDblsToZero');
    if strcmpi(num2str(value1), '1') || strcmpi(num2str(value2), '1') || strcmpi(num2str(value3), '1')
        subTemplate = [subTemplate 'By default, Real-Time Workshop Embedded Coder initializes all global ', ...
                'data to zero.  This is a precaution and may not be necessary for your application since ', ...
                'many embedded application environments initialize all RAM to zero at startup, making ', ...
                'initialization of global data redundant.  Confirm the data initialization settings in the ', ...
                'Data section of the Detailed Code Generation Goals.  Turning off redundant initialization ', ...
                'will lead to significant ROM savings.'];
        %subTemplate = [subTemplate '<select size="1" name="updateDataInitialization"><option selected>Yes</option><option>No</option></select>'];
    else
        subTemplate = [subTemplate passString];
    end
    %  fill into the main html source
    htmlSource = strrep(htmlSource, '<!--CheckDataInitialization template-->', subTemplate);
    % check checkbox
    htmlSource = strrep(htmlSource, 'name="CheckDataInitialization" value="ON"', 'name="CheckDataInitialization" value="ON" checked');
else
    % uncheck checkbox
    htmlSource = strrep(htmlSource, 'name="CheckDataInitialization" value="ON" checked', 'name="CheckDataInitialization" value="ON"');
end    

% check questionable Code Instrumentation
if HTMLattic('AtticData', 'CheckCodeInstrumentation')==1
    subTemplate = '';
    % check MAT file logging option
    value = readparameter(model, 'NewValue_rtwoption_MatFileLogging');
    if strcmpi(num2str(value), '1')
        subTemplate = [subTemplate '<p>The MAT-file logging option is currently selected, which results in significant code bloat.  ', ...
                'Consider turning off MAT-file logging in the Validation section of the Detailed Code Generation Goals.'];
        %subTemplate = [subTemplate '<select size="1" name="updateMATFileLogging"><option selected>Yes</option><option>No</option></select>'];
    end
    % check assertion blocks
    value = readparameter(model, 'NewValue_AssertionControl');
    if ~strcmpi(value, 'DisableAll') % ignore check if global control is off
        uBlocks = [find_system(hScope, ...
                'Findall', 'on', ...
                'LookUnderMasks', 'on', ...
                'BlockType', 'Assertion');
            find_system(hScope, ...
                'Findall', 'on', ...
                'LookUnderMasks', 'on', ...
                'MaskType', 'Checks_Gradient');
            find_system(hScope, ...
                'Findall', 'on', ...
                'LookUnderMasks', 'on', ...
                'MaskType', 'Checks_DGap');
            find_system(hScope, ...
                'Findall', 'on', ...
                'LookUnderMasks', 'on', ...
                'MaskType', 'Checks_DRange');
            find_system(hScope, ...
                'Findall', 'on', ...
                'LookUnderMasks', 'on', ...
                'MaskType', 'Checks_SGap');
            find_system(hScope, ...
                'Findall', 'on', ...
                'LookUnderMasks', 'on', ...
                'MaskType', 'Checks_SRange');
            find_system(hScope, ...
                'Findall', 'on', ...
                'LookUnderMasks', 'on', ...
                'MaskType', 'Checks_DMin');
            find_system(hScope, ...
                'Findall', 'on', ...
                'LookUnderMasks', 'on', ...
                'MaskType', 'Checks_DMax');
            find_system(hScope, ...
                'Findall', 'on', ...
                'LookUnderMasks', 'on', ...
                'MaskType', 'Checks_Resolution');
            find_system(hScope, ...
                'Findall', 'on', ...
                'LookUnderMasks', 'on', ...
                'MaskType', 'Checks_SMin');
            find_system(hScope, ...
                'Findall', 'on', ...
                'LookUnderMasks', 'on', ...
                'MaskType', 'Checks_SMax');];
        if ~isempty(uBlocks)
            subTemplate = [subTemplate '<p>The following blocks are generating additional assertion code.  ', ...
                    'Assertions can be disabled individually on a block-by-block basis or globally from the ', ...
                    'Advanced tab of the Simulation parameters dialog.'];
            % save block list into HTML attic
            uBlocks = unique(uBlocks);
            startPos = savefoundObjects(uBlocks);
            % get htmlhypelink list
            for i=1:length(uBlocks)
                subTemplate = [subTemplate '<p>' getHiliteHyperlink(startPos+i)];
            end
        end
    end
    if isempty(subTemplate)
        subTemplate = [subTemplate passString];
    end
    %  fill into the main html source
    htmlSource = strrep(htmlSource, '<!--CheckCodeInstrumentation template-->', subTemplate);
    % check checkbox
    htmlSource = strrep(htmlSource, 'name="CheckCodeInstrumentation" value="ON"', 'name="CheckCodeInstrumentation" value="ON" checked');
else
    % uncheck checkbox
    htmlSource = strrep(htmlSource, 'name="CheckCodeInstrumentation" value="ON" checked', 'name="CheckCodeInstrumentation" value="ON"');
end

% check fixpt blocks
if HTMLattic('AtticData', 'CheckFixedPoint')==1
    subTemplate = '';
    notes = fixpt_advisor(getfullname(hScope));
    if ~isempty(notes)
        subTemplate = [subTemplate ''];
        %for i = 1:length(notes)
        %    % save block list into HTML attic
        %    startPos = savefoundObjects(notes{i}.path);
        %    subTemplate = [subTemplate sprintf('\n\n<p>%s\n\n<p>%s',getHiliteHyperlink(startPos+1),notes{i}.issue)];
        %end
                % sort  
        combined_notes = [];
        for i = 1:length(notes)
            notes_found = 0;
            for j = 1:length(combined_notes)
                if strcmpi(combined_notes{j}.issue, notes{i}.issue)
                    notes_found = 1;
                    break
                end
            end
            if notes_found
                combined_notes{j}.path{end+1} = notes{i}.path;
            else
                combined_notes{end+1}.issue = notes{i}.issue;
                combined_notes{end}.path{1} = notes{i}.path;
            end
        end
        for i = 1:length(combined_notes)
            subTemplate = [subTemplate sprintf('\n\n<p><p><p>%s\n\n',combined_notes{i}.issue)];
            for j=1:length(combined_notes{i}.path)
                % save block list into HTML attic
                startPos = savefoundObjects(combined_notes{i}.path{j});
                subTemplate = [subTemplate sprintf('\n\n<p>%s', getHiliteHyperlink(startPos+1))];
            end
        end
        subTemplate = [subTemplate ''];
    else
        subTemplate = [subTemplate passString];
    end
    %  fill into the main html source
    htmlSource = strrep(htmlSource, '<!--check fixpt template-->', subTemplate);
    % check checkbox
    htmlSource = strrep(htmlSource, 'name="CheckFixedPoint" value="ON"', 'name="CheckFixedPoint" value="ON" checked'); 
else
    % uncheck checkbox
    htmlSource = strrep(htmlSource, 'name="CheckFixedPoint" value="ON" checked', 'name="CheckFixedPoint" value="ON"');            
end
    
    
% Write "Check model" button and "update model" button
checkButtonSrc = '<p align="center"><input type="submit" value="Check model" name="checkModel" onClick="htmlEncode(this.form)"></p>';
ButtonTblSrc = '';
ButtonTblSrc = [ButtonTblSrc '<table border="0" width="100%">'];
ButtonTblSrc = [ButtonTblSrc '  <tr>'];
ButtonTblSrc = [ButtonTblSrc '    <td width="50%">'];
ButtonTblSrc = [ButtonTblSrc '      <p align="center"><input type="submit" value="Check model" name="checkModel" onClick="htmlEncode(this.form)"></td>'];
ButtonTblSrc = [ButtonTblSrc '    <td width="50%">'];
ButtonTblSrc = [ButtonTblSrc '      <p align="center"><input type="submit" value="Apply updates" name="updateModel" onClick="htmlEncode(this.form)"></td>'];
ButtonTblSrc = [ButtonTblSrc '  </tr>'];
ButtonTblSrc = [ButtonTblSrc '</table>'];
%htmlSource = strrep(htmlSource, checkButtonSrc, ButtonTblSrc);

% Force refresh of RTWOptions
refreshRTWOptions(hModel);


% ====================================================================
% SUBFUNCTIONS
% ====================================================================
% incrementally save foundObjects into HTMLattic, and return start position
% as index
function startPos = savefoundObjects(foundObjects)
FOUND_OBJECTS = HTMLattic('AtticData', 'FOUND_OBJECTS');
startPos = length(FOUND_OBJECTS);
if ~isstr(foundObjects)
    for i=1:length(foundObjects)
        FOUND_OBJECTS(startPos+i).handle = get_param(foundObjects(i), 'handle');
        FOUND_OBJECTS(startPos+i).fullname = getfullname(foundObjects(i));
        FOUND_OBJECTS(startPos+i).name = get_param(foundObjects(i),'name');
    end
else
    FOUND_OBJECTS(startPos+1).handle = get_param(foundObjects, 'handle');
    FOUND_OBJECTS(startPos+1).fullname = getfullname(foundObjects);
    FOUND_OBJECTS(startPos+1).name = get_param(foundObjects,'name');    
end
HTMLattic('AtticData', 'FOUND_OBJECTS', FOUND_OBJECTS);        

% ====================================================================
% SUBFUNCTIONS
% ====================================================================
function [modelSimSizes, ICs, blocksWithState] = l_compileModel(model)
try
  hWait = waitbar(0, 'Compiling model', 'Name', 'Please wait...');
  [modelSimSizes, ICs, blocksWithState] = eval([getfullname(model), '([], [], [], ''compile'');']);
  waitbar(0.9);
  eval([getfullname(model), '([], [], [], ''term'', ''force'');']);
  waitbar(1);
catch
  modelSimSizes=[];
  ICs=[];
  blocksWithState=[];
end
close(hWait);

% ====================================================================
% SUBFUNCTIONS
% ====================================================================
function l_closeSimPrmDlg(hModel)

% Find handle to Simulation Parameters dialog
hSimPrmDlg = findall(0, 'Type', 'figure', ...
  'Name', sprintf('Simulation Parameters: %s', get_param(hModel, 'Name')));

% If SimParamDialog is open, prompt user to close it before continuing
for i = 1:length(hSimPrmDlg)
  if strcmp(get(hSimPrmDlg(i), 'Visible'), 'on')
    simprm('show', hSimPrmDlg(i));
    qString = 'The Simulation Parameters Dialog must be closed before continuing.';
    errordlg(qString);
    waitfor(hSimPrmDlg(i), 'Visible', 'off');
  end
end


% ====================================================================
function refreshRTWOptions(hModel)
% Ensure that Sim Param Dialog is closed for this model
l_closeSimPrmDlg(hModel);

% Open new Sim Param Dialog on RTW pane and press "OK" ==> update RTWOptions
oldSimParamPage = get_param(hModel, 'SimParamPage');
set_param(hModel, 'SimParamPage', 'RTW');
hSimPrmDlg = simprm('create', hModel);
set(hSimPrmDlg, 'Visible', 'off');
simprm('SystemButtons', 'OK', hSimPrmDlg);
set_param(hModel, 'SimParamPage', oldSimParamPage);



% xxxx Note: This function is serve as a gateway to hold information about
% Simulink block data type and their support in RTW-EC. The infomation here
% is as true as Release 13. Please keep the table updated when blocks get
% updated. (see showblockdatatypetable for details)
% blockDataTypeTable:
%  Note: to speed up loop through the table, we won't list blocks which are
%  suitable for code gen and no caveats. in other words, we only list
%  "questionable" blocks.
%
%       ReferenceBlock: sometime the block is a masked subsystem, i.e., Band-Limited White
%             Noise. In this case, BlockType is always subsystem, we need
%             this field to decide block type.
%       BlockType: same as BlockType in get_param(gcb, 'BlockType');
%       MaskType:  sometime BlockType is subsystem and referenceBlock is
%       empty, we need MaskType to get the block type.
%       RTWenable: is it able to generate code for RTW. false then
%           following field will be ignored.
%       C1: Caveats 1 - Cannot be used inside a triggered subsystem
%           hierarchy.
%       C2: Caveats 2 - These blocks are suitable for production deployment
%       when configured for sample-based operation. In time-based operation
%       they depend on absolute time, and are therefore not suitable for
%       production deployment.
%       C3: Caveats 3 - Depends on absolute time when placed inside a
%       triggered subsystem hierarchy.
%       N1: Notes 1 - Ignored for code generation.
function BlockDataTypeTable = createBlockDataTypeTable
BlockDataTypeTable = [];
idx = 0;

idx = idx+1;
BlockDataTypeTable(idx).BlockType = 'SubSystem';
BlockDataTypeTable(idx).ReferenceBlock = sprintf('simulink/Sources/Band-Limited\nWhite Noise');
BlockDataTypeTable(idx).RTWenable = 1;
BlockDataTypeTable(idx).C1 = 1;
BlockDataTypeTable(idx).C2 = 0;
BlockDataTypeTable(idx).C3 = 0;
BlockDataTypeTable(idx).N1 = 0;

idx = idx+1;
BlockDataTypeTable(idx).BlockType = 'SubSystem';
BlockDataTypeTable(idx).ReferenceBlock = sprintf('simulink/Sources/Chirp Signal');
BlockDataTypeTable(idx).RTWenable = 0;
BlockDataTypeTable(idx).C1 = 0;
BlockDataTypeTable(idx).C2 = 0;
BlockDataTypeTable(idx).C3 = 0;
BlockDataTypeTable(idx).N1 = 0;

idx = idx+1;
BlockDataTypeTable(idx).BlockType = 'Clock';
BlockDataTypeTable(idx).ReferenceBlock = '';
BlockDataTypeTable(idx).RTWenable = 0;
BlockDataTypeTable(idx).C1 = 0;
BlockDataTypeTable(idx).C2 = 0;
BlockDataTypeTable(idx).C3 = 0;
BlockDataTypeTable(idx).N1 = 0;

idx = idx+1;
BlockDataTypeTable(idx).BlockType = 'DigitalClock';
BlockDataTypeTable(idx).ReferenceBlock = '';
BlockDataTypeTable(idx).RTWenable = 0;
BlockDataTypeTable(idx).C1 = 0;
BlockDataTypeTable(idx).C2 = 0;
BlockDataTypeTable(idx).C3 = 0;
BlockDataTypeTable(idx).N1 = 0;

idx = idx+1;
BlockDataTypeTable(idx).BlockType = 'FromFile';
BlockDataTypeTable(idx).ReferenceBlock = '';
BlockDataTypeTable(idx).RTWenable = 0;
BlockDataTypeTable(idx).C1 = 0;
BlockDataTypeTable(idx).C2 = 0;
BlockDataTypeTable(idx).C3 = 0;
BlockDataTypeTable(idx).N1 = 0;

idx = idx+1;
BlockDataTypeTable(idx).BlockType = 'FromWorkspace';
BlockDataTypeTable(idx).ReferenceBlock = '';
BlockDataTypeTable(idx).RTWenable = 0;
BlockDataTypeTable(idx).C1 = 0;
BlockDataTypeTable(idx).C2 = 0;
BlockDataTypeTable(idx).C3 = 0;
BlockDataTypeTable(idx).N1 = 0;

idx = idx+1;
BlockDataTypeTable(idx).BlockType = 'DiscretePulseGenerator';
BlockDataTypeTable(idx).ReferenceBlock = '';
BlockDataTypeTable(idx).RTWenable = 1;
BlockDataTypeTable(idx).C1 = 1;
BlockDataTypeTable(idx).C2 = 1;
BlockDataTypeTable(idx).C2ParamName  = 'PulseType';
BlockDataTypeTable(idx).C2ParamValue = 'Time based'; % name/value pair to make C2 true.
BlockDataTypeTable(idx).C3 = 0;
BlockDataTypeTable(idx).N1 = 0;


idx = idx+1;
BlockDataTypeTable(idx).BlockType = 'SubSystem';
BlockDataTypeTable(idx).ReferenceBlock = sprintf('simulink/Sources/Ramp');
BlockDataTypeTable(idx).RTWenable = 0;
BlockDataTypeTable(idx).C1 = 0;
BlockDataTypeTable(idx).C2 = 0;
BlockDataTypeTable(idx).C3 = 0;
BlockDataTypeTable(idx).N1 = 0;

idx = idx+1;
BlockDataTypeTable(idx).BlockType = 'SubSystem';
BlockDataTypeTable(idx).ReferenceBlock = sprintf('simulink/Sources/Repeating\nSequence');
BlockDataTypeTable(idx).RTWenable = 0;
BlockDataTypeTable(idx).C1 = 0;
BlockDataTypeTable(idx).C2 = 0;
BlockDataTypeTable(idx).C3 = 0;
BlockDataTypeTable(idx).N1 = 0;

idx = idx+1;
BlockDataTypeTable(idx).BlockType = 'SubSystem';
BlockDataTypeTable(idx).ReferenceBlock = '';
BlockDataTypeTable(idx).MaskType = 'Sigbuilder block';
BlockDataTypeTable(idx).RTWenable = 0;
BlockDataTypeTable(idx).C1 = 0;
BlockDataTypeTable(idx).C2 = 0;
BlockDataTypeTable(idx).C3 = 0;
BlockDataTypeTable(idx).N1 = 0;

idx = idx+1;
BlockDataTypeTable(idx).BlockType = 'SignalGenerator';
BlockDataTypeTable(idx).ReferenceBlock = '';
BlockDataTypeTable(idx).RTWenable = 0;
BlockDataTypeTable(idx).C1 = 0;
BlockDataTypeTable(idx).C2 = 0;
BlockDataTypeTable(idx).C3 = 0;
BlockDataTypeTable(idx).N1 = 0;

idx = idx+1;
BlockDataTypeTable(idx).BlockType = 'Sin';
BlockDataTypeTable(idx).ReferenceBlock = '';
BlockDataTypeTable(idx).RTWenable = 1;
BlockDataTypeTable(idx).C1 = 0;
BlockDataTypeTable(idx).C2 = 1;
BlockDataTypeTable(idx).C2ParamName  = 'SineType';
BlockDataTypeTable(idx).C2ParamValue = 'Time based'; % name/value pair to make C2 true.
BlockDataTypeTable(idx).C3 = 1;
BlockDataTypeTable(idx).N1 = 0;

idx = idx+1;
BlockDataTypeTable(idx).BlockType = 'Step';
BlockDataTypeTable(idx).ReferenceBlock = '';
BlockDataTypeTable(idx).RTWenable = 0;
BlockDataTypeTable(idx).C1 = 0;
BlockDataTypeTable(idx).C2 = 0;
BlockDataTypeTable(idx).C3 = 0;
BlockDataTypeTable(idx).N1 = 0;

idx = idx+1;
BlockDataTypeTable(idx).BlockType = 'Stop';
BlockDataTypeTable(idx).ReferenceBlock = '';
BlockDataTypeTable(idx).RTWenable = 0;
BlockDataTypeTable(idx).C1 = 0;
BlockDataTypeTable(idx).C2 = 0;
BlockDataTypeTable(idx).C3 = 0;
BlockDataTypeTable(idx).N1 = 0;

idx = idx+1;
BlockDataTypeTable(idx).BlockType = 'ToFile';
BlockDataTypeTable(idx).ReferenceBlock = '';
BlockDataTypeTable(idx).RTWenable = 0;
BlockDataTypeTable(idx).C1 = 0;
BlockDataTypeTable(idx).C2 = 0;
BlockDataTypeTable(idx).C3 = 0;
BlockDataTypeTable(idx).N1 = 0;

idx = idx+1;
BlockDataTypeTable(idx).BlockType = 'Derivative';
BlockDataTypeTable(idx).ReferenceBlock = '';
BlockDataTypeTable(idx).RTWenable = 0;
BlockDataTypeTable(idx).C1 = 0;
BlockDataTypeTable(idx).C2 = 0;
BlockDataTypeTable(idx).C3 = 0;
BlockDataTypeTable(idx).N1 = 0;

idx = idx+1;
BlockDataTypeTable(idx).BlockType = 'Integrator';
BlockDataTypeTable(idx).ReferenceBlock = '';
BlockDataTypeTable(idx).RTWenable = 0;
BlockDataTypeTable(idx).C1 = 0;
BlockDataTypeTable(idx).C2 = 0;
BlockDataTypeTable(idx).C3 = 0;
BlockDataTypeTable(idx).N1 = 0;

idx = idx+1;
BlockDataTypeTable(idx).BlockType = 'Integrator';
BlockDataTypeTable(idx).ReferenceBlock = '';
BlockDataTypeTable(idx).RTWenable = 0;
BlockDataTypeTable(idx).C1 = 0;
BlockDataTypeTable(idx).C2 = 0;
BlockDataTypeTable(idx).C3 = 0;
BlockDataTypeTable(idx).N1 = 0;

idx = idx+1;
BlockDataTypeTable(idx).BlockType = 'StateSpace';
BlockDataTypeTable(idx).ReferenceBlock = '';
BlockDataTypeTable(idx).RTWenable = 0;
BlockDataTypeTable(idx).C1 = 0;
BlockDataTypeTable(idx).C2 = 0;
BlockDataTypeTable(idx).C3 = 0;
BlockDataTypeTable(idx).N1 = 0;

idx = idx+1;
BlockDataTypeTable(idx).BlockType = 'TransferFcn';
BlockDataTypeTable(idx).ReferenceBlock = '';
BlockDataTypeTable(idx).RTWenable = 0;
BlockDataTypeTable(idx).C1 = 0;
BlockDataTypeTable(idx).C2 = 0;
BlockDataTypeTable(idx).C3 = 0;
BlockDataTypeTable(idx).N1 = 0;

idx = idx+1;
BlockDataTypeTable(idx).BlockType = 'TransportDelay';
BlockDataTypeTable(idx).ReferenceBlock = '';
BlockDataTypeTable(idx).RTWenable = 0;
BlockDataTypeTable(idx).C1 = 0;
BlockDataTypeTable(idx).C2 = 0;
BlockDataTypeTable(idx).C3 = 0;
BlockDataTypeTable(idx).N1 = 0;

idx = idx+1;
BlockDataTypeTable(idx).BlockType = 'VariableTransportDelay';
BlockDataTypeTable(idx).ReferenceBlock = '';
BlockDataTypeTable(idx).RTWenable = 0;
BlockDataTypeTable(idx).C1 = 0;
BlockDataTypeTable(idx).C2 = 0;
BlockDataTypeTable(idx).C3 = 0;
BlockDataTypeTable(idx).N1 = 0;

idx = idx+1;
BlockDataTypeTable(idx).BlockType = 'ZeroPole';
BlockDataTypeTable(idx).ReferenceBlock = '';
BlockDataTypeTable(idx).RTWenable = 0;
BlockDataTypeTable(idx).C1 = 0;
BlockDataTypeTable(idx).C2 = 0;
BlockDataTypeTable(idx).C3 = 0;
BlockDataTypeTable(idx).N1 = 0;

idx = idx+1;
BlockDataTypeTable(idx).BlockType = 'DiscreteIntegrator';
BlockDataTypeTable(idx).ReferenceBlock = '';
BlockDataTypeTable(idx).RTWenable = 1;
BlockDataTypeTable(idx).C1 = 0;
BlockDataTypeTable(idx).C2 = 0;
BlockDataTypeTable(idx).C3 = 1;
BlockDataTypeTable(idx).N1 = 0;

idx = idx+1;
BlockDataTypeTable(idx).BlockType = 'SubSystem';
BlockDataTypeTable(idx).ReferenceBlock = sprintf('simulink/Math\nOperations/Algebraic Constraint');
BlockDataTypeTable(idx).RTWenable = 0;
BlockDataTypeTable(idx).C1 = 0;
BlockDataTypeTable(idx).C2 = 0;
BlockDataTypeTable(idx).C3 = 0;
BlockDataTypeTable(idx).N1 = 0;

idx = idx+1;
BlockDataTypeTable(idx).BlockType = 'SubSystem';
BlockDataTypeTable(idx).ReferenceBlock = sprintf('simulink/Signal\nRouting/Manual Switch');
BlockDataTypeTable(idx).RTWenable = 0;
BlockDataTypeTable(idx).C1 = 0;
BlockDataTypeTable(idx).C2 = 0;
BlockDataTypeTable(idx).C3 = 0;
BlockDataTypeTable(idx).N1 = 0;

idx = idx+1;
BlockDataTypeTable(idx).BlockType = 'SubSystem';
BlockDataTypeTable(idx).ReferenceBlock = sprintf('simulink/Discrete/First-Order\nHold');
BlockDataTypeTable(idx).RTWenable = 0;
BlockDataTypeTable(idx).C1 = 0;
BlockDataTypeTable(idx).C2 = 0;
BlockDataTypeTable(idx).C3 = 0;
BlockDataTypeTable(idx).N1 = 0;


idx = idx+1;
BlockDataTypeTable(idx).BlockType = 'InitialCondition';
BlockDataTypeTable(idx).ReferenceBlock = '';
BlockDataTypeTable(idx).RTWenable = 0;
BlockDataTypeTable(idx).C1 = 0;
BlockDataTypeTable(idx).C2 = 0;
BlockDataTypeTable(idx).C3 = 0;
BlockDataTypeTable(idx).N1 = 0;

idx = idx+1;
BlockDataTypeTable(idx).BlockType = 'SubSystem'; % actually Rate Transition is a S-function
BlockDataTypeTable(idx).ReferenceBlock = sprintf('simulink/Signal\nAttributes/Rate Transition');
BlockDataTypeTable(idx).RTWenable = 1;
BlockDataTypeTable(idx).C1 = 1;
BlockDataTypeTable(idx).C2 = 0;
BlockDataTypeTable(idx).C3 = 0;
BlockDataTypeTable(idx).N1 = 0;

idx = idx+1;
BlockDataTypeTable(idx).BlockType = 'HitCross';
BlockDataTypeTable(idx).ReferenceBlock = '';
BlockDataTypeTable(idx).RTWenable = 0;
BlockDataTypeTable(idx).C1 = 0;
BlockDataTypeTable(idx).C2 = 0;
BlockDataTypeTable(idx).C3 = 0;
BlockDataTypeTable(idx).N1 = 0;

idx = idx+1;
BlockDataTypeTable(idx).BlockType = 'RateLimiter';
BlockDataTypeTable(idx).ReferenceBlock = '';
BlockDataTypeTable(idx).RTWenable = 0;
BlockDataTypeTable(idx).C1 = 0;
BlockDataTypeTable(idx).C2 = 0;
BlockDataTypeTable(idx).C3 = 0;
BlockDataTypeTable(idx).N1 = 0;

idx = idx+1;
BlockDataTypeTable(idx).BlockType = 'MATLABFcn';
BlockDataTypeTable(idx).ReferenceBlock = '';
BlockDataTypeTable(idx).RTWenable = 0;
BlockDataTypeTable(idx).C1 = 0;
BlockDataTypeTable(idx).C2 = 0;
BlockDataTypeTable(idx).C3 = 0;
BlockDataTypeTable(idx).N1 = 0;

idx = idx+1;
BlockDataTypeTable(idx).BlockType = 'SubSystem'; 
BlockDataTypeTable(idx).ReferenceBlock = ''; %actually it's 'fixpt_lib_4/Sources/Repeating..', but it's more reliable to use MaskType
BlockDataTypeTable(idx).MaskType = 'Fixed-Point Repeating Sequence Interpolated';
BlockDataTypeTable(idx).RTWenable = 1;
BlockDataTypeTable(idx).C1 = 1;
BlockDataTypeTable(idx).C2 = 0;
BlockDataTypeTable(idx).C3 = 0;
BlockDataTypeTable(idx).N1 = 0;

idx = idx+1;
BlockDataTypeTable(idx).BlockType = 'SubSystem'; 
BlockDataTypeTable(idx).ReferenceBlock = ''; %actually it's 'fixpt_lib_4/..', but it's more reliable to use MaskType
BlockDataTypeTable(idx).MaskType = 'Fixed-Point Rate Limiter';
BlockDataTypeTable(idx).RTWenable = 1;
BlockDataTypeTable(idx).C1 = 1;
BlockDataTypeTable(idx).C2 = 0;
BlockDataTypeTable(idx).C3 = 0;
BlockDataTypeTable(idx).N1 = 0;

idx = idx+1;
BlockDataTypeTable(idx).BlockType = 'SubSystem'; 
BlockDataTypeTable(idx).ReferenceBlock = ''; %actually it's 'fixpt_lib_4/..', but it's more reliable to use MaskType
BlockDataTypeTable(idx).MaskType = 'Fixed-Point Rate Limiter Dynamic';
BlockDataTypeTable(idx).RTWenable = 1;
BlockDataTypeTable(idx).C1 = 1;
BlockDataTypeTable(idx).C2 = 0;
BlockDataTypeTable(idx).C3 = 0;
BlockDataTypeTable(idx).N1 = 0;

idx = idx+1;
BlockDataTypeTable(idx).BlockType = 'SubSystem'; 
BlockDataTypeTable(idx).ReferenceBlock = ''; %actually it's 'fixpt_lib_4/..', but it's more reliable to use MaskType
BlockDataTypeTable(idx).MaskType = 'Fixed-Point Derivative';
BlockDataTypeTable(idx).RTWenable = 1;
BlockDataTypeTable(idx).C1 = 1;
BlockDataTypeTable(idx).C2 = 0;
BlockDataTypeTable(idx).C3 = 0;
BlockDataTypeTable(idx).N1 = 0;

idx = idx+1;
BlockDataTypeTable(idx).BlockType = 'SubSystem'; 
BlockDataTypeTable(idx).ReferenceBlock = ''; %actually it's 'fixpt_lib_4/..', but it's more reliable to use MaskType
BlockDataTypeTable(idx).MaskType = 'Fixed-Point Integrator Backward';
BlockDataTypeTable(idx).RTWenable = 1;
BlockDataTypeTable(idx).C1 = 1;
BlockDataTypeTable(idx).C2 = 0;
BlockDataTypeTable(idx).C3 = 0;
BlockDataTypeTable(idx).N1 = 0;

idx = idx+1;
BlockDataTypeTable(idx).BlockType = 'SubSystem'; 
BlockDataTypeTable(idx).ReferenceBlock = ''; %actually it's 'fixpt_lib_4/..', but it's more reliable to use MaskType
BlockDataTypeTable(idx).MaskType = 'Fixed-Point Integrator Backward Resettable';
BlockDataTypeTable(idx).RTWenable = 1;
BlockDataTypeTable(idx).C1 = 1;
BlockDataTypeTable(idx).C2 = 0;
BlockDataTypeTable(idx).C3 = 0;
BlockDataTypeTable(idx).N1 = 0;

idx = idx+1;
BlockDataTypeTable(idx).BlockType = 'SubSystem'; 
BlockDataTypeTable(idx).ReferenceBlock = ''; %actually it's 'fixpt_lib_4/..', but it's more reliable to use MaskType
BlockDataTypeTable(idx).MaskType = 'Fixed-Point Integrator Backward Resettable Limited';
BlockDataTypeTable(idx).RTWenable = 1;
BlockDataTypeTable(idx).C1 = 1;
BlockDataTypeTable(idx).C2 = 0;
BlockDataTypeTable(idx).C3 = 0;
BlockDataTypeTable(idx).N1 = 0;

idx = idx+1;
BlockDataTypeTable(idx).BlockType = 'SubSystem'; 
BlockDataTypeTable(idx).ReferenceBlock = ''; %actually it's 'fixpt_lib_4/..', but it's more reliable to use MaskType
BlockDataTypeTable(idx).MaskType = 'Fixed-Point Integrator Forward';
BlockDataTypeTable(idx).RTWenable = 1;
BlockDataTypeTable(idx).C1 = 1;
BlockDataTypeTable(idx).C2 = 0;
BlockDataTypeTable(idx).C3 = 0;
BlockDataTypeTable(idx).N1 = 0;

idx = idx+1;
BlockDataTypeTable(idx).BlockType = 'SubSystem'; 
BlockDataTypeTable(idx).ReferenceBlock = ''; %actually it's 'fixpt_lib_4/..', but it's more reliable to use MaskType
BlockDataTypeTable(idx).MaskType = 'Fixed-Point Integrator Forward Resettable';
BlockDataTypeTable(idx).RTWenable = 1;
BlockDataTypeTable(idx).C1 = 1;
BlockDataTypeTable(idx).C2 = 0;
BlockDataTypeTable(idx).C3 = 0;
BlockDataTypeTable(idx).N1 = 0;

idx = idx+1;
BlockDataTypeTable(idx).BlockType = 'SubSystem'; 
BlockDataTypeTable(idx).ReferenceBlock = ''; %actually it's 'fixpt_lib_4/..', but it's more reliable to use MaskType
BlockDataTypeTable(idx).MaskType = 'Fixed-Point Integrator Forward Resettable Limited';
BlockDataTypeTable(idx).RTWenable = 1;
BlockDataTypeTable(idx).C1 = 1;
BlockDataTypeTable(idx).C2 = 0;
BlockDataTypeTable(idx).C3 = 0;
BlockDataTypeTable(idx).N1 = 0;

idx = idx+1;
BlockDataTypeTable(idx).BlockType = 'SubSystem'; 
BlockDataTypeTable(idx).ReferenceBlock = ''; %actually it's 'fixpt_lib_4/..', but it's more reliable to use MaskType
BlockDataTypeTable(idx).MaskType = 'Fixed-Point Integrator Trapezoidal';
BlockDataTypeTable(idx).RTWenable = 1;
BlockDataTypeTable(idx).C1 = 1;
BlockDataTypeTable(idx).C2 = 0;
BlockDataTypeTable(idx).C3 = 0;
BlockDataTypeTable(idx).N1 = 0;

idx = idx+1;
BlockDataTypeTable(idx).BlockType = 'SubSystem'; 
BlockDataTypeTable(idx).ReferenceBlock = ''; %actually it's 'fixpt_lib_4/..', but it's more reliable to use MaskType
BlockDataTypeTable(idx).MaskType = 'Fixed-Point Integrator Trapezoidal Resettable';
BlockDataTypeTable(idx).RTWenable = 1;
BlockDataTypeTable(idx).C1 = 1;
BlockDataTypeTable(idx).C2 = 0;
BlockDataTypeTable(idx).C3 = 0;
BlockDataTypeTable(idx).N1 = 0;

idx = idx+1;
BlockDataTypeTable(idx).BlockType = 'SubSystem'; 
BlockDataTypeTable(idx).ReferenceBlock = ''; %actually it's 'fixpt_lib_4/..', but it's more reliable to use MaskType
BlockDataTypeTable(idx).MaskType = 'Fixed-Point Integrator Trapezoidal Resettable Limited';
BlockDataTypeTable(idx).RTWenable = 1;
BlockDataTypeTable(idx).C1 = 1;
BlockDataTypeTable(idx).C2 = 0;
BlockDataTypeTable(idx).C3 = 0;
BlockDataTypeTable(idx).N1 = 0;

idx = idx+1;
% this includes Fixpt blocks: Sample Rate Probe, Sample Time Add, Sample
% Time Divide, Sample Time Multiply, Sample Time Probe, Sample Time
% Subtract, as they all have same BlockType, ReferenceBlock and MaskType.
BlockDataTypeTable(idx).BlockType = 'SubSystem'; 
BlockDataTypeTable(idx).ReferenceBlock = ''; %actually it's 'fixpt_lib_4/..', but it's more reliable to use MaskType
BlockDataTypeTable(idx).MaskType = 'Fixed-Point Sample Time Math';
BlockDataTypeTable(idx).RTWenable = 1;
BlockDataTypeTable(idx).C1 = 1;
BlockDataTypeTable(idx).C2 = 0;
BlockDataTypeTable(idx).C3 = 0;
BlockDataTypeTable(idx).N1 = 0;

