function inspect(obj)
%INSPECT Open inspector and inspect image acquisition object properties.
%
%    INSPECT(OBJ) opens the property inspector and allows you to 
%    inspect and set properties for image acquisition object, OBJ. OBJ
%    must be a 1-by-1 image acquisition object.
%
%    Example:
%      % Inspect video input properties.
%      obj = videoinput('matrox', 1, 'RS170');
%      inspect(obj)
%
%      % Inspect video source properties.
%      src = obj.Source;
%      inspect(src(1));
%
%    See also IMAQDEVICE/SET, IMAQDEVICE/GET, IMAQDEVICE/PROPINFO,
%             IMAQHELP.
%

%    CP 9-01-01
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:05:21 $

% Error checking.
if ~isa(obj, 'imaqdevice')
   errID = 'imaq:inspect:invalidType';
   error(errID, imaqgate('privateMsgLookup', errID));
elseif length(obj)>1
   errID =  'imaq:inspect:OBJ1x1';
   error(errID, imaqgate('privateMsgLookup', errID));
elseif ~isvalid(obj)
   errID =  'imaq:inspect:invalidOBJ';
   error(errID, imaqgate('privateMsgLookup', errID));
end

% Open the inspector.
inspect(imaqgate('privateGetField', obj, 'uddobject'));