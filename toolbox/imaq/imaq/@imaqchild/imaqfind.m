function output = imaqfind(obj, varargin)
%IMAQFIND Find image acquisition objects.
%
%    IMAQFIND displays a list of all the video input objects that exist
%    in memory. If only a single video input object exists in memory, 
%    IMAQFIND displays a detailed summary of that object.
%
%    OUT = IMAQFIND returns an array OUT of all valid video input objects
%    existing in memory.
%
%    OUT = IMAQFIND('P1', V1, 'P2', V2,...) returns a cell array, OUT, of
%    image acquisition objects whose property names and property values match 
%    those passed as parameter/value pairs, P1, V1, P2, V2. The parameter/value
%    pairs can be specified as a cell array. 
%
%    OUT = IMAQFIND(S) returns a cell array, OUT, of image acquisition objects 
%    whose property values match those defined in structure S. The field names 
%    of S are image acquisition object property names and the field values 
%    are the requested property values.
%   
%    OUT = IMAQFIND(OBJ, 'P1', V1, 'P2', V2,...) restricts the search for 
%    matching parameter/value pairs to the image acquisition objects listed
%    in OBJ. OBJ can be an array of objects.
%
%    Note that it is permissible to use parameter/value string pairs, 
%    structures, and parameter/value cell array pairs in the same call 
%    to IMAQFIND.
%
%    When a property value is specified, it must use the same format as
%    GET returns. For example, if GET returns the Name property value as 
%    'MyObject', IMAQFIND will not find an object with a Name property value 
%    of 'myobject'. However, properties that have an enumerated list data
%    type will not be case sensitive when searching for property values.
%    For example, IMAQFIND will find an object with a Running property value 
%    of 'Off' or 'off'. The data type of a property can be determined by 
%    PROPINFO's Constraint field.
%
%    Example:
%      obj1 = videoinput('matrox', 1, 'Tag', 'FrameGrabber');
%      obj2 = videoinput('winvideo', 1, 'Tag', 'Webcam');
%      out1 = imaqfind('Type', 'videoinput')
%      out2 = imaqfind('Tag', 'FrameGrabber')
%      out3 = imaqfind({'Type', 'Tag'}, {'videoinput', 'Webcam'})
%
%    See also IMAQCHILD/PROPINFO, IMAQCHILD/GET, IMAQHELP.
%

%    CP 7-13-02
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:04:53 $

% Search for matching PV pairs.
try
    output = imaqgate('privateFindObj', obj, varargin);
catch
    rethrow(lasterror);
end
