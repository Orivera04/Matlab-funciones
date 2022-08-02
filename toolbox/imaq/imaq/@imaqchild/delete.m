function delete(obj)
%DELETE Remove video input object from memory.
%
%    DELETE(OBJ) removes video input object, OBJ, from memory. When
%    OBJ is  deleted, it becomes an invalid object. An invalid object
%    should be removed from the workspace with the CLEAR command.
%
%    If multiple references to a video input object exist in the
%    workspace, then deleting one video input object invalidates the
%    remaining references. These remaining references should be cleared
%    from the workspace with the CLEAR command.
%
%    If the video input object is accessing hardware, i.e. has a 
%    Running property value of on, the video input object will be
%    stopped with the STOP function and then deleted.
%
%    If OBJ is an array of video input objects and one of the objects
%    cannot be deleted, the remaining objects in the array will be deleted
%    and a warning will be returned.
%
%    DELETE should be used at the end of an image acquisition session.
%
%    Example:
%      obj = videoinput('winvideo', 1);
%      start(obj);
%      data = getdata(obj);
%      stop(obj);
%      delete(obj);
%
%    See also IMAQDEVICE/STOP, IMAQDEVICE/ISVALID, IMAQ/PRIVATE/CLEAR,
%             IMAQHELP.
%

%    CP 2-1-02
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:04:45 $

errID = 'imaq:delete:noSources';
error(errID, imaqgate('privateMsgLookup', errID));
