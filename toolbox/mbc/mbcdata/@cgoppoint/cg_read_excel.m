function [data,headings,units,err,sheetname] = cg_read_excel(op,path,file,name)
%CG_READ_EXCEL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.8.4.3 $  $Date: 2004/02/09 06:51:31 $

wstate= warning;
warning off

headings = [];
data=[];
units = [];
wh=[];
err = [];
sheetname = [];

if mbciscom(path)
   excel = path;
   h = excel.activeworkbook;
else
   excel = actxserver('excel.application');
   h = invoke(excel.workbooks,'open',fullfile(path,file));
end

ActSheet = h.ActiveSheet;

while double(ActSheet.index) > 1
   ActSheet = ActSheet.previous;
end

try
   % for excel 95
   sheets = invoke(h,'sheets');
   xl_ver = 1;
catch
   % for office 97
   sheets = h.sheets;
   xl_ver = 0;
end
List = ActSheet.name;
all_sheets{1} = ActSheet;

for n = 1:double(sheets.count)-1
   List = strvcat(List,get(ActSheet.next,'name'));
   all_sheets{end+1} = ActSheet.next;
   ActSheet = ActSheet.next;
end

if nargin==4 & ~isempty(name)
   if ischar(name)
      f = strmatch(name,List);
   else
      f = name;
   end
   if ~isempty(f)
      p = f(1);
      OK = 1;
   else
      err = ['Cannot find sheet ' name '.'];
      OK = 0;
      p = 1;
   end
else
   
   if mbciscom(path)
      p=1;
      OK=1;
   else
      [p,OK]=mv_listdlg('ListString',List,...
         'PromptString','Select Sheet',...
         'Name','Select Sheet',...
         'InitialValue',1,...
         'selectionmode','single',...
         'ListSize',[200 240],...
         'fus',10,'ffs',20,...
         'uh',20);
   end
end

if OK
   try
      ws = all_sheets{p};
      
      %get variables
      if xl_ver
         toprow = invoke(ws.UsedRange,'rows',1);
         secondrow = invoke(ws.UsedRange,'rows',2);
         leftcolumn = invoke(ws.UsedRange,'columns',1);
      else
         toprow = get(ws.UsedRange,'rows',1);
         secondrow = get(ws.UsedRange,'rows',2);
         leftcolumn = get(ws.UsedRange,'columns',1);
      end
      
      % Addition - check that the worksheet isn't empty. Bail if it is
      if isnumeric(toprow.value) & isnumeric(leftcolumn.value)
         if toprow.value == -1
            err = 'This spreadsheet is empty. No data read';
            close_excel(path, h, excel, wstate);
            return;             
         end
      end
      
      names = toprow.value;
      if ~iscell(names)
         % Addition - this occurs if the imported file only consists of one 
         % column. Convert it to a cell for compatibility
         names = {names};
      end
      
      if strcmp(names(1),'Name:')
         start = 2;
      else
         start = 1;
      end
      
      vstart = 3;
      
      names = names(start:end);
      ncols = length(names);
      units = secondrow.value;
      if ~iscell(units)
         % Addition - this occurs if the imported file only consists of one 
         % column. Convert it to a cell for compatibility
         units = {units};
      end          
      units = units(start:end);
      % This 'if' loop is entered if the second row does NOT contain units
      if isa(units{start},'double') | ...
            (ncols>start & isa(units{start+1},'double'))
         %2nd test: may have test number (char) as first
         % col, but data in other columns from 2nd row.
         for n = 1:ncols
            units{n} = 'Number';
         end
         vstart = 2;
      end
      
      % The excel spreadsheet contains no column headers
      if isa(names{start},'double') | ...
            (ncols>start & isa(names{start+1},'double'))
         for n = 1:ncols
            names{n} = sprintf('Var%d',n);
         end
         vstart = 1;
      end
      
      rem = ~cellfun('isclass',names,'char');
      
      %get data
      if iscell(leftcolumn.value)
         nrows = length(leftcolumn.value);
      else
         nrows = 1;
      end
      wh = waitbar(0,['Reading "',ws.name,'"'], 'name', 'Importing Data ...');
      % Assume that sheet names contain no LaTeX style characters
      hAxes = findobj(wh, 'type', 'axes');
      hTitle = get(hAxes, 'title');
      set(hTitle, 'Interpreter', 'none')
      data = zeros(ncols,nrows-(vstart-1));
      coldata = cell(nrows,1);
      keepvec = [];
      for n = 1:ncols
         if xl_ver
            column = invoke(ws.UsedRange,'columns',n+start-1);
            hidden = invoke(column,'hidden');
         else
            column = get(ws.UsedRange,'columns',n+start-1);
            hidden = get(column,'hidden');
         end
         if ~hidden & ~rem(n)
            if nrows ==1
               if xl_ver
                  sel = invoke(column,'range','a1:a1');
               else
                  sel = get(column,'range','a1:a1');
               end
               coldata(1) = {sel.value};
            else
               for m = 0:ceil(nrows/2000)-2
                  if xl_ver
                     sel = invoke(column,'range',sprintf('a%d:a%d', 1+(m*2000), (m+1)*2000));
                  else
                     sel = get(column,'range',sprintf('a%d:a%d', 1+(m*2000), (m+1)*2000));
                  end
                  coldata((1+(m*2000)):((m+1)*2000)) = sel.value;
               end
               if isempty(m)
                  m=0;
               else
                  m = m+1;
               end
               if xl_ver
                  sel = invoke(column,'range',sprintf('a%d:a%d', 1+(m*2000), nrows));
               else
                  sel = get(column,'range',sprintf('a%d:a%d', 1+(m*2000), nrows));
               end
               coldata(1+(m*2000):end) = sel.value;
            end
            
            f = find(cellfun('isclass',coldata(vstart:nrows),'char'));
            if ~isempty(f)
               % Version 1.0 - File contains text that is not part of
               % row/column/units info. So we should bail out at this point
               % Version 2.1 - We should follow the Data Editor paradigm
               % and replace the strings with NaN and *not* bail.
               nancell = {NaN};
               coldata(f+ (vstart-1)) = nancell;
            end
            datanum = cat(1,coldata{vstart:nrows});
            % check datanum isn't too short - we might have imported empty
            % rows
            if length(datanum)<nrows
               data = data(:,1:length(datanum));
            end
            datanum(isnan(datanum)) = 0;         
            data(n,:) = datanum';
            keepvec = [keepvec n];
         end
         
         waitbar(n/ncols);
      end
      delete(wh)
      wh = [];
      headings = names(keepvec);
      data = data(keepvec,:)';
      units = units(keepvec);
      sheetname = List(p, :);
   catch
      if ~isempty(wh)
         delete(wh)
      end
      
      data = [];
      names = [];
      units = [];
      headings = [];
      err = 'The chosen spreadsheet cannot be read.  Check that its form is correct and then retry';
      sheetname = [];
   end
end

close_excel(path, h, excel, wstate);

%------------------------------------------------------------------------------
function close_excel(path, h, excel, ws)
%------------------------------------------------------------------------------
if ~mbciscom(path)
   invoke(h,'close');
   invoke(excel,'quit');
   delete(excel);
end
warning(ws)


