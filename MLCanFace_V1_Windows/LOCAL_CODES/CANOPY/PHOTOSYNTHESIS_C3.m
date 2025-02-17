function [Ph,   An,   	Phtype,     gamstar,        Wc,...
                Wj,     Vcmax,      Jmax] = ...
    PHOTOSYNTHESIS_C3(...
            VARIABLES,  PARAMS,     VERTSTRUC,      CONSTANTS,      sunlit) 
%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%%                              FUNCTION CODE                            %%
%%                     C3 PHOTOSYNTHESIS CALCULATION                     %%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%-------------------------------------------------------------------------%
%   Calculates leaf photosynthesis according to in vivo parameterization  %
%   of Farquhar's (1980) model made by Bernacchi et al (2001, 2003)       %
%   The particular parameterization used here is taken from the equations %
%   in Appendix 2 of Bernacchi et al (2003): Plant, Cell and Environment, %
%   26, 1419-1430                                                         %
%-------------------------------------------------------------------------%
%                                                                         %
%   INPUTS:                                                               %
%       Qabs    = absorbed PAR                      [umol/m^2 leaf area/s]%
%       Tl      = leaf temperature                  [C]                   %
%       Ci      = internal CO2 concentration        [ppm]                 %
%       O       = oxygen concentration                                    %
%       Vcmax25 = Vcmax at 25C                      [umol/m^2 leaf area/s]%
%       Jmax25  = Jmax at 25C                       [umol/m^2 leaf area/s]%
%       Rd25    = Rd at 25C                         [umol/m^2 leaf area/s]%
%       nvinds  = grid indices for which there is no vegetation           %
%                                                                         %
%   OUTPUTS:                                                              %
%       Ph       = gross leaf photosynthesis        [umol/m^2 leaf area/s]%
%       An       = net leaf CO2 uptake rate         [umol/m^2 leaf area/s]%
%                                                                         %
%-------------------------------------------------------------------------% 
%   Date        : January 13, 2010                                        %
%% --------------------------------------------------------------------- %%  
%
%
%*************************************************************************%
%% <<<<<<<<<<<<<<<<<<<<<<<<< DE-REFERENCE BLOCK >>>>>>>>>>>>>>>>>>>>>>>> %%
%*************************************************************************%
%
	if (sunlit)                                     % Sunlit
        Qabs = VARIABLES.CANOPY.PARabs_sun;
        Tl   = VARIABLES.CANOPY.Tl_sun;
        Ci   = VARIABLES.CANOPY.Ci_sun;
    else                                            % Shaded      
        Qabs = VARIABLES.CANOPY.PARabs_shade;
        Tl   = VARIABLES.CANOPY.Tl_shade;
        Ci   = VARIABLES.CANOPY.Ci_shade;
    end
%
    Vcmax25 = PARAMS.Photosyn.Vcmax25_C3;             
    Jmax25  = PARAMS.Photosyn.Jmax25_C3;
    Rd25    = PARAMS.Photosyn.Rd25;
    beta    = PARAMS.Photosyn.beta_ph_C3;
    O       = PARAMS.Photosyn.Oi;
%
    Vz      = VARIABLES.CANOPY.Vz;
    nvinds  = VERTSTRUC.nvinds; 
%    
    R_J     = CONSTANTS.R;
%    
%*************************************************************************%
%% <<<<<<<<<<<<<<<<<<<<<<< END OF DE-REFERENCE BLOCK >>>>>>>>>>>>>>>>>>> %%
%*************************************************************************%
%% 
    if (Qabs<=0)
        Ph      = zeros(size(Tl));
        An      = zeros(size(Tl));
        Phtype  = zeros(size(Tl));
        gamstar = zeros(size(Tl));
        Wc      = zeros(size(Tl));
        Wj      = zeros(size(Tl));
    end
% 
    R       = R_J/1000;                               % [kJ mol^-1 K^-1]     
    TlK     = Tl + 273.15;  
%    
    Vcmax25 = Vz * Vcmax25;
    Jmax25  = Vz * Jmax25;
%    
    gamstar = exp(19.02 - 37.83./(R*TlK));
    Ko      = exp(20.30 - 36.38./(R*TlK));
    Kc      = exp(38.05 - 79.43./(R*TlK));
%    
    Rd      = Rd25 * exp(18.72 - 46.39./(R*TlK));
%                
    Vcmax   = Vcmax25 .* exp(26.35 - 65.33./(R*TlK));
%     
    phiPSIImax  = 0.352 + 0.022 * Tl - 0.00034 * Tl .^ 2;
    Q2          = Qabs .* phiPSIImax * beta;
    thetaPSII   = 0.76 + 0.018 * Tl - 0.00037 * Tl .^ 2;
    Jmax        = Jmax25 .* exp(17.57 - 43.54./(R * TlK));
    J           = (Q2+Jmax-sqrt((Q2+Jmax).^2 - 4 * thetaPSII.*Q2.*Jmax))...
                    ./ (2 * thetaPSII);
%    
    Wc          = (Vcmax .* Ci) ./ (Ci + Kc .* (1 + O ./ Ko));
    Wj          = (J .* Ci) ./ (4.5 * Ci + 10.5 * gamstar);
    
% Limiting Rates
    Jc = (1 - gamstar./Ci) .* Wc;
    Jj = (1 - gamstar./Ci) .* Wj;
    Js = Vcmax ./ 2;
    
% Solve quadratics from [Collatz et al, ] to account for co-limitation between rates
    tt = 0.98;
    bb = 0.96;
    Jp = ( (Jc+Jj) - sqrt( (-(Jc+Jj)).^2 - 4*tt*Jc.*Jj ) ) ./ (2*tt);
    Ph = ( (Jp+Js) - sqrt( (-(Jp+Js)).^2 - 4*bb*Jp.*Js ) ) ./ (2*bb);
%    
    An =  Ph - Rd;
%    
    Phtype          = NaN(size(Jc));
    Jcinds          = find(Jc<Jj & Jc<Js);
    Phtype(Jcinds)  = 1;
    Jjinds          = find(Jj<=Jc & Jj<=Js);
    Phtype(Jjinds)  = 2;
    Jsinds          = find(isnan(Phtype));
    Phtype(Jsinds)  = 3;
%      
    Ph(nvinds)      = 0;
    An(nvinds)      = 0;
%
%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%% <<<<<<<<<<<<<<<<<<<<<<<<< END OF FUNCTION >>>>>>>>>>>>>>>>>>>>>>>>>>>>%%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
                