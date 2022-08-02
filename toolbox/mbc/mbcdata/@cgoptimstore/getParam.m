function property_value = getParam(obj, propertyname)
%GETPARAM Get optimization parameter.
%   V = GETPARAM(OPTIMSTORE, 'Parameter_name') returns the value of the
%   specified parameter in the optimization.  These optimization parameters
%   must be set up in the 'Options' section of the user defined script.
% 
%   See also CGOPTIMOPTIONS/ADDPARAMETER, MBCOSWORKEDEXAMPLE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.6.2 $    $Date: 2004/02/09 06:54:26 $

try
    property_value = get( get(obj.cgoptim, 'om'), propertyname);
catch    
    % if the property requested has spaces, and the right error has been thrown
    % construct a more helpful error message.
    if ~isvarname( propertyname ) && strcmp( getfield( lasterror, 'identifier' ), 'mbc:xregoptmgr:InvalidProperty' )
        validpropertyname = validmlname( propertyname );
        % does this new propertyname exist?
        omcell = cellopts( get(obj.cgoptim, 'om') );
        if any( strcmp( omcell(1,:), validpropertyname ) )
            % it looks like they used to have a parameter with spaces in
            error('mbc:cgoptimstore:InvalidParameterName',...
                ['Parameter "%s" has been renamed "%s".\n',...
                'This is because parameter names must now be valid MATLAB variable names.\n',...
                'You should update your optimisation scripts to reflect this change.'],...
                propertyname, validpropertyname );
        end        
    end
    
    % if we didn't throw our own error, this is some other problem
    rethrow( lasterror );
end

