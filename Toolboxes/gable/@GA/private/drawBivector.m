function drawBivector(A,O,c)
%drawBivector(A,O,c): Draw a bivector offset by vector O in color c.
%  The c argument may be omitted.
%
%See also gable.

% GABLE, Copyright (c) 1999, University of Amsterdam
% Copying, use and development for non-commercial purposes permitted.
%          All rights for commercial use reserved; for more information
%          contact Leo Dorst (leo@wins.uva.nl).
%
%          This software is unsupported.
     global GABVX;
     global GABVY;
     if ~strcmp(GAbvShape, 'default')
	 arrow(0.2*dual(A),O,'k');
     end
     if strcmp(GAbvShape, 'default')
	if nargin == 2
	   c = 'g';
	end
	% This line is a cheat - if your first object is 2D,
	%  then all subsequent draws will be 2D.  So draw
	%  a small 3D object first, hoping it won't be visible.
	arrow(0.001*dual(A),O,c);
	disk(A,O,c);

     elseif strcmp(GAbvShape, 'American')
        persistent gaAM;
        if isa(gaAM,'double')
	   gaAM.X = [315 272 130 245 201 315 430 386 500 359 315];
	   gaAM.Y = [580 445 445 362 227 310 227 362 445 445 580];
	   gaAM.Z = [ 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
	   gaAM.A = abs(gaarea(gaAM.X,gaAM.Y));
	   gaAM.CX = sum(gaAM.X)/length(gaAM.X);
	   gaAM.CY = sum(gaAM.Y)/length(gaAM.Y);
	end
	if nargin == 2
	   c = 'c';
	end

	polygon(gaAM, A, O, c);
     elseif strcmp(GAbvShape, 'Canadian')
        persistent gaCF;
        if isa(gaCF,'double')
	   gaCF.Y = [222 220 266 259 304 292 298 275 265 243 252 232 216    200   180   189   167   157   134   140   128   173   166   212   210];
	   gaCF.X = [ 3    43    38    51    90    96   126   121   135   110   161   157 188   157   161   110   135   121   126    96    90    51    38    43 3];
	   gaCF.Z = [ 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
	   gaCF.A = abs(gaarea(gaCF.X,gaCF.Y));
	   gaCF.CX = sum(gaCF.X)/length(gaCF.X);
	   gaCF.CY = sum(gaCF.Y)/length(gaCF.Y);
	end
	if nargin == 2
	   c = 'r';
	end

	polygon(gaCF, A, O, c);
     elseif strcmp(GAbvShape, 'Dutch')
        persistent gaWM;
        if isa(gaWM,'double')
	   gaWM.Y = [134 161 137 121 145 163 171 125 124 171 165 143 119 91 72 41 22 16 59 58 19 26 48 48 18 64];
	   gaWM.X = -1*[229 201 179 119 138 128 108  86  74  20   5   0  38 17 30 5  16 34 57 82 120 136 144 177 209 234];
	   gaWM.Z = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];

	   gaWM.A = abs(gaarea(gaWM.X,gaWM.Y));
	   gaWM.CX = sum(gaWM.X)/length(gaWM.X);
	   gaWM.CY = sum(gaWM.Y)/length(gaWM.Y);
	end
	if nargin == 2
	   c = 'b';
	end
	polygon(gaWM, A, O, c);
     elseif strcmp(GAbvShape, 'Clifford')
        persistent gaCL;
        if isa(gaCL,'double')
	   gaCL.Y = [ 5850 5841 5700 5325 5100 4875 5100 5100 4950 5100 5550 5400 5550 5850 5550 5400 5550 5100 5100 5325 5700 5850 5925 5850 5710 5448 5280 5448 5719 5700 5775 5700 5775 5550 5250 5250 5700 5250 5175 5250 5175 5175 5250 5700 5250 5100 4950 5100 4800 4725 4650 4725 4425 4500 4500 4650 4950 4950 4725 4725 4875 4800 4800 5025 5025 5025 5175 5550 5175 5250 5550 5250 4875 4875 5325 5400 5550 5550 5550 5850 5550 5625 5550 5550 5700 5700 5850 5925 5775 5850 5850];
	   gaCL.X = -1*[ 4275 4226 4275 4350 4275 4275 4275 4125 4050 4125 3975 3675 3375 3300 3375 3675 3975 4125 4275 4350 4275 4200 3975 3300 3020 3235 3235 3226 3001 2775 2550 2475 2475 2250 2325 2475 2475 2475 2550 2700 3075 3225 3225 2850 3225 3525 3900 3525 3600 3600 3825 3600 3675 3675 3825 3825 3900 4050 4050 4200 4275 4950 5700 5700 4875 6000 6000 6000 6000 6450 6450 6450 6600 6675 6600 6675 6600 6450 6000 5775 6000 6225 6375 6450 6450 6525 6525 6300 4950 4875 4275];
	   gaCL.A = abs(gaarea(gaCL.X,gaCL.Y));
	   gaCL.CX = sum(gaCL.X)/length(gaCL.X);
	   gaCL.CY = sum(gaCL.Y)/length(gaCL.Y);
	end
	if nargin == 2
	   c = 'b';
	end
	polygon(gaCL, A, O, c);
        
     elseif strcmp(GAbvShape, 'CLIFFORD')
	% Make Clifford Red
	c = 'r';
        persistent gaCBRD;
        if isa(gaCBRD,'double')
	    gaCBRD.Y = [92    83    77    70    65    55    51    53    66    66    64    41 31    10    10    16    29    25    31    27    26    29    35    32 35    33    35    31    35    33    35    48    51    50    41    44 48    48    44    48    48    44    58    58    61    66    68    64 65    68    77    80    86    87    80    74    77    77    79    89 93    88    86    82    79    76    79    82    86    88    93    93 92];
	    gaCBRD.X = -1*[35    35    30    29    35    32    36    40    40    39    45    43 45    21    30    41    48    56    66    72    84    86    83    80 73    70    67    66    67    70    73    80    78    75    68    66 60    52    48    52    60    66    69    84    86    86    84    81 68    66    67    71    70    67    62    62    56    49    46    48 43    43    45    43    44    40    44    43    45    43    43    39 35];
	    gaCBRD.Z = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
	    %gaCBRD.A = abs(gaarea(gaCBRD.X,gaCBRD.X));
	    % Make Clifford Big
	    gaCBRD.A = 100;
	    gaCBRD.CX = sum(gaCBRD.X)/length(gaCBRD.X);
	    gaCBRD.CY = sum(gaCBRD.Y)/length(gaCBRD.Y);
	end
	polygon(gaCBRD, A, O, c);
     elseif strcmp(GAbvShape, 'UserDefined')
	if nargin == 2
	   c = 'c';
	end
	gaUP.X = GABVX;
	gaUP.Y = GABVY;
	gaUP.Z = zeros(size(GABVX));
	gaUP.A = abs(gaarea(gaUP.X,gaUP.Y));
	gaUP.CX = sum(gaUP.X)/length(gaUP.X);
	gaUP.CY = sum(gaUP.Y)/length(gaUP.Y);
        polygon(gaUP, A, O, c);
     else
        error('Unknown GAbvShape');
     end
