function EF = evalfunctions(varargin);

% function EF = evalfunctions(varargin);
% 
% Class constructor for evalfunctions (inherited from graphicuserobject)
% which enables the user to execute the functions defined by methods
% setparametertypes and setfunctions.
%
% See the graphicuserobject class constructor for a description
% of the argument list varargin.
%
% Copyright (c) SINUS Messtechnik GmbH 2003
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

if nargin == 1 & isa(varargin(1), 'evalfunctions')
   EF = varargin(1);
else  
   GUO = graphicuserobject(varargin{:});
   EF = class(struct([]), 'evalfunctions', GUO);
   % The evalfunctions data is stored in the GUO frame UserData property
   % so that it is accessible via handle for the callback functions.
   UserData.ParameterTypes = {};       % See setparametertypes
   UserData.PTName = {};               %  "        "
   UserData.PTNameText = {};           %  "        "
   UserData.PTDataType = {};           %  "        "
   UserData.PTDataTypeQualifier = {};  %  "        "
   UserData.PTControls = [];           %  "        "
   UserData.Functions = {};            % See setfunctions
   UserData.FunctionNames = {};        %  "        "
   UserData.FunctionDescriptions = {}; %  "        "
   UserData.FirstInputParameter = [];  %  "        "
   UserData.PopupValue = 0;            % See popupcallback
   EF = set(EF, 'UserData', UserData);
end
