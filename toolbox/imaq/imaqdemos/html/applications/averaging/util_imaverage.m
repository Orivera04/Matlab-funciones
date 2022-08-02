function util_imaverage(obj, event, nFrames)
%UTIL_IMAVERAGE Average acquired image frames and save result to disk.
%
%    UTIL_IMAVERAGE(OBJ, EVENT, NFRAMES) accesses the video input 
%    object OBJ and uses it to remove NFRAMES of acquired images. 
%    These images are then averaged using the Image Processing Toolbox.
%    The results are saved to disk using the AVI file object stored in
%    OBJ.
%

%    CP 1-27-03
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:06:22 $

% Display information on the current event.
eventTime = datestr(event.Data.AbsTime, 13);
statusStr = [event.Type, ' event occurred at ' eventTime, '.'];
fprintf('%s\n', statusStr);

% Access acquired data.
data = getdata(obj, nFrames);

% Access the video input object's userdata, and
% determine if this is the first average or not.
firstFrame = 1;
userdata = obj.UserData;
if isempty(userdata.average),
    average = data(:, :, :, 1);
    firstFrame = 2;
else
    average = userdata.average{end};
end

% Average acquired data.
for f = firstFrame:nFrames,
    imageSum = imadd(average, data(:, :, :, f));
    average = imdivide(imageSum, 2);
end

% Log averaging results to disk.
aviobj = userdata.avi;
aviobj = addframe(aviobj, average);

% If there are no more frames to process, the 
% AVI file can be closed.
framesLeft = get(obj, 'FramesAvailable');
acqActive = strcmp(obj.Running, 'on');
aviOpen = strcmp(aviobj.CurrentState, 'Open');

if (framesLeft==0) && ~acqActive && aviOpen,
    aviobj = close(aviobj);
end

% Store the current state for the next iteration.
userdata.average{end+1} = average;
userdata.avi = aviobj;
obj.UserData = userdata;
