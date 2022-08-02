function desGUIDE(filein,fout)
%   Simplify a GUI m file produced by GUIDE -> Export
%
% This function takes as input a m file produced by GUIDE -> Export and
% removes all dependecies of other GUIDE related function (that is gui_mainfcn).
% It also simplifies the resulting file from what I think (If I'm wrong please
% tell me in what and why) are many GUIDE redundant definitions (e.g. re-declaring
% uicontrols defaults).
% In this cleaning process, eventual (?)_CreateFcn functions exported by GUIDE are
% removed as well. I do this because I didn't find anything usefull in these
% functions that cannot be set directly in GUIDE. Again, If I'm wrong and you want
% to revert this policy comment the section tha follows the line that reads
% ------------------ Remove eventual original 'CreateFcn' declarations
%
% At the end we get a much shorter and self-contained m file (that is, it doesn't
% need a .fig file) with all declarations that make up your GUI. This file runs
% faster than the exported GUIDE file. When compiled the difference in speed may be
% substantial and it can be used in previous versions of Matlab.
% It also preserves the very confortabe way of transmiting variables between the
% various uicontrols trough the handles structure.
%
% As far as I can tell, we only loose two functionalities of the original GUIDE version
% 1.    The "singleton" feature    (but it can be added)
% 2.    The possibility of calling a local function from another m file (or command line)
%
% example:
%   desGUIDE('test_export.m','test.m')

%   Author:     Joaquim Luis
%   Created:    04-Sep-2004
%   E-mail:     jluis@ualg.pt
%   remark:     I couldn't have writen this program without the help of the
%               "findcell" function of the CSSM member <us>.

if (nargin ~= 2)
    error('desGUIDE: Error, wrong number of inputs')
end
if (~ischar(filein) & ~ischar(filein))
    error('desGUIDE: Error, both Input arguments must be of string (char array) type.')
end

[PATH,FNAME,EXT] = fileparts(filein);
if isempty(EXT)     filein = [filein '.m'];     end
[PATH,FNAME,EXT] = fileparts(fout);
if isempty(EXT)     fout = [fout '.m'];     end

try
    file = textread(filein,'%s','delimiter','\n','whitespace','');
catch
    error('desGUIDE: Error reading input file')
end

func_line = file{1};
ind1 = strfind(func_line,'=');
ind2 = strfind(func_line,'(');
[pathstr,func_name,ext,versn] = fileparts(filein);

res1 = findcell([func_name '_OpeningFcn'],file);    % Find the location of ..._OpeningFcn
res2 = findcell([func_name '_OutputFcn'],file);     % Find the location of ..._OutputFcn

[pathstr,fname_out,ext,versn] = fileparts(fout);
out = {['function varargout = ' fname_out '(varargin)']};
out{end+1} = '% M-File changed by desGUIDE ';
out{end+1} = ' ';
out = out';
% ------------------- Insert this peace of code that will build the figure and the handles structure
out{end+1} = ' ';
out{end+1} = ['hObject = figure(''Tag'',''figure1'',''Visible'',''off'');'];
out{end+1} = ['handles = guihandles(hObject);'];
out{end+1} = ['guidata(hObject, handles);'];
out{end+1} = [fname_out '_LayoutFcn(hObject,handles);'];
out{end+1} = ['handles = guihandles(hObject);'];
out{end+1} = ' ';
% ------------------- Get the rest of the original code in func_name_OpeningFcn and add some more new code
res3 = findcell('% UIWAIT makes ',file);
if (~isempty(findstr(file{res3.cn(1)+1},'% uiwait(')) | ...
        ~isempty(findstr(file{res3.cn(1)+1},'%uiwait(')) )   % If the gui does not use uiwait
    out{end+1} = 'set(hObject,''Visible'',''on'');';
    out = [out; file(res1.cn(end)+1:res2.cn(end)-2)];
    out{end+1} = '% NOTE: If you make uiwait active you have also to uncomment the next three lines';
    out{end+1} = ['% handles = guidata(hObject);'];
    out{end+1} = ['% out = ' fname_out '_OutputFcn(hObject, [], handles);'];
    out{end+1} = ['% varargout{1} = out;'];
    out{end+1} = '';
else                        % If the gui uses the uiwait function
    out = [out; file(res1.cn(end)+1:res3.cn(1)-1)];
    out{end+1} = 'set(hObject,''Visible'',''on'');';
    out = [out; file(res3.cn(1):res2.cn(end)-2)];
    % New code
    out{end+1} = ['handles = guidata(hObject);'];
    out{end+1} = ['out = ' fname_out '_OutputFcn(hObject, [], handles);'];
    out{end+1} = ['varargout{1} = out;'];
    out{end+1} = '';
end

% ------------------ Find the location of the ..._LayoutFcn function
res3 = findcell([func_name '_LayoutFcn'],file);
out = [out; file(res2.cn(end)-1)];
out{end+1} = ['function varargout = ' fname_out '_OutputFcn(hObject, eventdata, handles)'];
out = [out; file(res2.cn(end)+1:res3.cn(end)-1)];
out{end+1} = ['function ' fname_out '_LayoutFcn(h1,handles);'];
out{end+1} = '';

res4 = findcell('h1 = figure(...', file);
res5 = findcell('hsingleton = h1;', file);

% ------ Make a copy of the gui uicontrols declarations. It's faster to grep inside this smaller variable
last_txt = file(res4.cn+1:res5.cn-1);
clear file;

% ---- Search for those possible functions in figure declaration and replace them with the new solution
res = findcell('CloseRequestFcn', last_txt);
if (~isempty(res))
    last_txt(res.cn) = {['''CloseRequestFcn'',{@figure1_CloseRequestFcn,handles},...']};
end
res = findcell('KeyPressFcn', last_txt);
if (~isempty(res))
    last_txt(res.cn) = {['''KeyPressFcn'',{@figure1_KeyPressFcn,handles},...']};
end

% ----------------- Search and replace the 'Callback' original declaration by the new ones
res = findcell('''Callback''', last_txt);
if (~isempty(res))
    for i=1:length(res.cn)
        tmp = last_txt{res.cn(i)};
        ind1 = strfind(tmp,'(''');        ind2 = strfind(tmp,''''',');
        cb_name = tmp(ind1+3:ind2-1);
        last_txt(res.cn(i)) = {['''Callback'',{@' fname_out '_uicallback,h1,''' cb_name '''},...']};
    end
end

% ------------------ Remove eventual original 'CreateFcn' declarations
res = findcell('''CreateFcn''', last_txt);
if (~isempty(res))
    for i=1:length(res.cn)
        last_txt(res.cn(i)) = [];
    end
end

% Search and replace the eventual 'ButtonDownFcn' declaration by the new one
res = findcell('''ButtonDownFcn''', last_txt);
if (~isempty(res))
    for i=1:length(res.cn)
        tmp = last_txt{res.cn(i)};
        ind1 = strfind(tmp,'(''');        ind2 = strfind(tmp,''''',');
        cb_name = tmp(ind1+3:ind2-1);
        last_txt(res.cn(i)) = {['''ButtonDownFcn'',{@' fname_out '_uicallback,h1,''' cb_name '''},...']};
    end
end

% Remove this. Don't know why but if present, transforms the figure handle in somethying else but a valid handle
res = findcell('''IntegerHandle''', last_txt);
if (~isempty(res))
    last_txt(res.cn) = [];
end

% Remove this.
res = findcell('''Colormap''', last_txt);
if (~isempty(res))
    last_txt(res.cn) = [];
end
% And this.
res = findcell('''InvertHardcopy''', last_txt);
if (~isempty(res))
    last_txt(res.cn) = [];
end
% And this (empty strings)
res = findcell(['''String'','''','], last_txt);
if (~isempty(res))
    last_txt(res.cn) = [];
end

% Remove this. I think it's better to have the HandleVisibility set on and let the
% user decide if he wants to change it. The extra inside test is due to the fact that
% 'HandleVisibility' is (as far as I could find from trials) the last declaration in
% the uicontrol. So we have to assure that the uicontrol definition ends with a ');'
res = findcell('''HandleVisibility''', last_txt);
if (~isempty(res))
    res_close = findcell(')',last_txt(res.cn));
    if (~isempty(res_close))
        idx = findstr(last_txt{res.cn(end)-1},',...');
        last_txt{res.cn(end)-1} = [last_txt{res.cn(end)-1}(1:idx-1) ');'];
    end
    last_txt(res.cn) = [];
end

% Apaga estes Listbox. CUIDADO, SO QUANDO NAO HA LISTBOXES
res = findcell('ListboxTop', last_txt);
if (~isempty(res))
    last_txt(res.cn) = [];
end

% Append the uicontrols revised section to the out variable
out{end+1} = 'set(h1,...';
out = [out; last_txt];

%
out{end+1} = ['function ' fname_out '_uicallback(hObject, eventdata, h1, callback_name)'];
out{end+1} = ['% This function is executed by the callback and than the handles is allways updated.'];
out{end+1} = ['feval(callback_name,hObject,[],guidata(h1));'];

% FINISHED. Now write the new file
[m,n] = size(out);
fid = fopen(fout,'w');
for i=1:m
    fwrite(fid,out{i},'uchar');    fprintf(fid,'\n');
end
fclose(fid);

%--------------------------------------------------------------------------------
% [cixn,cixo] = findcell(key,ca,'-opt')
% cix         = findcell(key,ca,'-opt')
%
%	returns cell number:offset
%	of any occurrence of <key>
%	in the cell array <ca>
%
% key	search pattern
%	format
%		string
%		numeric
%
% ca	a row or col array of cell(s)
%	format
%		string(s)
%		numeric
%	classes must not be mixed
%
% cix	result vector(s)/struct
%	format
%		struct					[def]
%		[cell_nr offset]			[opt:     -p]
%		[cell_nr] [offset]			[nargout:  2]
%
% opt	parameter	action
%  -a :	-		search ACROSS cells
%  -p :	-		output <cix> as vector(s)	[def: struct]
%
% examples
%	ac={'xa';'xxa';'foo';'xaxa';'goo'};
%	findcell('a',ac)
%		% cell nr:offset   1   2
%		% cell nr:offset   2   3
%		% cell nr:offset   4   2
%		% cell nr:offset   4   4
%	nc={[1:10];pi;pi*[1:10]};
%	findcell(pi,nc)
%		% cell nr:offset   2   1
%		% cell nr:offset   3   1
%	findcell([pi pi],nc);
%		% findcell> key not found
%	findcell([pi pi],nc,'-a');
%		% cell nr:offset   2   1
%	zc={['this' 0 'is0'];[0 0 0 'this' 0 'is0']};
%	findcell(['is' 0],zc);
%		% cell nr:offset   1   3
%		% cell nr:offset   2   6
%
% remark
%	program based on a problem by
%	CSSM member <michael robbins>
%	<Vectorizing FINDSTR> (3/11/03)

% search engine
%	since <findstr> does not find <nan>s, we use <nan>s as
%	stop markers after each cell to prevent <across> results,
%	which is the default behavior
%	cellarray
%		cell1 {nan}
%		cell2 {nan}
%		...
%		cellN {nan}
%
%	since <nan>s cannot be converted to <char>s, we must
%	convert cells containing string arrays to double

% created:
%	us	12-Mar-2003
% modified:
%	us	14-Mar-2003 20:40:37	/ TMW

%--------------------------------------------------------------------------------
function varargout = findcell(k,c,varargin)
% check input/output
if	nargout
	varargout=cell(nargout,1);
end
if	nargin < 2 | isempty(k) | isempty(c)
    %help(mfilename);
    return;
end
[p,k,c] = chk_input(k,c);
if (p.res)  return;     end

% get/set options
mat=[];
p=get_opt(p,varargin{:});

% precondition key/cells
c=c(:);
cs=length(c);
cl=length([c{:}]);

if (p.cflg)
    % ... do NOT search across <cell>s
	if (ischar(k) & all(p.isc))
		k=double(k);
		inn=cellfun('length',c)';
		c=[c num2cell(0*ones(cs,1))];
		c=reshape(c.',1,2*cs);
		in=cellfun('length',c)';
		c=double([c{:}]);
		c(cumsum(inn+1))=nan;
	elseif	isnumeric(k) & all(p.isn)
		c=[c num2cell(nan*ones(cs,1))];
		c=reshape(c.',1,2*cs);
		in=cellfun('length',c)';
		c=[c{:}];
	else
		disp(sprintf('findcell> unexpected error'));
		return;
	end
else
    % ...	do search across <cell>s
	in=cellfun('length',c)';
	c=[c{:}];
end

% find indices
ix=findstr(k,c);
if	~isempty(ix)
	[mx,mn]=meshgrid(ix,cumsum(in)-in);
	crow=sum(mx>mn,1)';
	if	p.cflg
		crow=.5*(crow-1)+1;
	end
	cix=find(crow==fix(crow));
	ccol=mx-mn;
	ccol(ccol<=0)=nan;
	ccol=min(ccol,[],1)';
	mat=[crow(cix) ccol(cix)];
end

% prepare output
if (isempty(mat))
	%disp('findcell> key not found');
	return;
end
if (nargout == 1)
	if	p.pflg
		varargout{1}.par=p;
		varargout{1}.csiz=cl;
		varargout{1}.cn=mat(:,1);
		varargout{1}.co=mat(:,2);
		varargout{1}.cno=mat;
	else
		varargout{1}=mat;
	end
	elseif	nargout == 2
		varargout{1}=mat(:,1);
		varargout{2}=mat(:,2);
	else	% no output requested
		disp(sprintf('cell nr:offset %8d %8d\n',mat.'));
end

%--------------------------------------------------------------------------------
function [p,k,c] = chk_input(k,c)
% must do extensive checking ...
p.res=0;
p.key=k;
p.cs=prod(size(c));
p.cl=length(c);
if	p.cs ~= p.cl
	txt=sprintf('%d/',size(c));
	disp(sprintf('findcell> input must be a ROW or COL array of cells [%s]',txt(1:end-1)))
	p.res=1;
	return;
end
if	~iscell(c)
	disp(sprintf('findcell> input must be a CELL array [%s]',class(c)));
	p.res=2;
	return;
end
p.isc=cellfun('isclass',c,'char');
p.isn=cellfun('isclass',c,'double');
if	sum(p.isc) ~= p.cs & sum(p.isn) ~= p.cs
	disp(sprintf('findcell> input contains invalid or mixed classes'));
	p.res=3;
	return;
end
if	any(isnan(k))
	disp(sprintf('findcell> numeric key must NOT include <NaN>s'));
	p.res=4;
	return;
end
if	ischar(k) & all(p.isn)
	p.res=5;
	disp(sprintf('findcell> input mismatch: key(char) / cells(double)'));
	return;
end
if	isnumeric(k) & all(p.isc)
	k=char(k);
end
%--------------------------------------------------------------------------------
function p = get_opt(p,varargin)
p.cflg=1;	% do NOT search across <cell>s
p.pflg=1;	% output is a <struct>

if	nargin
	if	any(strcmp('-a',varargin))
		p.cflg=0;
	end
	if	any(strcmp('-p',varargin))
		p.pflg=0;
	end
end

