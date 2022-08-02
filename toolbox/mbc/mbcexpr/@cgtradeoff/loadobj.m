function T = loadobj(T)
%LOADOBJ Load-time actiosn for cgtradeoff
%
%  OBJ = LOADOBJ(OBJ) performs load-time actions for cgtradeoff objects.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:16:10 $

if isa(T,'struct')
    if ~isfield(T,'version')
        % version field added at version 2
        if isfield(T,'sameYlimits')
            % push the field to the end of the structure
            yl=T.sameYlimits;
            T=mv_rmfield(T,'sameYlimits');
            T.sameYlimits=yl;
        else
            T.sameYlimits=0;
        end
        T.fillReg=zeros(size(T.fillMask));
        T.currentRows=[];
        T.currentCols=[];
        T.version=3;  % version 2-->3 upgrade is fixed within this code
    end

    if T.version<3
        % messy upgrade - need to re-order some fields in order to allow easy support
        % of v1 --> v3 upgrade
        % swap round the names and data of the sameYlimits and viewStore
        c=struct2cell(T);
        f=fieldnames(T);
        indx=strmatch('sameYlimits',f);
        f([indx indx+1])=f([indx+1 indx]);
        c([indx indx+1])=c([indx+1 indx]);
        T=cell2struct(c,f,1);
        T.version=3;
    end

    if T.version<4
        T.hiddenFactors = [];
        T.hiddenModels = [];
        T.version=4;
    end

    T=cgtradeoff(T);
end
