function boxHandle = makeGraph

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filename:     makeGraph.m
% 
% Description:  GUI for generating a directed/undirected graph. It outputs the adjacency
%               matrix, the Laplacian, and node edge incidence matrix
%               Note: useful for making a graph on a small set of nodes 
%
% Input:        Function takes no inputs. The GUI has some help notes on
%               how to enter info
%
% Output:       draws graph & outputs to workspace the adjacency matrix, Laplacian, degree matrix..etc
%                 boxHandle: handle for the main GUI window
%
%               The data (guidata) can be accessed as follows:
%                 temp = guidata(boxHandle.main_window);    
%               This outputs a data structure called graph that has all
%               data associated with the graph that is generated .. see
%               documentation (http://xxx) for details
%
% 6/29/03 Jasmine Sandhu - sandhu@aa.washington.edu 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   $Revision: 1.2 $   
%   $Date: 2004/10/30 20:46:25 $
%
%   Version History:
%   ----------------
%   $Log: makeGraph.m,v $
%   Revision 1.2  2004/10/30 20:46:25  jasmine
%   Updated use of drawRandGraph.m since it was modified
%
%   Revision 1.1  2004/10/30 18:11:37  jasmine
%   Created Graph Theory folder in STB repository
%
%

%----------------------------------------
% SECTION 1: Initialize GUI data to be stored
%----------------------------------------
%----------------------------------------
sv_data.graph.dir  = 0; % Defines Value property for directed radio buttons [1 means it is selected by default]
sv_data.graph.undir= 1; % Defines Value property for undirected radio buttons [0 means it is unselected]
boxHandle          = 0;

%----------------------------------------
% SECTION 2: GUI Layout
%----------------------------------------
%----------------------------------------
screen_size = get(0,'ScreenSize');
pad         = 7;
figure_size = [850 400];  % [width height]
figure_pos  = [(screen_size(3)-figure_size(1))*12    (screen_size(4)-figure_size(2))*14]./15;
plot_widt   = 500;
plot_hght   = 350;
lighten     = 1;          % This is used to chance the backgroundColor 

%----------------------------------------
% Create main window
%----------------------------------------
mainWin = figure('Position'    ,[figure_pos figure_size],...
    'NumberTitle' ,'off',...
    'Units'       ,'pixels',...
    'Menubar'     ,'none',...
    'Color'       ,[0.8 0.8 0.8],...
    'Name'        ,'Graph',...
    'Resize'      ,'off', ...
    'Tag'         ,'main_window');

%----------------------------------------
% 2 Frames: Frame 1 has info, & buttons
%----------------------------------------
frame_hght    = plot_hght;
frame_width   = figure_size(1)-3*pad-plot_widt;
frame_pos(1,:)= [plot_widt+2*pad    figure_size(2)-1.1*plot_hght    frame_width     frame_hght];

i = 1;
helpStr(i)    = {' Input no. of nodes and edges'};                              i = i + 1;
helpStr(i)    = {' - Undirected: input edges as ordered pair. eg: [1 2], [3 4]'}; i = i + 1;
helpStr(i)    = {'  - Directed: if edge has tail @ 1 and head @ 2 input [1,2]'};  i = i + 1;
helpStr(i)    = {'  - Assume graph is complete if no. edges is empty'};         i = i + 1;
helpStr(i)    = {'  - Cycle option checked => create a hamiltonian cycle'};     i = i + 1;
helpStr(i)    = {'  - If Cycle option checked & and Edges field is not empty '};i = i + 1;
helpStr(i)    = {'  - => ignore cycle option and use edges input by user'};     i = i + 1;
helpStr(i)    = {'  - Random Graph option checked => undirected, simple graph'};i = i + 1;
helpStr(i)    = {'  - 0 <= DistanceThreshold <= 1,used to compute random graph'};i = i + 1;
helpStr(i)    = {'  - type ''help makeGraph'' for more detailed info'}; i = i + 1;

frame.name    = {'info / user input'};
frame.handles = [];

frame.handles = [frame.handles, uicontrol('Position', frame_pos(1,:),'Visible','on','Style','frame','Tag','frames')];

% Add little info text on top of window
helpPos       = [frame_pos(1,1)+pad, frame_pos(1,2)+(frame_hght*.55 - pad), frame_width - 2*pad, frame_hght*.45];

frame.handles = [frame.handles, uicontrol( ...
        'Position'           , helpPos, ...
        'Visible'            , 'on', ...
        'BackgroundColor'    , get(0,'defaultUicontrolBackgroundColor')*.9,...
        'HorizontalAlignment', 'left', ...
        'Style'              , 'text', ...
        'String'             , char(helpStr))];

% Buttons for no of nodes & edges
boxHgt     = 18;
yShift     = boxHgt + pad;  % starting Y location for buttons after the short help section
pad_help   = 5;      % add an extra 17px to offset just the buttons and user input part=> more room for help

i1 = 1; i2 = 1;
% Alignment/style for static text fields
% Text that goes in static text fields
txt1(i1)  = {' Directed'};  sty1(i1)    = {'radiobutton'};  Tname1(i1) = {'direct'};
val_1(i1) = sv_data.graph.dir;
alig1(i1) = {'center'};   i1 = i1 + 1;

txt2(i2)  = {' Undirected'}; sty2(i2)    = {'radiobutton'}; Tname2(i2) = {'undirect'};
val_2(i2) = sv_data.graph.undir;
alig2(i2) = {'center'};   bgCol(i2,:) = get(0,'defaultUicontrolBackgroundColor')*lighten;  i2 = i2 + 1;

txt1(i1)  = {'Cycle Graph'}; sty1(i1)   = {'checkbox'};  Tname1(i1) = {'creatCycle'};
val_1(i1) = 0;  % Default is off
alig1(i1) = {'center'};   i1 = i1 + 1;

txt2(i2)  = {'Random Graph'}; sty2(i2)  = {'checkbox'};  Tname2(i2) = {'randomGraph'};
val_2(i2) = 0;  % Default is off
alig2(i2) = {'center'};   bgCol(i2,:) = get(0,'defaultUicontrolBackgroundColor')*lighten;  i2 = i2 + 1;

txt1(i1)  = {' Distance Threshold'}; sty1(i1)   = {'text'};  Tname1(i1) = {'threshold'};
val_1(i1) = 0;  % Default is off
alig1(i1) = {'left'};   i1 = i1 + 1;

txt2(i2)  = {''}; sty2(i2)  = {'edit'};  Tname2(i2) = {'thresholdInput'};
val_2(i2) = 0;  % Default is 0
alig2(i2) = {'center'};   bgCol(i2,:) = [1 1 1];  i2 = i2 + 1;

txt1(i1)  = {' no. Vertices'}; sty1(i1)  = {'text'};        Tname1(i1) = {'noVtx'};
val_1(i1) = 0;  % N/A for this property
alig1(i1) = {'left'};     i1 = i1 + 1;

txt2(i2)  = {''};         sty2(i2)    = {'edit'};           Tname2(i2) = {'vtxInput'};
val_2(i2) = 0;  % N/A for this property
alig2(i2) = {'center'};   bgCol(i2,:) = [1 1 1];  i2 = i2 + 1;

txt1(i1)  = {' Edges'};   sty1(i1)    = {'text'};           Tname1(i1) = {'noEdges'};
val_1(i1) = 0;  % N/A for this property
alig1(i1) = {'left'};     i1 = i1 + 1;

txt2(i2)  = {''};         sty2(i2)    = {'edit'};           Tname2(i2) = {'EdgeInput'};
val_2(i2) = 0;  % N/A for this property
alig2(i2) = {'left'};     bgCol(i2,:) = [1 1 1];  i2 = i2 + 1;

for ind = 1:length(sty1)
    
    yPosShift     = yShift *(ind) + pad_help;  % determines the Y location of buttons just below the help docs
    location1     = [helpPos(1)+pad, helpPos(2)-yPosShift, helpPos(3)*.5, boxHgt];
    frame.handles = [frame.handles, uicontrol( ...
            'Position'           , location1, ...
            'Visible'            , 'on', ...
            'BackgroundColor'    , get(0,'defaultUicontrolBackgroundColor')*lighten, ...
            'HorizontalAlignment', char(alig1(ind)), ...
            'Style'              , char(sty1(ind)), ...
            'FontWeight'         , 'bold', ...
            'Tag'                , char(Tname1(ind)), ...
            'String'             , char(txt1(ind)), ...
            'Value'              , val_1(ind), ...
            'Callback'           , {@setRadio, ind})];
    
    location2 = [helpPos(1)+helpPos(3)*.5, helpPos(2)-yPosShift, helpPos(3)*.5, boxHgt];
    frame.handles = [frame.handles, uicontrol( ...
            'Position'           , location2, ...
            'Visible'            , 'on', ...
            'BackgroundColor'    , bgCol(ind,:), ...
            'HorizontalAlignment', char(alig2(ind)), ...
            'Style'              , char(sty2(ind)), ...
            'String'             , char(txt2(ind)), ...
            'FontWeight'         , 'bold', ...
            'Tag'                , char(Tname2(ind)), ...
            'Value'              , val_2(ind), ...
            'Callback'           , {@setRadio, ind})];
end

yPosShift     = yShift * (ind + 1) + pad_help;

frame.handles = [frame.handles, uicontrol( ...
        'Position'            , [helpPos(1), helpPos(2)-yPosShift, helpPos(3), boxHgt], ...
        'Visible'             , 'on', ...
        'BackgroundColor'     , get(0,'defaultUicontrolBackgroundColor')*lighten, ...
        'HorizontalAlignment' , char(alig2(ind)), ...
        'Style'               , 'pushbutton', ...
        'String'              , 'Compute Graph Properties', ...
        'FontWeight'          , 'bold', ...
        'Tag'                 , 'computeGraphProps', ...
        'Callback'            , {@graphProp})];



% adjacM, degM, incidM,
frame.handles = [frame.handles, uicontrol( ...
        'Position'            , [pad  figure_size(2)-1.1*plot_hght    plot_widt   plot_hght], ...
        'Visible'             , 'on', ...
        'BackgroundColor'     , [1 1 1], ...
        'FontName'            , 'FixedWidth', ...
        'HorizontalAlignment' , char(alig2(ind)), ...
        'Style'               , 'listbox', ...
        'Enable'              , 'inactive', ...
        'Value'               , [], ...
        'Max'                 , 2, ...
        'Tag'                 , 'boxGraphProps', ...
        'FontWeight'          , 'normal')];


%store guidata
guidata(mainWin,sv_data);
boxHandle = guihandles(mainWin);

%----------------------------------------
% SECTION 3: Callback functions
%----------------------------------------
%----------------------------------------
% function setRadio: ensures only one radio button is set at a time..if one
% is selected, the other one is automatically unselected
%----------------------------------------
function setRadio(hObject,eventdata,index)
	handles = guihandles(hObject);
	gdata   = guidata(hObject);
	
	selec(1)= get( handles.direct  ,'Value');  
	selec(2)= get( handles.undirect,'Value');
	
	switch index
        case 1
            % By default, selecVal(1) = 1, and selecVal(2) = 0
            if( selec(1) == 0 & selec(2) == 0)
                selec(1) = gdata.graph.dir;  % reset to values stored in graph_type
                selec(2) = gdata.graph.undir;
            else if( selec(1) == 1 & selec(2) == 1)
                    % find out which selecVal has changed from default
                    % graph_type and make the other one 0
                    if( gdata.graph.undir == 1)
                        selec(2) = 0;
                        % set default values to the updated selecVal
                        gdata.graph.dir   = selec(1);
                        gdata.graph.undir = selec(2);
                        
                    else if( gdata.graph.dir == 1)% gdata.graph_type(2) == 1
                            selec(1) = 0;
                            gdata.graph.dir   = selec(1);
                            gdata.graph.undir = selec(2);
                            
                        end
                    end
                end
            end
            % update GUI and guidata variables
            guidata(handles.main_window, gdata);
            set(handles.direct  ,'Value',selec(1));
            set(handles.undirect,'Value',selec(2));
            
        otherwise
            return
	end
return

%----------------------------------------
% function graphProp: function creates dialog box that displays graph
% props. The graph props are computed by findGraphProps function
%----------------------------------------
function graphProp(hObject,eventdata)
	handles = guihandles(hObject);
	gdata   = guidata(hObject);     
    
    % update values as input by user
	Vtx  = str2num( get(handles.vtxInput, 'String'));
	set(handles.vtxInput,'Value', Vtx); %update the value of handles.vtxInput to user input value
	
	graph_Edge = str2num( get(handles.EdgeInput, 'String'));
    
    %%%%%%%%% Error Catchers & Dialogs %%%%%%%%%
    % undirected graph -- Edge is not empty and cycle is also checked, printwarning
    if( isempty(graph_Edge) == 0 & get(handles.creatCycle,'Value') == 1)
        % Display warning if cycle option is checked and Edges are also input by user    
        warning('Cycle option selected and Edges field is not empty => in this case, the Cycle option is ignored');
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    if( isempty(graph_Edge) == 1 & isempty(get(handles.EdgeInput, 'String')) == 0)
       errordlg('There is an error in the edges input, ensure all the semi-colons are in the correct place');
       return
    end
    terminate= graphErrorCatch(Vtx, graph_Edge);
    if( terminate == 1), disp('Found Error, refer to error dialog that popped  up'); return; end
    if( get(handles.randomGraph,'Value') == 1 & get(handles.direct,'Value') == 1)
        errordlg('In current implementation, random graph cannot be directed, please select either one of the two')
        return
    end
    if( get(handles.creatCycle,'Value') == 1 & Vtx == 2)
        errordlg('Graph must be simple => cannot have a cycle on 2 Vertices');
        return
    end
    if( get(handles.randomGraph,'Value') == 1 )
        temp = str2num( get(handles.thresholdInput, 'String'));
        set(handles.thresholdInput,'Value', temp); %update the value of handles.vtxInput to user input value
        
        if( get(handles.thresholdInput, 'Value') < 0 | get(handles.thresholdInput, 'Value') > 1 )
            errordlg(['Distance threshold must be between 0 & 1, you''ve input ',num2str(get(handles.thresholdInput,'Value'))]);
            return
        end
    end, %disp('ln 291'); keyboard
	%% Add another error catching mech for ensure edges included are consistent w/ no of VTX!!!
	%% NEED 2 FIX -- graph w/ 3 vtx cannot have an edge [1,4]
	%% If directed graph, then edges are oriented as r_ij for all i = 1 ..
	%% Vtx, and j > i.  Therefore, for K4, the edges are directed as:
	%% [1,2], [1,3], [1,4], [2,3], [2,4], [3,4]
    
	%%%%%%%%%%%%%%%%%% Display graph properties %%%%%%%%%%%%%%%%%%
    % Graph is random, call genRandGraphEdges function to generate edges
    if( get(handles.randomGraph,'Value') == 1)
        if( get(handles.creatCycle,'Value') == 1), graph_Edge = getEdges( Vtx,'cycle',get(handles.direct,'Value') ); end
        randProps  = genRandUndirectedGraphEdg(Vtx, graph_Edge, get(handles.thresholdInput,'Value') );
        graph_Edge = randProps.Edges;
        % compute and display graph props in list box, incidence matrix, 
        % adjacency matrix, Laplacian..degree matrix .. etc
        graph_props = findGraphProps( Vtx, graph_Edge, get(handles.direct,'Value'));
        close(findobj('Tag','graphWin'));       % close previously open window

        % Following function simply updates certain values ?? !!
        drawGraph( Vtx, graph_Edge, get(handles.direct,'Value'), [], randProps.usrEdge, randProps.addEdge);
        
        close(findobj('Tag','RandGraphWin'));   % close previously open window
        
        %--- updated drawRandGraph function to take a 7th input
        drawRandGraph( Vtx, graph_Edge, get(handles.direct,'Value'), randProps.nodeLoc, ...
                       randProps.usrEdge, randProps.addEdge, [] );     
        gdata.graph.randProps = randProps;    % if random graph, then add this to data structure
    else
        % use getEdges function to generate edges depending on user input
        if( isempty(graph_Edge) == 1)
            if( get(handles.creatCycle,'Value') == 1)
                graph_Edge = getEdges( Vtx, 'cycle', get(handles.direct,'Value') );
            else
                graph_Edge = getEdges( Vtx, 'complete', get(handles.direct,'Value') );
            end
        end
        % compute and display graph props in list box, incidence matrix, 
        % adjacency matrix, Laplacian..degree matrix .. etc
        graph_props  = findGraphProps(Vtx, graph_Edge, get(handles.direct,'Value'));

        % Create graphing window & add to current guidata object
        close(findobj('Tag','RandGraphWin'));   % close previously random graph window open window
        close(findobj('Tag','graphWin'));       % close previously open window
        drawGraph( Vtx, graph_Edge, get(handles.direct,'Value'));
    end
	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	% Define headers for listbox - graph props are printed in this list box
	stI      = 1;
    str(stI) = {['Rank of Laplacian:  ', num2str(rank(graph_props.LapMat))]};  stI = stI + 2;
	str(stI) = {'Eigenvalues of Laplacian:'};                                  stI = stI + 1;
	%%% laplacian eigenvalues %%%%%%%%%%%%%%%%%%
	lapEgVal = num2str(eig(graph_props.LapMat)', '  %+1.3f');     
	space    = {'       '};
	%%% continue indexing stI %%%%%%%%%%%%%%%%%%
	str(stI) = strcat(space, {lapEgVal});                         stI = stI + 1;
	str(stI) = {''};                                              stI = stI + 1;
	str(stI) = {'Adjacency Matrix [A]:'};   sTind = stI;          stI = stI + 2; % sTind: starting index for matrices below
	str(stI +   size(graph_props.degMat,1)) = {'Degree Matrix [D]: [in + out degree]:'}; stI = stI + 2;
	str(stI + 2*size(graph_props.LapMat,1)) = {'Laplacian [Directed : L = I*I''] / [Undirected: L = D - A] :'};stI = stI + 2;
	str(stI + 3*size(graph_props.LapMat,1)) = {'Incidence Matrix [I]:'};stI = stI + 3;
    str(stI + 4*size(graph_props.LapMat,1)) = {'Normalized Laplacian [inv(D)*Laplacian]:'};
	
	for ind     = 1:size(graph_props.adjMat,1)
        
        value1  = num2str(graph_props.adjMat( ind,:),'  %+1.3f');
        value2  = num2str(graph_props.degMat( ind,:),'  %+1.3f');
        value3  = num2str(graph_props.LapMat( ind,:),'  %+1.3f');
        value4  = num2str(graph_props.incMat( ind,:),'      %+1.0f');
        value5  = num2str(graph_props.normalizedLapMat( ind,:),'  %+1.3f');
	
        strInd  = sTind + ind;
        str(strInd) = strcat(space, value1);
        str(strInd + 2 +   size(graph_props.degMat, 1)) = strcat(space, value2);  
        str(strInd + 4 + 2*size(graph_props.LapMat, 1)) = strcat(space, value3);
        str(strInd + 6 + 3*size(graph_props.incMat, 1)) = strcat(space, value4);
        %% Add a row of labels for edges associated with columns of incMat
        if( ind == size(graph_props.adjMat,1))
            str(strInd + 7 + 3*size(graph_props.incMat, 1)) = strcat('Edg:', graph_props.edgList);
        end    
        str(strInd + 9 + 4*size(graph_props.normalizedLapMat, 1)) = strcat(space, value5);
	    
	end
	set(handles.boxGraphProps, 'String', str);  % display listbox dialog
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    gdata.graph.numOfVtx = Vtx;
    gdata.graph.Edges   = graph_Edge;
    gdata.graph.random  = get(handles.randomGraph, 'Value');    % 0 or 1 depending on whether graph is random or not
    gdata.graph.graph_props = graph_props;    % updated guidata with the additional graph props info
    guidata( handles.main_window, gdata);
return
