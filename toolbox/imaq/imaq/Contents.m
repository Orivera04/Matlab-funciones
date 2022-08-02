% Image Acquisition Toolbox
% Version 1.5 (R14) 05-May-2004
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
% See also VIDEOINPUT, IMAQHELP.
%

% Copyright 2001-2004 The MathWorks, Inc. 
% Generated from Contents.m_template revision 1.1.4.1  $Date: 2004/04/08 20:52:13 $
