function HTMLout=print2html(s,nrecurs,f,options)
% PRINT2HTML - Write data in a structured way using html-code
%    print2html(d[,nrecurs[,f[,options]]])
%        d - data
%        nrecurs - maximum level of recursive writing
%            if not given or empty : 1
%        f - filename, file-handle for result
%            1 : screen
%            if a filename is given a general html begin and end is added.
%            'web' or not given : data is sent to Matlab-webviewer
%    HTMLout=print2html(d[,nrecurs[,options]])
%
%    arrays are printed if they are small, otherwise they are summarized in one line.
%    The definition of "small" can be changed by giving options.
%
%    OPTIONS
%    -------
%
%    options can be given as a 2d-cell-array, a 1d-cell-array or a struct :
%       1d :
%           {'option1'[,<value for option1 if necessary>],...}
%       struct :
%           struct('option1',<value for option1>,....);
%       2d :
%           {'option1',<value for option1>;
%            'option2.....}
%           (!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!)
%              this possibility can only be used if more then one option is used
%              otherwise confusion with 1d-list is possible
%     Additionally a string value may be used if one option without value is given.
%
%    The following options are possible (in any combination and order).
%
%        'maxcolarr' (def. 4) : maximum columns to display full array (numeric arrays)
%        'maxrowarr' (def.10) : maximum rows to display full array
%               (this limitation is also used in char-arrays)
%        'maxel'     (def.20) : maximum total number of values to display 1D-list of values
%        'forcehead'          : print head and end of HTML-page
%                In 1d-option-lists no value had to be given, otherwise
%                       values 0 or 1(~=0) can be given or 'on' or 'off'
%                for 1d-option-lists values 0 or 1 are allowed (no char-value
%                       because then this value is interpreted as a new option)
%
%        'numForm'  : the way numbers are displayed (input to fprintf)
%                 default %g : "normal display" (see fprintf-documentation for more details)
%                 (!)Every value displayed is using this format.
%        'emptyArray' : this gives what has to be displayed for an empty array (default '[]')
%        'emptyCell'  : this gives what has to be displayed for an empty cell (default '{}')
%        'maxcolcell' (def. 0) : maximum columns to display full cell
%        'maxrowcell' (def. 0) : maximum rows to display full cell
%        'title' : title of html-page (default Matlab-data display)
%      .................................
%      Other options (related to the display of data) are possible but these are too
%         long to list here.  Look to the comments further in the code to find a more
%         complete list.


% Originally this function was made for structures.  By some simple
%    changes it was made to work on other data too.

% Copyright (c)2003, Stijn Helsen <SHelsen@compuserve.com> Januari 2003

% History
%    2003-01-10 - first version
%    2003-01-22 - print structures also done in printdata
%                 no tables for single values
%                 options added
%                 CSS-possibilities added
%                 some special characters are translated to HTML-code ('&','<','>')
%    2003-2005  - "running changes"
%                 tests for adding CSS-usage
%    2006-02-27 - Because of a proposal from Ralph Smith (Thanks!)
%                 possibility for sending to "web", for direct view

% Comments :
%   Non-ASCII-codes are not translated to HTML-code
%   Now that options are added can be said that the input nrecurs better could be defined
%        as an option.  For keeping the same function call, this is not done.
%   If output is written to a file is not closed if an error occurs, also if the file is
%        opened inside this program.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% Other options %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% The display of data-elements can be changed.
%
%    This can be done in two different ways :
%        use of CSS.
%        use of separate options for structures, cells and numerical data
%              (type-data is included for every element separately)
%    The same options can be used for both methods.
%
%    Advantages of CSS are :
%        one definition for elements in the beginning of the file.
%            to change later (not in Matlab) the style of all structures you
%                have to change only the beginning of the file
%        because the styles don't have to be copied everytime, the file is smaller
%    Disadvantages are :
%        not all programs that can read HTML-files use the info of the stylesheet.
%           some programs even use the CSS-definition as text
%    Therefore the two ways are combined if the use of CSS is activated.
%        borders of tables (used in structures, (cell-)arrays) are not done in CSS.
%
%        options :
%           'useCSS' : values : 0 or 1, 'off' or 'on' of no value (for 1d-list))
%
%           'structBorder' : value : size of border (default 1) (if empty no border is defined)
%                    this defines the border of the struct
%           'structColor : RGB-values, HTML-name of color or HTML-colorspec (example #ff0000)
%                    foreground color
%           'structBgColor'
%           'structFont' :
%           'structFontSize' :
%           'structExtra' :
%           'structCSS' : method for complete CSS-definition at once (overwrites other options)
%
%           'cellBorder' : value : size of border (default 1) (if empty no border is defined)
%                    this defines the border of the struct
%           'cellColor : RGB-values, HTML-name of color or HTML-colorspec (example #ff0000)
%                    foreground color
%           'cellBgColor'
%           'cellFont' :
%           'cellFontSize' :
%           'cellExtra' :
%           'cellCSS' : method for complete CSS-definition at once (overwrites other options)
%
% !!!array styles
%

stroptions=struct('maxcolarr',4,'maxrowarr',10,'maxel',20	...
	,'maxcolcell',0,'maxrowcell',0	...
	,'numForm','%g'	...
	,'emptyArray','[]'	...
	,'emptyCell','{}'	...
	,'optstructtable',' border="1"'	...
	,'optnumtable',''	...
	,'optcelltable',''	...
	,'printhead',0	...
	,'useCSS',0	...
	,'structStyle',[]	...
	,'cellStyle',[]	...
	,'title','Matlab-data display'	...
	);

if ~exist('nrecurs','var')|isempty(nrecurs)
	nrecurs=1;
end
if ~exist('options','var')
	options=[];
end
if ~exist('f','var')
	f=[];
end
ownf=0;
if nargout
	options=f;
	f=[];
end
if nargout|isempty(f)
	f='web';
end
if ischar(f)
	if strcmp(lower(f),'web')
		f=struct('buffer',char(zeros(1,10000)),'n',0);
	else
		f=fopen(f,'wt');
		if f<3
			error('Can''t open file');
		end
	end
	stroptions.printhead=1;
	ownf=1;
end

if ~isempty(options)
	if ischar(options)
		options={options};
	end
	if isstruct(options)
		opts=fieldnames(options);
		for i=1:length(opts)
			stroptions=setoptions(stroptions,opts{i},getfield(options,opts{i}),1);
		end
	elseif ~iscell(options)
		error('Impossible input for options')
	elseif min(size(options))==1
		i=1;
		while i<=length(options)
			[stroptions,n]=setoptions(stroptions,options{i},options{min(end,i+1)},0);
			i=i+n;
		end
	else
		for i=1:length(options)
			stroptions=setoptions(stroptions,options{i,1},options{i,2},1);
		end
	end
	if ~isempty(stroptions.structStyle)
		if ~isfield(stroptions.structStyle,'border')
			stroptions.structStyle.border=1;	% default
		end
		if stroptions.useCSS
			stroptions.optstructtable=sprintf(' class="cstruct" border ="%d"',stroptions.structStyle.border);
		else
			stroptions.optstructtable=printDef1(stroptions.structStyle);
		end
	end
	if ~isempty(stroptions.cellStyle)
		if ~isfield(stroptions.cellStyle,'border')
			stroptions.cellStyle.border=1;	% default
		end
		if stroptions.useCSS
			stroptions.optcelltable=sprintf(' class="ccell" border ="%d"',stroptions.cellStyle.border);
		else
		stroptions.optcelltable=printDef1(stroptions.cellStyle);
		end
	end
end

if stroptions.printhead
	% print html-header
	localprint(f,'<html>\n<head>\n<title>%s</title>\n<meta name="GENERATOR" content="PRINT2HTML - Matlab function">\n',stroptions.title);
	if stroptions.useCSS
		printCSSdef(f,stroptions)
	end
	localprint(f,'</head>\n<body>\n');
end

f=printdata(f,s,nrecurs,stroptions);

if stroptions.printhead
	localprint(f,'</body>\n</html>\n');
end
if ownf
	if nargout
		if ~isstruct(f)
			error('Something went wrong in this program!!!!')
		end
		HTMLout=f.buffer(1:f.n);
		return
	end
	if isstruct(f)
		web(['text://' f.buffer(1:f.n)])
	else
		fclose(f);
	end
end

function f=printdata(f,d,nrecurs,options)
% printdata - print field-data

sz=size(d);
n=prod(sz);
ndim=sum(sz>1);
ndim0=length(sz);
a=cell(1,ndim0);

switch class(d)
case 'struct'
	if nrecurs>0&n<=options.maxel
		fields=fieldnames(d);
		if isempty(d)
			localprint(f,'empty structure (%d fields)<br>\n',length(fields));
		elseif length(d)==1
			localprint(f,'<table%s>\n',options.optstructtable);
			for i=1:length(fields)
				localprint(f,'<tr><td>%s :</td><td>',fields{i});
				f=printdata(f,getfield(d,fields{i}),nrecurs-1,options);
				localprint(f,'</td></tr>\n');
			end
			localprint(f,'</table>\n');
		else
			localprint(f,'<table%s>\n<tr><td> </td>',options.optstructtable);
			for i=1:length(fields)
				localprint(f,'<td>%s</td>',fields{i});
			end
			localprint(f,'</tr>\n');
			a=cell(1,ndim0);
			for i=1:n
				localprint(f,'<tr><td valign="top">%d',i);
				if ndim>1	% add full index
					[a{:}]=ind2sub(sz,i);
					localprint(f,' (%d',a{1});
					localprint(f,',%d',a{2:ndim0});
					localprint(f,')');
				end
				localprint(f,'</td>\n');
				for j=1:length(fields)
					localprint(f,'<td>');
					f=printdata(f,getfield(d,{i},fields{j}),nrecurs-1,options);
					localprint(f,'</td>\n');
				end	% fields
				localprint(f,'</tr>\n');
			end	% rows
			localprint(f,'</table>\n');
		end	% struct array
	else
		localprint(f,'%s structure (%d fields)',stringsize(sz),length(fieldnames(d)));
	end
case {'double','sparse'}
	if n==1
		localprint(f,options.numForm,d);
	elseif n==0
		localprint(f,options.emptyArray);
	elseif ndim0==2&sz(1)<=options.maxrowarr&sz(2)<=options.maxcolarr
		localprint(f,'<table%s>\n',options.optnumtable);
		for i=1:sz(1)
			localprint(f,'<tr>');
			for j=1:sz(2)
				localprint(f,['<td>' options.numForm '</td>'],d(i,j));
			end
			localprint(f,'</tr>\n');
		end	% rows
		localprint(f,'</table>\n');
	elseif n<=options.maxel
		localprint(f,'<table%s>\n',options.optnumtable);
		for i=1:n
			[a{:}]=ind2sub(sz,i);
			localprint(f,'<tr><td>%d (%d',i,a{1});
			localprint(f,',%d',a{2:ndim0});
			localprint(f,[')</td><td>' options.numForm '</td></tr>\n'],d(i));
		end
		localprint(f,'</table>\n');
	else
		localprint(f,'%s ',stringsize(sz));
		if issparse(d)
			localprint(f,'sparse ');
		end
		localprint(f,'array\n');
	end
case 'cell'
	if n==0
		localprint(f,options.emptyCell);
	elseif nrecurs<=0
		localprint(f,'%s cell array\n',stringsize(sz));
	elseif ndim0==2&sz(1)<=options.maxrowcell&sz(2)<=options.maxcolcell
		localprint(f,'<table%s>\n',options.optcelltable);
		for i=1:sz(1)
			localprint(f,'<tr>');
			for j=1:sz(2)
				localprint(f,'<td>');
				f=printdata(f,d{i,j},nrecurs-1,options);
				localprint(f,'</td>');
			end
			localprint(f,'</tr>\n');
		end	% rows
		localprint(f,'</table>\n');
	elseif n<=options.maxel&nrecurs>0
		localprint(f,'<table%s>\n',options.optcelltable);
		for i=1:n
			[a{:}]=ind2sub(sz,i);
			localprint(f,'<tr><td valign="top">%d (%d',i,a{1});
			localprint(f,',%d',a{2:ndim0});
			localprint(f,')</td><td>');
			f=printdata(f,d{i},nrecurs-1,options);
			localprint(f,'</td></tr>\n');
		end
		localprint(f,'</table>\n');
	else
		localprint(f,'%s cell array\n',stringsize(sz));
	end
case {'int8','uint8','int16','uint16','int32','uint32'}
	if sz(1)<=options.maxrowarr&sz(2)<=options.maxcolarr
		f=printdata(f,double(d),0,options);
	else
		localprint(f,'%s %s array\n',stringsize(sz),class(d));
	end
case 'char'
	if ndim0>2|sz(1)>options.maxrowarr
	
localprint(f,'%s char array',stringsize(sz));
	elseif isempty(d)
		localprint(f,'&nbsp;');
	else
		for i=1:sz(1)-1
			printstring(f,d(i,:));
			localprint(f,'<br>\n');
		end
		printstring(f,d(end,:));
	end
otherwise
	localprint(f,'%s',class(d));
end

function ssize=stringsize(sz)
ssize=num2str(sz(1));
ssize=[ssize sprintf('x%d',sz(2:end))];

function printCSSdef(f,options)
% PRINTCSSHEAD - Print the definition of the CSS
localprint(f,'<style type="text/css">\n');
localprint(f,'.cstruct {\n');
if isempty(options.structStyle)
	localprint(f,'    // no styles given\n');
else
	printCSSdef1(f,options.structStyle);
end	% struct styles
localprint(f,'}\n');
localprint(f,'.ccell {\n');
if isempty(options.cellStyle)
	localprint(f,'    // no styles given\n');
else
	printCSSdef1(f,options.cellStyle);
end	% cell styles
localprint(f,'}\n');
%fprintf(f,'.cnum {\n    %s}\n',options.CSSnum);
localprint(f,'</style>\n');

function printCSSdef1(f,options)
% PRINTCSSDEF1 - Print 1 definition (for CSS-usage)
fields=fieldnames(options);
for i=1:length(fields)
	value=getfield(options,fields{i});
	switch fields{i}
	case 'border'
		% not in CSS (?!!)
	case 'color'
		localprint(f,'    color: %s;\n',getcolorspec(value));
	case 'bgColor'
		localprint(f,'    background: %s;\n',getcolorspec(value));
	case 'font'
		localprint(f,'    font-family: %s;\n',value);
		% also :
		%  font-weigth
		%  font-style
		%  font-face
		%  text-decoration
	case 'fontSize'
		if ischar(value)
			localprint(f,'    font-size: "%s";\n',value);
		else
			localprint(f,'    font-size: "%dpt";\n',value);
		end
	case 'extra'
		localprint(f,'    %s;\n',value);
	otherwise
		error('!!!!unknown spec!!!')
	end
end

function s=printDef1(options)
% PRINTCSSDEF1 - Print 1 definition (for inline styles)
s='';
if isempty(options)
	return;
end
fields=fieldnames(options);
for i=1:length(fields)
	value=getfield(options,fields{i});
	switch fields{i}
	case 'border'
		s=[s sprintf(' border="%d"',value)];
	case 'color'
		s=[s ' color="' getcolorspec(value) '"'];
	case 'bgColor'
		
	case 'font'
		
	case 'fontSize'
	case 'extra'
	otherwise
		error('!!!!unknown spec!!!')
	end
end

function printstring(f,s)
% PRINTSTRING - Print a string to the file
%    Only some conversions are done of special characters.
s=strrep(s,'&','&amp;');
s=strrep(s,'<','&lt;');
s=strrep(s,'>','&gt;');
s=strrep(s,'�','&eacute;');
s=strrep(s,[char(13) char(10)],'<br>');
s=strrep(s,char(10),'<br>');
s=strrep(s,char(13),'<br>');
localprint(f,'%s',s);
assignin('caller','f',f)
% This is not so nice Matlab-code, but prevents adding
%     f=localp.... everywhere.

function [options,n]=setoptions(options,opt,value,forcevalue)
% SETOPTIONS - set option according to user supplied option
%   forcevalue means that a value is always given
%   n is 2 if value is used, 1 if value is not used (for determining
%       next value in 1d-lists

n=2;
switch lower(opt)
case 'maxcolarr'
	options.maxcolarr=value;
case 'maxrowarr'
	options.maxrowarr=value;
case 'maxel'
	options.maxel=value;
case 'forcehead'
	if isnumeric(value)
		options.printhead=value~=0;	% (value could be used but ...)
	elseif forcevalue
		if strcmp(value,'on')	% if value is not numeric or char a matlab-error will occur
			options.printhead=1;
		elseif strcmp(value,'off')
			options.printhead=0;
		else
			error('Invalid value for "forcehead"-option');
		end
	else
		options.printhead=1;
		n=1;
	end
case 'numform'
	options.numForm=value;
case 'emptyarray'
	options.emptyArray=value;
case 'emptycell'
	options.emptyCell=value;
case 'maxcolcell'
	options.maxcolcell=value;
case 'maxrowcell'
	options.maxrowcell=value;
case 'usecss'
	if isnumeric(value)
		options.useCSS=value~=0;	% (value could be used but ...)
	elseif forcevalue
		if strcmp(value,'on')	% if value is not numeric or char a matlab-error will occur
			options.useCSS=1;
		elseif strcmp(value,'off')
			options.useCSS=0;
		else
			error('Invalid value for "forcehead"-option');
		end
	else
		options.useCSS=1;
		n=1;
	end
case 'structborder'
	options.structStyle.border=value;
case 'structbolor'
	options.structStyle.color=value

case 'structbgcolor'
	options.structStyle.bgColor=value;
case 'structfont'
	options.structStyle.font=value;
case 'structfontsize'
	options.structStyle.fontSize=value;
case 'structextra'
	options.structStyle.extra=value;
case 'structcss'
	options.structStyle.CSS=value;
case 'cellborder'
	options.cellStyle.border=value;
case 'cellcolor'
	options.cellStyle.color=value;
case 'cellbgcolor'
	options.cellStyle.bgColor=value;
case 'cellfont'
	options.cellStyle.font=value;
case 'cellfontsize'
	options.cellStyle.fontSize=value;
case 'cellextra'
	options.cellStyle.extra=value;
case 'cellcss'
	options.cellStyle.CSS=value;
case 'title'
	options.title=value;
otherwise
	error(sprintf('Unknown option "%s"',opt))
end

function s=getcolorspec(value)
if isnumeric(value)
	if length(value)~=3
		error('If value is given for color, three elements has to be given.');
	end
	if any(value>1)	% values between 0 and 255 are expected (8-bit-format)
		s=sprintf('#%02x%02x%02x',min(255,max(0,value)));
	else	% values between 0 and 1 are expected (matlab-format)	
		s=sprintf('#%02x%02x%02x',min(255,max(0,value*255)));
	end
else
	s=value;
end

function localprint(f,varargin)
% localprint - for flexible ouput writing (to buffer or file)

if isstruct(f)
	s=sprintf(varargin{:});
	if length(f.buffer)<f.n+length(s)
		f.buffer(end+length(s)+1000)=char(0);
	end
	n=f.n+length(s);
	f.buffer(f.n+1:n)=s;
	f.n=n;
	assignin('caller','f',f)
	% This is not so nice Matlab-code, but prevents adding
	%     f=localp.... everywhere.
else
	fprintf(f,varargin{:});
end

