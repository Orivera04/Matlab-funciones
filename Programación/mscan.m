function mscan(name,varargin)
%   MSCAN     Version 1.0 Copyright (C) Peter Rydesäter 1998-12-13 -
%
%             This makes your m-files look better and helps
%             you find non matching for,if,while,try,else
%             ,end . . .
%
%             Tested with matlab 5.x 
%
% Syntax: 
%
%   mscan name option
%   mscan(name,option)
%
%             name is filename with/without path and can also
%             hold wildcard (*) to work on multiple files. If an
%             optional string argument with an 'r' in is added
%             it will work on ALL sub directories.
%
%             Updates m-files, replaces tabs with spaces and
%             indents for block structures. Also fixes end of
%             line:       windows (^M ) <--> unix
%             It works with wildcards and can
%
%             Use with care. Backup your m-files first!
%
% 
%
% Example 1:
%             mscan /home/mrxx/matlab/*.m  r
%         OR
%             mscan('/home/mrxx/matlab/*.m','r')
%
%         Converts all *.m files in the path and sub
%         derectories.( Optional r.)
% 
% Example 2:
%             mscan('test*.m');
%         OR
%             mscan test*.m
%
%         Converts all m-files beginning with 'test' in
%         current dir. No sub directories.
%
%
%  This program is free software; you can redistribute it and/or
%  modify it under the terms of the GNU General Public License
%  as published by the Free Software Foundation; either version 2
%  of the License, or (at your option) any later version.
%
%  This program is distributed in the hope that it will be useful,
%  but WITHOUT ANY WARRANTY; without even the implied warranty of
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%  GNU General Public License for more details.


%  You should have received a copy of the GNU General Public License
%  along with this program; if not, write to the Free Software
%  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
%  02111-1307, USA.
%
%  Please send me an e-mail if you use this: 
%  Peter.Rydesater@ite.mh.se
%  Mitthögskolan
%  Östersund
%  Sweden
%  
    
    subdir=0;
    inter=1;
    tbsize=2;
    casesub=2;
    level=0;
    lastwasfun=0;
    
    for a=1:length(varargin),
        if strcmp(upper(varargin{a}),'R'),
            subdir=1;
        elseif strcmp(upper(varargin{a}),'NI'),
            inter=0;
        end
    end
    
    if inter,
        r=input('Have you backed up your *.m files or some outher safety rutine? (y/n)','s');
        
        if strncmp(r,'y',1)==0,
            disp('Then you better do that first!');
            return;
        end
        
        disp('Processing following files:');
        
        
        if strncmp(findrevend(name),'m.',2)==0,
            disp('Not matlab *.m file');
            return;
        end
    end
    
    if subdir,
        [dirname,filename,extname]=fileparts(name);
        dirnames=dir(dirname);
        for a=1:length(dirnames),
            if strncmp(dirnames(a).name,'.',1),        % Not .* directorys
            elseif dirnames(a).isdir,                  % Recursive call if it's a directory
                mscan(fullfile(dirnames(a).name,[filename extname]),'R','NI');
            end
        end
    end
    
    % Operatiors for start of move in...
    start_op=strvcat('if','else','elseif','function','for',...
          'switch','otherwise','while','try','catch');
    
    % Operation for end of move in...
    stop_op=strvcat('end','else','elseif','otherwise','catch');
    
    % Reversed ordered letters for operators ending move in in the end of line.
    end_op_at_end=strvcat('dne');
    
    % Converts a tab to a space
    asciiconv=char([1:255]);
    asciiconv(9)=' ';
    
    names=dir(name);
    
    for a=1:length(names),
        disp(names(a).name);
        file=fopen(names(a).name,'r');
        line=1;
        while(1),
            buff=fgetl(file);
            if ~isstr(buff), break, end %here is a coment at the end
            filebuff{line}=pr_str_trim(asciiconv(double(buff)));
            line=line+1;
        end
        fclose(file);
        
        level=0;
        file=fopen(names(a).name,'w');
        for line=1:length(filebuff),
            if length(filebuff)<=line & length(filebuff{line})==0,
                fprintf(file,'\n');
            else
                [x,y]=strtok(filebuff{line},' ()');
                x=lower(pr_str_trim(x));
                if strcmp('function',x),
                    level=0;
                    lastwasfun=1;
                end
                if strmatch(x,stop_op,'exact') & level>0 & length(x)>0,
                    level=level-1;
                end
                if strncmp(filebuff{line},'%%',2) | ...
                          (strncmp(filebuff{line},'%',1) & lastwasfun)
                    fprintf(file,'%s\n',filebuff{line});
                else
                    fprintf(file,'%s%s\n',blanks(level*tbsize-casesub*strcmp('case',x)),filebuff{line});
                    if strcmp('function',x)
                        lastwasfun=1;
                    elseif length(x)==0
                        lastwasfun=lastwasfun; % Do nothing empty line.
                    else
                        lastwasfun=0;
                    end
                end
                if strmatch(x,start_op,'exact') & length(x)>0,
                    level=level+1;
                end
                x=findrevend(filebuff{line});
                if strncmp(x,'...',3),
                    fprintf(file,blanks(ceil(tbsize*1.5)));
                end
                [x,y]=strtok(x,' ,;');
                if strmatch(x,end_op_at_end,'exact') & level>0 & length(x)>0 & length(deblank(y))>2,
                    level=level-1;
                end
            end
        end
        clear line
        clear filebuff
        fclose(file);
    end
    return;
    
    
function ret=findrevend(str)
% Picks out end of line before comment in reverse order with blanks
% in beginning and end removed.
    
    deblank(str);
    isstr=0;
    for a=1:length(str),
        if str(a)==char(39),
            isstr= ~isstr;
        elseif str(a)=='%' & isstr==0,
            a=a-1;
            break;
        end
    end
    ret=deblank(str(a:-1:1));
    return;
    
function ret=pr_str_trim(str)
    
% ret=pr_str_trim(str)  Removes blanks in both beginninge and end of line.
%
% Peter Rydesäter 99-04-06
%
    str=deblank(str(end:-1:1));
    ret=deblank(str(end:-1:1));
    return; 
