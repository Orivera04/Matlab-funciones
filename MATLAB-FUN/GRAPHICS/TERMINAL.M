function terminal(ttype)
%TERMINAL Set graphics terminal type.
%
%	TERMINAL puts up a menu of graphics terminal types and prompts for
%	a choice.  It then configures MATLAB. You can also specify the
%	terminal type as the first parameter.
%	You can add any terminal settings you may need for your specific
%	emulators/terminals to this file.
%
%	The graphics terminals that are currently supported are:
%
%	tek401x - Tektronix 4010/4014
%	tek4100 - Tektronix 4100
%	tek4105 - Tektronix 4105
%	retro - retrographics card
%	sg100 - Selanar graphics 100
%	sg200 - Selanar graphics 200
%	vt240tek - VT240 & VT340 Tek mode
%	ergo - ergo terminal
%	graphon - graphon terminal
%	citoh - C.Itoh terminal
%	xtermtek - xterm, Tektronix graphics
%	wyse - Wyse WY-99GT
%	kermit - MS-DOS Kermit 2.23
%	hp2647 - Hewlett-Packard 2647
%	versa - Macintosh with VersaTerm (Tektronics 4010/4014)
%	versa4100 - Macintosh with VersaTerm (Tektronics 4100)
%	versa4105 - Color/Grayscale Macintosh with VersaTerm (Tektronics 4105)
%	hds - Human Designed Systems

%	Copyright (c) 1984-94 by The MathWorks, Inc.

c = computer;
if strcmp(c(1:2),'PC') | strcmp(c(1:3),'MAC')
   return
end

if nargin == 0,
	s0 = 'Graphics Terminal Types';
	s1 = 'C.Itoh';
	s2 = 'Ergo';
	s3 = 'Graphon';
	s4 = 'HP 2647';
	s5 = 'Human Designed Systems';
	s6 = 'Kermit';
	s7 = 'Macintosh with VersaTerm (Tektronix 4010/4014)';
	s8 = 'Macintosh with VersaTerm (Tektronix 4100)';
	s9 = 'Macintosh (Color/Grayscale) with VersaTerm (Tektronix 4105)';
	s10 = 'Tektronix 4010/4014';
	s11 = 'Tektronix 4100';
	s12 = 'Tektronix 4105';
	s13 = 'More selections - - - ';
	s14 = 'VT100 with Retrographics';
	s15 = 'VT100 with Selanar 100';
	s16 = 'VT100 with Selanar 200';
	s17 = 'VT-240 & VT340 Tek mode';
	s18 = 'Wyse WY-99GT';
	s19 = 'xterm (Tektronics emulation)';
	s20 = 'Back to main menu'
	s21 = 'Cancel';

	flag = 1;

	while flag,
		clc
		i=menu(s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13);
		if i == 13
			clc
			i = i + menu(s0,s14,s15,s16,s17,s18,s19,s20,s21) - 1;
		end
		if i >= 20 | i <= 0
			return
		end
		if i ~= 19,
			flag = 0;
		end
	end
	
	ttype = i;

else
	termtab = [
		'citoh    '
		'ergo     '
		'graphon  '
		'hp2647   '
		'hds      '
		'kermit   '
		'versa    '
		'versa4100'
		'versa4105'
		'tek401x  '
		'tek4100  '
		'tek4105  '
		'retro    '
		'sg100    '
		'sg200    '
		'vt240tek '
		'wyse     '
		'xtermtek '
	];
	t = 0;
	for tt=1:18,
		l = min(length(ttype),length(termtab(tt,:)));
		if (strcmp(ttype,termtab(tt,1:l))),
			t = tt;
			break;
		end
	end
	if t == 0,
		if ~exist(ttype),
			error(['Invalid terminal type ' ttype]);
		else
			eval(ttype);
			return;
		end
	end
	ttype = t;
end


% Some control characters
esc = 27;
nl = 10;
ret = 13;
ff = 12;
alphamode = 31;
graphmode = 29;
can = 24;
ctrlc = 3;
nul = 0;

% This gets disp'ed at the end after the settings are done
% to initialize certain terminal characteristics right away.
% See Tektronix 4105 below for an example of why you'd want to use this.
init_str = [];


if (ttype == 1),
% C. Itoh
	showgraph = [esc '[H' esc '[2J' esc '1' esc '*'];
	hidegraph = [esc ff esc '8' esc '2' esc '[A'];
	screendepth = 1;
	onewindow = 'yes';
	tp = 'tek401x';

elseif (ttype == 2),
% Ergo
	showgraph = [esc '[H' esc '[2J' esc '1' esc '*'];
	hidegraph = [esc ff esc '8' esc '0' esc '2'];
	screendepth = 1;
	onewindow = 'yes';
	tp = 'tek401x';

elseif (ttype == 3),
% Graphon
	showgraph = [esc '[H' esc '[2J' esc '1'];
	hidegraph = [esc ff esc '8' esc '2'];
	screendepth = 1;
	onewindow = 'yes';
	tp = 'tek401x';

elseif (ttype == 4),
% HP2647
	showgraph = [esc '[H' esc '[2J' esc '&s1p0Q' nul];
	hidegraph = [esc ff esc '8' esc '&s0p0Q' nul esc '*dT'];
	screendepth = 1;
	onewindow = 'yes';
	tp = 'tek401x';

elseif (ttype == 5),
% HDS
	showgraph = setstr(graphmode);
	hidegraph = [can esc '[A'];
	screendepth = 1;
	onewindow = 'yes';
	tp = 'tek401x';

elseif (ttype == 6),
% Kermit
	showgraph = [esc '[?38h'];
	hidegraph = [esc '[?38l'];
	screendepth = 1;
	onewindow = 'yes';
	tp = 'tek401x';

elseif (ttype == 7),
% Versaterm (Tektronix 4010/4014)
	showgraph = [esc '%!8' esc ff graphmode];
	hidegraph = [esc '2'];
	screendepth = 1;
	onewindow = 'no';
	tp = 'tek401x';

elseif (ttype == 8),
% Versaterm (Tektronix 4100)
	showgraph = [esc '%!0' graphmode];
	hidegraph = [esc '%!2'];
	init_str = [esc '%!0' esc 'TF43000' esc 'LI133' esc 'KA0' esc 'LV0'];
	init_str = [init_str esc 'RW `` @8co?_' nl esc 'RA!  ' esc 'MC'];
	screendepth = 1;
	onewindow = 'no';
	tp = 'tek410x';

elseif (ttype == 9),
% Versaterm (Tektronix 4105 color)
	showgraph = [esc '%!0' graphmode];
	hidegraph = [esc '%!2'];
	init_str = [esc '%!0' esc 'TF43000' esc 'LI133' esc 'KA0' esc 'LV0'];
	init_str = [init_str esc 'RW `` @8co?_' nl esc 'RA!  ' esc 'MC'];
	screendepth = 3;
	onewindow = 'no';
	tp = 'tek410x';

elseif (ttype == 10),
% Tektronix 4010/4014
	showgraph = setstr([esc ff]);
	hidegraph = [esc ff esc '8' nl];
	screendepth = 1;
	onewindow = 'yes';
	tp = 'tek401x';

elseif (ttype == 11),
% Tektronix 4100
	showgraph = [esc '%!0' esc 'KA0' esc 'LV0'];
	hidegraph = [alphamode esc 'LV1' esc 'KA1' esc '%!1'];
	init_str = [esc '%!0' esc 'TF43000' esc 'LI133'];
	init_str = [init_str esc 'RW `` @@' nl];
	init_str = [init_str esc 'RA1' esc 'MC' esc 'MN' esc 'MR'];
	init_str = [init_str esc 'LLA>' esc 'LM0' esc 'LBA>' esc '%!1'];
	screendepth = 1;
	onewindow = 'yes';
	tp = 'tek410x';


elseif (ttype == 12),
% Tektronix 4105

% showgraph selects TEK mode, disables the dialog area and makes it invisible
	showgraph = [esc '%!0' esc 'KA0' esc 'LV0'];

% hidegraph selects ALPHA mode, enables the dialog area and makes it visible
% then selects ANSI mode
	hidegraph = [alphamode esc 'LV1' esc 'KA1' esc '%!1'];

% init_str is used to set the following defaults:
%   dialog area colormap's index 3 to (0,0,0) (HSV)
%   window size to the factory default
%   view attributes (background color) for the screen to 0 (factory default)
%   graphtext size to the factory default
%   graphtext character path to the factory default
%   graphtext rotation to the factory default
%   dialog area number of lines to 30
%   dialog area writing mode to REPLACE mode
%   dialog area buffer size to 30 lines
	init_str = [esc '%!0' esc 'TF43000' esc 'LI133'];
	init_str = [init_str esc 'RW `` @@' nl];
	init_str = [init_str esc 'RA1' esc 'MC' esc 'MN' esc 'MR'];
	init_str = [init_str esc 'LBA>' esc 'LLA>' esc 'LM0' esc '%!1'];

% there are 8 colors (tek4105 is a 3-bit machine)
	screendepth = 3;

% tek4105 only has one window
	onewindow = 'yes';
	tp = 'tek410x';

elseif (ttype == 13),
% Retrographics
	showgraph = [esc '[H' esc '[2J' esc ff graphmode];
	hidegraph = [esc ff esc '8' can esc '[A' nl];
	screendepth = 1;
	onewindow = 'yes';
	tp = 'tek401x';

elseif (ttype == 14),
% Selanar 100
	showgraph = [esc '[H' esc '[2J' esc '1' esc '*'];
	hidegraph = [esc ff esc '8' esc '2' esc '[A'];
	screendepth = 1;
	onewindow = 'yes';
	tp = 'tek401x';

elseif (ttype == 15),
% Selanar 200
	showgraph = [esc '[H' esc '[2J' esc '1' esc '~6T'];
	hidegraph = [esc ff esc '8' esc '~1T' esc '[A'];
	screendepth = 1;
	onewindow = 'yes';
	tp = 'tek401x';

elseif (ttype == 16),
% VT240 Tektronix mode
	showgraph = [esc '[H' esc '[2J' esc '[?38h' esc ff graphmode];
	hidegraph = [esc ff esc '8' ret esc '[?38l' nl];
	screendepth = 1;
	onewindow = 'yes';
	tp = 'tek401x';

elseif (ttype == 17),
% WYSE
	showgraph = [esc '[?38h'];
	hidegraph = [esc '[?38l' esc '[61"p' esc '[A' esc '[41' esc '[?7h'];
	screendepth = 1;
	onewindow = 'yes';
	tp = 'tek401x';

elseif (ttype == 18),
% Xterm Tektronix mode
	showgraph = [esc '[?38h' esc ff];
	hidegraph = setstr([esc ctrlc]);
	screendepth = 1;
	onewindow = 'no';
	tp = 'tek401x';

else
	error ('Invalid terminal type');
end


% Check to see if the terminal protocol is already set.
% If it is already set and what it's currently set to is not what we want
% the user will have to exit MATLAB to change it.
currtp = get(0,'TerminalProtocol');
if ~strcmp(currtp,'none') & ~strcmp(currtp,tp),
	error(['Terminal protocol is already set to ' currtp '.' nl 'In order to switch you must exit MATLAB.']);
end

% Set the other root terminal properties now
set(0,'TerminalShowGraphCommand',showgraph);
set(0,'TerminalHideGraphCommand',hidegraph);
set(0,'ScreenDepth',screendepth);
set(0,'TerminalOneWindow',onewindow);
if ~strcmp(currtp,tp),
	set(0,'TerminalProtocol',tp);
end
disp(init_str);
