function p = delete( nde )
%DELETE Delete a feature node
%
%  DELETE( FEATNODE )

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.4 $    $Date: 2004/04/20 23:19:09 $ 

% Check whether node is the main container for this feature
if ismajoritem(nde)
    % Need to remove the subfeature pointer from any lookups and
    % normalisers inside the feature
    pfeature = getdata( nde );
    eq = pfeature.get('equation');
    if ~isempty(eq)
        allptrs = unique([eq; eq.getptrs]);
        lkups = pveceval(allptrs, @istable);
        lkups = logical([lkups{:}]);
        norms = pveceval(allptrs, @isa, 'cgnormaliser');
        norms = logical([norms{:}]);
        tableptrs = allptrs(lkups | norms);

        passign(tableptrs, pveceval(tableptrs, @UpdateSFlist, pfeature, 0));
    end
end

% Call the superclass' delete
p = delete( nde.cgcontainer );