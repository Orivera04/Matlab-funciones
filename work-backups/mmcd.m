function newdir = mmcd(varargin)
%MMCD Change Working Directory. (MM)
% MMCD with no input arguments brings up a GUI for selecting a
%           desired working directory. See pushbutton definitions below.
% MMCD FUNC where FUNC is a function name changes the working
%           directory to the first matching directory containing the
%           function FUNC on the MATLABPATH. @directories are ignored.
% MMCD FUNC @ where FUNC is a function name changes the working
%           directory to the first matching directory containing the
%           function FUNC on the MATLABPATH including @directories.
% MMCD DIR where DIR is a (partial) directory name changes the working
%           directory to the first matching directory on the MATLABPATH.
% NEWDIR=MMCD(...) returns the new directory path to the string NEWDIR.
%
% GUI Pushbuttons:
% Matlab  - Go to the MATLAB root directory.
% Toolbox - Go to the MATLAB Toolbox directory.
% Restore - Return to the original directory.
% Close   - Quit and return to the command window.
%
% See also CD, PWD, DIR.

% Calls: mmfitpos.

% B.R. Littlefield, University of Maine, Orono, ME, 04469
% 4/28/97, 5/6/97, 8/3/99
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8

done = 0;
initdir = cd;
lastdir = initdir;
mydir = [];
atsign = 0;

%-------------------------------------------------------------------%
% Check that any argument is a string.
%-------------------------------------------------------------------%
if nargin > 0
   argstr=varargin{1};
   if ~isstr(argstr)
      error('Argument must be a string.');
   end 
   
   %-------------------------------------------------------------------%
   %  If the second argument is an @, include @subdirectories.
   %-------------------------------------------------------------------%
   
   if ((nargin > 1) & (varargin{2} == '@'))
      atsign = 1;
   end
   
   %-------------------------------------------------------------------%
   %  If the argument is a function name, select the appropriate directory.
   %-------------------------------------------------------------------%
   
   myx=[];
   pl=which(argstr,'-all');
   if ~isempty(pl)
      for idx=1:length(pl)
         mdir=char(pl(idx));
         if isempty(findstr('built-in',mdir))
            if ~isempty(findstr(argstr,mdir))
               if isempty(findstr('@',mdir))
                  mydir=char(mdir);
               else
                  if atsign == 1
                     mydir=char(mdir);
                  end
               end
               if ~isempty(mydir)
                  myx=findstr(filesep,mydir);
                  if length(myx) > 1
                     mydir=mydir(1:myx(end)-1);
                  end
                  break;
               end
            end
         end
      end
   end
   
   %-------------------------------------------------------------------%
   %  If the argument is a directory, go to the appropriate directory.
   %-------------------------------------------------------------------%
   
   if isempty(mydir)
      remains={};
      tmp={};
      myentries=length(findstr(matlabpath,pathsep));
      [tmp remains]=strtok(matlabpath,pathsep);
      if ~isempty(findstr(argstr,tmp))
         if ~isempty(findstr('@',tmp))
            if atsign
               mydir=char(tmp);
            end
         else
            mydir=char(tmp);
         end
      else
         for myindex=2:myentries+1
            [tmp remains]=strtok(remains,pathsep);
            if ~isempty(findstr(argstr,tmp))
               if ~isempty(findstr('@',tmp))
                  if atsign
                     mydir=char(tmp);
                  end
               else
                  mydir=char(tmp);
               end
            end
            if ~isempty(mydir), break; end
         end
      end
   end
   
   if ~isempty(mydir)
      eval('cd(mydir)', 'disp(''Invalid directory or permission denied.'')'); 
      if (nargout > 0)
         newdir = mydir; 
      else
         disp(mydir);
      end
      return
   else
      disp(['Directory ', argstr, ' not found.'])
      return
   end
   
end

%-------------------------------------------------------------------%
% Requested directory not found on matlabpath.
%-------------------------------------------------------------------%
%-------------------------------------------------------------------%
% The main loop begins here.
%-------------------------------------------------------------------%

while ~done 
   
   d = dir;
   if isempty(d)
      disp(['Cannot get a directory list in ',cd,'.']);
      cd(lastdir);
      d = dir;
   end
   lastdir = cd;
   
   %-----------------------------------------------------------------%
   % This is a workaround for a PC bug: some '..' directories
   % return a d.isdir value of 0 (false). (Assume singular '..')
   
   % The PC platform returns an error if the '..' directory is referenced
   
   % while in the root directory of a drive. Mac and Unix are OK.
   % On the MAC, 'dir' does not return '..'; so add an entry for '..'.
   % On PC and Unix platforms, remove the '.' directory entry.
   %-----------------------------------------------------------------%
   
   switch computer
   case 'PCWIN'
      d(strmatch('.',char(d.name),'exact')) = [];
      if ~isempty(d(strmatch('..',char(d.name),'exact')))
         d(strmatch('..',char(d.name),'exact')).isdir = 1;
      end   
   case 'MAC2'
      didx = length(d)+1;
      d(didx).name = '..'; d(didx).isdir = 1;
   otherwise
      d(strmatch('.',char(d.name),'exact')) = [];
   end
   
   %-----------------------------------------------------------------%
   % Split up directories and files.
   %-----------------------------------------------------------------%
   
   f = {d.isdir};
   ff = logical(cat(1,f{:}));
   dlist = {d(ff).name};
   flist = {d(~ff).name};
   
   %-----------------------------------------------------------------%
   % Sort the directory entries. Sort will not work with cells
   % so convert to a string array, sort, and convert back to cells.
   %-----------------------------------------------------------------%
   
   dlist = shiftdim(cellstr(sortrows(char(dlist{:}))),1);
   
   %-----------------------------------------------------------------%
   % Now we have a list of directories only - no file names.
   % Call the internal function local_mmcd to get a selection.
   % done is TRUE when the Close button was selected.
   % s contains the new directory or a flag representing a button press.
   %-----------------------------------------------------------------%
   
   [s,done] = local_mmcd(dlist);
   
   %-----------------------------------------------------------------%
   % If a button was pressed, change to the appropriate directory.
   % If a directory was selected, change to the new directory.
   %-----------------------------------------------------------------%
   
   if ~isempty(s)
      switch char(s)
      case 'CDmatlab', cd(matlabroot);
      case 'CDtoolbox', cd(fullfile(matlabroot,'toolbox'));
      case 'CDrestore', cd(initdir);
      otherwise, eval('cd(char(s))',...
            'disp(''Invalid directory or permission denied.'')'); 
         
      end %switch
   end   %if
end     %while

if nargout == 1, newdir = cd; end

%-------------------------------------------------------------------%
% The main loop ends here.
%-------------------------------------------------------------------%

return

%-------------------------------------------------------------------%
% The internal function local_mmcd puts up a GUI and processes input.
%-------------------------------------------------------------------%

function [selection,dflag] = local_mmcd(liststring)
% LOCAL_MMCD local function.

%-------------------------------------------------------------------%
% Define some variables and calculate some values.
%-------------------------------------------------------------------%

dflag = 0;
selection = [];
promptstring = cd;
switch computer
case 'PCWIN'
   ex_const = 2.8; fname = 'MS Sans Serif'; fsize = 8;
case 'MAC2'
   ex_const = 2.0; fname = 'Geneva'; fsize = 10;
otherwise
   ex_const = 1.8; fname = 'Helvetica'; fsize = 10;
end
ex = get(0,'defaultuicontrolfontsize')*ex_const;
listsize = [max(length(promptstring)*ex/2.8,186) ...
      max(100,min(300,length(liststring)*ex))];
runit = get(0,'units');
set(0,'units','pixels');
dfp = get(0,'defaultfigureposition');
set(0,'units',runit);
w = listsize(1)+32;
h = ex+listsize(2)+104;
fp = [dfp(1)-w/2 dfp(2)+0.6*dfp(4)-h w h];
fp = mmfitpos(fp,0,'pixels');
w = fp(3); h = fp(4);
btn_wid = (w-40)/2;

%-------------------------------------------------------------------%
% Get a figure.
%-------------------------------------------------------------------%

fig = findobj(0,'type','figure','tag','CDDLG');

if isempty(fig)
   
   %-----------------------------------------------------------------%
   % Create a new dialog box.
   %-----------------------------------------------------------------%
   
   fig = figure('name','Change Directory','resize','off',...
      'numbertitle','off','windowstyle','modal',...
      'defaultuicontrolfontname',fname,...
      'defaultuicontrolfontsize',fsize,...
      'createfcn','','integerhandle','off',...
      'position',fp,'tag','CDDLG','userdata','CDnotyet',...
      'closerequestfcn','set(gcf,''userdata'',''CDdone'')');
   
   %-----------------------------------------------------------------%
   % Add some frames, text, listbox, and buttons.
   %-----------------------------------------------------------------%
   
   figframe = uicontrol('style','frame', 'tag','figframe',...
      'position',[0 0 fp([3 4])]);
   
   butframe = uicontrol('style','frame','tag','butframe',...
      'position',[8 8 fp(3)-16 60]);
   
   listframe = uicontrol('style','frame','tag','listframe',...
      'position',[8 72 fp(3)-16 fp(4)-80]);
   
   prompt_text = uicontrol('style','edit','string',promptstring,...
      'tag','prompt_text',...
      'horizontalalignment','left','units','pixels',...
      'callback','set(gcf,''userdata'',''CDedit'')',...
      'position',[16 fp(4)-ex-16 listsize(1) ex]);
   
   listbox = uicontrol('style','listbox','string',liststring,...
      'backgroundcolor','w','position',[16 80 listsize],...
      'callback',...
      ['if strcmp(get(gcf,''SelectionType''),''open''),'...
         'set(gcf,''userdata'',''CDselected''),',...
         'end'],...
      'tag','listbox','value',1);
   
   rs_btn = uicontrol('style','pushbutton','string','Restore',...
      'tag','rs_btn','position',[16 14 btn_wid 22],...
      'callback','set(gcf,''userdata'',''CDrestore'')');
   
   ok_btn = uicontrol('style','pushbutton','string','Close',...
      'tag','ok_btn', 'position',[24+btn_wid 14 btn_wid 22],...
      'callback','set(gcf,''userdata'',''CDdone'')');
   
   ml_btn = uicontrol('style','pushbutton','string','Matlab',...
      'tag','ml_btn','position',[16 40 btn_wid 22],...
      'callback','set(gcf,''userdata'',''CDmatlab'')');
   
   tb_btn = uicontrol('style','pushbutton','string','Toolbox',...
      'tag','tb_btn','position',[24+btn_wid 40 btn_wid 22],...
      'callback','set(gcf,''userdata'',''CDtoolbox'')');
   
else
   
   %-----------------------------------------------------------------%
   % Use the existing dialog box, but resize as necessary.
   %-----------------------------------------------------------------%
   
   fp = get(fig,'position');
   fp = [fp(1) fp(2)+fp(4)-h w h];  
   fp = mmfitpos(fp,0,'pixels');
   set(fig,'position',fp);
   
   figframe = findobj(fig,'tag','figframe');
   set(figframe,'position',[0 0 fp([3 4])]);
   
   butframe = findobj(fig,'tag','butframe');
   set(butframe,'position',[8 8 fp(3)-16 60]);
   
   rs_btn = findobj(fig,'tag','rs_btn');
   set(rs_btn,'position',[16 14 btn_wid 22]);
   
   ok_btn = findobj(fig,'tag','ok_btn');
   set(ok_btn,'position',[24+btn_wid 14 btn_wid 22]);
   
   ml_btn = findobj(fig,'tag','ml_btn');
   set(ml_btn,'position',[16 40 btn_wid 22]);
   
   tb_btn = findobj(fig,'tag','tb_btn');
   set(tb_btn,'position',[24+btn_wid 40 btn_wid 22]);
   
   listframe = findobj(fig,'tag','listframe');
   set(listframe,'position',[8 72 fp(3)-16 fp(4)-80]);
   
   prompt_text = findobj(fig,'tag','prompt_text');
   set(prompt_text,'string',promptstring,...
      'position',[16 fp(4)-ex-16 listsize(1) ex]);
   
   listbox = findobj(fig,'tag','listbox');
   set(listbox,'string',liststring,'value',1,...
      'position',[16 80 listsize]);
   
end

%-------------------------------------------------------------------%
% Now wait around for something to happen.
%-------------------------------------------------------------------%

waitfor(fig,'userdata');

fig = findobj(0,'type','figure','tag','CDDLG');
if isempty(fig)
   error('Dialog box misplaced.')
else
   ud = get(fig,'userdata');
   
   %-----------------------------------------------------------------%
   % Determine the action to take based on the userdata string.
   %-----------------------------------------------------------------%
   
   switch ud
      
   case 'CDdone' 
      delete(fig); selection = []; dflag = 1;
      
   case {'CDrestore','CDmatlab','CDtoolbox'} 
      set(fig,'userdata','CDnotyet'); selection = ud;
      
   case 'CDselected' 
      set(fig,'userdata','CDnotyet'); 
      listbox = findobj(fig,'tag','listbox');
      selection = liststring(get(listbox,'value'));
      
   case 'CDedit' 
      set(fig,'userdata','CDnotyet');
      prompt_text = findobj(fig,'tag','prompt_text');
      selection = get(prompt_text,'string');
      
   otherwise, disp('Unknown userdata value');
      
   end
   
end


