function str=prettify(invect,fuzz)
% PRETTIFY   Create a nice-looking string from a vector
%
%   S=PRETTIFY(VECT) returns a representation of the row vector VECT
%   in the string variable S.  Sequences in VECT that can be created
%   in MATLAB using a shorter notation are searched for, e.g.
%
%   VECT=[0 0.2 0.4 0.6 0.8 1.0];
%   S=PRETTIFY(VECT);
%
%   will return S='0:0.2:1'
%
%
%   S=PRETTIFY(VECT,TOL) sets the tolerance level to TOL.  The tolerance
%   is the level below which differences in the intervals are ignored.
%   The default value of the tolerance is (Average of input vector)/1e6.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.4.2 $  $Date: 2004/02/09 06:49:10 $


if length(invect) == 0
	str = '';
else
	if nargin<2
		fuzz=(mean(abs(invect)).*.000001);
	end
	
	
	% convert column to row
	invect=invect(:)';
	
	if length(invect)<3
		out=num2cell([1:length(invect)]');
	else
		d=diff(invect);
		dd=diff(d);
		dd=(abs(dd)<fuzz);
		
		% convert to [first last] indices
		out={};
		
		if ~isempty(dd)
			s=0;
			loop=1;
            maxl=length(dd);
            while loop
                if loop>maxl
                    %save last output
                    if s
                        if d(loop-s)==0
                            out(end+1)={[loop-s s+2]};
                        else
                            out(end+1)={[loop-s d(loop-s) loop+1]};
                        end
                    else
                        out(end+1)={loop};
						if (loop-maxl)<2
							out(end+1)={loop+1};
						end
					end
					loop=0;
				elseif dd(loop)
					s=s+1;
					loop=loop+1;
				else
                    if s
                        % save output
                        if d(loop-s)==0
                            out(end+1)={[loop-s  s+2]};
                        else
                            out(end+1)={[loop-s  d(loop-s) loop+1]};
                        end
						loop=loop+2;
					else
						out(end+1)={loop};
						loop=loop+1;
					end
					% reset s
					s=0;
				end
			end
		end
	end
	
	str='';
	% create string
	for loop=1:length(out)
		v=out{loop};
		if length(v)==3
			if v(2)==1
				str=[str ' ' num2str(invect(v(1))) ':' num2str(invect(v(3)))];
			else
				str=[str ' ' num2str(invect(v(1))) ':' num2str(v(2)) ':' num2str(invect(v(3)))];
			end
        elseif length(v)==2
            val = invect(v(1));
            if val==1
                str=[str ' ' sprintf('ones(1, %d)', v(2))]; 
            elseif val==0
                str=[str ' ' sprintf('zeros(1, %d)', v(2))]; 
            else
                str=[str ' ' sprintf('%s*ones(1, %d)', num2str(val), v(2))];  
            end
        elseif length(v)==1
			str=[str ' ' num2str(invect(v(1)))];      
		end
	end	
	% strip off leading space
	if length(str)
		str=str(2:end);
	end
end
