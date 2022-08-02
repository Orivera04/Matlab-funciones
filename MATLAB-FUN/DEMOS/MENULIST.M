function [labelList,nameList]=menulist(areaName,sectionName);
%MENULIST MATLAB Expo helper function for keeping list data.

%	Ned Gulley, 6-21-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

% The variable ToolboxExistenceMatrix is used as a global to keep track of
% whether the user has a given toolbox.
% The indexing is as follows:
% simulink 1	 signal   2	sysid    3
% optim    4	 neural   5	control  6
% robust   7	 mutools  8	spline   9
% images   10    stats   11


global ToolboxExistenceMatrix
if length(ToolboxExistenceMatrix)==0,
    existtb;
end

if strcmp(areaName,'matlab'),
    if strcmp(sectionName,'matrices'),
        labelList=str2mat( ...
	    'Intro', ...
	    'Invert', ...
	    'Bucky', ...
	    'Sparse', ...
	    'Matrix Math', ...
	    'Cmd Line Demos');
    	nameList=str2mat( ...
	    'sshow intro', ...
	    'sshow inverter', ...
	    'sshow buckydem', ...
	    'sshow sparsity', ...
 	    'sshow matmanip', ...
	    'matdems');

    elseif strcmp(sectionName,'numerics'),
    	labelList=str2mat( ...
	    'Funfuns', ...
	    'Fitting', ...
	    'FFT', ...
	    '2D Functions', ...
	    'Cmd Line Demos');
    	nameList=str2mat( ...
	    'funfuns', ...
	    'sshow fitdemo', ...
	    'sshow sunspots', ...
	    'sshow e2pi', ...
	    'numdems');

    elseif strcmp(sectionName,'visualization'),
    	labelList=str2mat( ...
	    'XY Plots', ...
	    'XYZ Plots', ...
	    'Complex', ...
	    'Animation');
	    if ~isstudent
	        labelList=str2mat(labelList, ...
	        'Movie', ...
	        'Sound');
	    end
	    labelList=str2mat(labelList, ...
	    'Klein', ...
	    'Cmd Line Demos');
    	nameList=str2mat( ...
	    'graf2d', ...
	    'graf2d2', ...
	    'grafcplx', ...
	    'lorenz');
	    if ~isstudent
	        nameList=str2mat(nameList, ...
	        'xpmovie vibes', ...
	        'xpsound');
	    end
	    nameList=str2mat(nameList, ...
	    'xpklein', ...
	    'visdems');

    elseif strcmp(sectionName,'language'),
    	labelList=str2mat( ...
	    'Intro', ...
	    'Lines', ...
	    'Surfaces', ...
	    'Axes');
    	nameList=str2mat( ...
	    'sshow xplang', ...
	    'hndlgraf', ...
	    'graf3d', ...
	    'hndlaxis');

    end

elseif strcmp(areaName,'simulink'),
    if strcmp(sectionName,'simple'),
    	if ~ToolboxExistenceMatrix(1),
	    labelList='No demos';
	    nameList='tbwarn(''simulink'');';
	else
    	    labelList=str2mat( ...
	    	'Intro', ...
	    	'Libraries', ...
	    	'Pendulum', ...
	    	'Spring-Mass', ...
	    	'Bounce', ...
	    	'Van der Pol');
    	    nameList=str2mat( ...
	    	'sshow(''simintro'',''text'')', ...
	    	'sshow(''libintro'',''text'')', ...
	    	'simppend', ... 
	    	'onecart', ...
	    	'bounce', ...
	    	'vdp');
    	end

    elseif strcmp(sectionName,'complex'),
    	if ~ToolboxExistenceMatrix(1),
	    labelList='No demos';
	    nameList='tbwarn(''simulink'');';
	else
    	    labelList=str2mat( ...
	   	'Double Pend. I', ...
	    	'Double Pend. II', ...
	    	'Inverted Pend.', ...
	    	'Two Carts', ...
	    	'House', ...
	    	'Aircraft');
    	    nameList=str2mat( ...
	    	'dblpend1', ...
	    	'dblpend2', ...
	    	'penddemo', ...
	    	'dblcart1', ...
	    	'thermo', ...
	    	'f14');
    	end

    elseif strcmp(sectionName,'advanced'),
    	if ~ToolboxExistenceMatrix(1),
	    labelList='No demos';
	    nameList='tbwarn(''simulink'');';
	else
        labelList=str2mat( ...
	    'Accelerator', ...
	    'Code Gen.');
    	nameList=str2mat( ...
	    'xpaccel', ...
	    'ccodegen');
    	end
    end

elseif strcmp(areaName,'toolbox1'),
    if strcmp(sectionName,'signal'),
    	if ~ToolboxExistenceMatrix(2),
	    labelList='No demos';
	    nameList='tbwarn(''signal'');';
    	else
    	    labelList=str2mat( ...
	    	'Filter I', ...
	    	'Filter II', ...
	    	'Phone', ...
	    	'Discrete FT', ...
	    	'Cont. FT');
    	    nameList=str2mat( ...
	    	'sshow filtdem', ...
	    	'sshow filtdem2', ...
	    	'phone', ...
	    	'sigdemo1', ...
	    	'sigdemo2');
	end
	if ToolboxExistenceMatrix(2)>2,
	    % Add v3 demos if v3 is available
	    labelList=str2mat(labelList, ...
	    	'Chirp-z Trans.', ...
	    	'Filt. Design', ...
	    	'Mod./Demod.', ...
	    	'2nd-Ord. Sections');
	    nameList=str2mat(nameList, ...
	    	'cztdemo', ...
	    	'filtdemo', ...
	    	'moddemo', ...
	    	'sosdemo');
	end

    elseif strcmp(sectionName,'sysid'),
    	if ~ToolboxExistenceMatrix(3),
	    labelList='No demos';
	    nameList='tbwarn(''sysid'');';
	else
    	    labelList=str2mat( ...
	    	'Dryer', ...
	    	'Cmd Line Demos');
    	    nameList=str2mat( ...
	    	'sshow sysiddm', ...
	    	'iddems');
    	end

    elseif strcmp(sectionName,'optim'),
    	if ~ToolboxExistenceMatrix(4),
	    labelList='No demos';
	    nameList='tbwarn(''optim'');';
	else
    	    labelList=str2mat( ...
	    	'Bananas', ...
	    	'Cmd Line Demos');
    	    nameList=str2mat( ...
	    	'bandem', ...
	    	'optdems');
    	end

    elseif strcmp(sectionName,'neural'),
    	if ~ToolboxExistenceMatrix(5),
	    labelList='No demos';
	    nameList='tbwarn(''neural'');';
	else
    	    labelList=str2mat( ...
	    	'Backprop', ...
	    	'Momentum', ...
	    	'ABCs');
    	    nameList=str2mat( ...
	    	'sshow bckprp12', ...
	    	'sshow bckprp62', ...
	    	'neural');
    	end

    end

elseif strcmp(areaName,'toolbox2'),

    if strcmp(sectionName,'control'),
    	if ~ToolboxExistenceMatrix(6),
	    labelList='No demos';
	    nameList='tbwarn(''control'');';
	else
    	    labelList=str2mat( ...
	    	'Commands', ...
	    	'Disk Drive', ...
	    	'Cmd Line Demos');
    	    nameList=str2mat( ...
	    	'xpctrl', ...
	    	'sshow dskdemo2', ...
	    	'ctrldems');
    	end

    elseif strcmp(sectionName,'robust'),
    	if ~ToolboxExistenceMatrix(7),
	    labelList='No demos';
	    nameList='tbwarn(''robust'');';
	else
    	    labelList=str2mat( ...
	    	'Two Carts', ...
	    	'Cmd Line Demos');
    	    nameList=str2mat( ...
	    	'sshow accdm2', ...
	    	'rctdems');
    	end

    elseif strcmp(sectionName,'mutools'),
    	if ~ToolboxExistenceMatrix(8),
	    labelList='No demos';
	    nameList='tbwarn(''mutools'');';
	else
    	    labelList=str2mat( ...
	    	'HiMAT', ...
	    	'Cmd Line Demos');
    	    nameList=str2mat( ...
	    	'xpmu', ...
	    	'mudems');
    	end

    elseif strcmp(sectionName,'spline'),
    	if ~ToolboxExistenceMatrix(9),
	    labelList='No demos';
	    nameList='tbwarn(''spline'');';
	else
    	    labelList=str2mat( ...
	    	'Curve Fit', ...
	    	'Cmd Line Demos');
    	    nameList=str2mat( ...
	    	'sshow spapidm2', ...
	    	'spldems');
        end

    elseif strcmp(sectionName,'symbolic'),
    	labelList=str2mat( ...
	    'Transformations', ...
	    'Calculus');
    	nameList=str2mat( ...
	    'sshow(''xpgiv'',''text'')', ...
	    'xpcalc');

    elseif strcmp(sectionName,'images'),
    	if ~ToolboxExistenceMatrix(10),
	    labelList='No demos';
	    nameList='tbwarn(''images'');';
	else
    	    labelList=str2mat( ...
	    	'Enhancements', ...
	    	'General Demo', ...
	    	'DCT Compression', ...
	    	'FIR Filtering', ...
	    	'Nonlin. Filtering');
    	    nameList=str2mat( ...
	    	'xpimage', ...
	    	'imdemo', ...
	    	'dctdemo', ...
	    	'firdemo', ...
	    	'nlfdemo');
        end

    elseif strcmp(sectionName,'stats'),
    	if ~ToolboxExistenceMatrix(11),
	    labelList='No demos';
	    nameList='tbwarn(''stats'');';
	else
    	    labelList=str2mat( ...
	    	'Data Fitting', ...
	    	'Cmd Line Demos');
    	    nameList=str2mat( ...
	    	'xppolytl', ...
	    	'statdems');
        end

    end

elseif strcmp(areaName,'extras'),

    if strcmp(sectionName,'gallery'),
    	labelList=str2mat( ...
	    'Knot', ...
	    'Quiver');
	    if ~isstudent
	        labelList=str2mat(labelList, ...
	        'Modes', ...
	        'Logo');
	    end
	    labelList=str2mat(labelList, ...
	    'Klein II', ...
	    'Cruller', ...
	    'Hoops', ...
	    'Slosh');
    	nameList=str2mat( ...
	    'knot', ...
	    'xpgallry quivdemo');
	    if ~isstudent
	        nameList=str2mat(nameList, ...
	        'xpgallry modes', ...
	        'xpgallry logo');
	    end
	    nameList=str2mat(nameList, ...
	    'xpgallry klein1', ...
	    'xpgallry cruller', ...
	    'xpgallry tori4', ...
	    'xpgallry spharm2');

    elseif strcmp(sectionName,'games'),
    	labelList=str2mat( ...
	    'Bombs', ...
	    'Life', ...
	    'Bubblewrap');
	computerType=computer;
	if computerType(1:2) ~= 'PC' & computerType(1:2) ~= 'MA',
	    smallMachineFlag=1;
	    labelList=str2mat(labelList,'Mazes');
	else
	    smallMachineFlag=0;
	end;
    	nameList=str2mat( ...
	    'xpbombs', ...
	    'life', ...
	    'bblwrap');
	if smallMachineFlag,
	    nameList=str2mat(nameList,'makemaze');
	end;

    elseif strcmp(sectionName,'misc'),
	    labelList=str2mat( ...
 	    'Bending', ...
	    'Salesman', ...
	    'Vases');
	    if ~isstudent
	        labelList=str2mat(labelList, ...
	        'Traveler', ...
	        'Spin Logo', ...
	        'Spin Cruller');
	    end
	    labelList=str2mat(labelList, ...
	    'Cool Lines', ...
	    'Superquadrics', ...
	    'Codec');
	    nameList=str2mat( ...
	    'truss', ...
	    'travel', ...
	    'makevase');
        if ~isstudent
	        nameList=str2mat(nameList, ...
	        'wrldtrv', ...
	        'xpmovie logospin', ...
	        'xpmovie crulspin');
	    end
  	    nameList=str2mat(nameList, ...
	    'spinner', ...
	    'xpquad', ...
	    'codec');

    elseif strcmp(sectionName,'contact'),
	    labelList=str2mat( ...
	    'Address', ...
	    'E-Mail', ...
	    'International');
    	nameList=str2mat( ...
	    'contact1', ...
	    'contact2', ...
	    'contact3');
        if ~isstudent
    	    labelList=str2mat(labelList,'World Map');
    	    nameList=str2mat(nameList,'agents');
        end
    end

end;
