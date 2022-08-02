% The table class is a composite element which can be treated as a two-
% dimensional cell array, placed on figures and positioned or resized
% flexibly from code.  It is implemented using a "windowing" principle,
% whereby a fixed number of edit controls are used to provide access to
% a rectangular region of the underlying cell array, which is stored
% within the \MATLAB{UserData} property of the GUO frame.
%
% The separately supplied file TableDemo.m demonstrates the main
% features;  see also GUODemo.m for a demonstration of the
% graphicuserobject class from which the table class is inherited.
%
% The following methods are available for the table class:
% 
% function T = table(varargin);
% Class constructor for table (inherited from graphicuserobject).
% See the graphicuserobject class constructor for a description
% of the argument list varargin.
%
% function T = controls(T, RowMax, ColMax, varargin);
% Creates RowMax * ColMax edit controls within table object.
% The argument list varargin, if supplied, is passed on to
% uicontrol when creating the edit controls.
%
% function val = subsref(T, index);
% Defines cell reference (indexing) for table objects (see MATLAB help).
%
% function T = subsasgn(T, index, h);
% Defines cell assignment for table objects (see MATLAB help).
%
% function T = scroll(T, Row, Column, FrameTag, UserData);
% Scrolls table object T so that the desired Row & Column is in the upper
% left corner.  If Row & Column are not supplied, they default to their
% current values (initially 1) and the function simply refreshes the
% display from the stored table data.  FrameTag is used to access the
% UserData property of the GUO frame because no table object is
% available in callback functions (e.g. slidercallback); if FrameTag
% is empty or not supplied, it is obtained from the table object T.
% UserData should not normally be supplied:  it is purely an
% optimization for when the data is already available, e.g. in the
% subsasgn function.
%
% function editcallback(DummyTable, FrameTag, Row, Column);
% Callback function for edit controls within table object.
% FrameTag is used to access the UserData property of the GUO frame.
% The control's Row and Column are built into its callback string.
% DummyTable is required by MATLAB and will be deleted.
%
% function slidercallback(DummyTable, FrameTag);
% Callback function for slider controls within table object.
% FrameTag is used to access the UserData property of the GUO frame.
% DummyTable is required by MATLAB and will be deleted.
%
%
% Copyright (c) SINUS Messtechnik GmbH 2002
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production
