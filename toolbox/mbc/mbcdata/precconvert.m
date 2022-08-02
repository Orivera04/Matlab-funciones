function p = precconvert(str,r,row)
% PRECCONVERT
% precobj = PrecConvert(precString,Range,row) 
% A temporary function to convert a CAGE 2.1.1 precision string to a 
% CAGE 2.1.2 precision object

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:56:36 $

p = cgprecfloat('double'); % Initialise p so that if str is of a different 
% type to those listed, it won't corrupt the file. We found that with an input of the form
%               str = 'Signed Floating Point 4 Bytes'; 
% from a really old session (spk_mbt_filled in cage training) this function wouldn't 
% return anything and hence meant the fill could not be saved properly. By initialising p
% this function will return a sensible value that will allow saving etc. The Mystery Programmer - 28-02-2001

if nargin == 2
	row = 1;
end
if isempty(r)
	r = [-inf,inf];
else
	s = size(r);
	if s > 1
		r = r(row,:);
	end
end
if isempty(str)
	p = cgprecfloat('double');
	p = set(p,'physrange',r);
else
	if iscell(str)
		str = str{1};
	end
	if isempty(str)
		p = cgprecfloat('double');
		p = set(p,'physrange',r);
	else
		if ischar(str)
			s = size(str);
			if s(1) > 1 
				str = str(row,:);
			end
			switch str(1)
			case '%'
				if strcmp(str(2:end),'SF4')
					p = cgprecfloat('single');
					set(p,'physrange',r);
				else
					p = cgprecfloat('double');
					set(p,'physrange',r);
				end
			case '*'
				x = str2num(str(2));
				if isempty(x)
					x = 4;
				end
				b = x*8;
				p = cgprecpolyfix([1 0],[0 1],r,8,1,0,precision);      
			case 'A'
				signed = strcmp(lower(str(2)),'s');
				b = 32;
				switch str(3:6)
				case byte
					b = 8;
				case word
					b = 16;
				case long
					b = 32;
				end
				switch str(7:14)
				case 'RAT_FUNC'
					s = size(in);
					V = in(:);
					try
						c = eval(str(15:end));
					catch
						p = cgprecpolyfix([1 0],[0 1],r);
						return
					end
					if length(c) ~= 6
						p = cgprecpolyfix([1 0],[0 1],r);
					else
						p = cgprecpolyfix(c(1:3),c(4:6),r);
					end
					
				case 'TAB_INTP'
					try
						c = eval(str(15:end));
					catch
						p = cgpreclookupfix;
						set(p,'physrange',r);
						return
					end
					s = size(c);
					if any(s == 1)
						
					else
						p = cgpreclookupfix(c(2,:),c(1,:),r);
					end
				case 'TAB_VERB'
					% not implemented yet
					p = cgprecfloat('double');
					p = set(p,'physrange',r); 
				end
			end
		end
	end
end

