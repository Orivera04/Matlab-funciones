function nd=addnodestoproject(nd,nodes)
%ADDNODESTOPROJECT  Add nodes to cage project
%
%  ND=ADDNODESTOPROJECT(ND,NODES)  adds the list of cage nodes NODES
%  to the correct part of the cage project and ensures they have unique
%  names in the project.
%
%  NODES is a pointer array of nodes

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.2.3 $  $Date: 2004/02/09 08:24:37 $


PROJ = project(nd);

i_doaddprocedure(PROJ,nodes);

ndP = address(nd);
if ndP==address(PROJ)
    % return updated node
    nd=info(address(nd));
end





function i_doaddprocedure(PROJ,nodes)
if ~isempty(nodes)
    % gather all nodes, including children
    ch_nodes = pveceval(nodes, @allchildren);
    ren_nodes = [nodes(:)', ch_nodes{:}];

    % Reduce nodes which are referencing the same data to a single item.
    ren_nodes = unique(ren_nodes);
    keep_nodes = true(size(ren_nodes));
    ren_objects = info(ren_nodes);
    if ~iscell(ren_objects)
        ren_objects = {ren_objects};
    end
    if length(ren_nodes)>1
        for n = length(ren_nodes):-1:1
            for m = n-1:-1:1
                keep_nodes(n) = ~usesamename(ren_objects{n}, ren_objects{m});
                if ~keep_nodes(n)
                    break;
                end
            end
        end
    end

    ren_objects = ren_objects(keep_nodes);
    ren_nodes = ren_nodes(keep_nodes);
    
    
    % Check names for uniqueness against project and themselves, and
    % generate new ones where needed
    names = pveceval(ren_nodes, @name);
    [names,tochange] = uniquename(PROJ, names);
    
    if any(tochange)
        % Each change needs to be checked to make sure that the node it is clashing
        % with isn't in fact referencing the same data, in which case we shouldn't name-change
        for k = find(tochange)
            if tochange(k)<0
                % DDnode item clash : need to rename
                name(ren_objects{k}, names{k}); 
            else
                % check with clash node
                clashnode = info(assign(xregpointer, tochange(k)));
                if ~usesamename(clashnode, ren_objects{k});
                    name(ren_objects{k}, names{k}); 
                end
            end
        end
    end
    
    addcgitems(PROJ,nodes);
end