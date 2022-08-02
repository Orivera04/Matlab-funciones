function getClosestSwitchPoint(m)
%GETCLOSESTSWITCHPOINT Return the closest valid evaluation point
%
%  GETCLOSESTSWITCHPOINT(OBJ) sets the inport objects so that the
%  expression is at the closest valid evaluation point. 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.3 $    $Date: 2004/02/09 07:13:04 $ 

if isSwitchModel(m.model)
    pInports = getinports(m);
    pInp = getinputs(m);
    % The closest point can only be found if the inports list matches the
    % direct input list exactly
    if (length(pInports)==length(pInp)) ...
        && all(ismember(pInports,pInp))
        vals = pveceval(pInports, @i_eval);
        newvals = getClosestSwitchPoint(m.model, [vals{:}]);
        passign(pInports, pvecinputeval(pInports, @setvalue, num2cell(newvals)'));
    else
        % Just keep going down the chain to let other expressions try and
        % find a valid place
        getClosestSwitchPoint(m.cgexpr);
    end
else
    getClosestSwitchPoint(m.cgexpr);
end
