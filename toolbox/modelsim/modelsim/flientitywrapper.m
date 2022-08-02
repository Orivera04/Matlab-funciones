function flientitywrapper(file,varargin)
% FLIENTITYWRAPPER Generates FLI/VHDL gateway code 
%   FLIENTITYWRAPPER(FILE) generates a VHDL file that 
%    implements a simple FLI Gateway to MATLAB.  FILE 
%    is the name/path to an existing VHDL file.  The first 
%    VHDL 'entity' declarated within FILE will be wrapped 
%    to provide direct access to it's ports from MATLAB.  
%    The entity name in FILE applied as a base for the 
%    generated file and entities.  This also generates
%    a template m-function to match the generated FLI
%    gateway.  
%
%   Thus:
%   (entity)_tg.m   - Generated MATLAB m-template
%   (entity)_tb.vhd - Generated wrapper file
%     (entity)_tb    - Test entity, This is the entity
%                      that should loaded in ModelSim
%     (entity)_tg    - FLI gateway entity
%
%   FLIENTITYWRAPPER(FILE,''PropertyName',PropertyValue,...)
%    Property value pairs can be supplied to customize
%    the code generation. 
%  
%   Optional Properties
%    'port'  - The socket port value to be applied 
%    'entity' - The first entity in FILE is used by default
%               This option allows other entities in
%               FILE to be used.  
%    'ext' - File/entity extensions
%  
%  
%  See Also HDLDAEMON
%

% Copyright 2003 The MathWorks, Inc.
% $Revision: 1.1 $ $Date: 2003/04/09 20:12:26 $

  port = '4449';                        % for now

  [pathstr name ext versn] = fileparts(file);

  entityfilename = fullfile(pathstr, [ name '_tb' ext versn]);

  [libs entityname ports arch] = vhdlreadandparsefile(file);
  
  tbname = [entityname '_tb'];
  tgname = [entityname '_tg'];

  [vhdlports vhdlgatewayports vhdlinstance vhdlgatewayinstance vhdlsignals] = ...
      buildvhdlports(entityname, tgname, ports);
  
  comment_date = datestr(datevec(now),31);

  vhdl_entity_library = [libs, '\n\n'];

  vhdl_entity_comment = ['----------------------------------------------------------------\n',...
                         '--\n',...
                         '-- Modules: ', tgname, ' and ', tbname, '\n',...
                         '--\n',...
                         '-- Generated on: ', comment_date, '\n',...
                         '----------------------------------------------------------------\n'];

  vhdl_entity_decl = ['ENTITY ', tbname, ' IS\n'];
  vhdl_entity_ports = '';
  vhdl_entity_end = ['\nEND ', tbname, ';\n\n\n'];

  vhdl_arch_comment = '----------------------------------------------------------------\n';
  vhdl_arch_decl = ['ARCHITECTURE test OF ', tbname, ' IS\n'];
  vhdl_arch_end =  ['END test;\n'];
  
  vhdl_arch_component_decl = ['  COMPONENT ', entityname, '\n', vhdlports, '  END COMPONENT;\n\n',...
                              '  COMPONENT ', tgname, '\n', vhdlgatewayports, '  END COMPONENT;\n\n'];
  vhdl_arch_component_config = ['  FOR ALL : ', entityname, '\n',...
                      '    USE ENTITY work.', entityname, '(', arch, ');\n\n',...
                      '  FOR ALL : ', tgname, '\n',...
                      '    USE ENTITY work.', tgname, '(matlab_foreign);\n\n'];


  vhdl_gateway_entity_decl = ['ENTITY ', tgname, ' IS\n'];
  vhdl_gateway_entity_ports = vhdlgatewayports;
  vhdl_gateway_entity_end = ['\nEND ', tgname, ';\n\n\n'];

  vhdl_gateway_arch_decl = ['ARCHITECTURE matlab_foreign OF ', tgname, ' IS\n',...
                            '  ATTRIBUTE foreign OF matlab_foreign : ARCHITECTURE IS\n',...
                            '    "fligateway matlablink.so; -p ', port, '";'];
  vhdl_gateway_arch_end =  ['END matlab_foreign;\n'];


  vhdl_arch_functions = '';
  vhdl_arch_typedefs = '';
  vhdl_arch_constants = '';
  vhdl_arch_signals = vhdlsignals;
  vhdl_arch_begin = '\n\nBEGIN\n';
  vhdl_arch_body_component_instances = [vhdlinstance, vhdlgatewayinstance];
  vhdl_arch_body_blocks = '';
  vhdl_arch_body_output_assignments = '';


  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Write the file
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  entityfid = fopen(entityfilename,'w');

  % First the gateway entity/arch -- make a separate file option someday

  vhdl_gateway_entity = [vhdl_entity_comment,... % same
                         vhdl_entity_library,... % same
                         vhdl_gateway_entity_decl,...
                         vhdl_gateway_entity_ports,... 
                         vhdl_gateway_entity_end]; 

  fprintf(entityfid,vhdl_gateway_entity);

  vhdl_gateway_arch = [vhdl_arch_comment,... % same
                       vhdl_gateway_arch_decl,...
                       vhdl_arch_begin,... % same
                       vhdl_gateway_arch_end]; 
  fprintf(entityfid,vhdl_gateway_arch);

  % Now the main tb

  vhdl_entity =  [vhdl_entity_comment,...
                  vhdl_entity_library,...
                  vhdl_entity_decl,...
                  vhdl_entity_ports,... 
                  vhdl_entity_end];

  fprintf(entityfid,vhdl_entity);

  vhdl_arch =    [vhdl_arch_comment,...
                  vhdl_arch_decl,...
                  vhdl_arch_component_decl,...
                  vhdl_arch_component_config,...
                  vhdl_arch_functions,...
                  vhdl_arch_typedefs,... 
                  vhdl_arch_constants,... 
                  vhdl_arch_signals,...
                  vhdl_arch_begin,...
                  vhdl_arch_body_component_instances,...
                  vhdl_arch_body_blocks,...
                  vhdl_arch_body_output_assignments,...
                  vhdl_arch_end];
  fprintf(entityfid,vhdl_arch);
  fclose(entityfid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Generate MATLAB template


  tgname = [entityname '_tg'];
  mtemptfilename = fullfile(pathstr, [tgname '.m']);
  
  mtempt_comment_head = [...
      'function [oport,tnext] = ', tgname, '(iport,tnow,portinfo)\n',...
      '%% ', tgname, ' - Template for MATLAB foreign entity \n',...
      '%%     IPORT - VHDL signals values defined as IN\n'...
      '%%     OPORT - VHDL signals values defined as OUT\n'...      
      '%%     TNOW  - Simulation time (in seconds) \n'...
      '%%     TNEXT - (optional) Time of next MATLAB callback in seconds\n',...  
      '%%\n',... 
      '%% See also HDLDAEMON \n\n',... 
       ];
      
  mtempt_code_portinfo = [   
      'if(nargin == 3),\n',...
      '  disp(''Initialization received'')\n',...
      '  portinfo\n',...
      'end\n',...
  ];
  mtempt_tnext = ['\ntnext = [];\n\n']; 

  % Ports
  mtempt_code_got = [
     '%% Ports that are providing data (IN ports of ' tgname ')\n',...
     ];   
  for n = 1:length(ports)
    p = ports{n};
    if strcmp(p{2},'OUT'),  %% This is NOT a typo
        mtempt_code_got = [ mtempt_code_got,...
        'iport.', p{1}, '  %% VHDL Type = ' p{3}  '\n',
        ];
    end
  end  
  mtempt_code_need = [
     '\n%% Ports that require data (OUT ports of ' tgname ')\n',...
     ];
  for n = 1:length(ports)
    p = ports{n};
    if strcmp(p{2},'IN'),  %% This is NOT a typo
        mtempt_code_need = [ mtempt_code_need,...
        'oport.', p{1}, '= (TBD);  %% VHDL Type = ' p{3} '\n',
        ];
    end
  end   
  
  mtempfid = fopen(mtemptfilename,'w');
  fprintf(mtempfid,mtempt_comment_head);
  fprintf(mtempfid,mtempt_code_portinfo);
  fprintf(mtempfid,mtempt_tnext);
  fprintf(mtempfid,mtempt_code_got);    
  fprintf(mtempfid,mtempt_code_need);        
  fclose(mtempfid);
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [vhdlports, vhdlgatewayports, vhdlinstance, vhdlgatewayinstance, vhdlsignals] = ...
      buildvhdlports(entity, tgname, ports)
  
  vhdlports = '   PORT( ';
  vhdlgatewayports = '   PORT( ';
  vhdlinstance = ['  ', 'u_', entity,': ', entity, '\n', '    PORT MAP ( \n'];
  vhdlgatewayinstance = ['  ', 'u_', tgname, ': ', tgname, '\n', '    PORT MAP ( \n'];
  vhdlsignals = '';

  %might need these someday
  initializer = '';
  comment = '';

  first = 1;
  for n = 1:length(ports)
    p = ports{n};
    if ~any(strcmpi(p{2}, {'buffer','linkage'}))
      switch lower(p{2})
       case 'in'
        invport = 'OUT';
       case 'out'
        invport = 'IN';
       case 'inout'
        invport = 'INOUT';
      end
      if ischar(p{1})
        if first == 0
          vhdlports = [vhdlports, '         '];
          vhdlgatewayports = [vhdlgatewayports, '         '];
        end
        vhdlports    = [vhdlports, sprintf('%-32s:   %-7s %s;\n', p{1}, p{2}, p{3})];
        vhdlgatewayports    = [vhdlgatewayports, sprintf('%-32s:   %-7s %s;\n', p{1}, invport, p{3})];
        vhdlinstance = [vhdlinstance, sprintf('      %-32s => %s,\n', p{1}, p{1})];
        vhdlgatewayinstance = [vhdlgatewayinstance, sprintf('      %-32s => %s,\n', p{1}, p{1})];
        vhdlsignals  = [vhdlsignals, '  SIGNAL ', sprintf('%-32s',p{1}),...
                        ' : ', p{3}, initializer, '; ', comment, '\n'];
        first = 0;
      else
        for m = 1:length(p{1})
          q = p{1}{m};
          if first == 0
            vhdlports = [vhdlports, '         '];
            vhdlgatewayports = [vhdlgatewayports, '         '];
          end
          vhdlports = [vhdlports, sprintf('%-32s:   %-7s %s;\n', q, p{2}, p{3})];
          vhdlgatewayports    = [vhdlgatewayports, sprintf('%-32s:   %-7s %s;\n', q, invport, p{3})];
          vhdlinstance = [vhdlinstance, sprintf('      %-32s => %s,\n', q, q)];
          vhdlgatewayinstance = [vhdlgatewayinstance, sprintf('      %-32s => %s,\n', q, q)];
          vhdlsignals  = [vhdlsignals, '  SIGNAL ', sprintf('%-32s',q),...
                          ' : ', p{3}, initializer, '; ', comment, '\n'];
          first = 0;
        end
      end
    end
  end
  
  lastsemi = find(vhdlports==';');
  vhdlports(lastsemi(end)) = ' '; % set it to space instead of semicolon
  vhdlports = [ vhdlports, '         );\n']; 
  lastsemi = find(vhdlgatewayports==';');
  vhdlgatewayports(lastsemi(end)) = ' '; % set it to space instead of semicolon
  vhdlgatewayports = [ vhdlgatewayports, '         );\n']; 
    
  lastcomma = find(vhdlinstance==',');
  vhdlinstance(lastcomma(end)) = ' '; % set it to space instead of comma
  vhdlinstance = [vhdlinstance, '      );\n\n'];
  lastcomma = find(vhdlgatewayinstance==',');
  vhdlgatewayinstance(lastcomma(end)) = ' '; % set it to space instead of comma
  vhdlgatewayinstance = [vhdlgatewayinstance, '      );\n\n'];


  
  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [libs, entity, ports, arch] = vhdlreadandparsefile(file)
% Parse and divided VHDL file into component parts

  fid = fopen(file, 'r');
  nn = fread(fid);
  st = char(nn');


  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Remove comments
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  [start finish tokens] = regexpi(st,'(--.*?\n)');
  for n = 1:size(tokens,2)
    tok = tokens{n};
    st(tok(1):tok(2)-1) = ' '*ones(1,tok(2)-tok(1)); % space out, man
  end


  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Parse Library and Use
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  all_libs = '(library.*?)\s+entity\s+';
  [start finish tokens] = regexpi(st,all_libs);  
  libs = '';
  if ~isempty(tokens)
    tok = tokens{1};
    libs = deblank(st(tok(1):tok(2)));
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Parse Ports
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  ports = {};
  cnt = 1;

  openp  = '\(';
  closep = '\)';
  vid = '([a-z][a-z0-9_]*)';
  eols = '[\s;]';
  vtype = ['(([a-z][a-z0-9_]*\s*', openp, '\s*[0-9]*\s+(to|downto)\s+[0-9]*', closep, eols, ')',...
           '|',...
           '([a-z][a-z0-9_]*', eols, '))?'];

  portmodes = '(in|out|inout|buffer|linkage)';
  interface_names = [ '(', vid '\s*|,\s*' vid, '\s*)+?' ];
  interface_elem = [ interface_names '\s*:\s*', portmodes, '\s+', vtype, ];
  interface_list = [ '\s*(' interface_elem '\s*)+\s*'];
  entityname = ['\s*entity\s+', vid, '\s+is\s+port\s*' openp];

  ports = {};
  entity = 'unknown';
  [enstart enfinish entokens] = regexpi(st,entityname);
  if ~isempty(entokens)
    tok = entokens{1};
    entity = deblank(st(tok(1):tok(2)));
  else
    error(generatemsgid('entitynotfound'),'Cannot find start of VHDL entity in %s', file);
  end
  
  entityports = ['\s*entity\s+', entity, '\s+is\s+port\s*' openp, ...
                 '(.*)?',...
                 closep, '\s*;\s*end\s+', entity, '\s*;'  ];


  [startports finishports tokens] = regexpi(st,entityports);
  if ~isempty(tokens)
    tok = tokens{1};
    portstart = tok(1);
    portend   = tok(2);
    ielem = [st(portstart:portend), ';']; % add semi to make parsing easier
    [start_ie finish_ie tk2] = regexpi(ielem,interface_elem);
    if ~isempty(tk2)
      for m = 1:size(tk2,2)
        tok = tk2{m};
        names = st(portstart-1+tok(1,1):portstart-1+tok(1,2));
        pos = find(names == ',');
        if ~isempty(pos)
          temp = {};
          tcnt = 1;
          last = 1;
          for q = pos
            tstr = deblank(names(q-1:-1:last)); % reverse
            temp{tcnt} = deblank(tstr(end:-1:1));
            tcnt = tcnt + 1;
            last = q + 1;
          end
          tstr = deblank(names(end:-1:last)); % reverse
          temp{tcnt} = deblank(tstr(end:-1:1));
          names = temp;
        else
          tstr = deblank(names(end:-1:1)); % reverse
          names = deblank(tstr(end:-1:1));
        end
        dtype = deblank(ielem(tok(3,1):tok(3,2)));
        if dtype(end) == ';' 
          dtype = dtype(1:end-1);
        end
        ports{cnt} = { names,...
                       ielem(tok(2,1):tok(2,2)),...
                       dtype };
        cnt = cnt + 1;
      end
    end
  end

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Parse Arch
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  arch_body = ['architecture\s+', vid, '\s+of\s+', vid, '\s+is'];
  [startarch finisharch archtokens] =regexpi(st(finishports:end),arch_body);
  if ~isempty(archtokens)
    tok = archtokens{1};
    arch = deblank(st(finishports-1+tok(1,1):finishports-1+tok(1,2)));
  else
    arch = 'rtl';                       % default arch
  end

