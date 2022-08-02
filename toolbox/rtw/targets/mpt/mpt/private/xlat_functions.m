function rcff = xlat_functions(cff,cFile,modelName)
%XLAT_FUNCTIONS Translates and registers SF functions. 
%
%  RCFF = XLAT_FUNCTION(CFF, CFILE, MODELNAME) 
%        It is used to register SF functions and replace SF function calls with
%        the production function calls.
%
%  INPUTS:  
%        cff:                 C string to tranalate and register
%        cFile:              name of C file
%        modelName:   name of model
%
%  OUTPUT:
%        rcff:  resulting string 

%  Steve Toeppe
%  Copyright 2001-2003 The MathWorks, Inc.
%  $Revision: 1.15.4.2 $
%  $Date: 2004/04/15 00:29:00 $

%Detect empty case and do no processing.
if isempty(cff) == 1
    rcff = cff;
    return
end

%
%Symbol duplication of names have been resolved.
%Get definitions of special functions to be resolved.
%

fdb = get_function_resolution_db;
nameRules = get_name_rules(modelName);
cnt = 100; 
ncff=[];
%
%for all register functions
% replace the SF function call with the production function call
% 
for i=1:length(fdb)
    last=1;

    % Get list of function matches with associated parameters and indexes.

    [status, parameters, stInd, endInd] = find_function_pattern(cff,fdb{i}.sfFunctionName,fdb{i}.sfFunctionParam);
    if status == 0
        if isempty(fdb{i}.symbolRegistrationFunction) == 0
            %Handle special registration of symbolds associated with function.
            sstr = [fdb{i}.symbolRegistrationFunction,'(fdb{i},parameters,cFile,modelName)'];
            eval(sstr);
        end
        if isempty(fdb{i}.includeDependency) == 0
            for j=1:length(fdb{i}.includeDependency)
                object=[];
                object.name = fdb{i}.includeDependency{j};
                object.fileInclude = fdb{i}.includeDependency{j};
                status = register_object_with_sym(cFile,'IncludeFiles',object);
            end
        end
        if isempty(fdb{i}.regSymbol) == 0
            for j=1:length(fdb{i}.regSymbol)
                object=[];
                object.name = fdb{i}.regSymbol{j};
                status = register_object_with_sym(cFile,fdb{i}.symbol,object);
            end
        end
        for j=1:length(stInd)
            if strcmp(fdb{i}.sfFunctionName,'sf_matlab') == 1
                fstr = ml_handler(fdb{i}, parameters{j});                    
          %
          % The cFunReNameScript was added to address the case where one of 
          % the arguments causes the function name to change in the generated code. 
          % This is to support the many to one fucntion mapping based on input 
          % argument list.  PWM 11-28-2001
          %
            elseif isempty(fdb{i}.cFunReNameScript)==0
                argVariables ='';
                for ivar=1:length(parameters{j})-1
                    argVariables = [argVariables,' ''',strrep(parameters{j}{ivar},'''',''),''','];
                end    
                
                argVariables = [argVariables,' ''',strrep(parameters{j}{end},'''',''),''''];
              
                if fdb{i}.sfFunctionParam > 0
                  fstr = [eval([fdb{i}.cFunReNameScript,'(',argVariables,')']),'(',parameter_resolve(fdb{i},parameters{j},nameRules),')'];                
                else
                  fstr = [eval([fdb{i}.cFunReNameScript,'(',argVariables,')'])];                  
                end 
           
            else
                fstr = [fdb{i}.cFunctionName,'(',parameter_resolve(fdb{i},parameters{j},nameRules),')'];
            end
            ncff=[ncff,cff(last:stInd{j}-1),fstr];
            last = endInd{j};
        end
        ncff=[ncff,cff(last:end)];
        
        cff=ncff;
    end
    ncff=[];
end
rcff=cff;

%--------------------------------------------------------------------------------

function str = ml_handler(fdb, parameters)

%
% One possible solution to the matlab function issue.
%
str = [];
if ~isempty(fdb.mFunXtlScript)==1
    argVariables ='';
    for ivar=1:length(parameters)-1,
        argVariables = [argVariables,' ''',parameters{ivar},''','];
    end    
    argVariables = [argVariables,' ''',parameters{end},''''];
    [str,parmameters] = eval([fdb.mFunXtlScript,'(',argVariables,')']);
else
    index = findstr(parameters{1},'(');
    fname = parameters{1}(1:index-1);
    fname = strrep(fname,'"','');
    str = [fname,'('];
    for i=2:length(parameters)-1,
        str = [str,parameters{i},','];
    end
    str = [str,parameters{end},')'];
end

%--------------------------------------------------------------------------------

function str = parameter_resolve(fdb,parameters,nameRules)

wstr = fdb.cFunctionParamMapping;

if strcmp(fdb.paramCase,'lower') == 1
    parameters = lower(parameters);
end
if isempty(fdb.cFunXtlScript) == 1
    for i=1:fdb.sfFunctionParam
        wstr = strrep(wstr,['%P',num2str(i),'%'],parameters{i});
    end
else
    wstr = eval([fdb.cFunXtlScript,'(','''',fdb.sfFunctionName,'''',', parameters, nameRules',')']);
end
str = wstr;
