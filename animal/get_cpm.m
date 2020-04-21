%% get_cpm
% get cohort trajectories

%%
function [tXN, tXW, M_N, M_W, info] = get_cpm(model, par, tT, tJX, x_0, V_X, n_R, t_R)
% created 2020/03/03 by Bob Kooi & Bas Kooijman
  
%% Syntax
% [tXN, tXW, M_N, M_W, info] = <../get_cpm.m *get_cpm*> (model, par, tT, tJX, x_0, V_X, n_R, t_R)
  
%% Description
% integrates cohorts with synchronized reproduction events, called by cpm, 
%
% variables to be integrated, packed in Xvars:
%  X: mol/vol or mol/surface, food density
%    for each cohort:
%  q: 1/d^2, aging acceleration
%  h_a: 1/d, hazard for aging
%  L: cm, struc length
%  E: J/cm^3, reserve density [E]
%  E_R: J, reprod buffer
%  E_H: J, maturity
%  N: #, number of individuals in cohort
%
% number of current cohorts n_c = (length(Xvars) - 1)/8
% n_c increases for 1 till some max value, determined by number of oldest cohort < 1e-4, which depends on ageing and other hazards  
%
% Input:
%
% * model: character-string with name of model
% * par: structure with parameter values
% * tT: (nT,2)-array with time and temperature in Kelvin; time scaled between 0 (= start) and 1 (= end of cycle)
% * tJX: (nX,2)-array with time and food supply; time scaled between 0 (= start) and 1 (= end of cycle)
% * x_0: scalar with scaled initial food density 
% * V_X: scalar with volume of reactor
% * n_R: scalar with number of reproduction events to be simulated
% * t_R: scalar with time period between reproduction events 
%
% Output:
%
% * tXN: (n,m)-array with times, food density and number of individuals in the various cohorts
% * tXW: (n,m)-array with times, food density and total wet weights of the various cohorts
% * M_N: (n_c,n_c)-array with map for N: N(t+t_R) = M_N * N(t), where N(t) is the vector of numbers of individuals in the cohorts at t
% * M_W: (n_c,n_c)-array with map for W: W(t+t_R) = M_W * W(t), where W(t) is the vector of total wet weights in the cohorts at t
% * info: boolean with failure (0) or success (1)

%% Remarks
% The last 2 outputs (the maps for N and W) are only not-empty if the number of cohorts did not change long enough.

  options = odeset('Events',@puberty, 'AbsTol',1e-9, 'RelTol',1e-9);
  info = 1;
  
  % unpack par and compute compound pars
  vars_pull(par); vars_pull(parscomp_st(par));  
  
  % temperature correction
  par_T = T_A;
  if exist('T_L','var') && exist('T_AL','var')
    par_T = [T_A; T_L; T_AL];
  end
  if exist('T_L','var') && exist('T_AL','var') && exist('T_H','var') && exist('T_AH','var')
    par_T = [T_A; T_L; T_H; T_AL; T_AH]; 
  end
  % unscale knots for temperature, and convert to temp correction factors
  if length(tT) == 1
     TC = tempcorr(tT, T_ref, par_T); tTC = TC; % Temperature Correction factor
  else
     tTC = [tT(:,1) * t_R, tempcorr(tT(:,2), T_ref, par_T)]; TC = tTC(1,2); % Temperature Correction factor
  end
  % unscale knots for food density in supply flux
  if length(tJX) > 1
    tJX(:,1) = tJX(:,1) * t_R; % unscale tJX
  end
  
  % initial reserve and states at birth appended to par
  switch model
    case {'stf','stx'}        
      [S_b, q_b, h_Ab, tau_b, tau_0b, u_E0, l_b] = get_Sb_foetus([g k v_Hb h_a s_G h_B0b 0]); 
    otherwise
      [S_b, q_b, h_Ab, tau_b, tau_0b, u_E0, l_b] = get_Sb([g k v_Hb h_a s_G h_B0b 0]);
  end
  E_0 = g * E_m * L_m^3 * u_E0; % J, initial reserve
  if length(tTC)==1
    kT_M = k_M * TC; aT_b = tau_b/ kT_M; % d, age at birth (temp corrected)
  else
    kT_M = k_M * TC; aT_b = tau_b/ kT_M; % d, age at birth (temp corrected)
  end
  L_b = l_b * L_m; % cn, length at birth
  
  switch model
    case 'abj'
      [tau_j, tau_p, tau_b, l_j, l_p, l_b, l_i, rho_j, rho_B] = get_tj([g k l_T v_Hb v_Hj v_Hp]); % -, scaled ages and lengths
      L_j = l_j * L_m;
    case 'asj'
      [tau_s, tau_j, tau_p, tau_b, l_s, l_j, l_p, l_b, l_i, rho_j, rho_B] = get_ts([g, k, 0, v_Hb, v_Hs, v_Hj, v_Hp]); 
      L_s = l_s * L_m; L_j = l_j * L_m;
    case 'abp'
      [tau_j, tau_p, tau_b, l_j, l_p, l_b, l_i, rho_j, rho_B] = get_tj([g k l_T v_Hb v_Hp-1e-6 v_Hp]); % -, scaled ages and lengths
      L_p = l_j * L_m;
  end
  
  if t_R < aT_b
    fprintf('Warning from get_cpm: age at birth is larger than reproduction interval\n');
    info = 0; tXN = []; tXW = []; return
  end
  if strcmp(model,'ssj')
    pars_ts = [g k 0 v_Hb v_Hs]; [tau_s, tau_b, l_s, l_b] = get_tp(pars_ts, 1);
    tT_s = tau_s/ kT_M; tT_j = tT_s + t_sj; kT_E = k_E * TC;
    if t_R < tT_j
      fprintf('Warning from get_cpm: age at metam is larger than reproduction interval\n');
      info = 0; tXN = []; tXW = []; M_N = []; M_W = []; return
    end
  end
  
  % initial states with number of cohorts n_c = 1;
  X_0 = x_0 * K; % unscale initial food density
  Xvars_0 = [X_0; 0; 0; L_b; E_m; 0; E_Hb; 1]; % X q h L [E] E_R E_H N
  tXN = [0, X_0, 1]; tXW = [0, X_0, E_0/ mu_E * w_E/ d_E];% initialise output
  M_N = []; M_W = [];  
  
  for i = 1:n_R
    switch model
      case {'std','stf'}
        par_std = {E_Hp, E_Hb, tTC, tJX, V_X, h_D, h_J, q_b, h_Ab, h_Bbp, h_Bpi, h_a, s_G, thin, S_b, aT_b, ...
            L_b, L_m, E_m, k_J, k_JX, v, g, p_M, p_Am, J_X_Am, K, kap, kap_G};
        [t, Xvars] = ode45(@dcpm_std, [0; aT_b; t_R], Xvars_0, options, par_std{:});
      case 'stx'
        par_stx = {E_Hp, E_Hx, E_Hb, tTC, tJX, V_X, h_D, h_J, q_b, h_Ab, h_Bbx, h_Bxp, h_Bpi, h_a, s_G, thin, S_b, aT_b, ...
            L_b, L_m, E_m, k_J, k_JX, v, g, p_M, p_Am, J_X_Am, K, kap, kap_G};
        [t, Xvars] = ode45(@dcpm_stx, [0; aT_b; t_R], Xvars_0, options, par_stx{:});
      case 'ssj'
        par_ssj = {E_Hp, E_Hs, E_Hb, tTC, tJX, V_X, h_D, h_J, q_b, h_Ab, h_Bbs, h_Bjp, h_Bpi, h_a, s_G, thin, S_b, aT_b, ...
            L_b, L_m, E_m, k_E, k_J, k_JX, v, g, p_M, p_Am, J_X_Am, K, kap, kap_G};
        % treat shrinking at E_H(t) = E_Hs of first cohort as event
        [t, Xvars] = ode45(@dcpm_ssj, [0; aT_b; tT_s], Xvars_0, options, par_ssj{:});
        [X, q, h_A, L, L_max, E, E_R, E_H, N] = cpm_unpack(Xvars(end,:)); 
        L(1) = L(1) * exp(- t_sj * kT_E); N(1) = N(1) * exp( - t_sj * h_Bsj);
        Xvars_0 = max(0,[X; q; h_A; L; L_max; E; E_R; E_H; N]); % pack state vars
        [t, Xvars] = ode45(@dcpm_ssj, [tT_s; t_R], Xvars_0, options, par_ssj{:});
      case 'sbp'
        par_sbp = {E_Hp, E_Hb, tTC, tJX, V_X, h_D, h_J, q_b, h_Ab, h_Bbp, h_Bpi, h_a, s_G, thin, S_b, aT_b, ...
            L_b, L_m, E_m, k_J, k_JX, v, g, p_M, p_Am, J_X_Am, K, kap, kap_G};
        [t, Xvars] = ode45(@dcpm_sbp, [0; aT_b; t_R], Xvars_0, options, par_sbp{:});
      case 'abj'
        par_abj = {E_Hp, E_Hj, E_Hb, tTC, tJX, V_X, h_D, h_J, q_b, h_Ab, h_Bbj, h_Bjp, h_Bpi, h_a, s_G, thin, S_b, aT_b, ...
            L_b, L_j, L_m, E_m, k_J, k_JX, v, g, p_M, p_Am, J_X_Am, K, kap, kap_G};
        [t, Xvars] = ode45(@dcpm_abj, [0; aT_b; t_R], Xvars_0, options, par_abj{:});
      case 'asj'
        par_asj = {E_Hp, E_Hj, E_Hs, E_Hb, tTC, tJX, V_X, h_D, h_J, q_b, h_Ab, h_Bbs, h_Bsj, h_Bjp, h_Bpi, h_a, s_G, thin, S_b, aT_b, ...
            L_b, L_j, L_s, L_m, E_m, k_J, k_JX, v, g, p_M, p_Am, J_X_Am, K, kap, kap_G};
        [t, Xvars] = ode45(@dcpm_asj, [0; aT_b; t_R], Xvars_0, options, par_asj{:});
      case 'abp'
        par_abp = {E_Hp, E_Hb, tTC, tJX, V_X, h_D, h_J, q_b, h_Ab, h_Bbp, h_Bpi, h_a, s_G, thin, S_b, aT_b, ...
            L_b, L_p, L_m, E_m, k_J, k_JX, v, g, p_M, p_Am, J_X_Am, K, kap, kap_G};
        [t, Xvars] = ode45(@dcpm_abp, [0; aT_b; t_R], Xvars_0, options, par_abp{:});
      case {'hep','hex'}
        fprintf('Warning from get_cpm: this species does not sport periodic reproduction\n');
        info = 0; tXN = []; tXW = []; M_N = []; M_W = []; return
    end
    % catenate output and possibly insert new cohort
    [t, Xvars_0, tXN, tXW] = cohorts(t(end), Xvars(end,:), tXN, tXW, t_R, E_0, kap_R, L_b, E_m, E_Hb, mu_E, w_E, d_E); 
    n_c = (length(Xvars_0)-1)/7; % number of cohorts
    [i, n_c]
  end
  
  % maps
  if length(tXN) > n_c 
    M_N = tXN(end-n_c:end,3:end)'/tXN(end-n_c-1:end-1,3:end)';
    M_W = tXW(end-n_c:end,3:end)'/tXW(end-n_c-1:end-1,3:end)';
  end
end


function [t, Xvars_0, tXN, tXW] = cohorts(t, Xvars, tXN, tXW, t_R, E_0, kap_R, L_b, E_m, E_Hb, mu_E, w_E, d_E)
  t = tXN(end,1) + t_R; Xvars_t = Xvars(end,:); % last value of t, Xvars
  [X, q, h_A, L, E, E_R, E_H, N] = cpm_unpack(Xvars_t);

  % reproduction event
  dN = kap_R * sum(N .* floor(E_R/ E_0)); % #, number of new eggs
  E_R = mod(E_R, E_0); % reduce reprod buffer to fractions of eggs
    
  % build new initial state vectors and append t, X, N and W to output
  q = [0; q]; h_A = [0; h_A]; L = [L_b; L]; E = [E_m; E]; E_R = [0; E_R]; E_H = [E_Hb; E_H]; N = [dN; N]; 
  % most values for cohort 0 will be overwritten in dget_mod during embryo stage
  W = N .* L.^3 .* (1 + E/ mu_E * w_E/ d_E) + E_R/ mu_E * w_E/ d_E; % g, wet weights
  if N(end) > 1e-4 % add new youngest cohort
    tXN = [[tXN, zeros(size(tXN,1),1)]; [t, X, N']]; % append to output
    tXW = [[tXW, zeros(size(tXW,1),1)]; [t, X, W']]; % append to output
  else % add new youngest cohort and remove oldest
    q(end)=[]; h_A(end)=[]; L(end)=[]; E(end)=[]; E_R(end)=[]; E_H(end)=[]; N(end)=[]; W(end)=[];
    tXN = [tXN; [t, X, N']]; % append to output
    tXW = [tXW; [t, X, W']]; % append to output
  end
  Xvars_0 = max(0,[X; q; h_A; L; E; E_R; E_H; N]); % pack state vars
end

function [value,isterminal,direction] = puberty(t, Xvars, E_Hp, varargin)
  n_c = (length(Xvars) - 1)/ 7; % #, number of cohorts
  E_H = Xvars(1+5*n_c+(1:n_c)); % J, maturities, cf cpm_unpack
  value = min(abs(E_H - E_Hp)); % trigger 
  isterminal = 0;  % continue after event
  direction  = []; % get all the zeros
end

function [value,isterminal,direction] = leptoPub(t, Xvars, E_Hp, E_Hs, varargin)
  n_c = (length(Xvars) - 1)/ 7; % #, number of cohorts
  E_H = Xvars(1+5*n_c+(1:n_c)); % J, maturities, cf cpm_unpack
  value = [E_H(1) - E_Hs,  min(abs(E_H - E_Hp))]; % triggers 
  isterminal = [1 1];  % stop at event
  direction  = []; % get all the zeros
end

