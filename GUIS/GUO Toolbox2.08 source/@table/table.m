function T = table(varargin);

% function T = table(varargin);
% 
% Class constructor for table (inherited from graphicuserobject).
% See the graphicuserobject class constructor for a description
% of the argument list varargin.
%
% Copyright (c) SINUS Messtechnik GmbH 2002
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

if nargin == 1 & isa(varargin(1), 'table')
   T = varargin(1);
else  
   GUO = graphicuserobject(varargin{:});
   T = class(struct([]), 'table', GUO);
   % The table data is stored in the GUO frame UserData property
   % so that it is accessible via handle for the callback functions.
   UserData.RowMax = 0;
   UserData.ColMax = 0;
   UserData.CurrentRow = 1;
   UserData.CurrentColumn = 1;
   UserData.Data = cell(0);
   T = set(T, 'UserData', UserData);
end
