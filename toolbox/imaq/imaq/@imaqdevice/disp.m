function disp(obj)
%DISP Display method for image acquisition objects.
%
%    DISP(OBJ) dynamically displays information pertaining to image
%    acquisition object OBJ.
%
%    See also VIDEOINPUT, IMAQDEVICE/GET.

%    To expand the display, only two variables should be modified:
%      1) OBJPROPS (along with its' list of corresponding variable names)
%      2) CHILDPROPS ( See private/childdisp. )
%
%    OBJPROPS is the list of OBJ properties used for the dynamic
%    display.  Changing OBJPROPS may require re-formatting the dynamic
%    display a bit.

%    OBJ fields:
%       .version    - class version number.
%       .data       - Structure containing strings used to provide object
%                     methods with information regarding the object.  Its
%                     fields are:
%       .objtype    - object type with first characters capitalized.

%    CP 9-01-01
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.5 $  $Date: 2004/03/30 13:05:07 $

if length(obj)>1
    display(obj);
    return;
elseif ~all(isvalid(obj))
   disp([...
         'Invalid Image Acquisition object.', sprintf('\n'),...
         'This object is not associated with any hardware and',sprintf('\n'),...
         'should be removed from your workspace using CLEAR.',sprintf('\n')]);
   return
end

% File identifier...fid=1 outputs to the screen.
fid=1;

% Determine if we want a compact or loose display.
isloose = strcmp(get(0,'FormatSpacing'),'loose');
if isloose,
   newline=sprintf('\n');
else
   newline=sprintf('');
end

% =============================================================================
% OBJECT PROPERTY VARIABLES:
% =============================================================================
objprops = {...
      'Running',            'FrameGrabInterval',  'FramesAcquired',...
      'FramesAvailable',    'FramesPerTrigger',   'Logging',...
      'LoggingMode',        'SelectedSourceName', 'VideoFormat',...
      'TriggerType',        'TriggerRepeat',      'TriggersExecuted'};

nprops = length(objprops);
ObjVals = cell(1,nprops);
uddObj = imaqgate('privateGetField', obj, 'uddobject');
info = imaqgate('privateGetField', obj, 'data');
ObjVals = get(uddObj, objprops);

[     Run,     FrmGrbInt, FrmAcq,...
      FrmAvl,  FrmPerTrg, Log,...
      LogMode, SlctdSrc,  VidFrmt,...
      TrgTyp,  TrgRpt,    TrgTm ] = deal(ObjVals{:});

% =============================================================================
% DYNAMIC DISPLAY BEGINS HERE...
% =============================================================================
% Display header:
devName = imaqhwinfo(obj, 'DeviceName');
st='';
st=[st  sprintf('Summary of%s %s Object Using ''%s''.\n', '', info.objtype, devName)];
st=[st  sprintf(newline)];

% Indentation format for each subject line.
format = '%27s';

% Available sources:
%
% Format source info as: input1, input2, input3, or input6.
srcStr = '';
AvailableSrcs = set(uddObj, 'SelectedSourceName');
nSources = length(AvailableSrcs);
for nSrc=1:nSources,
    if nSources==1,
        % rgb0 is available.
        srcStr = [AvailableSrcs{nSrc} ' is available.'];
    elseif nSrc~=nSources,
        if nSources==2
            % Don't want to end up with an extra comma,
            % like: "A, and B are available."
            sepStr = ' ';
        else
            % ..., rgb3, rgb4, ...
            sepStr = ', ';
        end
        srcStr = [srcStr AvailableSrcs{nSrc} sepStr];
    else
        % ... and rgb6.
        srcStr = [srcStr 'and ', AvailableSrcs{nSrc} ' are available.'];
    end
end

% Wrap the list of available sources in case it's too long.
srcSection = '';
parseSrc = true;
tokenToParse = ' ';
lenToken = length(tokenToParse);
maxStrLen = 35;
while parseSrc,
    commaInd = strfind(srcStr, tokenToParse);
    if ~isempty(commaInd)
        extralines = find(commaInd>maxStrLen);
        if ~isempty(extralines),
            srcSection = [srcSection, srcStr(1:commaInd(extralines(1))), sprintf('\n'), sprintf(format, '')];
            srcStr = srcStr(commaInd(extralines(1))+lenToken:end);
        else
            srcSection = [srcSection srcStr];
            parseSrc = false;
        end
    else
        srcSection = [srcSection srcStr];
        parseSrc = false;
    end
end

% Display the available source section.
st=[st, sprintf(format,'Acquisition Source(s):  ')];
st=[st  srcSection];
st=[st  sprintf('\n')];
st=[st  sprintf(newline)];

% Acquisition Parameters:
st=[st sprintf(format,'Acquisition Parameters:  ')];

st=[st sprintf('''%s'' is the current selected source.\n', SlctdSrc)];
st=[st sprintf(format,' ')];

if FrmPerTrg==Inf,
   st=[st sprintf('Continuous acquisition using the selected source.\n')];
else
   st=[st sprintf('%d frames per trigger using the selected source.\n',FrmPerTrg)];
end
st=[st sprintf(format,' ')];

st=[st sprintf('''%s'' video data to be logged upon START.\n', VidFrmt)];
st=[st sprintf(format,' ')];

st=[st sprintf('Grabbing first of every %d frame(s).\n', FrmGrbInt)];
st=[st sprintf(format,' ')];

st=[st sprintf('Log data to ''%s'' on trigger.\n',LogMode)];
st=[st sprintf(newline)];

% Trigger Parameters:
st=[st sprintf(format,'Trigger Parameters:  ')];
trgstr = 'trigger';
switch TrgTyp,
case 'immediate'
   st=[st sprintf('%d ''%s'' trigger(s) on START.\n',TrgRpt+1,TrgTyp)];
case 'manual'
   trgstr = 'TRIGGER';
   st=[st sprintf('%d ''%s'' trigger(s) upon %s.\n', TrgRpt+1, TrgTyp, trgstr)];
otherwise
   st=[st sprintf('%d ''%s'' trigger(s).\n',TrgRpt+1,TrgTyp)];
end
st=[st sprintf(newline)];

% Engine status:
st=[st sprintf(format,'       Status:  ')];
ison = strcmp({Log, Run}, {'on', 'on'});
Running = ison(2);
switch sum(ison),
case 0,
   st=[st  sprintf('%s\n','Waiting for START.')];
case 1,
   if Running,
      % Determine which trigger we're waiting for.
      trigL = TrgTm;
      trigN = trigL+1;
      
      % In case we have triggered all we will want, but have not stopped yet,
      % we will not display....waiting for trigger 3 of 2.
      if trigN > TrgRpt+1,
         trigN = TrgRpt;
      end      
      st=[st  sprintf('%s %s %d of %d.\n','Waiting for', trgstr, trigN, TrgRpt+1)];
   end   
case 2,
   st=[st  sprintf('%s\n','Logging data.')];
end

st=[st sprintf(format,' ')];
st=[st sprintf('%d frames acquired since starting.\n', FrmAcq)];

st=[st sprintf(format,' ')];
st=[st sprintf('%d frames available for GETDATA.\n', FrmAvl)];

st=[st  sprintf(newline)];

fprintf(newline);
fprintf(fid,'%s',st)
