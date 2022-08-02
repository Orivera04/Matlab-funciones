function OM= AddOption(OM,Param,Value,varargin)
% xregoptmgr/ADDOPTION add a settable option to optimisation manager
%
% OM= AddOption(OM,Param,Value,InputType,DisplayName,GUISetable)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.3 $  $Date: 2004/02/09 07:56:37 $

Defaults= {'evalstr','',1};
if nargin<3
	error('Not enough inputs')
elseif nargin<4
	varargin= Defaults;
end

if ~isvarname( Param )
    error('mbc:xregoptmgr:InvalidParameterName', 'Invalid parameter name "%s".\nParameters must be valid MATLAB variable names.', Param);
end

n= length(varargin);
if n<length(Defaults)
	varargin(n+1:length(Defaults))= Defaults(n+1:end);
end
[CheckInput,Name,GUISet]= deal(varargin{:});
if isempty(GUISet)
	GUISet= 1;
end

if isa(CheckInput,'char') & strcmp(lower(CheckInput),'evalstr') & ~isa(Value,'cell')
	% set catch string to Value
	Value= {Value,Value};
end
Param= {Param};
Value= {Value};
if isa(Value,'xregoptmgr')
	Value.IsMaster= 0;
end


Name= {Name};
GUISet= {GUISet};
CheckInput= {CheckInput};
if isempty(OM.foptions)
	OM.foptions= struct('Param',Param,...
		'Value',Value,...
		'Name',Name,...
		'GuiSetable',GUISet,...
		'CheckInput',CheckInput);
else
	if ~strcmp(lower(Param{1}),lower({OM.foptions.Param}))
		OM.foptions(end+1)= struct('Param',Param,...
			'Value',Value,...
			'Name',Name,...
			'GuiSetable',GUISet,...
			'CheckInput',CheckInput);
	else
		error('mbc:xregoptmgr:RepeatedParameterName', 'Parameter %s is already an option', Param{1} )
	end
end	
