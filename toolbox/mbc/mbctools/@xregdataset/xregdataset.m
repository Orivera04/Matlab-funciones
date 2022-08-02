function T=dataset32(testnum,type,sizes);
% XREGDATASET constructor

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:19:12 $

% All dataset fields are now cell arrays, allowing multi-level information
% to be stored in the dataset. In addition sizes has been changed to type
% uint32 to allow rapid acces from mex functions GetSweepPos and GetRecPos

T.version = 2;
if nargin==0
	sizes= [];
	type= [];
	testnum=[];
end

if iscell(sizes)
	% Do something here to deal with sizes of multi-level inputs
elseif isnumeric(sizes)
	% This code deals with version 1 input types
	if numel(type) == numel(testnum) & numel(type) == numel(sizes)
		T.testnum = {getUniqueTestnum(testnum(:)')};
		T.type = {type(:)'};
		T.sizes =  {uint32(sizes(:)')};
		T = class(T,'xregdataset');
	else
		error('Incompatable sizes for logno and stype')
	end
else
	error('Invalid input type')
end

