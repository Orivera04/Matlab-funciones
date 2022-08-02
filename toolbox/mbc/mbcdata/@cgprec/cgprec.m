function PREC = cgprec(varargin)
%CGPREC

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:54:38 $

%CGPREC/CGPREC   Constructor for the cgprec class.
%
%   PREC = cgprec(Name) constructs a cgprec object PREC with name Name.
%
%   PREC = cgprec constructs a cgprec object PREC with a default name.
%
%   See also  CGPRECFIX, FLOATPRECISON

% ---------------------------------------------------------------------------
% Description : Constructor for the cgprec class.
% Opt inputs  : Name - name (char)
% Outputs     : PREC - cgprec object
% ---------------------------------------------------------------------------

% Define object structure
PRECStruct = struct('Name',[],...
    'Writable',[]);

switch nargin,
case 0,
    % No input arguments, so create a cgprec object with default settings
    PRECStruct.Name     = 'Default';
    PRECStruct.Writable = 1;
otherwise,
    if ischar(varargin{1})
        % Use varargin as the cgprec object name
        PRECStruct.Name = varargin{1};
    else
        % Use the default cgprec object name
        PRECStruct.Name = 'Default';
    end %if
    PRECStruct.Writable = 1;
end % switch

% Create object class
PREC = class(PRECStruct,'cgprec');