function [znode_all, dz_all, zlayer_all, nl_soil, rootfr] = SOILGRIDSW
% Interpolate Monti's Observed Root profiles to model soil grid
% Output normalized root profile - MISCANTHUS

% Monti's Root Profile Data
% Depth of 15cm intervals
    zlayer_all  = [ 15,   30,   45,   60,   75,   90,   105,   120,   135,   150,   165,   180,   195,   210,   225,   240,   255,   270,   285,   300,   315,   330,   345,   360,   375,   390]'/100;
    znode_all   = [7.5, 22.5, 37.5, 52.5, 67.5, 82.5, 107.5, 112.5, 127.5, 142.5, 157.5, 172.5, 187.5, 202.5, 217.5, 232.5, 247.5, 262.5, 277.5, 292.5, 307.5, 322.5, 337.5, 352.5, 367.5, 382.5]'/100;
    dz_all      = [ 15,   15,   15,   15,   15,   15,    15,    15,    15,    15,    15,    15,    15,    15,    15,    15,    15,    15,    15,    15,    15,    15,    15,    15,    15,    15]'/100;
    
% Root density
    root_den    = [9.79, 1.29, 0.30, 0.486, 0.39, 0.28, 0.056, 0.037, 10e-4, 10e-5, 10e-6, 10e-6, 10e-6, 10e-6, 10e-6, 10e-6, 10e-6, 10e-6, 10e-6, 10e-6, 10e-6, 10e-6, 10e-6, 10e-6, 10e-6, 10e-6]';

% Calculate the number of soil layer
    nl_soil     = length(zlayer_all);
    
% Interpolate root soil grid
    rootfr      = root_den/sum(root_den);
end