function cellstr = pAlgStats(d, obj)
%PALGSTATS Create cell array containing algorithm statistics
%
%  STR = PALGSTATS(VIEWDATA, NODE) creates a cell array containing the
%  algorithm statistics for the current selection in the GUI

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 08:27:47 $ 

if isempty(obj.output)
    cellstr{1, 1} = '<No information available>';
    cellstr{1, 2} = '';
else
    if length(obj.output) == 1
        fnames = fieldnames(obj.output);
        data = struct2cell(obj.output);
        cellstr = cell(length(fnames), 2);
        cellstr(:,1) = fnames(:);
        for n = 1:length(data)
            cellstr{n,2} = num2str(data{n});
        end
    else
        if d.CurrentView~=3
            ind = d.CurrentOpPoint;
            fnames = fieldnames(obj.output);
            data = struct2cell(obj.output(ind));
            cellstr = cell(length(fnames), 2);
            cellstr(:,1) = fnames(:);
            for n = 1:length(data)
                cellstr{n,2} = num2str(data{n});
            end
        else
            % Can't display per-oppoint info when the op-points are all
            % showing
            cellstr{1, 1} = '<No information available>';
            cellstr{1, 2} = '';
        end
    end
end