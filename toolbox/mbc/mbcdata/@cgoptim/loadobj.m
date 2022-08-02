function optim= loadobj(optim);
%LOADOBJ Load-time object actions
%
%  OBJ = LOADOBJ(OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.11.6.3 $    $Date: 2004/02/09 06:53:45 $

if optim.version<2
    % Need to start with a fresh structure
    s = optim;
    optim = cgoptim;
    optim.name = s.name;
    optim.description = s.description;
    optim.om = s.om;
    optim.values = s.values;
    optim.valueLabels = s.valueLabels;
    optim.oppoints = s.oppoints;
    optim.oppointLabels = s.oppointLabels;
    optim.oppointValues = s.oppointValues;
    optim.oppointValueLabels = s.oppointValueLabels;
    optim.objectiveFuncs = s.objectiveFuncs;
    optim.objectiveFuncLabels = s.objectiveFuncLabels;
    optim.constraints = s.constraints;
    optim.constraintLabels = s.constraintLabels;
end

if optim.version<3
    optim.outputOppoints = [];
end

if optim.version<4
    optim.ParetoOutput = [];
end

if optim.version<5
    optim.summary.objectivesums = [];    
    optim.summary.data = [];
end

if optim.version<6
    optim.customOutput = [];
end

if optim.version<7
    optim.isenabled = true;
end

if optim.version<8
    % Simplify the output data structure.  These initial settings will be
    % reconstructed properly in the post-load function
    optim.outputData = [];
    optim.outputColumns = null(xregpointer,0);
    optim.outputWeights = [];
    optim.outputWeightsColumns = null(xregpointer,0);
    if isempty(optim.customOutput)
        optim.outputSelection = cgoptcsol;
    else
        optim.outputSelection = optim.customOutput;
    end
    
    % Schedule a post load action to remove unused pointers
    h = mbcloadrecorder('current');
    h.add({@i_removeoutputpointers,optim.outputOppoints, optim.ParetoOutput, optim.summary.objectivesums, optim.name}); 
    
    % Remove old fields
    optim = rmfield(optim, 'outputOppoints');
    optim = rmfield(optim, 'ParetoOutput');
    optim = rmfield(optim, 'summary');
    optim = rmfield(optim, 'customOutput');
end

if optim.version < 9
    % Additions to simplify the script API
    optim.lastOK = [];
    optim.lastErr = '';
    optim.diagStat = [];
    optim.x0 = [];
    optim.running = struct('flag', 0, 'pref',null(xregpointer,0));  
    % Ensure sessions have correct function handles 
    fhdl = setupfromscript(cgoptim, 'gethandle');
    optim.om = createom(optim.om, cgoptimstore, fhdl);
end

optim.version = 9;

if isstruct(optim)
    optim = cgoptim(optim);
end

function i_removeoutputpointers(pPROJ, evt, pOutputs, pPareto, pObjectives, myname)
PROJ = pPROJ.info;
% First we need to find the pointer to this optimization in the project
pOptimNode = findname(PROJ, myname);
if isempty(pOptimNode) || length(pOptimNode)>1
    error('mbc:cgoptim:ProjectLoadError', 'Failed to load old optimization.');
else
    if ~isempty(pOutputs)
        pOptim = pOptimNode.getdata;
        optim = pOptim.info;
        
        % Reconstruct data fields from the pointer-ed objects
        tmp_data = pveceval(pOutputs, @get, 'data');
        tmp_ptrs = pOutputs(1).get('ptrlist');
        
        % Ignore columns that have null pointers in the dataset
        ignore_cols = isnull(tmp_ptrs);
        optim.outputData = cat(3, tmp_data{:});
        optim.outputData = optim.outputData(:, ~ignore_cols);
        optim.outputColumns = tmp_ptrs(~ignore_cols);
        
        tmp_data = pveceval(pObjectives, @get, 'weights');
        optim.outputWeights = cat(2, tmp_data{:});
        optim.outputWeightsColumns = null(xregpointer, 1, size(optim.outputWeights,2));
        oppoint =  pOutputs(1).info;
        for n=1:length(pObjectives)
            sModelName = getname(info(pObjectives(n).get('modptr')));
            optim.outputWeightsColumns(n) =  optim.outputColumns(findname(oppoint, sModelName));
        end
        pOptim.info = optim;
        
        % Free the pointers if not used elsewhere in project
        pDelete = unique([pOutputs, pPareto, pObjectives]);
        pProjectPtrs = preorder(PROJ,@getptrs);
        pDelete = pDelete(~ismember(pDelete, unique([pProjectPtrs{:}])));
        freeptr(pDelete);
    end
end
