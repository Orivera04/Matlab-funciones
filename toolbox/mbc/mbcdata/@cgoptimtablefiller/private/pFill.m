function fillstat = pFill(otf, outdata, outfactors, outweights, optimname, DOWAITBAR, fillflag)
%PFILL Fill the tables with the required values
%
%  FILLSTAT = PFILL(OTF, OUTDATA, OUTFACTORS, FILLFLAG) fills the tables
%  set up in the CGOPTIMTABLEFILLER object, OTF.
%
%  Note that this method is intended to be private. Use
%  CGOPTIMTABLEFILLER/FILL instead.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.3 $  $Date: 2004/04/04 03:26:15 $

if DOWAITBAR
    DLGTITLE = 'Table Filling from Optimization Results';
    waitH = xregGui.waitdlg('title',DLGTITLE,'message','');
    waitH.waitbar.min = 0;
    waitH.waitbar.max = length(find(fillflag));
end

fillstat = true(1, length(find(fillflag)));
pTabs = getTables(otf);
ct = 0;
for i = 1:length(fillflag)
    if fillflag(i)
        % Inform the user if required
        if DOWAITBAR
            tablename = pTabs(i).getname;
            waitH.message = ['Filling table ',tablename];
        end
        % Increment table counter
        ct = ct+1;
        % fill the table
        fillstat(ct) = i_FillTable(otf, outdata, outfactors, outweights, optimname, i);
        % Increment the waitbar
        if DOWAITBAR
            waitH.waitbar.value = ct;
        end
    end
end

if DOWAITBAR
    delete(waitH);
end

%--------------------------------------------------------------------------
function ok = i_FillTable(otf, outdata, outfactors, outweights, optimname, table_no)
%--------------------------------------------------------------------------

% Optimistically assume that the table will fill without a hitch.
ok = true;

% Table axes, table axes pointers
tptr = otf.tables(table_no);
axesptrs = tptr.get('axesptrs');
axes = tptr.get('axes');

% Data to fill the table
filldata = pGetTableData(otf, outdata, outfactors, outweights, table_no);

if isempty(filldata)
    % There has been a problem in retrieving the data. Return.
    ok = false;
    return
end

switch length(axesptrs)
    case 2
        % 2D table
        % Prepare big matrix
        [xpts,xi,xj] = unique([axes{1} filldata(:,1)']);
        [ypts,yi,yj] = unique([axes{2} filldata(:,2)']);
        valM = repmat(0,length(ypts),length(xpts));
        mask = logical(valM);
        % Fill matrix with data points
        mindex = yj(length(axes{2})+1:end) + (size(valM,1)*(xj(length(axes{1})+1:end) - 1));
        valM(mindex) = filldata(:,3);
        mask(mindex) = true;

        if all(all(mask))
            % Special case - if the mask is full of ones, then we do not need to
            % extrapolate, just use the table values
        else
            % Do the extrapolation
            valM = eval(cgmathsobject,'extrapolate_values_RBF',valM,mask,xpts,ypts);
        end

        % retrieve table values
        tabval = valM(yj(1:length(axes{2})),xj(1:length(axes{1})));

        % Set new values
        info = ['Values filled from optimization ', optimname];
        tptr.info = tptr.set('values',{tabval , info});
    case 1
        % 1D Table
        axes = {axes};
        [xpts, xi] = unique(filldata(:,1)');
        if length(xi) < 2
            % Cannot use the 1-d extrapolation routine with only one data
            % point. Return.
            ok = false;
            return;
        end
        ypts = filldata(xi, 2);
        % Do the extrapolation
        tabvalues = tptr.get('values');
        if size(tabvalues, 2)  > 1
            xtabpts = axes{1}(:)';
        else
            xtabpts = axes{1}(:);
        end
        tabval = eval(cgmathsobject,'extinterp1',xpts,ypts, xtabpts);
        % Set new values
        info = ['Values filled from optimization ', optimname];
        tptr.info = tptr.set('values',{tabval , info});
    otherwise
        % We shouldn't get here.
        ok = false;
        return;
end
