function [vertex,face] = read_mesh(file)

% read_mesh - read data from OFF, PLY, SMF or WRL file.
%
%   [vertex,face] = read_mesh(filename, verbose);
%
%   'vertex' is a 'nb.vert x 3' array specifying the position of the vertices.
%   'face' is a 'nb.face x 3' array specifying the connectivity of the mesh.
%
%   Copyright (c) 2005 Gabriel Peyré

ext = file(end-2:end);
ext = lower(ext);
if strcmp(ext, 'off')
    [vertex,face] = read_off(file);
elseif strcmp(ext, 'ply')
    [vertex,face] = read_ply(file);
elseif strcmp(ext, 'smf')
    [vertex,face] = read_smf(file);
elseif strcmp(ext, 'wrl')
    [vertex,face] = read_wrl(file);
else
    error('Unknown extension.');    
end