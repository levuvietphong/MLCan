function [znode_all, dz_all, zlayer_all, nl_soil, rootfr] = SOILGRIDCORN
% Interpolate Monti's Observed Root profiles to model soil grid
% Output normalized root profile

% Monti's Root Profile Data
% Depth of 15cm intervals
    zlayer_all  = [15, 30, 45, 60, 75, 90, 105, 120]'/100;
    znode_all   = [7.5, 22.5, 37.5, 52.5, 67.5, 82.5, 107.5, 112.5]'/100;
    dz_all      = [15, 15, 15, 15, 15, 15, 15, 15]'/100;
    
% Root density
    root_den    = [2.76, 3.79, 4.45, 2.56, 1.99, 1.52, 0.96, 0.16]';

% Calculate the number of soil layer
    nl_soil     = length(zlayer_all);
    
% Interpolate root soil grid
    rootfr      = root_den/sum(root_den);
end