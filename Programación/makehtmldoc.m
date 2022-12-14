function makehtmldoc(filename,varargin)
%MAKEHTMLDOC Create HTML help files from a set of M-Files
%   MAKEHTMLDOC(FILENAME) creates an html help file for each M-File
%   matching FILENAME. This help file contains the header of the M-File
%   (the first block of contiguous comment lines, see HELP for details),
%   with links between each M-File matching FILENAME referencing each
%   other.
%
%   If no input argument specified, works with all the M-files of the
%   current directory (ie, MAKEHTMLDOC('*.m')).
%
%   MAKEHTMLDOC(FILENAME, 'Property1', 'Property2'...) where 'Property.'
%   may be:
%
%     'code'               adds a link to the source code (except for the
%                          file 'Contents.m');
%     'upper'              makes a link only for words in upper case.
%     'quiet'              does not display informations during the
%                          processing.
%     'color', string      any HTML color code for the upper and lower
%                          panels. Default = '#e7ebf7'.
%     'title', string      title of the browser window. Default = '\f'.
%     'firstline', string  text at the top of the page. Default =
%                          'Contents'.
%     'lastline', string   text at the bottom of the page. Default = ''.
%
%   Note: In the string of the last three properties, '\f' will be replaced
%   by the name of the current M-file. Web links may be used, e.g.
%   string = '\f (<a href="MyToolbox.html">MyToolbox</a>)'
%
%   MAKEHTMLDOC works essentially as Matlab's DOC function, except that the
%   links are only established between the set of files matching FILENAME.
%   So the resulting set of HTML pages only have link between themselves,
%   and will not have broken links when consulted from an external web
%   site.
%
%   Examples:
%      makehtmldoc('*.m','code')  produces a set of *.html help files for
%      all the *.m files of the current directory, with a link to the
%      corresponding source code.
%
%      makehtmldoc('*.m','title','\f (MyToolbox)','lastline','(c) 2006');
%
%      makehtmldoc('*.m', ...
%                  'color', '#ffff00', ...
%                  'title', 'Help for \f', ...
%                  'firstline', '<a href="Contents.html">Back</a>', ...
%                  'lastline', '<a href="www.mytoolbox.com">MyToolBox</a>', ...
%                  'upper', 'code');
%
%   F. Moisy
%   Revision: 1.22,  Date: 2006/10/30.
%
%   See also HELP, DOC, WEB.

% History:
% 2005/10/18: v1.00, first version.
% 2005/10/19: v1.02, process the 'See Also' section.
% 2005/10/20: v1.03, option 'quiet' added.
% 2005/10/22: v1.04, prev and next in the upper menu bar added
% 2005/10/28: v1.05, prev and next instead of < and >.
% 2005/11/01: v1.06, <pre> mode (keeps normal white spaces instead of &nbsp;)
% 2006/06/02: v1.10, works with varargin input arguments
% 2006/06/16: v1.11, minor bug fixed with docstyle.css
% 2006/07/21: v1.12, option 'lastline' added
% 2006/09/04: v1.13, options 'title' and 'contentspage' added
% 2006/09/06: v1.20, renamed 'makehtmldoc' (was named m2html before).
%                    upper table modified (options 'firstline' and 'color'
%                    added)      
% 2006/10/24: v1.21, link to contents.html only if contents.m exists
% 2006/10/30: v1.22, process the 'Example' section.


if nargin==0,
    filename='*.m';
end;

listefilename=dir(filename);
listefilename={listefilename.name};

if ~length(listefilename)
    error('No file match.');
end;

% iscontents is 1 if the file 'Contents.m' is present, 0 otherwise:
iscontents=any(strcmp(listefilename,'Contents.m'));

% color of upper and lower table (new v1.20)
if any(strncmpi(varargin,'color',3)),
    colortable = varargin{1+find(strncmpi(varargin,'color',3),1,'last')};
else
    colortable = '#e7ebf7';
end;

for f=1:length(listefilename),
    nbrelink=0;
    filename=listefilename{f};
    [pathstr,name,ext] = fileparts(filename);
    if ~strcmp(ext,'.m'),
        error([filename ' is not an M-file.']);
    end;
    htmlfilename=fullfile(pathstr,[name '.html']);
    fid=fopen(htmlfilename,'w');
    if fid==-1
        error(['Can''t create ' htmlfilename]);
    end;

    % title of the html page (new v1.13):
    if any(strncmpi(varargin,'title',3)),
        titlehtmlpage = varargin{1+find(strncmpi(varargin,'title',3),1,'last')};
    else
        titlehtmlpage = '\f';
    end;
    titlehtmlpage = strrep(titlehtmlpage,'\f',name);
    
    % head of the html page:
    fprintf(fid,'%s\n',['<html><head><title>' titlehtmlpage '</title>']);
    fprintf(fid,'%s\n',['<!-- Help file for ' name '.m generated by makehtmldoc 1.22, ' datestr(now) ' -->']);
    fprintf(fid,'%s\n','<!-- makehtmldoc (F. Moisy, 2005-2006), see http://www.fast.u-psud.fr/~moisy/ml/ -->');
    fprintf(fid,'%s\n',' ');
    fprintf(fid,'%s\n','<link rel=stylesheet href="docstyle1.css" type="text/css">');
    fprintf(fid,'%s\n','</head>');
    fprintf(fid,'%s\n','<body bgcolor=#ffffff>');

    % upper table: links to the code source (if option 'code') and to the
    % Contents file (if present), except for the Contents.m file itself:
    if ~strcmpi(name,'contents'),
        headfline='<table width="100%" border=0 cellpadding=0 cellspacing=0><tr>';
        tailfline='</tr></table>';
        if iscontents
            firstlinetext='<a href="Contents.html">Contents</a>';
            if any(strncmpi(varargin,'firstline',4))
                firstlinetext = varargin{1+find(strncmpi(varargin,'firstline',4),1,'last')};
                firstlinetext = strrep(firstlinetext,'\f',name);
            end;
        else
            firstlinetext=name;
        end
        fline1=['<td valign=baseline bgcolor="' colortable '"><b>' firstlinetext '</b></td>'];

        if any(strncmpi(varargin,'code',3))
            fline2=['<td valign=baseline bgcolor="' colortable '" align=center>&nbsp;<a href="matlab:open ''' name '.m''"><b>View code</b></a></td>'];
        else
            fline2='';
        end;
        
        if length(listefilename)>1,
            fline3=['<td valign=baseline bgcolor="' colortable '" align=right>'];
            if f>1,
                [pathstr prevfname ext]=fileparts(listefilename{f-1});
                fline3=[fline3 '<a href="' prevfname '.html"><b>&lt;&lt; Prev</b></a>&nbsp;'];
            else
                fline3=[fline3 '<b>&lt;</b>&nbsp;'];
            end;
            if f<length(listefilename),
                [pathstr nextfname ext]=fileparts(listefilename{f+1});
                fline3=[fline3 '|&nbsp;<a href="' nextfname '.html"><b>Next &gt;&gt;</b></a>&nbsp;'];
            else
                fline3=[fline3 '|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'];
            end;
            fline3=[fline3 '</td>'];
        else
            fline3='';
        end;
        fprintf(fid,'%s\n',[headfline fline1 fline2 fline3 tailfline]);
    end;

    helptext=help(filename);

    % suppress the 'overloaded ...' part (for Contents.m file)
    pover=strfind(helptext,'Overloaded');
    if length(pover),
        helptext=[helptext(1:(pover-1)) char(10)];
    end;

    % number of initial spaces to jump at each line
    % (this value may be overestimated):
    firstchar=6;

    remhelptext=helptext; % initialize the remainder of the help text
    firstline = true;
    while length(remhelptext),
        %extracts the first line of the remainder of the help text:
        pnextenter=strfind(remhelptext,10); pnextenter=pnextenter(1);
        curline=remhelptext(1:(pnextenter-1)); % current line

        % removes the < and > signs (confusion with html syntax):
        curline=strrep(curline,'<','&lt;');
        curline=strrep(curline,'>','&gt;');

        if firstline, % the first line of the help text is the name of the function
            if ~strcmpi(name,'contents'),
                fprintf(fid,'%s\n',['<font size=+3 color="#990000">' lower(name) '</font><br>']);
                [token,remline]=strtok(curline);
                fprintf(fid,'%s\n',[strtrim(remline) '<br>']);
            else
                fprintf(fid,'%s\n',['<font size=+3 color="#990000">' curline '</font><br>']);
            end;
            fprintf(fid,'%s\n','<br>');
            fprintf(fid,'%s\n',' ');
            if ~strcmpi(name,'contents'),
                fprintf(fid,'%s\n','<font size=+1 color="#990000"><b>Description</b></font>');
            end;
            fprintf(fid,'%s\n','<code><pre>');
            firstline = false;
        else
            % removes the first white spaces:
            curline=[curline '           '];
            while ~isequal(curline(firstchar-1),' '),
                firstchar=firstchar-1; %
            end;
            curline=deblank(curline(firstchar:end));

            % detects the 'See Also' section  (v1.01)
            pseealso=strfind(lower(curline),'see also');
            if ((length(pseealso))&&(length(curline)>2)),
                pseealso=pseealso(1);
                fprintf(fid,'%s\n','</pre>');
                fprintf(fid,'%s\n','<font size=+1 color="#990000"><b>See Also</b></font>');
                fprintf(fid,'%s\n','<pre>');
                curline=curline((pseealso+9):end);
                seealsotoken=strtok(curline);
                pp=strfind(curline,seealsotoken); pp=pp(1); % position of the first character of the "see also" words
                curline=curline(pp:end);
            end;
            
            % detects the 'Examples' line (v1.22)
            if length(curline)>=7,
                pexample=strfind(lower(curline(1:7)),'example');
                if length(pexample)
                    fprintf(fid,'%s\n','</pre>');
                    if (strncmpi(curline,'examples',8))
                        fprintf(fid,'%s\n','<font size=+1 color="#990000"><b>Examples</b></font>');
                    else
                        fprintf(fid,'%s\n','<font size=+1 color="#990000"><b>Example</b></font>');
                    end;
                    fprintf(fid,'%s\n','<pre>');
                    curline=curline(8:end);
                    psc=findstr(curline,':');
                    if length(psc)
                        curline=curline((psc(1)+1):end);
                    end;
                end;
            end;
            
            remline=curline; % remainder of the current line

            while length(remline),
                [token, newremline] = strtok(remline,' ,.;:!?()[]{}"''=+-*/'); % next word
                if length(token)
                    pnextword=strfind(remline,token); pnextword=pnextword(1); % position of the next word
                    fprintf(fid,'%s',remline(1:(pnextword-1))); % writes the characters before % changed v1.06
                    makelink=0;
                    if strcmpi(token,name)
                        makelink=-1; % if the word is the filename itself, displays it in bold
                    else
                        if logical(sum(ismember(listefilename,lower([token '.m'])))),
                            if any(strncmpi(varargin,'upper',1))
                                makelink=strcmp(token,upper(token)); % makes a link only if the word is in upper case
                            else
                                makelink=1;
                            end;
                        end;
                    end;
                    if makelink==1
                        fprintf(fid,'%s',['<a href="' lower(token) '.html">' lower(token) '</a>']);
                        nbrelink=nbrelink+1;
                    elseif makelink==-1,
                        fprintf(fid,'%s',['<b>' lower(token) '</b>']);
                    else
                        fprintf(fid,'%s',token);   % no link for this word
                    end;
                else  % if no word found until the end of the line, simply writes the end of the line:
                    fprintf(fid,'%s',remline);
                end;
                remline=newremline;
            end;
            fprintf(fid,'%s\n',' '); % end of the line
        end;
        remhelptext=remhelptext((pnextenter+1):end); % new remainder
    end;
    fprintf(fid,'%s\n','</pre></code>');  % end of "code" section

    fprintf(fid,'%s\n',' ');

    % lower table (links to the previous and next filenames):
    if ~strcmpi(name,'contents'),
        if length(listefilename)>1,
            headfline=['<table width="100%" border=0 cellspacing=0 bgcolor="' colortable '"><tr>'];
            tailfline='</tr></table><br>';
            if f==1,
                fline1='<td>&nbsp;</td>';
            else
                [pathstr prevfname ext]=fileparts(listefilename{f-1});
                fline1=['<td>&nbsp;<a href="' prevfname '.html"><b>Previous: ' prevfname '</b></a></td>'];
            end;
            if f==length(listefilename),
                fline2='<td align=right>&nbsp;</td>';
            else
                [pathstr nextfname ext]=fileparts(listefilename{f+1});
                fline2=['<td align=right><a href="' nextfname '.html"><b>Next: ' nextfname '</b></a>&nbsp;</td>'];
            end;
            fprintf(fid,'%s\n','<br>');
            fprintf(fid,'%s\n',[headfline fline1 fline2 tailfline]);
        end;
    end;

    % foot of the html page:
    if any(strncmpi(varargin,'lastline',4)),
        lastline = varargin{1+find(strncmpi(varargin,'lastline',4),1,'last')};
        lastline = strrep(lastline,'\f',name);
        fprintf(fid,'%s\n',[lastline '<br>']);
    end;
    
    fprintf(fid,'%s\n','<br>');
    if ~any(strncmpi(varargin,'noadver',4)),  % hidden option: 'noad'
        fprintf(fid,'%s\n','<font size=-1>Help file generated by <a href="http://www.fast.u-psud.fr/~moisy/ml" target="_blank">makehtmldoc 1.22</a></font><br>');
    end;
    fprintf(fid,'%s\n','</body></html>');
    fclose(fid);

    % new v1.02
    if ~any(strncmpi(varargin,'quiet',1)),
        disp([name '.m --> ' name '.html  [' num2str(nbrelink) ' links]']);
    end;
end;

