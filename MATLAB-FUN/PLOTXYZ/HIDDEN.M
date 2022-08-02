function ret_type = hidden(onoff)
%HIDDEN	Mesh hidden line removal mode.
%	HIDDEN ON sets hidden line removal on for the current mesh.
%	HIDDEN OFF sets hidden line removal off so you can see through
%	the current mesh.
%	HIDDEN by itself toggles the state of hidden line removal.
%
%	See also MESH.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

if nargin == 0
	tog = 'tog';	% toggle hidden state
else
	tog = lower(onoff);
end
hf = gcf;
ax = gca;
bkgd = get(hf,'Color');
% get mesh handle
hk = get(ax,'Children');
hm = [ ];
for i = 1:max(size(hk))
% see if the object could be a mesh - must be a surface first.
	if strcmp('surface',get(hk(i),'type'))
		fc = get(hk(i),'facecolor');
% see if the object could be a mesh.
		if isstr(bkgd)
			bkstr = bkgd;
		else
			bkstr = num2str(bkgd);
		end
		if isstr(fc)
			fcstr = fc;
		else
			fcstr = num2str(fc);
		end
		if strcmp('none',fc) | strcmp(bkstr,fcstr)
% okay - it's the mesh
			hm = hk(i);
			if strcmp(tog,'on')
				set(hm,'facecolor',bkgd);
			elseif strcmp(tog,'off')
				set(hm,'facecolor','none');
			else
				if strcmp(fc,'none')
					set(hm,'facecolor',bkgd);
                    tog = 'on';
				else
					set(hm,'facecolor','none');
                    tog = 'off';
				end
			end
			break;
		end
	end
end
if nargout > 0
   ret_type = tog;
end
