function desout=loadobj(desin)
%LOADOBJ Object loading function
%
%  B=LOADOBJ(A) is called when a design object is loaded.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:07:05 $


if isa(desin,'xregdesign');
    % loading worked ok anyway
    desout=desin;
else
    % do version switching
    % new features are cumulatively added to this section
    if desin.version<=1
        % version 1 -> 1.1 additions
        % need a display field
        desin.displaynatural=0;
        desin.version=1.1;
    end

    if desin.version<=1.1
        % version 1.1 ->1.2
        desin.constraintsflag=0;
        desin.version=1.2;
    end
    if desin.version<=1.2
        % version 1.2 -> 2
        desin.guiflags.waitbars=1;
        desin.version=2;
    end
    if desin.version<=2
        desin.model= xregmodel('nfactors',desin.nfactors);
        desin.modelstate=0;
        desin.version=3;
    end
    if desin.version<=3
        % candidate set updating
        new_cs=i_convert_to_cs(desin);
        desin=mv_rmfield(desin,'pointbasis');
        desin=mv_rmfield(desin,'basisparams');
        desin.candset=new_cs;
    end
    if desin.version<=4
        % added information on design type
        desin.style=struct('base',1,'baseinfo',desin.lastoptimisation);
    end
    if desin.version<=5
        desin.lockflag=0;
    end
    if desin.version<=6
        % Convert fixedpoints field to one of a set of bit flags
        flgs = uint8(zeros(length(desin.fixedpoints), 1));
        if ~isempty(desin.fixedpoints)
            % Make sure fixedpoints field is logical: needed to fix bug
            % where the field could become double.
            idx = logical(desin.fixedpoints);
            flgs(idx) = bitset(flgs(idx), 1, 1);
        end
        
        desin.designpointflags = flgs;
        desin = rmfield(desin, 'fixedpoints');
    end
    desout=xregdesign(desin);
end
if isempty(desout.design)
    % make sure design field is the correct size
    desout.design = zeros(0, desout.nfactors);
end
return


function cs=i_convert_to_cs(des)
switch des.pointbasis
    case 'continuous'
        warning('Continuous candidate set no longer supported.  Converting to a Grid...');
        for n=1:length(des.basisparams)
            lvls(n)={linspace(min(des.basisparams{n}),max(des.basisparams{n}),21)};
        end
        cs=cset_grid(lvls);

    case 'fullgrid'
        cs=cset_grid(des.basisparams);
    case 'lattice'
        cs=cset_lattice({des.basisparams.limits,des.basisparams.g,des.basisparams.N});
    case 'grid/lattice'
        s=des.basisparams;
        cs=cset_grdlatt({{s.griddims,s.lattdims},s.grid.levels,s.lattice.limits,s.lattice.g,s.lattice.N});
    case 'lhs'
        s=des.basisparams;
        cs=cset_lhs(candidateset, {s.limits, s.N, s.selectMethod, 'random',1}, s.indices);
    case 'userdef'
        cs=cset_userdef(des.basisparams.data);
end
return
