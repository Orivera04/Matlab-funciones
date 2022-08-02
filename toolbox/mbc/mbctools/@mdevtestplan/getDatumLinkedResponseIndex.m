function index = getDatumLinkedResponseIndex(T)
%GETDATUMLINKEDRESPONSEINDEX returns the indices of datum linked responses
%
%  INDEX = GETDATUMLINKEDRESPONSEINDEX(T)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:07:48 $ 

index = [];
% Get the models from the children of the testplan
if numChildren(T) > 0
    models = children(T, 'model');
else
    models = T.Responses;
end
linked = false(size(models));
% You can only have datum linked models for a two stage testplan
if numstages(T) > 1 & length(models) > 0
    % Some constants used by model datumtype
    NO_DATUM = 0; DATUM_LINK = 3;
    % We know there is at leat one model - Check if it has any sort of datum model
    if get(models{1}, 'datumtype') ~= NO_DATUM
        for i = 2:length(models)
            if get(models{i}, 'datumtype') == DATUM_LINK
                linked(i) = true;
            end
        end
    end
    index = find(linked);
end
