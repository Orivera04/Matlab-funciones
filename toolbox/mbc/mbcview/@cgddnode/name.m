function str=name(nd,newname)
%NAME  return name for node
%
%  N=NAME(NODE)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:23:38 $

% This method is overloaded to handle subitem inputs.  Renaming in the data
% dictionary
% is performed via the renameDDitem method.

if nargin==1
    str=name(nd.cgcontainer);
elseif nargin==2 
    if ischar(newname)
        % attempting to set name - not allowed via this interface
        str=nd;
    else
        if newname~=0
            % get subitem name 
            str=getname(newname.info);
        else
            str='';
        end
    end
end