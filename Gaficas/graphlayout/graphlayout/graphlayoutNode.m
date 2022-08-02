classdef graphlayoutNode < dynamicprops & hgsetget
% This class represents a drawable node in an arbitrary graph.
%
% Public properties can be set using the standard Matlab set method as in
% set(node,'curvature',[0,0],'linesytle','--','linecolor','g'). Call
% node.redraw to redraw it after changing properties. 
%
% Nodes are not really designed to live on their own, they should be
% aggregated into a graph object responsible for layout.
%
% Matthew Dunham
% University of British Columbia 
% http://www.cs.ubc.ca/~mdunham/
    
    properties
        label;                      % displayed name for the node
        splitLabel;                 % label split in the middle
        useFullLabel    = false;    % if true, the full non-split label is used regardles of how long it is. 
        description     = '';       % text displayed when you click on the node
        curvature       = [1 1];    % curvature of the node, [1,1] = circle
        lineStyle       = '-';      % line style for the node
        lineWidth       = 2;        % line wdth for the node
        inedges         = [];       % indices of edges in
        outedges        = [];       % indices of edges out
        fontSize        = 12;       % The font size for the node
        showFullLabel  = false;     % If true, node labels are not split onto multiple lines regardelss of how long
    end
    
    properties
    % Color properties
        lineColor       = 'k';       % line color for the node
        selectedColor  = [1 1 0.7];  % face color when selected with mouse
        faceColor       = [1 1 0.8]; % face color when not shaded  
        shadedColor     = 'r';       % color when shaded, call shade() to shade
        textColor       = 'k';       % label's text color
        containingGraph = [];        % containing graph object
        
    end
    
    properties(GetAccess = 'public', SetAccess = 'protected')
    % Read only properties
        xpos            = 0;        % x-coordinate of node center relative to parent axes
        ypos            = 0;        % y-coordinate of node center relative to parent axes
        isvisible       = false;    % true iff the node is being displayed
        isshaded        = false;    % is the node shaded or not? 
        width           = 1;        % width in data units
        height          = 1;        % height in data units
    end
    
    properties(GetAccess = 'public', SetAccess = 'protected')
    % Handles to underlying Matlab graphics objects    
        rechandle       = [];       % handle to the underlying rectangle object
        labelhandle     = [];       % handle to the underlying text object
        parent          = [];       % handle to the parent axes object
        isselected      = false;    % true iff, the node has been selected 
    end
    
    methods
       
        function obj = graphlayoutNode(label)
         % Node Constructor
            obj.label = label;
            obj.setSplitLabel(label);
            
        end
            
        function draw(obj,parent)
        % Draw the node on the specified parent axes. If no parent is
        % specified, the current axis is used. 
            if(obj.isvisible)
                warning('GRAPHNODE:draw',['Node ',obj.label,' is already drawn, call redraw().']);
                return;
            end
            if(nargin < 2)
                if(isempty(obj.parent) || ~ishandle(obj.parent))
                    obj.parent = gca;
                end
            else
                obj.parent = parent;
            end
            obj.drawNode();
            obj.setText();
            obj.isvisible = true;
        end
        
        function redraw(obj)
        % Redraw the node, (must be called after node properties are
        % changed).
            if(obj.isvisible), obj.erase;end
            obj.draw();
        end
        
        function erase(obj)
        % Erase the node but do not delete it
           if(~obj.isvisible)
              warning('GRAPHNODE:erase',['Node ',obj.label,' is already erased']);
              return;
           end
           delete(obj.rechandle); 
           delete(obj.labelhandle);
           obj.rechandle = [];
        end
        
        function shade(obj,color)
        % Shade the node the specified color. The default color is used if 
        % none given.
           obj.isshaded = true;
           if(nargin == 2)
              obj.shadedColor = color; 
           end
           if(obj.isvisible)
                set(obj.rechandle,'FaceColor',obj.shadedColor);
           end
        end
        
        function unshade(obj)
        % Unshade the node
           obj.isshaded = false;
           if(obj.isvisible)
                set(obj.rechandle,'FaceColor',obj.faceColor);
           end
        end
        
        function resize(obj,width,height)
        % Resize the node by the specified proportion
            if(nargin < 3)
               if(~isempty(obj.containingGraph))
                    height = width;
                end
            end
            obj.width = width;
            obj.height = height;
            if(obj.isvisible), obj.redraw; end
        end

        function move(obj,x,y)
        % Move the node's center to the new x,y coordinates, (relative to
        % the parent axes.)
            obj.xpos = x; obj.ypos = y;
            if(obj.isvisible),obj.redraw;end
        end
        
        function select(obj)
        % Call this function to set the node in a selected state. 
            obj.isselected = true;
            if(obj.isvisible)
                set(obj.rechandle,'faceColor',obj.selectedColor);
            end
        end
        
        
        function deselect(obj)
        % Call this function to deselect the node. 
            obj.isselected = false;
            if(obj.isvisible)
                obj.redraw;
            end
        end
        
    end % end of public methods
    
    methods(Access = 'protected')
        
        function nodePressed(obj,varargin)
        % This function is called whenever the node is pressed.   
            if(~isempty(obj.containingGraph))
               obj.containingGraph.nodeSelected(obj); 
            end
        end
        
        function nodeDeleted(obj)
        % This function is called whenver the node is deleted, (perhaps
        % because the figure window was closed for instance).
            obj.isvisible = false;
            obj.parent = [];
        end
       
        function drawNode(obj)
        % Draw the actual node    
            recxpos = obj.xpos - obj.width/2;
            recypos = obj.ypos - obj.height/2;
            lineColor = obj.lineColor;
            lineWidth = obj.lineWidth;
            if(obj.isselected)
                color = obj.selectedColor;
                lineColor = 'r';
                lineWidth = 1.5*lineWidth;
            elseif(obj.isshaded)
                color = obj.shadedColor;
            else
                color = obj.faceColor;
            end
            obj.rechandle = rectangle(...
               'Parent'       ,obj.parent                              ,...
               'Position'     ,[recxpos,recypos,obj.width,obj.height]  ,... 
               'Curvature'    ,obj.curvature                           ,...
               'LineWidth'    , lineWidth                                ,...
               'LineStyle'    ,obj.lineStyle                           ,...
               'EdgeColor'    ,lineColor                               ,...
               'faceColor'    ,color                                   ,...
               'DisplayName'  ,obj.label                               ,...
               'Tag'          ,obj.label                               ,...
               'ButtonDownFcn',@obj.nodePressed                        ,...
               'UserData'     ,obj                                     ,...
               'DeleteFcn'    ,@(varargin)obj.nodeDeleted()            );
        end
        
        function setText(obj)
        % Draw the node's label    
            if((length(obj.label) < 10) || obj.useFullLabel || obj.showFullLabel)
                label = obj.label;
            else
                label = obj.splitLabel;
            end
            obj.labelhandle = text(obj.xpos,obj.ypos,label            ,...
                'FontUnits'           , 'points'                      ,...
                'HitTest'             , 'off'                         ,...
                'FontWeight'          , 'demi'                        ,...
                'Margin'              , 0.01                          ,...
                'HorizontalAlignment' , 'center'                      ,...
                'BackGroundColor'     , 'none'                        ,...
                'Selected'            , 'off'                         ,...
                'VerticalAlignment'   , 'middle'                      ,...
                'LineStyle'           , 'none'                        ,...
                'FontSize'            , obj.fontSize                  ,...
                'Color'               , obj.textColor                 );
            if(obj.useFullLabel)
               set(obj.labelhandle,'BackgroundColor',obj.selectedColor,'Margin',6,'EdgeColor','k','LineStyle','-');
            end
        end
        
        function resizeText(obj)
          % Resize the text to fill the node (too slow for large graphs)
           fontsize = obj.maxFontSize;
           set(obj.labelhandle,'FontSize',fontsize);
           extent = get(obj.labelhandle,'Extent');
 
           while((extent(1) < (obj.xpos - obj.width/2)) || (extent(2)+(extent(4)) > (obj.ypos + obj.height/2)))
                fontsize = 0.95*fontsize;
                set(obj.labelhandle,'FontSize',fontsize);
                extent = get(obj.labelhandle,'Extent');
           end
        end
         
        function setSplitLabel(obj,label)
            SPLITSIZE = 8;
            obj.splitLabel = strjust(splitInTwo(label),'center');
            
            function str = splitInTwo(str)
            % recursively split a string into two.
               if(length(str) >= SPLITSIZE)
                  top = [str(1:floor(length(str)/2)),'-'];                    
                  bottom = str(floor(length(str)/2)+1:end);  
                  str = strvcat(splitInTwo(top),splitInTwo(bottom)); %#ok
               end
            end
            
             
        end
       
    end % end of protected methods
    
end % end of graphnode class