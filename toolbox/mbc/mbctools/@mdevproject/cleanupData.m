function MP = cleanupData(MP, T)
%CLEANUPDATA
%
%  MP = cleanupData(MP, pT);
%  
% This function looks at the data currently in the project and finds all the
% project data that is a testplansweepsetfilter and not attached to a testplan.
% It then looks to see if that data is identical to some pre-exsiting data and if
% it is then it deletes the tssf. otherwise it casts it back to an ssf and
% continues

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%  $Revision: 1.5.6.3 $    $Date: 2004/02/09 08:03:19 $ 

% list of testplans and dataobjects
pTestplanData = children(MP,'DataLinkPtr');
pTestplanData = [pTestplanData{:}];
pTestplanData = pTestplanData(pTestplanData ~= 0);

k = 1;
for i = 1:length(MP.Datalist)
    ssf = MP.Datalist(k).info;
    if  isa(ssf,'testplansweepsetfilter') && ~any(pTestplanData == MP.Datalist(k))
        % Find other dependents of the parent
        p = getDataDependancies(MP, MP.Datalist(k));
        % Cast me as a double for comparison
        thisDblSS = double(sweepsetfilter(ssf));
        % Default is that this isn't the same as anyone else and so can't be deleted
        CAN_DELETE = false;
        % Check all the dependents 
        for j = 1:length(p)
            % First cast to ssf then get the output double
            dblSS = double(sweepsetfilter(p(j).info));
            % Note that this could have NaN's in it so call isidentical
            if isequalwithequalnans(thisDblSS, dblSS)
                CAN_DELETE = true;
                % No need to continue since we know we can delete this one
                break
            end
        end
        % Have we decided that this data is suitable for removal
        if CAN_DELETE
            % Remove entirely
            MP = removeData(MP, MP.Datalist(k));
            k = k - 1;
        else
            % Turn back into ssf
            ssf = sweepsetfilter(ssf);
            % Legacy - need to remove any sweep reordering from old
            % testplans - Inf is a hack to remove all sweepreordering
            if ~isempty(get(ssf, 'reordersweeps'))
                ssf = reorderSweeps(ssf, Inf);
            end
            % Update the project data pointer
            MP.Datalist(k).info = ssf;
        end
    end
    k = k + 1;
end