function [c, msg] = setparams( c, varargin )
%SETPARAMS  Set constraint parameters
%  C=  SETPARAMS(C,PARAMLIST)  where PARAMLIST is a list of parameter-value
%  pairs.  Valid parameters for the CONTWOSTAGE object are : 
%        Local: local constriant model template
%       Global: cell array of models of the repsonse features for the local
%               constraint models


%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:59:47 $ 

msg = {};

for n = 1:2:length(varargin),
    val = varargin{n+1};
    switch lower( varargin{n} )
        case 'local',
            if isa( val, 'conbase' ),
                c.Local = val;
            else
                msg(end+1) ={ 'Invalid local constraint object' };
            end
            
        case 'global',
            if ~iscell( val ) && numel( val ) == numfeats( c.Local ),
               c.Global = val; 
            else
                msg(end+1) ={ 'Invalid set of global models' };
            end
            
        otherwise
            [c.conbase, tmp_msg] = setparams( c.conbase, varargin{n}, val );
            msg = { msg{:}, tmp_msg{:} };
    end
end
