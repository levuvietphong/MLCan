function [ELEV, LAT,    LONG,   decyear,    decdoy,     year,   doy,... 
                hour,   ZEN,    LAI,        Rg,         Ta,     VPD,...
                PPT,    U,      ustar,      Pa,         ea,     Fc,...
                LE,     H,      Hg,         Fc_qc,      LE_qc,  H_qc,...
                Tskin,  Ts4,    Ts8,        Ts16,       Ts32,   Ts64,   Ts128,...
                SWC10,  SWC20,  SWC30,      SWC40,      SWC50,	SWC60,  SWC100,...
                Rgout,  LWin,   LWout,      Rn  ] = ...
                ...
         LOAD_DATA_SoyAmeriflux(years,      doys,       laimin, hobs,   hcan,...
                                z0,         d0,         vonk,   datafile)
                           
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%%                             FUNCTION CODE                             %%
%%                        LOAD_DATA_CornAmeriflux                        %%
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::%
%-------------------------------------------------------------------------%
% This function is used to load Soy (Bondville) Ameriflux data            %
%   - gapfilled .mat data file name is hardcoded                          %
%-------------------------------------------------------------------------%
%   Created by  : Darren Drewry                                           %
%   Modified by : Phong Le                                                %
%   Date        : December 23, 2009                                       %
%-------------------------------------------------------------------------%    
% 
%
load(datafile);

    inds = find(ismember(year_corn, years) & ...
                ismember(doy_corn, doys)   & ...
                LAI_corn >= laimin);
%    
    decyear = decyear_corn(inds);
    decdoy  = decdoy_corn(inds);
    year    = year_corn(inds);
    doy     = doy_corn(inds);
    hour    = hour_corn(inds);
    ZEN     = ZEN_corn(inds);           % Zenith Angle
    LAI     = LAI_corn(inds);           % Leaf Area Index
%    
    Ta      = Ta_corn(inds);			% Air temperature
    VPD     = VPD_corn(inds);			% Vapour Pressure Deficit
    PPT     = PPT_corn(inds);			% Precipitation
    U       = U_corn(inds);             % Wind
    ustar   = ustar_corn(inds);			% Friction velocity
    Pa      = Pa_corn(inds);			% Pressure
    ea      = ea_corn(inds);            % Vapor pressure
%    
    Fc      = Fc_corn(inds);            % CO2 fluxes
    LE      = LE_corn(inds);			% Latent heat
    H       = H_corn(inds);             % Sensible heat
    Hg      = Hg_corn(inds);			% Heat conducted into soil
%    
    Fc_qc   = Fc_qc_corn(inds);         % qc means flag
    LE_qc   = LE_qc_corn(inds);         % same
    H_qc    = H_qc_corn(inds);          % same
%    
% SOIL TEMPERATURE DEPTHS (Surface, 4, 8, 16, 32, 64, 128) [Degree celcius]
    Tskin   = Tskin_corn(inds);
    Ts4     = Ts4_corn(inds);
    Ts8     = Ts8_corn(inds);
    Ts16    = Ts16_corn(inds);
    Ts32    = Ts32_corn(inds);
    Ts64    = Ts64_corn(inds);
    Ts128   = Ts128_corn(inds);
%
% SOIL WATER CONTENT DEPTHS 10, 20, 30, 40, 50, 60, 10 [% Volume]            
    SWC10   = SWC10_corn(inds);
    SWC20   = SWC20_corn(inds);
    SWC30   = SWC30_corn(inds);
    SWC40   = SWC40_corn(inds);
    SWC50   = SWC50_corn(inds);
    SWC60   = SWC60_corn(inds);
    SWC100  = SWC100_corn(inds);
%
    Rg      = Rg_corn(inds);                % Global radiation [W m-2]
    Rgout   = Rgout_corn(inds);             % Global radiation out [W m-2]
    LWin    = LWin_corn(inds);              % Longwave radiation in [W m-2]
    LWout   = LWout_corn(inds);             % Longwave radiation out [W m-2]
    Rn      = Rn_corn(inds);                % Net radiation [W m-2]
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
          
          
          
          
          
          
          