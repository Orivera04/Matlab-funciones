function createDetailConfigurePage(varargin)
% Display the RTW-EC configuration of a model in HTML page format.
% The page will show current settings, it also allows user to set up new
% values for RTW-EC.
% It accepts optionally varargin input to overriden parameter values.

%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $ $Date: 2002/11/27 17:40:12 $

htmlSource = fileread(HTMLattic('AtticData', 'DetailConfigureTemplatePage'));
javascript = fileread([HTMLattic('AtticData', 'cmdRoot') filesep 'Advisortranslate.js']);
detailconfigurePage = HTMLattic('AtticData', 'DetailConfigurePage');
model = get_param(bdroot(HTMLattic('AtticData', 'model')), 'Handle');

f=fopen(detailconfigurePage, 'w');

% find <select ... </select> tag pair
a=strfind(htmlSource, '<select');
b=strfind(htmlSource, '</select>');
if length(a)~=length(b)
    error('Broken HTML template file!');
end

% special handle for ProdHWWordLengths
paramValue = readparameter(model,'NewValue_ProdHWWordLengths'); % get '8,16,32,15' style string
[token, paramValue] = strtok(paramValue, ',');
ProdHWWordLengths_char = token;
[token, paramValue] = strtok(paramValue, ',');
ProdHWWordLengths_short = token;
[token, paramValue] = strtok(paramValue, ',');
ProdHWWordLengths_int = token;
[token, paramValue] = strtok(paramValue, ',');
ProdHWWordLengths_long = token;


% We expect each tag is following pattern
% <select size="1" name="NewValue_SolverMode">
%  <option>SingleTasking</option>
%  <option>MultiTasking</option>
%  <option>Auto</option>
tagList = [];
newtagList = [];
for i=1:length(a)
    tag = htmlSource(a(i):b(i)-1);
    idx=strfind(tag, 'name="');
    idx=idx+length('name="');
    idx2=strfind(tag(idx:end), '"');
    idx2=idx2+idx-2;
    paramName = tag(idx:idx2); %got NewValue_SolverMode
    paramValue = readparameter(model, paramName);
    if strcmp(paramName, 'ProdHWWordLengths_char')
        paramValue = ProdHWWordLengths_char;
    elseif strcmp(paramName, 'ProdHWWordLengths_short')
        paramValue = ProdHWWordLengths_short;
    elseif strcmp(paramName, 'ProdHWWordLengths_int')
        paramValue = ProdHWWordLengths_int;
    elseif strcmp(paramName, 'ProdHWWordLengths_long')
        paramValue = ProdHWWordLengths_long;
    end
    
    if strcmp(paramValue, 'We_Can_Not_Find_The_Value')
        newtag = strrep(tag, '<select', '<select disabled');
        %htmlSource = strrep(htmlSource, tag, ''); % remove this tag if correspond parameter doesn't exist
    else
        paramValue = l_translate(paramValue, 'encode');
        if iscell(paramValue)
            paramValue=paramValue{:};
        end
        if strcmp(paramName, 'NewValue_OptimizeBlockIOStorage') % inverse logic for Implement signals in persistent global memory
            if strcmp(paramValue, 'on')
                paramValue = 'off';
            else
                paramValue = 'on';
            end
        end
        %newtag = strrep(tag, ['<option>' paramValue '</option>'], ['<option selected>' paramValue '</option>']);
        if ~isempty(strfind(tag, ['>' paramValue '</option>']))
            % in the case <option>Microprocessor</option>, and paramValue
            % is Microprocessor, etc.
            newtag = strrep(tag, ['>' paramValue '</option>'], [' selected>' paramValue '</option>']);
        else
            % in the case <option value="ASIC/FPGA">Unconstrained integer
            % sizes</option>, and paramValue is ASIC/FPGA, etc.
            newtag = strrep(tag, ['<option value="' paramValue '">'], ['<option value="' paramValue '" selected>']);
        end
        %htmlSource = strrep(htmlSource, tag, newtag);
    end
    tagList{end+1} = tag;
    newtagList{end+1} = newtag;
end

for i=1:length(tagList)
    htmlSource = strrep(htmlSource, tagList{i}, newtagList{i});
end

% display target.tlc and target_rtw_info_hook.m info
model = get_param(bdroot(HTMLattic('AtticData', 'model')), 'Handle');
systemTargetFile = get_param(model, 'RTWSystemTargetFile');
htmlSource = strrep(htmlSource, '<!--system_target_file.tlc-->', systemTargetFile);
rtwInfoHookFile = [strtok(systemTargetFile, '.') '_rtw_info_hook'];
wordlengths = rtwwordlengths(model);
cImplementation = rtw_implementation_props(model);
if exist(rtwInfoHookFile)
    htmlSource = strrep(htmlSource, '<!--rtwInfoHookFile-->', rtwInfoHookFile);
else
    htmlSource = strrep(htmlSource, '<font color="#808080">READ_ONLY from hook file <!--rtwInfoHookFile-->', ['<font color="#FF0000">WARNING, ' rtwInfoHookFile '.m file does not exist.  Defaulting to these values:']);
end

htmlSource = strrep(htmlSource, '<!--char_word_length-->', num2str(double(wordlengths.CharNumBits)));
htmlSource = strrep(htmlSource, '<!--short_word_length-->', num2str(double(wordlengths.ShortNumBits)));    
htmlSource = strrep(htmlSource, '<!--int_word_length-->', num2str(double(wordlengths.IntNumBits)));
htmlSource = strrep(htmlSource, '<!--long_word_length-->', num2str(double(wordlengths.LongNumBits)));
htmlSource = strrep(htmlSource, '<!--ShiftRightIntArith-->', num2booleanString(cImplementation.ShiftRightIntArith));
htmlSource = strrep(htmlSource, '<!--Float2IntSaturates-->', num2booleanString(cImplementation.Float2IntSaturates));
htmlSource = strrep(htmlSource, '<!--IntPlusIntSaturates-->', num2booleanString(cImplementation.IntPlusIntSaturates));
htmlSource = strrep(htmlSource, '<!--IntTimesIntSaturates-->', num2booleanString(cImplementation.IntTimesIntSaturates));

% handle input box type HTML items
%paramValue = readparameter(model,'NewValue_ProdHWWordLengths'); % get '8,16,32,15' style string
%[token, paramValue] = strtok(paramValue, ',');
%htmlSource = strrep(htmlSource, '<!--ProdHWWordLengths_char-->', token);
%[token, paramValue] = strtok(paramValue, ',');
%htmlSource = strrep(htmlSource, '<!--ProdHWWordLengths_short-->', token);
%[token, paramValue] = strtok(paramValue, ',');
%htmlSource = strrep(htmlSource, '<!--ProdHWWordLengths_int-->', token);
%[token, paramValue] = strtok(paramValue, ',');
%htmlSource = strrep(htmlSource, '<!--ProdHWWordLengths_long-->', token);

paramValue = readparameter(model, 'NewValue_rtwoption_MaxRTWIdLen');
paramValue = num2str(paramValue);
if strcmpi(paramValue, 'We_Can_Not_Find_The_Value')
    htmlSource = strrep(htmlSource, ...
        '<input type="text" name="NewValue_rtwoption_MaxRTWIdLen" size="20" value="<!--rtwoption_MaxRTWIdLen-->">', ...
        '<input type="text" name="NewValue_rtwoption_MaxRTWIdLen" size="20" disabled >' );
else
    htmlSource = strrep(htmlSource, '<!--rtwoption_MaxRTWIdLen-->', paramValue);
end
paramValue = readparameter(model, 'NewValue_rtwoption_RollThreshold');
paramValue = num2str(paramValue);
if strcmpi(paramValue, 'We_Can_Not_Find_The_Value')
    htmlSource = strrep(htmlSource, ...
        '<input type="text" name="NewValue_rtwoption_RollThreshold" size="20" value="<!--rtwoption_RollThreshold-->">', ...
        '<input type="text" name="NewValue_rtwoption_RollThreshold" size="20" disabled >' );
else
    htmlSource = strrep(htmlSource, '<!--rtwoption_RollThreshold-->', paramValue);
end

htmlSource = strrep(htmlSource, '<!--Insert Javascript template-->', javascript);
htmlSource = strrep(htmlSource, '<!--start system template-->', HTMLattic('AtticData', 'StartInSystemTemplate'));
fprintf(f, '%s', htmlSource);
fclose(f);

% end main function

% this function will translate between HTML page display and internal
% representive. i.e., "Yes"<->1 "No <->0
function output = l_translate(input, choice)
Table = ...
    { 'Yes' '1';...
      'No' '0';...
  };
input = num2str(input);
output = input;
switch choice
    case 'encode'
        for i=1:length(Table)
            if strcmpi(Table(i,2), input)
                output = Table(i,1);
                return
            end
        end
    case 'decode'
        for i=1:length(Table)
            if strcmpi(Table(i,1), input)
                output = Table(i,2);
                output = str2num(output{:});
                return
            end
        end
    otherwise
end
