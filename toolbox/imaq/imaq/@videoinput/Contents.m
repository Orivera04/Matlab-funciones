% VIDEOINPUT Functions and Properties.
%
% VIDEOINPUT Construction.
%   videoinput         - Construct a video input object.
% 
% Configuration.
%   get                - Get value of image acquisition object property.
%   inspect            - Open property inspector and configure image acquisition 
%                        object properties.
%   set                - Set value of image acquisition object property.
% 
% Execution.
%   getselectedsource  - Return the video source object currently selected for 
%                        acquisition.
%   start              - Initiate video input object to start running.
%   stop               - Stop object running and logging. 
%   wait               - Wait for video input object to stop running.
% 
% Trigger Functions.
%   trigger            - Manually initiate logging for running object.
%   triggerconfig      - Configure video input object to a trigger configuration.
%   triggerinfo        - Return all valid trigger configurations.
%
% Data Functions.
%   flushdata          - Remove buffered image frames from memory.
%   getdata            - Return acquired image frames from buffer.
%   getsnapshot        - Immediately acquire a single image frame.
%   peekdata           - Return most recently acquired image frames.
%  
% Tools.
%   closepreview       - Close image preview windows.
%   imaqmem            - Limit or display memory used for acquiring frames.
%   imaqmontage        - Display acquired image frames as a montage.
%   preview            - Activate a live image preview window.
% 
% General.
%   delete             - Remove video input object from memory.
%   imaqcallback       - Display event information for an acquisition event.
%   imaqfind           - Find image acquisition objects with specified property
%                        values.
%   imaqreset          - Delete and unload all image acquisition objects and
%                        adaptors.
%   isvalid            - True for image acquisition objects that can be
%                        associated with hardware.
% 
% Information And Help.
%   imaqhelp           - Display image acquisition object function and property
%                        help.
%   imaqhwinfo         - Return information on available hardware.
%   propinfo           - Return image acquisition object property information.
%  
% Image Acquisition Tutorials.
%   demoimaq_AccessDevices      - Accessing an image acquisition device.
%   demoimaq_Acquisition        - Acquiring image data to memory.
%   demoimaq_Callbacks          - Using image acquisition callbacks.
%   demoimaq_DiskLog            - Logging image data to an AVI file.
%   demoimaq_Events             - Working with image acquisition events.
%   demoimaq_IdentifyDevices    - Determining available image acquisition 
%                                 hardware.
%   demoimaq_Objects            - Managing image acquisition objects.
%   demoimaq_Properties         - Working with image acquisition properties.
%   demoimaq_Triggers           - Working with image acquisition triggers.
%
% Application Demos.
%   demoimaq_AcquisitionRate    - Calculating the acquisition rate.
%   demoimaq_AlphaBlending      - Alpha blending image data as it is acquired.
%   demoimaq_AlphaBlendingIPT   - Alpha blending image data as it is acquired,
%                                 using the Image Processing Toolbox.
%   demoimaq_Averaging          - Averaging image data as it is acquired and 
%                                 saving results to disk.
%   demoimaq_IntervalLogging    - Acquiring image data at a constant interval.
%   demoimaq_Pendulum           - Calculating the gravitational constant using a 
%                                 pendulum.
%
% VIDEOINPUT Properties.
%   DeviceID                - Hardware device identifier.
%   DiskLogger              - Specify the MATLAB AVIFILE object used to log data.
%   ErrorFcn                - Callback function to execute when a runtime 
%                             error occurs.
%   EventLog                - Information relating to specific events.
%   FrameGrabInterval       - Specify the frame buffering interval. 
%   FramesAvailable         - Number of buffered frames available per 
%                             source.
%   FramesAcquired          - Total number of frames acquired per source.
%   FramesAcquiredFcn       - Callback to execute every time a predefined 
%                             number of frames is acquired.
%   FramesAcquiredFcnCount  - Number of frames to acquire before a frames 
%                             acquired event is generated.
%   FramesPerTrigger        - Number of frames to acquire for each trigger.
%   Logging                 - Indicate whether data is being logged or 
%                             not. 
%   LoggingMode             - Specify the destination for acquired image data.
%   Name                    - Descriptive name of the video input object.
%   ROIPosition             - Specify the region of interest acquisition 
%                             window.
%   Running                 - Indicates if the video input object is in an 
%                             acquisition state.
%   SelectedSourceName      - Currently selected video source to be used for acquisition.
%   Source                  - Video source objects contained by a video input 
%                             object.
%   StartFcn                - Callback function to execute just before the 
%                             video input object and hardware device 
%                             start executing.
%   StopFcn                 - Callback function to execute just after the 
%                             video input object and hardware device 
%                             stop executing.
%   Tag                     - Label for object.
%   Timeout                 - Waiting time to extract image data.
%   TimerFcn                - Callback function to execute whenever a 
%                             predefined period of time passes.
%   TimerPeriod             - Period of time between timer events.
%   TriggerCondition        - Condition on which a trigger is issued.
%   TriggerFcn              - Callback function to execute when a trigger 
%                             occurs.
%   TriggerFrameDelay       - Delay value for logging image frames.
%   TriggerRepeat           - Number of additional times to repeat a trigger.
%   TriggersExecuted        - Number of triggers executed.
%   TriggerSource           - Trigger source that initiates the acquisition.
%   TriggerType             - Type of trigger to issue. 
%   Type                    - Object type.
%   UserData                - User data for object.
%   VideoFormat             - Video input format from the hardware.
%   VideoResolution         - Vector indicating the image width and height 
%                             for the incoming video signal.
% 
% VIDEOSOURCE Properties.
%   Parent                 - Indicates the video source object parent.    
%   Selected               - Indicates if the video source object is currently selected.    
%   SourceName             - Indicates the name of a video source.    
%   Tag                    - User defined string for the video source object.    
%   Type                   - Object type.
%
%   Note: Additional device-specific video source properties may also be available.
% 
% 
% See also VIDEOINPUT, IMAQHELP, IMAQDEVICE/PROPINFO.

% CP 12-02-02
% Copyright 2001-2003 The MathWorks, Inc. 
% $Revision: 1.1.6.3 $  $Date: 2004/02/01 21:45:46 $