function resolvedSymbol = ec_mp_tool_version

% Copyright 2003 The MathWorks, Inc.

cr = sprintf('\n');
        ml_ver = ver('matlab');
        sl_ver = ver('simulink');
        rt_ver = ver('rtw');
        ec_ver = ver('ecoder');
        sf_ver = ver('stateflow');
        sc_ver = ver('coder');
        mp_ver = ver('mpt');
        fx_ver = ver('fixpoint');
        if ~isempty(ml_ver)
            ml_str = sprintf('%s %s %s', ml_ver.Name, ml_ver.Version, ml_ver.Date);
            ml_str = [' * ', ml_str, blanks(75-length(ml_str)), '*', cr];
        else
            ml_str = [];
        end
        if ~isempty(sl_ver)
            sl_str = sprintf('%s %s %s', sl_ver.Name, sl_ver.Version, sl_ver.Date);
            sl_str = [' * ', sl_str, blanks(75-length(sl_str)), '*', cr];
        else
            sl_str = [];
        end
        if ~isempty(rt_ver)
            rt_str = sprintf('%s %s %s', rt_ver.Name, rt_ver.Version, rt_ver.Date);
            rt_str = [' * ', rt_str, blanks(75-length(rt_str)), '*', cr];
        else
            rt_str = [];
        end
        if ~isempty(ec_ver)
            ec_str = sprintf('%s %s %s', ec_ver.Name, ec_ver.Version, ec_ver.Date);
            ec_str = [' * ', ec_str, blanks(75-length(ec_str)), '*', cr];
        else
            ec_str = [];
        end
        if ~isempty(sf_ver)
            sf_str = sprintf('%s %s %s', sf_ver.Name, sf_ver.Version, sf_ver.Date);
            sf_str = [' * ', sf_str, blanks(75-length(sf_str)), '*', cr];
        else
            sf_str = [];
        end
        if ~isempty(sc_ver)
            sc_str = sprintf('%s %s %s', sc_ver.Name, sc_ver.Version, sc_ver.Date);
            sc_str = [' * ', sc_str, blanks(75-length(sc_str)), '*', cr];
        else
            sc_str = [];
        end
        if ~isempty(mp_ver)
            mp_str = sprintf('%s %s %s', mp_ver.Name, mp_ver.Version, mp_ver.Date);
            mp_str = [' * ', mp_str, blanks(75-length(mp_str)), '*',cr];
        else
            mp_str = [];
        end
        if ~isempty(fx_ver)
            fx_str = sprintf('%s %s %s', fx_ver.Name, fx_ver.Version, fx_ver.Date);
            fx_str = [' * ', fx_str, blanks(75-length(fx_str)), '*',cr];
        else
            fx_str = [];
        end
        topComm = '/*======================== TOOL VERSION INFORMATION ==========================*';
        botComm = ' *============================================================================*/';
        resolvedSymbol = [topComm,cr,ml_str, sl_str, rt_str, ec_str, sf_str, sc_str, mp_str,fx_str ,botComm];