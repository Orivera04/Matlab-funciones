function val = getuserdata(DummyGUO, Tag);

% function val = getuserdata(DummyGUO, Tag);
% 
% Gets the UserData property from the GUO frame object identified by "Tag"
% (for use in callback functions - see also "setuserdata").  "DummyGUO" is 
% ignored - it is required by MATLAB in order to be able to find this method.
% 
% The "getuserdata" and "setuserdata" methods allow callback functions in
% particular to access data associated with a GUO.  Although this is a
% fundamental breach of the object-oriented paradigm, the only alternative
% in MATLAB would be to define all such GUOs globally in order that they may be
% assigned to;  however, this would also be a breach of the paradigm and would
% be inappropriate in particular for general-purpose, reusable GUOs.  For an
% excellent definition of the object-oriented paradigm, see "Object-oriented
% Software Construction" by Bertrand Meyer (Prentice Hall).
%
% Copyright (c) SINUS Messtechnik GmbH 2002
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

try
   FrameHandle = findobj('Type', 'axes', 'Tag', Tag);
catch
   FrameHandle = [];
end
if isempty(FrameHandle)
   error(['No GUO frame found with Tag ' Tag]);
elseif length(FrameHandle) > 1
   error([num2str(FrameHandle) ' GUO frames found with Tag ' Tag]);
end
val = get(FrameHandle, 'UserData');
