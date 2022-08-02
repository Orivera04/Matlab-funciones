function msg = privateMsgLookup(ID)
%PRIVATEMSGLOOKUP Return a message for image acquisition objects.
%
%    PRIVATEMSGLOOKUP(MSGID) returns the message string cooresponding to
%    the message ID, MSGID.
%

%    CP 1-20-2002
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:06:15 $

switch ID,
    case 'imaq:imaqmem:exceededLIMIT'
        msg = 'Frame memory in use already exceeds LIMIT.';
        
    case 'imaq:imaqmem:nonScalarLIMIT'
        msg = 'LIMIT must be a numeric scalar value.';
        
    case 'imaq:imaqmem:nonPositiveLIMIT'
        msg = 'LIMIT must be a positive number.';
        
    case 'imaq:imaqmem:nonScalarFIELD'
        msg = 'FIELD must be a 1-by-N string value.';
        
    case 'imaq:imaqmem:invalidFIELD'
        msg = 'Invalid or ambiguous FIELD specified.';
        
    case 'imaq:imaqmem:invalidInputType'
        msg = 'Invalid input type. Input must be a number or a string.';
        
    case 'imaq:saveobj:invalid'
        msg = 'An invalid object is being saved.';
        
    case 'imaq:loadobj:noInputRestore'
        msg = 'Unable to restore some video input property values.';
        
    case 'imaq:loadobj:noSourceRestore'
        msg = 'Unable to restore some video source property values.';
        
    case 'imaq:loadobj:wrongDevice'
        msg = ['Loading a video input object with a different number of video sources.\n', ...
            'Can not restore video source property values.'];
        
    case 'imaq:saveobj:recursive'
        msg = ['A recursive link between objects has been found during SAVE. \n', ...
            'All objects have been saved, but the link has been removed.'];
        
    case 'imaq:videosource:invalidSyntax'
        msg = ['Video source objects can only be created by the VIDEOINPUT function.',...
            sprintf('\n'), 'For help type ''imaqhelp videoinput''.'];
        
    case 'imaq:imaqchild:invalidSyntax'
        msg = ['IMAQCHILD is intended to be used by the VIDEOINPUT function.',...
            sprintf('\n'), 'For help type ''imaqhelp videoinput''.'];
        
    case 'imaq:imaqdevice:invalidSyntax'
        msg = ['IMAQDEVICE is intended to be used by the VIDEOINPUT function.',...
            sprintf('\n'), 'For help type ''imaqhelp videoinput''.'];
        
    case 'imaq:imaqdevice:invalidSyntax'
        msg = 'An imaqdevice object is created with the VIDEOINPUT function.';
        
    case 'imaq:imaqgate:invalidSyntax'
        msg = ['IMAQGATE is a gateway routine to the Image Acquistion',...
            ' Toolbox \nprivate functions and should not be directly called by users.'];
        
    case {'imaq:vertcat:parentMixedTypes', 'imaq:horzcat:parentMixedTypes', 'imaq:subsasgn:parentMixedTypes'}
        msg = ['Video input objects can only be concatenated ',...
            'with other video input objects.'];
        
    case {'imaq:vertcat:childMixedTypes', 'imaq:horzcat:childMixedTypes', 'imaq:subsasgn:childMixedTypes'}
        msg = ['Video source objects can only be concatenated ',...
            'with other video source objects.'];
        
    case {'imaq:fieldnames:mixedArray'}
        msg = 'Image acquisition object array OBJ cannot mix different object types.';
        
    case {'imaq:subsref:badsubscript'}
        msg = 'Subscript indices must either be real positive integers or logicals.';
        
    case 'imaq:subsref:invalidIndex',
        msg = 'Unable to find subsindex function for class ';
        
    case {'imaq:vertcat:noMatrix', 'imaq:horzcat:noMatrix', 'imaq:subsref:noMatrix'},
        msg = 'Only a row or column vector of image acquisition objects can be created.';
        
    case {'imaq:horzcat:differentParent', 'imaq:vertcat:differentParent'},
        msg = 'Only valid video source objects with the same parent can be concatenated.';
        
    case {'imaq:privateGetField:invalidField' 'imaq:isetfield:invalidField'},
        msg = 'Invalid field: ';
        
    case {'imaq:size:invalidType', 'imaq:propinfo:invalidType', ...
            'imaq:imaqfind:invalidType', 'imaq:inspect:invalidType', ...
            'imaq:fieldnames:invalidType'},
        msg = 'OBJ must be an image acquisition object.';
        
    case {'imaq:getsnapshot:invalidType', 'imaq:start:invalidType', ...
            'imaq:stop:invalidType', 'imaq:imaqhwinfo:invalidType', ...
            'imaq:closepreview:invalidType', 'imaq:preview:invalidType', ...
            'imaq:getselectedsource:invalidType', 'imaq:triggerinfo:invalidType', ...
            'imaq:triggerconfig:invalidType', 'imaq:wait:invalidType', ...
            'imaq:obj2mfile:invalidType', 'imaq:peekdata:invalidType', ...
            'imaq:getdata:invalidType', 'imaq:flushdata:invalidType'},
        msg = 'OBJ must be a video input object.';
        
    case {'imaq:propinfo:OBJ1x1', 'imaq:imaqhelp:OBJ1x1', ...
            'imaq:inspect:OBJ1x1'},
        msg = 'OBJ must be a 1-by-1 image acquisition object.';
        
    case {'imaq:getsnapshot:OBJ1x1', 'imaq:getselectedsource:OBJ1x1', ...
            'imaq:triggerinfo:OBJ1x1', 'imaq:triggerconfig:OBJ1x1',...
            'imaq:peekdata:OBJ1x1', 'imaq:getdata:OBJ1x1',...
            'imaq:flushdata:OBJ1x1'},
        msg = 'OBJ must be a 1-by-1 video input object.';
        
    case {'imaq:subsref:invalidParens', 'imaq:subsasgn:invalidParens'},
        msg = 'Inconsistently placed ''()'' in subscript expression.';
        
    case {'imaq:subsref:cellRef', 'imaq:subsasgn:cellRef'},
        msg = 'Cell contents reference from a non-cell array object.';
        
    case {'imaq:subsref:invalidDot', 'imaq:subsasgn:invalidDot'},
        msg = 'Inconsistently placed ''.'' in subscript expression.';
        
    case {'imaq:subsref:unknownType', 'imaq:subsasgn:unknownType'},
        msg = 'Unknown type: ';
        
    case 'imaq:subsasgn:elementMismatch',
        msg = 'In an assignment A(I)=B, the number of elements in B and I must be the same.';
        
    case 'imaq:subsasgn:negativeIndex',
        msg = ['Index into matrix is negative or zero.  See release notes on changes to ',...
            sprintf('\n'), 'logical indices.'];
        
    case 'imaq:subsasgn:noGaps',
        msg = 'Gaps are not allowed in image acqusition array indexing.';
        
    case 'imaq:subsasgn:useClear',
        msg = 'Use CLEAR to remove the object from the workspace.';
        
    case 'imaq:subsasgn:dimensionExceeded',
        msg = 'Index exceeds matrix dimensions.';
        
    case 'imaq:delete:notAll',
        msg = 'An object in OBJ could not be deleted.';
        
    case {'imaq:get:invalidOBJ', 'imaq:set:invalidOBJ', ...
            'imaq:getsnapshot:invalidOBJ', 'imaq:start:invalidOBJ', ...
            'imaq:stop:invalidOBJ', 'imaq:propinfo:invalidOBJ', ...
            'imaq:closepreview:invalidOBJ', 'imaq:preview:invalidOBJ', ...
            'imaq:imaqhwinfo:invalidOBJ', 'imaq:inspect:invalidOBJ', ...
            'imaq:fieldnames:invalidOBJ', 'imaq:getselectedsource:invalidOBJ', ...
            'imaq:triggerinfo:invalidOBJ', 'imaq:triggerconfig:invalidOBJ', ...
            'imaq:peekdata:invalidOBJ', 'imaq:getdata:invalidOBJ', ...
            'imaq:obj2mfile:invalidOBJ', 'imaq:imaqhelp:invalidOBJ'};
        msg = 'Image acquisition object OBJ is an invalid object.';
        
    case 'imaq:delete:noSources',
        msg = ['Video source objects can not be deleted.',...
            sprintf('\n'), 'Only a video source object''s Parent may be deleted.'];
        
    case {'imaq:get:tooManyInputs', 'imaq:imaqhelp:tooManyInputs', ...
            'imaq:triggerconfig:tooManyInputs', 'imaq:getdata:tooManyInputs'},
        msg = 'Too many input arguments.';
        
    case {'imaq:imaqhelp:tooManyOutputs'},
        msg = 'Too many output arguments.';
        
    case {'imaq:get:vectorOBJ'},
        msg = 'Vector of handles not permitted for get(OBJ) with no left hand side.';
        
    case {'imaq:set:vectorOBJ'},
        msg = 'Vector of handles not permitted for set(OBJ).';
        
    case 'imaq:stop:noStop',
        msg = 'An object in OBJ could not be stopped or is invalid.';
        
    case 'imaq:getdata:invalidNInput',
        msg = 'N must be specified as a numeric value.';
        
    case 'imaq:getdata:invalidTypeInput',
        msg = 'TYPE must be specified as a string.';
        
    case 'imaq:getdata:invalidFormatInput',
        msg = 'FORMAT must be specified as a string.';
        
    case 'imaq:triggerconfig:objRunning',
        msg = 'Trigger configurations are read only while Running is on.';
        
    case 'imaq:start:noStart',
        msg = 'An object in OBJ could not be started, was already started, or is invalid.';
        
    case 'imaq:imaqhwinfo:invalidFieldName',
        msg = 'Fieldname must be a string or a cell array of strings.';
        
    case 'imaq:imaqhwinfo:invalidField',
        msg = 'Invalid FIELD specified: ';
        
    case 'imaq:imaqhwinfo:invalidAdaptor',
        msg = 'Invalid ADAPTOR specified. Type ''imaqhwinfo'' for a list of installed ADAPTORs.';
        
    case 'imaq:imaqhwinfo:fieldType',
        msg = 'Second input must be specified as a numeric vector, a string, or 1xN cell array of strings.';
        
    case 'imaq:imaqhwinfo:matrixField',
        msg = 'Second input must be specified as a 1xN cell array of strings, or numerical vector.';
        
    case 'imaq:imaqhwinfo:noDeviceID',
        msg = 'There is no device with the specified DEVICEID.';
        
    case 'imaq:imaqhelp:firstStrObj',
        msg = 'The first input must be a string or an image acquisition object.';
        
    case 'imaq:imaqhelp:firstObj',
        msg = 'The first input must be an image acquisition object.';
        
    case 'imaq:imaqhelp:invalidSecondArg',
        msg = 'The second input argument must be a string.';
        
    case 'imaq:imaqhelp:invalidFcnProp',
        msg = 'Invalid image acquisition function or property: ';
        
    case 'imaq:imaqhelp:invalidFcn',
        msg = 'Invalid image acquisition function: ';
        
    case 'imaq:privateAdaptorSearch:invalidOS',
        msg = 'The Image Acquisition Toolbox is not supported on this platform.';
        
    case 'imaq:privateAdaptorSearch:noAdaptor',
        msg = 'The specified ADAPTOR could not be found. See IMAQHWINFO.';
        
    case 'imaq:videoinput:adaptorID',
        msg = 'ADAPTORNAME and DEVICEID must be specified.';
        
    case 'imaq:videoinput:strAdaptor',
        msg = 'ADAPTORNAME must be specified as a string.';
        
    case 'imaq:videoinput:emptyAdaptor',
        msg = 'ADAPTORNAME must be specified as a non-empty string.';
        
    case 'imaq:videoinput:emptyID',
        msg = 'The DEVICEID must be a non-empty double.';
        
    case 'imaq:videoinput:negativeID',
        msg = 'The DEVICEID must be greater than or equal to 0.';
        
    case 'imaq:videoinput:notAnID',
        msg = 'The DEVICEID is not a valid identifier. See IMAQHWINFO(ADAPTORNAME).';
        
    case 'imaq:videoinput:invalidID',
        msg = 'No device is available at the specified DEVICEID. See IMAQHWINFO(ADAPTORNAME).';
        
    case 'imaq:videoinput:strFormat',
        msg = 'FORMAT must be a specified as a string.';
        
    case 'imaq:videoinput:noDevices',
        msg = 'There are no devices installed for the specified ADAPTORNAME. See IMAQHWINFO.';
        
    case 'imaq:videoinput:noFile',
        msg = 'Device files are not supported by this device. See IMAQHWINFO.';
        
    case 'imaq:videoinput:noFormat',
        msg = 'The FORMAT specified is not supported by this device. See IMAQHWINFO(ADAPTORNAME).';
        
    case 'imaq:eq:dimagree',
        msg = 'Matrix dimensions must agree.';
        
    case {'imaq:isequal:minrhs', 'imaq:obj2mfile:minrhs' },
        msg = 'Not enough input arguments.';
        
    case 'imaq:imaqcallback:invalidSyntax',
        msg = 'Type ''imaqhelp imaqcallback'' for an example using IMAQCALLBACK.';
        
    case 'imaq:imaqcallback:zeroInputs',
        msg = ['This function may not be called with 0 inputs.\n',...
            'Type ''imaqhelp imaqcallback'' for an example using IMAQCALLBACK.'];
        
    case 'imaq:triggerinfo:stringType',
        msg = 'TYPE must be specified as a string.';
        
    case 'imaq:triggerconfig:invalidParamType',
        msg = 'Second parameter must be a string or 1x1 structure.';
        
    case 'imaq:triggerconfig:invalidStruct',
        msg = ['S does not have the correct structure fields for configuring triggers.\n',...
            'Type ''imaqhelp triggerconfig'' for help.'];
        
    case 'imaq:triggerconfig:invalidString',
        msg = 'TYPE, CONDITION, and SOURCE must be specified as strings.';
        
    case 'imaq:triggerconfig:notUnique',
        msg = 'The trigger configuration specified is not unique.';
        
    case 'imaq:triggerconfig:notValid',
        msg = 'The trigger configuration specified is not valid.';
        
    case 'imaq:wait:invalidWAITTIME',
        msg = 'WAITTIME must be a numeric scalar value.';
        
    case 'imaq:wait:invalidSTATE',
        msg = 'Invalid STATE specified. Valid STATE values are ''running'' and ''logging''.';
        
    case 'imaq:wait:nonStringSTATE',
        msg = 'STATE must be specified as a non-empty string.';
        
    case 'imaq:imaqmontage:noFrames',
        msg = 'FRAMES must be specified.';
        
    case 'imaq:imaqmontage:inputInvalid',
        msg = 'FRAMES must be a numeric matrix, or an Fx1 cell array of numeric matrices.';
        
    case 'imaq:imaqmontage:sizeMismatch',
        msg = 'All matrices in FRAMES must be of the same size.';
        
    case 'imaq:imaqmontage:inputInvalid',
        msg = 'FRAMES must be a numeric matrix, or an Fx1 cell array of numeric matrices.';
        
    case 'imaq:imaqmontage:invalidClim',
        msg = 'CLIM must be specified as a 1x2 numeric vector.';
        
    case 'imaq:obj2mfile:invalidSetting',
        msg = 'Third input must be a valid SYNTAX, MODE, or REUSE value.';
        
    case 'imaq:obj2mfile:invalidSYNTAX',
        msg = 'Invalid SYNTAX setting. Valid SYNTAX values are ''set'' and ''get''.';
        
    case 'imaq:obj2mfile:invalidMODE',
        msg = 'Invalid MODE setting. Valid MODE values are ''modified'' and ''all''.';
        
    case 'imaq:obj2mfile:invalidREUSE',
        msg = 'Invalid REUSE setting. Valid REUSE values are ''reuse'' and ''create''.';
        
    case 'imaq:obj2mfile:nonStringFILENAME',
        msg = 'FILENAME must be specified as a string.';
        
    case 'imaq:obj2mfile:nonStringSetting',
        msg = 'All input settings must be specified as strings.';
        
    case 'imaq:obj2mfile:tooManySettings',
        msg = 'Too many settings specified.';
        
    case 'imaq:peekdata:invalidFrames',
        msg = 'FRAMES must be specified as a numeric scalar.';
        
    case 'imaq:flushdata:invalidMode',
        msg = 'MODE must either be ''all'' or ''triggers''.';
        
    case 'imaq:wait:nonPositiveWAITTIME',
        msg = 'WAITTIME must be a positive number.';
        
    case {'imaq:wait:invalidOBJ', 'imaq:isrunning:invalidOBJ', ...
            'imaq:islogging:invalidOBJ', 'imaq:imaqfind:invalidOBJ', ...
            'imaq:flushdata:invalidOBJ'};
        msg = 'OBJ contains an invalid video input object at index';
    case 'imaq:get:sameprops'
        msg = 'All objects in OBJ must have the same properties.';
    case 'imaq:imaqregister:invalidaction'
        msg = 'Invalid ACTION specified.  ACTION must be either ''register'' or ''unregister.';
    case 'imaq:imaqregister:filenotfound'
        msg = 'The file ''%s'' could not be found.';
    case 'imaq:imaqregister:alreadyregistered'
        msg = 'The name ''%s'' conflicts with a toolbox or third party adaptor.';
    case 'imaq:imaqregister:unregisterfailed'
        msg = 'The ADAPTORPATH specified was not found.  There is nothing to unregister.';
    case 'imaq:imaqregister:invalidadaptorpath'
        msg = 'Invalid ADAPTORPATH specified.  ADAPTORPATH must be a 1-by-N character array.';
    case 'imaq:imaqregister:nonfullpath'
        msg = 'ADAPTORPATH should specify the full absolute path to the adaptor library.';
    otherwise
        msg = ['Error: ' ID];
end
