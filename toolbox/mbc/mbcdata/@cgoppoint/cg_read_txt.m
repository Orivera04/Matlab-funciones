function [data,headings,units,err] = cg_read_txt(op,path,file,delim)
% Function to read .txt files
% (output from concerto?)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.3 $  $Date: 2004/02/09 06:51:32 $

err = [];
data = [];
headings = [];
units = '';
if nargin<4
    delim = char(9);
end

try
    if strcmp(path,'clipboard')
       s = clipboard('paste');
       sdbl = double(s);
        newline = find(sdbl==10);
       if length(newline)>100
           wh = waitbar(0,'Reading clipboard');
       else
           wh = [];
       end
        if isempty(newline) | newline(end)~=length(s)
            % ensure data ends with a newline
            s(end+1) = char(10);
            sdbl(end+1) = 10;
            newline = [newline length(s)];
        end
        switch length(newline)
        case 1
            % keep all of sdbl
        case 2
            % take second line (first line may be titles)
            sdbl = sdbl(newline(1)+1:end);
        otherwise
            % take 3rd line (first two may be text)
            sdbl = sdbl(newline(2)+1:newline(3));
        end
        tab = any(sdbl==9);
        space = any(sdbl==32);
        comma = any(sdbl==44);
        ws = '\b\r\n\t';
        if tab  %work out what is used as a separator
            delim = char(9); ws = '\b\r\n';
        elseif comma
            delim = ',';
        elseif space
            delim = ' ';
        else 
            %no separators - use newline
            delim = char(10); ws = '\b\r\t';
        end
        firstline = s(1:newline(1)-1);
        data = strread(s,'%s','whitespace',ws,'delimiter',delim);
    else        
       wh = waitbar(0, sprintf('Reading "%s"',file), 'name', 'Importing Data...', 'DefaultTextInterpreter', 'none');
       fid = fopen(fullfile(path,file));
       if (fid<0)
           err = sprintf('Can''t open file: %s\n', fullfile(path,file) );
           return;
       end
       firstline = fgetl(fid);
       if double(delim)==9
           ws = '\b\r\n';
       else
           ws = '\b\r\n\t';
       end
       data = textread(fullfile(path,file),'%s','whitespace',ws,'delimiter',delim);
       fclose(fid);
   end
   
   if firstline(end)~=delim & ~strcmp(delim,' ')
       firstline = [firstline delim];
   end
   
   spaces = find(double(firstline)==double(delim));
   spaces = spaces([1 find(diff(spaces)~=1)+1]);
   nsp = length(spaces);
   
   count = 1;
   namesflag = 0;
   
   units = []; varnames = {[]};
   start = 1;
   % data may only be one column
   check_col = min(nsp,2);
   if (start+check_col-1)<=length(data) & all(isnan(str2double(data(start:start+check_col-1))))    %first line = varnames?
       varnames = data(1:nsp);
       start = start+nsp;
   end
   if (start+check_col-1)<=length(data) & all(isnan(str2double(data(start:start+check_col-1)))) %second line = units?
       units = data(start:start+nsp-1);
       start = start+nsp;
   end
   if (start+1)<=length(data) & isnan(str2double(data{start})) & check_col>1 %third line
       if isnumeric(str2double(data{start+1}))  %begins with 'Data:'
           nsp = nsp - 1;
           if ~isempty(varnames{1}), varnames = varnames(2:end); end
           if ~isempty(units), units = units(2:end); end
           start = start + 1;
       end
   end
   
   if isempty(varnames{1})
       for i = 1:nsp
           varnames{i} = ['Var',num2str(i)];
       end
   end
   if isempty(units)
       for i = 1:length(varnames)
           units{i} = 'Number';
       end
   end
   
   if start>length(data) | (start-1+nsp)>length(data)
       data = [];
   else
       for i = 1 : (length(data)+1-start)/nsp
           newd = data(start+nsp*(i-1):start-1+nsp*i);
           if strcmp(newd{1,1},varnames{1})
               namesflag = 1;
           elseif namesflag == 1
               namesflag = 0;
           else
               d(count,:) = newd;
               count = count+1;
           end
       end
       
       waitlen = length(varnames)*2;
       
       for i = 1 : length(varnames)
           if ishandle(wh)
               waitbar(i/waitlen);
           end
           if size(d,1)>0 & size(d,2)>=i & isempty(str2num(d{1,i}))
               numind(i) = 0;
           else
               if size(d,1)>1 & size(d,2)>=i & isempty(str2num(d{2,i}))
                   for j = 1:size(d,1)
                       if ~isempty(d{j,i})
                           curval = d{j,i};
                       else
                           d{j,i} = curval;
                       end
                   end
               end
               numind(i) = 1;
           end
       end
       numind = numind~=0;
       d = d(:,numind);
       varnames = varnames(numind);
       units = units(numind);

       nrows = size(d,1);
       for i = 1 : size(d,1)
           if ishandle(wh)
               waitbar((nrows+i)/(2*nrows));
           end
           numstring = strvcat(d{i,:});
           numstring(~((double(numstring)<=57 & double(numstring)>=45) | double(numstring)==32)) = '0';
           numdata(1:size(numstring,1),i) = str2num(numstring);
       end
       
       data = numdata';
   end
   headings = varnames;
   if ishandle(wh)
       delete(wh)
   end
   wh = [];
   
catch
   data = [];
   headings = [];
   units = [];
   err = 'Data could not be read.  Check format';
   if ~isempty(wh)
      delete(wh)
   end
   
end