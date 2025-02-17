function [ELEV, LAT,    LONG,   decyear,    decdoy,     year,   doy,... 
                hour,   ZEN,    LAI,        Rg,         Ta,     VPD,...
                PPT,    U,      ustar,      Pa,         ea,     Fc,...
                LE,     H,      Hg,         Fc_qc,      LE_qc,  H_qc,...
                Tskin,  Ts4,    Ts8,        Ts16,       Ts32,   Ts64,   Ts128,...
                SWC10,  SWC20,  SWC30,      SWC40,      SWC50,	SWC60,  SWC100,...
                Rgout,  LWin,   LWout,      Rn  ] = ...
                ...
         LOAD_DATA_SWAmeriflux(years,      doys,       laimin, hobs,   hcan,...
                                z0,         d0,         vonk,   datafile)
                           
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%%                             FUNCTION CODE                             %%
%%                        LOAD_DATA_SWAmeriflux                          %%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%-------------------------------------------------------------------------%
% This function is used to load (Bondville) Ameriflux data                %
%   - gapfilled .mat data file name is hardcoded                          %
%-------------------------------------------------------------------------%
%   Created by  : Darren Drewry                                           %
%   Modified by : Phong Le                                                %
%   Date        : December 23, 2009                                       %
%-------------------------------------------------------------------------%    
% 
%
load(datafile);

    inds = find(ismember(year_SW, years) & ...
                ismember(doy_SW, doys)   & ...
                LAI_SW >= laimin);
%    
    decyear = decyear_SW(inds);
    decdoy  = decdoy_SW(inds);
    year    = year_SW(inds);
    doy     = doy_SW(inds);
    hour    = hour_SW(inds);
    ZEN     = ZEN_SW(inds);             % Zenith Angle
    LAI     = LAI_SW(inds);             % Leaf Area Index
%    
    Ta      = Ta_SW(inds);              % Air temperature
    VPD     = VPD_SW(inds);             % Vapour Pressure Deficit
    PPT     = PPT_SW(inds);             % Precipitation
    U       = U_SW(inds);               % Wind
    ustar   = ustar_SW(inds);			% Friction velocity
    Pa      = Pa_SW(inds);              % Pressure
    ea      = ea_SW(inds);              % Vapor pressure
%    
    Fc      = Fc_SW(inds);              % CO2 fluxes
    LE      = LE_SW(inds);              % Latent heat
    H       = H_SW(inds);               % Sensible heat
    Hg      = Hg_SW(inds);              % Heat conducted into soil
%    
    Fc_qc   = 0; %Fc_qc_SW(inds);           % qc means flag
    LE_qc   = 0; %LE_qc_SW(inds);           % same
    H_qc    = 0; %H_qc_SW(inds);            % same
%    
% SOIL TEMPERATURE DEPTHS (Surface, 4, 8, 16, 32, 64, 128) [Degree celcius]
    Tskin   = Tskin_SW(inds);
    Ts4     = Ts4_SW(inds);
    Ts8     = Ts8_SW(inds);
    Ts16    = Ts16_SW(inds);
    Ts32    = Ts32_SW(inds);
    Ts64    = Ts64_SW(inds);
    Ts128   = Ts128_SW(inds);
%
% SOIL WATER CONTENT DEPTHS 10, 20, 30, 40, 50, 60, 10 [% Volume]            
    SWC10   = SWC10_SW(inds);
    SWC20   = SWC20_SW(inds);
    SWC30   = SWC30_SW(inds);
    SWC40   = SWC40_SW(inds);
    SWC50   = SWC50_SW(inds);
    SWC60   = SWC60_SW(inds);
    SWC100  = SWC100_SW(inds);
%
    Rg      = Rg_SW(inds);                % Global radiation [W m-2]
    Rgout   = Rgout_SW(inds);             % Global radiation out [W m-2]
    LWin    = LWin_SW(inds);              % Longwave radiation in [W m-2]
    LWout   = LWout_SW(inds);             % Longwave radiation out [W m-2]
    Rn      = Rn_SW(inds);                % Net radiation [W m-2]
%    
% Calculate Vapor Variables (See Campbell and Norman, 1998)
    aa      = 0.611;                        % [kPa]
    bb      = 17.502;                       % [Dimensionless]
    cc      = 240.97;                       % [Degree Celcius]
    esat    = aa * exp((bb * Ta)./(cc+Ta));	% Saturation vapor pressure (Tetens formula, Buck 1981)
    ean     = esat - VPD;
    hr      = ea ./ esat;                   % Relative humidity
%    
% Data Corrections    
    uinds   = find(U<0.1);
    U(uinds)= 0.1;
%
% Calculate ustar for missing periods
    binds   = find(isnan(ustar) | ustar<=0);
    ustar(binds) = vonk.*U(binds)./(log((hobs-d0)/z0));
%    
% Adjust U from measurement height to canopy height (Brutsaert, 4.2)
    U       = U - (ustar/vonk).*log(hobs/hcan);
    uinds   = find(U<0.1);
    U(uinds)= 0.1;
%    
% Downward LW - eliminate pre-2005.5 data as they appear to be filled with
% low values
%    binds = find(decyear<2005.5);
%    LWin(binds) = NaN;
%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%% <<<<<<<<<<<<<<<<<<<<<<<<< END OF FUNCTION >>>>>>>>>>>>>>>>>>>>>>>>>>>>%%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%          
          
          
          
          
          
          
          