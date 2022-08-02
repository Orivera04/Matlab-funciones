function serdate = parsedate(datestring, endflag)
% PARSEDATE Parses incomplete date strings into serial dates.
%
% Syntax:   SERDATE = parsedate(DATESTRING, ENDFLAG)
%
% Inputs:   DATESTRING - Input date in incomplete string format.
%           ENDFLAG    - Return date as beginning or end of period flag;
%                        0 = beginning (1), 1 = end, default (28, 29, 30, or 31).
%
% Output:   SERDATE    - Output date in serial date format.
%
% 
% Incomplete date strings are:
%
%      'mmmyy'                  Mar00      (DATESTR format: 12)
%      'mmmyyyy'                Mar2000    (DATESTR format: 28)
%      'mmm/yy'                 Mar/00     
%      'mmm/yyyy'               Mar/2000   
%      'mmm-yy'                 Mar-00     
%      'mmm-yyyy'               Mar-2000   
%   
%      'QQYY'                   Q196      
%      'QQYYYY'                 Q11996    
%      'QQ/YY'                  Q1/96     
%      'QQ/YYYY'                Q1/1996   
%      'QQ-YY'                  Q1-96     (DATESTR format: 17)
%      'QQ-YYYY'                Q1-1996   (DATESTR format: 27)
%
%      'SSYY'                   S196      
%      'SSYYYY'                 S11996    
%      'SS/YY'                  S1/96     
%      'SS/YYYY'                S1/1996   
%      'SS-YY'                  S1-96     
%      'SS-YYYY'                S1-1996   
%
%      'YY'                     96        (DATESTR format: 11)
%      'YYYY'                   1996      (DATESTR format: 10)  
%   

%   Author: P. N. Secakusuma, 11-12-2000
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.3 $   $Date: 2002/01/21 12:27:28 $

if ~exist('endflag', 'var'),
	endflag = 1;
end

if iscell(datestring),
	datestring = char(datestring);
end

switch double(datestring(1, 1)),
case num2cell([65:90, 97:122]),
	switch upper(datestring(1, 1:2))
	case {'Q1', 'Q2', 'Q3', 'Q4'},   % Quarterly Data
		qrtstr = upper(datestring(:, 1:2));
		qrtcnt = size(qrtstr, 1);
		[iii, jjj] = find(datestring == double('-') | datestring == double('/'));
		if ~isempty(iii) & ~isempty(jjj),	
			if sum(diff(diff(iii))) ~= 0 | sum(diff(jjj)) ~= 0 | length(iii) ~= qrtcnt,
				error('Date string format is inconsistent.');
			end
			yrstr  = datestring(:, 4:end);
		else,
			yrstr  = datestring(:, 3:end);
		end
		if endflag == 0,
			qrtmonnum = zeros(qrtcnt, 1);
			qrtmonstr = cellstr(repmat('   ', qrtcnt, 1));
			qrtmonnum(strmatch('Q1', qrtstr)) =  1;
			qrtmonstr(strmatch('Q1', qrtstr)) = {'jan'};
			qrtmonnum(strmatch('Q2', qrtstr)) =  4;
			qrtmonstr(strmatch('Q2', qrtstr)) = {'apr'};
			qrtmonnum(strmatch('Q3', qrtstr)) =  7;
			qrtmonstr(strmatch('Q3', qrtstr)) = {'jul'};
			qrtmonnum(strmatch('Q4', qrtstr)) = 10;
			qrtmonstr(strmatch('Q4', qrtstr)) = {'oct'};
			datedate = repmat('1', qrtcnt, 1);
		else,
			qrtmonnum = zeros(qrtcnt, 1);
			qrtmonstr = cellstr(repmat('   ', qrtcnt, 1));
			qrtmonnum(strmatch('Q1', qrtstr)) =  3;
			qrtmonstr(strmatch('Q1', qrtstr)) = {'mar'};
			qrtmonnum(strmatch('Q2', qrtstr)) =  6;
			qrtmonstr(strmatch('Q2', qrtstr)) = {'jun'};
			qrtmonnum(strmatch('Q3', qrtstr)) =  9;
			qrtmonstr(strmatch('Q3', qrtstr)) = {'sep'};
			qrtmonnum(strmatch('Q4', qrtstr)) = 12;
			qrtmonstr(strmatch('Q4', qrtstr)) = {'dec'};
			datedate = num2str(eomday(str2double(yrstr), qrtmonnum));
		end
		serdate  = [datedate, repmat('-', qrtcnt, 1), char(qrtmonstr), repmat('-', qrtcnt, 1), yrstr];
	
	case {'S1', 'S2'},   % Semi-annual Data
		smastr = upper(datestring(:, 1:2));
		smacnt = size(smastr, 1);
		[iii, jjj] = find(datestring == double('-') | datestring == double('/'));
		if ~isempty(iii) & ~isempty(jjj),	
			if sum(diff(diff(iii))) ~= 0 | sum(diff(jjj)) ~= 0 | length(iii) ~= smacnt,
				error('Date string format is inconsistent.');
			end
			yrstr  = datestring(:, 4:end);
		else,
			yrstr  = datestring(:, 3:end);
		end
		if endflag == 0,
			smamonnum = zeros(smacnt, 1);
			smamonstr = cellstr(repmat('   ', smacnt, 1));
			smamonnum(strmatch('S1', smastr)) =  1;
			smamonstr(strmatch('S1', smastr)) = {'jan'};
			smamonnum(strmatch('S2', smastr)) =  7;
			smamonstr(strmatch('S2', smastr)) = {'jul'};
			datedate = repmat('1', smacnt, 1);
		else,
			smamonnum = zeros(smacnt, 1);
			smamonstr = cellstr(repmat('   ', smacnt, 1));
			smamonnum(strmatch('S1', smastr)) =  6;
			smamonstr(strmatch('S1', smastr)) = {'jun'};
			smamonnum(strmatch('S2', smastr)) = 12;
			smamonstr(strmatch('S2', smastr)) = {'dec'};
			datedate = num2str(eomday(str2double(yrstr), smamonnum));
		end
		serdate  = [datedate, repmat('-', smacnt, 1), char(smamonstr), repmat('-', smacnt, 1), yrstr];
	
	otherwise,
		switch lower(datestring(1, 1:3)),
		case {'jan', 'feb', 'mar', 'apr', 'may', 'jun', ...
				'jul', 'aug', 'sep', 'oct', 'nov', 'dec'},   % Monthly Data
			monstr = lower(datestring(:, 1:3));
			moncnt = size(monstr, 1);
			[iii, jjj] = find(datestring == double('-') | datestring == double('/'));
			if ~isempty(iii) & ~isempty(jjj),	
				if sum(diff(diff(iii))) ~= 0 | sum(diff(jjj)) ~= 0 | length(iii) ~= moncnt,
					error('Date string format is inconsistent.');
				end
				yrstr  = datestring(:, 5:end);
			else,
				yrstr  = datestring(:, 4:end);
			end
			if endflag == 0,
				datedate = repmat('1', moncnt, 1);
			else,
				monnum = zeros(moncnt, 1);
				monnum(strmatch('jan', monstr)) =  1;
				monnum(strmatch('feb', monstr)) =  2;
				monnum(strmatch('mar', monstr)) =  3;
				monnum(strmatch('apr', monstr)) =  4;
				monnum(strmatch('may', monstr)) =  5;
				monnum(strmatch('jun', monstr)) =  6;
				monnum(strmatch('jul', monstr)) =  7;
				monnum(strmatch('aug', monstr)) =  8;
				monnum(strmatch('sep', monstr)) =  9;
				monnum(strmatch('oct', monstr)) = 10;
				monnum(strmatch('nov', monstr)) = 11;
				monnum(strmatch('dec', monstr)) = 12;
				datedate = num2str(eomday(str2double(yrstr), monnum));
			end
			serdate  = [datedate, repmat('-', moncnt, 1), monstr, repmat('-', moncnt, 1), yrstr];
	
		otherwise,
			error('Unrecognized format.  Please look at HELP PARSEDATE for list of formats.');
		end   % End of 'switch lower(datestring(1, 1:3))' block.
	
	end   % End of 'switch upper(datestring(1, 1:2))' block.

case num2cell(48:57),   % Annual data
	if size(datestring, 2) ~= 2 & size(datestring, 2) ~= 4,
		error('Unrecognized format.  Please look at HELP PARSEDATE for list of formats.');
	else
	   yrstr = datestring;
		yrcnt = size(yrstr, 1);
		if endflag == 0,
			yrmonnum = zeros(yrcnt, 1);
			yrmonstr = repmat('jan', yrcnt, 1);
			datedate = repmat('1', yrcnt, 1);
		else,
			yrmonnum = zeros(yrcnt, 1);
			yrmonstr = repmat('dec', yrcnt, 1);
			datedate = repmat('31', yrcnt, 1)
		end
		serdate  = [datedate, repmat('-', yrcnt, 1), yrmonstr, repmat('-', yrcnt, 1), yrstr];
	end
	
otherwise,
	error('Unrecognized format.  Please look at HELP PARSEDATE for list of formats.');
	
end   % End of 'switch double(datestring(1, 1))' block.

return

