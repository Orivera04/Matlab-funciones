function obj=redraw(obj,level)
%% xreglistctrl/REDRAW
%% redraws list control for changes to 
%% numCells, position, controls
%% that have alreay been made using SET
%% Slider on/off as appropriate
%% and calls draw on controls

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:32:09 $

% check to see whether controls should be visible
ObjVis=get(obj,'visible');

frame = obj.frame;
slider = obj.slider;
fh = get(slider,'parent');
ud = get(slider,'userdata');
top = ud.top;
cellHeight = ud.cellHeight;
controls = ud.controls;
sliderWidth = ud.sliderwidth;
border = ud.border;
cellBorder = ud.cellBorder;
pos = ud.position;

if pos(3) < 25+sliderWidth | pos(4) < 40
   pos = [pos(1) pos(2) 25+sliderWidth 40];
end

%% check level entered correctly
if nargin == 1 | ~isequal(pos,get(frame,'position'))
   level = 'full';
end

switch level
case 'full'
   %% === GLOBAL REDRAW === 
   %% if changed position or numCells
   set(frame,'position',pos);
   sliderPos = [pos(1)+pos(3)-sliderWidth-1 pos(2)+1 sliderWidth  pos(4)-2];
   
   %% there is an optional field to fix number of visible cells
   if isempty(ud.fixnumcells)
       %% this is teh normal mode = KEEP CELL HEIGHT SAME
       %% see how many cells we can fit in
       numCells = floor((pos(4)-2*border)/(cellHeight+2*cellBorder));
   else
       %% number of visible cells fixed = KEEP NUM CELLS SAME
       %% change cell height
       numCells = ud.fixnumcells;
       ud.cellHeight = floor((pos(4)-2*border)/numCells)-2*cellBorder;
       cellHeight = ud.cellHeight;
   end


   %% heights checked on SET but just in case
   if numCells < 1
      ud.cellHeight = pos(4)-2*border - 2*cellBorder;
      cellHeight = ud.cellHeight;
   end
   
   %% recalibrate slider
   slLength = max(length(controls)-numCells+1,1+eps);
   set(slider,'position',sliderPos,...   
      'sliderstep',[1/slLength, 2/slLength],...
      'max',slLength,...
      'min',1,...
      'value',slLength);
   %% catch if slider only has one space to move
   if 1/slLength == 0.5
      set(slider,'sliderstep',[0.5+eps, 1]);
   end
   
   %% === Draw the controls ===
   %% create small inner border
   pos = pos + [border border -2*border -2*border];
   wd = pos(3); ht = pos(4);
   cellWd = wd - sliderWidth;

   if ~isempty(controls)
      %% check the current val of top is what we want
      top = max(1,min(top, length(controls)-numCells+1 ));
      %% visible 'off' top controls
      if top > 1
         for i = 1:top-1
            set(controls{i},'visible','off');
         end
      end
      %%move the currently visible controls
      for i = top:min(length(controls), top+numCells-1)
         cellPos = [pos(1) pos(2)+ht-(i-top+1)*(cellHeight+2*cellBorder) cellWd cellHeight+2*cellBorder];
         cellPos = cellPos + [cellBorder cellBorder -2*cellBorder -2*cellBorder];
         set(controls{i},'position',cellPos,...
            'visible',ObjVis);
      end
      %% visible off remaining controls
      if length(controls) >= top+numCells
         for i = top+numCells:length(controls) 
            set(controls{i},'visible','off');
         end
      end
   end
   
   set(slider,'value',min(max(1,slLength-top+1),slLength));
   
case 'cell'
   %% if cells, top changed
   numCells = floor((pos(4)-2*border)/(cellHeight+2*cellBorder));

   slLength = max(length(controls)-numCells+1,1+eps);
   set(slider, 'sliderstep',[1/slLength, 2/slLength],...
      'max',slLength,...
      'min',1,...
      'value',min(max(1,slLength-top+1),slLength));
   %% catch if slider has only one space to move.
   if 1/slLength == 0.5
      set(slider,'sliderstep',[0.5+eps, 1]);
   end
   
   %% === Draw the controls ===
   %% first find how many cells to draw
   pos = pos + [border border -2*border -2*border];
   wd = pos(3); ht = pos(4);
   cellWd = wd- sliderWidth;
   
   if ~isempty(controls)
      %% visible 'off' top controls
      if top > 1
         for i = 1:top-1
            set(controls{i},'visible','off');
         end
      end
      %%move the currently visible controls
      for i = top:min(length(controls), top+numCells-1)
         cellPos = [pos(1) pos(2)+ht-(i-top+1)*(cellHeight+2*cellBorder) cellWd cellHeight+2*cellBorder];
         cellPos = cellPos + [cellBorder cellBorder -2*cellBorder -2*cellBorder];
         set(controls{i},'position',cellPos);
         %% set visibility to agree with that of the whole ListCtrl
         set(controls{i},'visible',ObjVis);
      end
      %% visible off remaining controls
      if length(controls) >= top+numCells
         for i = top+numCells:length(controls) 
            set(controls{i},'visible','off');
         end
      end
   end
   
   
end

repack(frame);
ud.controls = controls;
ud.top = top;
ud.cellHeight = cellHeight;
set(slider,'userdata',ud);

if numCells < length(controls)
   set(slider,'enable','on');
else
   set(slider,'enable','off');
end

