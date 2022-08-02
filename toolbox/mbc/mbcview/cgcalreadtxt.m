function [data,headings,units,err] = cgcalreadtxt(file,delim)
% Function to read .txt files

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 08:39:24 $

err = [];
data = [];
headings = [];
[p,n,e] = fileparts(file);
if nargin<2
	if strcmp(lower(e),'.csv')
		delim = ',';
	else
		delim = char(9);
	end
end


try
	fid = fopen(file);
	firstline = fgetl(fid);
	if double(delim)==9
		ws = '\b\r\n';
	else
		ws = '\b\r\n\t';
	end
	data = textread(file,'%s','whitespace',ws,'delimiter',delim);
	fclose(fid);
	
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
% 	if (start+1)<=length(data) & isnan(str2double(data{start})) & check_col>1 %third line
% 		if isnumeric(str2double(data{start+1}))  %begins with 'Data:'
% 			nsp = nsp - 1;
% 			if ~isempty(varnames{1}), varnames = varnames(2:end); end
% 			if ~isempty(units), units = units(2:end); end
% 			start = start + 1;
% 		end
% 	end
	
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
		
		for i = 1 : length(varnames)
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
		numind = (numind~=0);
		d = d(:,numind);
		
		data = str2double(d);
% 		nrows = size(d,1);
% 		for i = 1 : size(d,1)
% 			if ishandle(wh)
% 				waitbar((nrows+i)/(2*nrows));
% 			end
% 			numstring = strvcat(d{i,:});
% 			dnumstring = double(numstring);
% 			numstring(~((dnumstring<=57 & dnumstring>=48) | dnumstring==32)) = '0';
% 			numdata(1:size(numstring,1),i) = str2num(numstring);
% 		end
% 		
% 		data = numdata';
	end	
catch
	data = [];
	headings = [];
	units = [];
	err = 'Data could not be read.  Check format';
end