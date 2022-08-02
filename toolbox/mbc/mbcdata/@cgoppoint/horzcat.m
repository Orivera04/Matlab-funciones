function P = horzcat(varargin);
% cgOpPoint / horzcat
% Concatenate two operating point sets with different factors
% The sets must have the same number of points or 1 point

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:51:54 $

if nargin==1
    P = varargin{1};
else
    for i = 1:nargin
        if ~isa(varargin{i},'cgoppoint')
            error('horzcat: all inputs must be cgoppoint objects');
        end
    end
    P = varargin{1};
    data = P.data;
    name = P.name;
    ptrlist = get(P,'ptrlist');
    for i = 2:nargin
        this = varargin{i};
        thispl = get(this,'ptrlist');
        duplicate = 0;
        if ~isempty(ptrlist) & ~isempty(thispl)
            for j = 1:length(thispl)
                if isvalid(thispl(j))
                    duplicate = max(duplicate,double(ptrlist)==double(thispl(j)));
                end
            end
        end
        if duplicate
            warning('mtimes: duplicate factors detected - oppoint ignored');
        else
            if isempty(name)
                name = this.name;
            end
            ptrlist = [ptrlist thispl];
            tdata = this.data;
            if isempty(P.ptrlist)
                data = tdata;
            elseif ~isempty(this.ptrlist)
                if size(tdata,1)~=size(data,1)
                    if size(tdata,1)==1
                        tdata = repmat(tdata,size(data,1),1);
                    elseif size(tdata,1)==0
                        tdata = repmat(0,size(data,1),1);
                    elseif size(data,1)==1
                        data = repmat(data,size(tdata,1),1);
                    elseif size(data,1)==0
                        data = repmat(0,size(tdata,1),1);
                    else
                        error('horzcat: data sets must have same number of points');
                    end
                end
                data = [data tdata];
            end
            P.ptrlist = [P.ptrlist this.ptrlist];
            P.units = [P.units this.units];
            P.orig_name = [P.orig_name this.orig_name];
            P.factor_type = [P.factor_type this.factor_type];
            P.linkptrlist = [P.linkptrlist this.linkptrlist];
            P.overwrite = [P.overwrite this.overwrite];
            %%%%%% need to check this one! Do all this as an addfactor?
            P.group = [P.group this.group];
            %%%%%% what about rules? update to point to correct new factor?
            
            P.grid_flag = [P.grid_flag this.grid_flag];
            P.range = [P.range this.range];
            P.constant = [P.constant this.constant];
            P.created_flag = [P.created_flag this.created_flag];
            P.tolerance = [P.tolerance this.tolerance];
            % If there is a block in both op points, then set the block length
            % to the length of this if this > 1, else 
            if any(find(P.grid_flag == 7)) & any(find(this.grid_flag == 7))
                P.blocklen = size(P.data, 1);
            elseif any(find(P.grid_flag == 7)) & ~any(find(this.grid_flag == 7))
                P.blocklen = size(P.data, 1);
            elseif ~any(find(P.grid_flag == 7)) & any(find(this.grid_flag == 7))
                P.blocklen = size(this.data, 1);
            else
                P.blocklen = [];
            end
        end
    end
    P.name = name;
    P.data = data;
    
end




