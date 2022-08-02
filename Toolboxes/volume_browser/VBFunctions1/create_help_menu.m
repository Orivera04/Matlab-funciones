function create_help_menu(figure_handle)


%	Check if a help file exists
path=fileparts(which('volume_browser'));
if ~exist(path,'dir')
   alert('Help-file directory has not been found. No help button created.')
   return
end

callback=@help4BV;
menuid = uimenu(figure_handle,'Label',' Need help? ','ForegroundColor','red');

uimenu(menuid,'Label','General','Callback', ...
              {callback,path,figure_handle,'help4VB_general'})
uimenu(menuid,'Label','Explore volume','Callback', ...
              {callback,path,figure_handle,'help4VB_explore'})

uimenu(menuid,'Label',' &About ','Separator','on','enable','on', ...
    'CallBack',{@about_callback,figure_handle});


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function help4BV(varargin)

% path=fileparts(which('volume_browser'));
path=varargin{3};
figure_handle=varargin{4};
funct=varargin{5};

%	Check if a help file exists
hfile=[funct,'.txt'];
filename=fullfile(path,'HelpFiles',hfile);

%	Read help file
try
   help_info=textread(filename,'%s','delimiter','\n');
catch
   alert(['Help file "',hfile,'" has not been found.'])
   return
end

handle=helpdlg(help_info,'Volume Browser Help');

add_handle2delete1(handle,figure_handle)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function about_callback(varargin)

% global V3D_HANDLES

createmode.Interpreter='tex';
createmode.WindowStyle='modal';
handle=msgbox({...
'Matlab function to vizualize 3D Data; release 1.01';
'Copyright \copyright 2006  Eike Rietsch';
' ';
'This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.';
' ';
'This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.';
' ';
'You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.'
},createmode);

%	Store handle of message box so that it can be deleted (if it 
%       still exists) upon closing of the browser 

add_handle2delete1(handle,varargin{3})
