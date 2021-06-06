%% estim_options
% Sets options for estim.pars

%%
function estim_options (key, val)
  %  created at 2015/01/25 by Goncalo Marques; 
  %  modified 2015/03/26 by Goncalo Marques, 2018/05/21, 2018/08/21 by Bas Kooijman, 2019/12/20 by Nina Marn, 2021/06/06 by Bas Kooijman
  
  %% Syntax
  % <../estim_options.m *estim_options*> (key, val)
  
  %% Description
  % Sets options for estimation one by one, some apply to methods nm and ga, others are specific for nm or ga
  %
  % Input
  %
  % * no input: print values to screen
  % * one input:
  %
  %    'default': sets options at default values
  %     any other key (see below): print value to screen
  %
  % * two inputs
  %
  %    'loss_function': 
  %      'sb': multiplicative symmetric bounded (default)
  %      'su': multiplicative symmetric unbounded
  %      're': relative error (not recommanded)
  %
  %    'filter': 
  %      0: do not use filters;
  %      1: use filters (default)
  %
  %    'pars_init_method':
  %      0: get initial estimates from automatized computation 
  %      1: read initial estimates from .mat file (for continuation)
  %      2: read initial estimates from pars_init file (default)
  %
  %    'results_output':
  %      0     - only saves data to .mat (no printing to html or screen and no figures) - use this for (automatic) continuations 
  %      1, -1 - no saving to .mat file, prints results to html (1) or screen (-1), shows figures but does not save them
  %      2, -2 - saves to .mat file, prints results to html (2) or screen (-2), shows figures but does not save them
  %      3, -3 - like 2 (or -2), but also prints graphs to .png files (default is 3)
  %      4, -4 - like 3 (or -3), but also prints html with implied traits
  %      5, -5 - like 4 (or -4), but includes related species in the implied traits
  %      6     - like 5, but also prints html with population traits
  %   
  %    'method': 
  %      'no': do not estimate
  %      'nm': Nelder-Mead method
  %      'ga': genetic algorithm
  %
  %    'max_fun_evals': maximum number of function evaluations (default 10000)
  %
  %    'report' (method nm only): 
  %       0 - do not report
  %       1 - report steps to screen (default)
  %
  %    'max_step_number' (method nm only): maximum number of steps (default 500)
  %
  %    'tol_simplex' (method nm only): tolerance for how close the simplex points must be together to call them the same (default 1e-4)
  %
  %    'tol_fun' (method nm only): tolerance for how close the loss-function values must be together to call them the same (default 1e-4)
  %
  %    'simplex_size' (method nm only): fraction added (subtracted if negative) to the free parameters when building the simplex (default 0.05)
  %
  %    'search_method' (method ga only): 
  %      'mm1' - use shade method (default)
  %      'mm2' - do not estimate
  %     
  %    'num_results' (method ga only): The size for the multimodal algorithm's population. The author recommended
  %       100 for SHADE ('search_method mm1', default) 
  %       18 * number of free parameters for L-SHADE ('search method mm2')
  %
  %    'gen_factor' (method ga only): percentage to build the ranges for initializing the first population of individuals (default 0.5)                  
  %
  %    'bounds_from_ind' (method ga only): 
  %      0: use ranges from pseudodata if exist (these ranges not existing will be taken from data)         
  %      1: use ranges from data (default) 
  %
  %    'max_calibration_time' (method ga only): maximum calibration time in minutes (default 30)
  %
  %    'num_runs' (method ga only): the number of independent runs to perform (default 1)
  %
  %    'add_initial' (method ga only): if the initial individual is added in the first  population.
  %      1: activated
  %      0: not activated (default)
  %
  %    'refine_initial' (method ga only): if the initial individual is refined using Nelder-Mead.
  %      0: not activated (default)
  %      1: activated
  %     
  %    'refine_best'  (method ga only): if the best individual found is refined using Nelder-Mead.
  %      0: not activated (default)
  %      1: activated
  %     
  %    'refine_running' (method ga only): If to apply local search to some individuals while simulation is running 
  %      0: not activated (default)
  %      1: activated
  %
  %    'refine_run_prob' (method ga only): The probability to apply a local search to an individual while algorithm is running (default 0.05)
  %
  %    'refine_firsts' (method ga only): If to apply a local search to the first population
  %       0: not activated (default)
  %       1: activated (this is recommended when the algorithm is not able to converge to good solutions till the end of its execution)
  %
  %    'verbose_options' (method ga only): The number of solutions to show from the set of optimal solutions found by the algorithm through the calibration process (default 10)                                           
  %
  %    'verbose' (method ga only): prints some information while the calibration  process is running              
  %       0: not activated (default)
  %       1: activated
  %
  %    'seed_index' (method ga only): index of vector with values for the seeds used to generate random values 
  %       each one is used in a single run of the algorithm (default 1, must be between 1 and 30)
  %
  %    'ranges' (method ga only): Structure with ranges for the parameters to be calibrated (default empty)
  %       one value (factor between [0, 1], if not: 0.01 is set) to increase and decrease the original parameter values.
  %       two values (min, max) for the  minimum and maximum range values. Consider:               
  %         (1) Use min < max for each variable in ranges. If it is not, then the range will be not used
  %         (2) Do not take max/min too high, use the likely ranges of the problem
  %         (3) Only the free parameters (see 'pars_init_my_pet' file) are considered
  %       Set range with cell string of name of parameter and value for range, e.g. estim_options('ranges',{'kap', [0.3 1]}} 
  %       Remove range-specification with e.g. estim_options('ranges', {'kap'}} or estim_options('ranges', 'kap'}
  %
  %    'results_display (method ga only)': 
  %       Basic - Does not show results in screen (default) 
  %       Best  - Plots the best solution results in DEBtool style
  %       Set   - Plots all the solutions remarking the best one 
  %               html with pars (best pars and a measure of the variance of each parameter in the solutions obtained for example)
  %       Complete - Joins all options with zero variate data with input and a measure of the variance of all the solutions considered
  %
  %    'results_filename (method ga only)': The name for the results file (solutionSet_my_pet_time) 
  %
  %    'save_results' (method ga only): If the results output images are going to be saved
  %       0: no saving (default)
  %       1: saving
  %
  %    'mat_file' (method ga only): The name of the .mat-file with results from where to initialize the calibration parameters 
  %       (only useful if pars_init_method option is equal to 1 and if there is a result file)
  %       This file is outputted as results_my_pet.mat ("my pet" replaced by name of species) using method nm, results_output 0, 2-6.
  %
  % Output
  %
  % * no output, but globals are set to values or values are printed to screen
  %
  %% Remarks
  % See <estim_pars.html *estim_pars*> for application of the option settings.
  % Initial estimates are controlled by option 'pars_init_method', but the free-setting is always taken from the pars_init file
  % A typical estimation procedure is
  % 
  % * first use estim_options('pars_init_method',2) with estim_options('max_step_number',500),
  % * then estim_options('pars_init_method',1), repeat till satiation or convergence (using arrow-up + enter)
  % * type mat2pars_init in the Matlab's command window to copy the results in the .mat file to the pars_init file
  %
  % The default setting for max_step_number on 500 in method nm is on purpose not enough to reach convergence.
  % Continuation (using arrow-up + 'enter' after 'pars_init_method' set on 1) is important to restore simplex size.
  %
  %% Example of use
  %  estim_options('default'); estim_options('filter', 0); estim_options('method', 'no')
 
  global method lossfunction filter pars_init_method results_output max_fun_evals 
  global report max_step_number tol_simplex tol_fun simplex_size % method nm only
  global search_method num_results gen_factor bounds_from_ind % method ga only
  global max_calibration_time  num_runs add_initial  
  global refine_initial refine_best  refine_running refine_run_prob refine_firsts 
  global verbose verbose_options random_seeds seed_index ranges mat_file
  global results_display results_filename save_results

  availableMethodOptions = {'no', 'nm', 'ga'};

  if exist('key','var') == 0
    key = 'inexistent';
  end
      
  switch key
	
    case 'default'
      lossfunction = 'sb';
      filter = 1;
      pars_init_method  = 2;
      results_output = 3;
      method = 'nm';
	  max_fun_evals = 1e4;
      
      % for nm method
	  report = 1;
	  max_step_number = 500;
	  tol_simplex = 1e-4;
	  tol_fun = 1e-4;
      simplex_size = 0.05;

      % for ga method (taken from calibration_options)
      search_method = 'mm1'; % Use SHADE 
      num_results = 100;   % The size for the multimodal algorithm's population.
                           % If not defined then sets the values recommended by the author, 
                           % which are 100 for SHADE ('mm1') and 18 * problem size for L-SHADE.
      gen_factor = 0.5;    % Percentage bounds for individual 
                           % initialization. (e.g. A value of 0.9 means that, for a parameter value of 1, 
                           % the range for generation is [(1 - 0.9) * 1, 1 * (1 + 0.9)] so
                           % the new parameter value will be a random between [0.1, 1.9]
      bounds_from_ind = 1; % This options selects from where the parameters for the initial population of individuals are taken. 
                           % If the value is equal to 1 the parameters are generated from the data initial values 
                           % if is 0 then the parameters are generated from the pseudo data values. 
      add_initial = 0;     % If to add an invidivual taken from initial data into first population.
      refine_initial = 0;  % If a refinement is applied to the initial individual of the population 
                           % (only if it the 'add_initial' option is activated)
      refine_best = 0;     % If a local search is applied to the best individual found. 
      refine_running = 0;  % If to apply local search to some individuals while simulation is running. 
      refine_run_prob = 0.05; % The probability to apply a local search to an individual while algorithm is  running. 
      refine_firsts = 0;   % If to apply a local search to the first population (this is recommended when the
                           % algorithm is not able to converge to good solutions till the end of its execution). 
      max_calibration_time = 30; % The maximum calibration time calibration process. 
      num_runs = 1; % The number of runs to perform. 
      verbose = 0;  % If to print some information while the calibration process is running. 
      verbose_options = 10; % The number of solutions to show from the  set of optimal solutions found by the  algorithm through the calibration process.
      random_seeds = [2147483647, 2874923758, 1284092845, ... % The values of the seed used to
                      2783758913, 3287594328, 9328947617, ... % generate random values (each one is used in a
                      1217489374, 9815931031, 3278479237, ... % single run of the algorithm).
                      8342427357, 8923758927, 7891375891, ... 
                      8781589371, 8134872397, 2784732823]; 
      seed_index = 1; % index for seeds for random number generator
      rng(random_seeds(seed_index), 'twister'); % initialize the number generator is with a seed, to be updated for each run of the calibration method.
      ranges = struct(); % The range struct is empty by default. 
      results_display = 'Basic'; % The results output style.
      results_filename = 'Default';
      save_results = false; % If results output are saved.
      mat_file = '';

    case 'loss_function'
      if exist('val','var') == 0
        if numel(lossfunction) ~= 0
          fprintf(['loss_function = ', lossfunction,' \n']);  
        else
          fprintf('loss_function = unknown \n');
        end
        fprintf('sb - multiplicative symmetric bounded \n');
        fprintf('su - multiplicative symmetric unbounded \n');
        fprintf('re - relative error \n');
      else
        lossfunction = val;
      end
      
    case 'filter'
      if exist('val','var') == 0
        if numel(filter) ~= 0
          fprintf(['filter = ', num2str(filter),' \n']);  
        else
          fprintf('filter = unknown \n');
        end
        fprintf('0 - do not use filter \n');
        fprintf('1 - use filter \n');
      else
        filter = val;
      end
      
    case 'pars_init_method'
      if exist('val','var') == 0
        if numel(pars_init_method) ~= 0
          fprintf(['pars_init_method = ', num2str(pars_init_method),' \n']);  
        else
          fprintf('pars_init_method = unknown \n');
        end	      
        fprintf('0 - get initial estimates from automatized computation \n');
        fprintf('1 - read initial estimates from .mat file \n');
        fprintf('2 - read initial estimates from pars_init file \n');
      else
        pars_init_method = val;
      end

    case 'results_output'
      if exist('val','var') == 0
        if numel(results_output) ~= 0
          fprintf(['results_output = ', num2str(results_output),' \n']);
        else
          fprintf('results_output = unknown \n');
        end	 
        fprintf('0      only saves data results to .mat, no figures, no writing to html or screen\n');
        fprintf('1, -1  no saving to .mat file, prints results to html (1) or screen (-1)\n');
        fprintf('2, -2  saves to .mat file, prints results to html (2) or screen (-2) \n');
        fprintf('3, -3  like 2 (or -2), but also prints graphs to .png files (default is 3)\n');
        fprintf('4, -4  like 3 (or -3), but also prints html with implied traits \n');
        fprintf('5, -5  like 3 (or -3), but also prints html with implied traits including related species \n');
        fprintf('6,     like 5, but also prints html with population traits \n');         
      else
        results_output = val;
      end
            
    case 'method'
      if exist('val','var') == 0 || ~any(ismember(availableMethodOptions, val))
        if numel(method) ~= 0
          fprintf(['method = ', method,' \n']);  
        else
          fprintf('method = unknown \n');
        end	      
        fprintf('''no'' - do not estimate \n');
        fprintf('''nm'' - use Nelder-Mead method \n');
        fprintf('''ga'' - use genetic algorithm method \n');
      else
        method = val;
      end

    case 'max_fun_evals'
      if exist('val','var') == 0 
        if numel(max_fun_evals) ~= 0
          fprintf(['max_fun_evals = ', num2str(max_fun_evals),' \n']);  
        else
          fprintf('max_fun_evals = unknown \n');
        end	      
      else
        max_fun_evals = val;
        % max_calibration_time = Inf; % ga method only
      end
   
    % method nm only
    case 'report'
      if ~exist('val','var')
        if numel(report) ~= 0
          fprintf(['report = ', num2str(report),' (method nm)\n']);  
        else
          fprintf('report = unknown \n');
        end	      
        fprintf('0 - do not report \n');
        fprintf('1 - do report \n');
      else
        report = val;
      end

    case 'max_step_number'
      if exist('val','var') == 0 
        if numel(max_step_number) ~= 0
          fprintf(['max_step_number = ', num2str(max_step_number),' (method nm)\n']);  
        else
          fprintf('max_step_number = unknown \n');
        end	      
      else
        max_step_number = val;
      end

    case 'tol_simplex'
      if exist('val','var') == 0 
        if numel(tol_simplex) ~= 0
          fprintf(['tol_simplex = ', num2str(tol_simplex),' (method nm)\n']);  
        else
          fprintf('tol_simplex = unknown \n');
        end	      
      else
        tol_simplex = val;
      end

    case 'simplex_size'
      if exist('val','var') == 0 
        if numel(simplex_size) ~= 0
          fprintf(['simplex_size = ', num2str(simplex_size),' (method nm)\n']);  
        else
          fprintf('simplex_size = unknown \n');
        end	      
      else
        simplex_size = val;
      end
      
    % method ga only, taken from calibatrion_options
    case 'search_method'
      if ~exist('val','var')
        search_method = 'mm1'; % Select SHADE as the default method.
      else
        search_method = val;
      end 
      
    case 'num_results'
      if ~exist('val','var')
        if numel(num_results) ~= 0 
          fprintf(['num_results = ', num2str(num_results),' \n']);  
        else
          fprintf('num_results = unknown \n');
        end	      
      else
        if num_results < 100 
          num_results = 100;
        else
          num_results = val;
        end
      end
      
    case 'gen_factor'
      if ~exist('val','var')
        if numel(gen_factor) ~= 0.0
          fprintf(['gen_factor = ', num2str(gen_factor),' \n']);  
        else
          fprintf('gen_factor = unknown \n');
        end	      
      else
        if val >= 1.0
           val = 0.99;
        elseif val <= 0.0
           val = .01;
        end
        gen_factor = val;
      end
      
    case 'bounds_from_ind'
      if ~exist('val','var')
        if numel(bounds_from_ind) ~= 0
          fprintf(['bounds_from_ind = ', num2str(bounds_from_ind),' \n']);  
        else
          fprintf('bounds_from_ind = unknown \n');
        end	      
      else
        bounds_from_ind = val;
      end
      
    case 'add_initial'
      if ~exist('val','var')
        if numel(add_initial) ~= 0
          fprintf(['add_initial = ', num2str(add_initial),' \n']);  
        else
          fprintf('add_initial = unknown \n');
        end	      
      else
        add_initial = val;
      end
      
    case 'refine_running'
      if ~exist('val','var')
        if numel(refine_running) ~= 0
          fprintf(['refine_running = ', num2str(refine_running),' \n']);  
        else
          fprintf('refine_running = unknown \n');
        end	      
      else
        refine_running = val;
      end
      
    case 'refine_run_prob'
      if ~exist('val','var')
        if numel(refine_run_prob) ~= 0
          fprintf(['refine_run_prob = ', num2str(refine_run_prob),' \n']);  
        else
          fprintf('refine_run_prob = unknown \n');
        end	      
      else
        refine_run_prob = val;
      end
      
    case 'refine_firsts'
      if ~exist('val','var')
        if numel(refine_firsts) ~= 0
          fprintf(['refine_firsts = ', num2str(refine_firsts),' \n']);  
        else
          fprintf('refine_firsts = unknown \n');
        end	      
      else
        refine_firsts = val;
      end
      
    case 'refine_initial'
      if ~exist('val','var')
        if numel(refine_initial) ~= 0
          fprintf(['refine_initial = ', num2str(refine_initial),' \n']);  
        else
          fprintf('refine_initial = unknown \n');
        end	      
      else
        refine_initial = val;
      end
      
    case 'refine_best'
      if ~exist('val','var')
        if numel(refine_best) ~= 0
          fprintf(['refine_best = ', num2str(refine_best),' \n']);  
        else
          fprintf('refine_best = unknown \n');
        end	      
      else
        refine_best = val;
      end
      
    case 'max_calibration_time'
      if ~exist('val','var')
        if numel(max_calibration_time) ~= 0
          fprintf(['max_calibration_time = ', num2str(max_calibration_time),' \n']);
        else
          fprintf('max_calibration_time = unkown \n');
        end
      else
        max_calibration_time = val;
        max_fun_evals = Inf;
      end
      
    case 'num_runs'
      if ~exist('val','var')
        if numel(max_fun_evals) ~= 0
          fprintf(['num_runs = ', num2str(num_runs),' \n']);
        else
          fprintf('num_runs = unkown \n');
        end
      else
        num_runs = val;
      end
      
    case 'verbose'
      if ~exist('val','var')
        if numel(verbose) ~= 0
          fprintf(['verbose = ', num2str(verbose),' \n']);
        else
          fprintf('verbose = unkown \n');
        end
      else
        verbose = val;
      end
      
    case 'verbose_options'
      if ~exist('val','var')
        if numel(verbose_options) ~= 0
          fprintf(['verbose_options = ', num2str(verbose_options),' \n']);
        else
          fprintf('verbose_options = unkown \n');
        end
      else
        verbose_options = val;
      end
      
    case 'seed_index'
      if ~exist('val','var')
        if numel(random_seeds) ~= 0
          fprintf(['seed_index = ', num2str(seed_index(1)),' \n']);
        else
          fprintf('seed_index = unkown \n');
        end
      else
        seed_index = val;
      end
      rng(random_seeds(seed_index), 'twister'); % initialize the number generator
      
    case 'ranges'
      if ~exist('val','var')
        if numel(ranges) ~= 0
          fprintf(['ranges = structure with fields: \n']);
          disp(struct2table(ranges));
        else
          fprintf('ranges = unkown \n');
        end
      else
        if iscell(val) && length(val)>1
          ranges.(val{1}) = val{2};
        elseif iscell(val) && isfield(ranges, val)
          ranges = rmfield(ranges, val{1});
        elseif isfield(ranges, val)
          ranges = rmfield(ranges, val);
        end
      end
      
    case 'results_display'
      if ~exist('val','var')
        if strcmp(results_display, 'Basic')
          fprintf(['results_display = ', results_display,' \n']);
        elseif strcmp(results_display, 'Best')
          fprintf(['results_display = ', results_display,' \n']);
        elseif strcmp(results_display, 'Set')
          fprintf(['results_display = ', results_display,' \n']);
        elseif strcmp(results_display, 'Complete')
          fprintf(['results_display = ', results_display,' \n']);
        else
          fprintf('results_display = unkown \n');
        end
      else
        results_display = val;
      end
      
    case 'results_filename'
      if ~exist('val','var')
        results_filename = 'Default'; 
      else
        results_filename = val;
      end
      
    case 'save_results'
      if ~exist('val','var')
        if numel(save_results) ~= 0
          fprintf(['save_results = ', save_results,' \n']);
        else
          fprintf('save_results = unkown \n');
        end
      else
        save_results = val;
      end
      
    case 'mat_file'
      if ~exist('val','var')
        mat_file = ''; 
      else
        mat_file = val;
      end

    % only a single input
    case 'inexistent' 
      if numel(lossfunction) ~= 0
        fprintf(['loss_function = ', lossfunction,' \n']);
      else
        fprintf('loss_function = unknown \n');
      end
      
      if numel(filter) ~= 0
        fprintf(['filter = ', num2str(filter),' \n']);
      else
        fprintf('filter = unknown \n');
      end
      
      if numel(pars_init_method) ~= 0
        fprintf(['pars_init_method = ', num2str(pars_init_method),' \n']);
      else
        fprintf('pars_init_method = unknown \n');
      end
            
      if numel(results_output) ~= 0
        fprintf(['results_output = ', num2str(results_output),' \n']);
      else
        fprintf('results_output = unknown \n');
      end
      
      if numel(method) ~= 0
        fprintf(['method = ', method,' \n']);
        if strcmp(method, 'ga')
          calibration_options;
        end
      else
        fprintf('method = unknown \n');
      end

      if numel(max_fun_evals) ~= 0
        fprintf(['max_fun_evals = ', num2str(max_fun_evals),' \n']);
      else
        fprintf('max_fun_evals = unknown \n');
      end
      
      % method nm only
      if numel(report) ~= 0
        fprintf(['report = ', num2str(report),' (method nm)\n']);
      else
        fprintf('report = unknown \n');
      end

      if numel(max_step_number) ~= 0
        fprintf(['max_step_number = ', num2str(max_step_number),' (method nm)\n']);
      else
        fprintf('max_step_number = unknown \n');
      end
      
      if numel(tol_simplex) ~= 0
        fprintf(['tol_simplex = ', num2str(tol_simplex),' (method nm)\n']);
      else
        fprintf('tol_simplex = unknown \n');
      end
      
      if numel(simplex_size) ~= 0
        fprintf(['simplex_size = ', num2str(simplex_size),' (method nm)\n']);
      else
        fprintf('simplex_size = unknown \n');
      end
      
      % method ga only
      if numel(search_method) ~= 0
        fprintf(['search_method = ', search_method,' (method ga)\n']);
      else
        fprintf('search_method = unkown \n');
      end
      
      if numel(num_results) ~= 0.0
        fprintf(['num_results = ', num2str(num_results),' (method ga)\n']);
      else
        fprintf('num_results = unknown \n');
      end
      
      if numel(gen_factor) ~= 0.0
        fprintf(['gen_factor = ', num2str(gen_factor),' (method ga)\n']);
      else
        fprintf('gen_factor = unknown \n');
      end
      
      if numel(bounds_from_ind) ~= 0.0
        fprintf(['bounds_from_ind = ', num2str(bounds_from_ind),' (method ga)\n']);
      else
        fprintf('bounds_from_ind = unknown \n');
      end
      
      if numel(max_fun_evals) ~= 0
        fprintf(['max_fun_evals = ', num2str(max_fun_evals),' (method ga)\n']);
      else
        fprintf('max_fun_evals = unkown \n');
      end
      
      if numel(max_calibration_time) ~= 0
        fprintf(['max_calibration_time = ', num2str(max_calibration_time),' (method ga)\n']);
      else
        fprintf('max_calibration_time = unkown \n');
      end
      
      if numel(num_runs) ~= 0
        fprintf(['num_runs = ', num2str(num_runs),' (method ga)\n']);
      else
        fprintf('num_runs = unkown \n');
      end
      
      if numel(add_initial) ~= 0
        fprintf(['add_initial = ', num2str(add_initial),' (method ga)\n']);
      else
        fprintf('add_initial = unkown \n');
      end
      
      if numel(refine_running) ~= 0
        fprintf(['refine_running = ', num2str(refine_running),' (method ga)\n']);
      else
        fprintf('refine_running = unkown \n');
      end
      
      if numel(refine_run_prob) ~= 0
        fprintf(['refine_run_prob = ', num2str(refine_run_prob),' (method ga)\n']);
      else
        fprintf('refine_run_prob = unkown \n');
      end
      
      if numel(refine_firsts) ~= 0
        fprintf(['refine_firsts = ', num2str(refine_firsts),' (method ga)\n']);
      else
        fprintf('refine_firsts = unkown \n');
      end
      
      if numel('refine_initial') ~= 0
        fprintf(['refine_initial = ', num2str(refine_initial),' (method ga)\n']);
      else
        fprintf('refine_initial = unkown \n');
      end
      
      if numel(refine_best) ~= 0
        fprintf(['refine_best = ', num2str(refine_best),' (method ga)\n']);
      else
        fprintf('refine_best = unkown \n');
      end
      
      if numel(verbose) ~= 0
        fprintf(['verbose = ', num2str(verbose),' (method ga)\n']);
      else
        fprintf('verbose = unkown \n');
      end
      
      if numel(verbose_options) ~= 0
        fprintf(['verbose_options = ', num2str(verbose_options),' (method ga)\n']);
      else
        fprintf('verbose_options = unkown \n');
      end
      
      if numel(random_seeds) ~= 0
        fprintf(['random_seeds = ', num2str(random_seeds(1)),' (method ga)\n']);
      else
        fprintf('random_seeds = unkown \n');
      end
      
      if numel(ranges) ~= 0 
        fprintf(['ranges = structure with fields (method ga)\n']);
        disp(struct2table(ranges));
      else
        fprintf('ranges = unkown \n');
      end
      
      if strcmp(results_display, '') ~= 0
        fprintf(['results_display = ', results_display,' (method ga)\n']);
      else
        fprintf('results_display = unkown \n');
      end
      
      if strcmp(results_filename, '') ~= 0
        fprintf(['results_filename = ', results_filename,' (method ga)\n']);
      else
        fprintf('results_filename = unkown \n');
      end
      
      if strcmp(mat_file, '') ~= 0
        fprintf(['mat_file = ', mat_file,' (method ga)\n']);
      else
        fprintf('mat_file = unkown \n');
      end

    otherwise % option 'other'
        fprintf(['key ', key, ' is unkown \n\n']);
        estim_options;
  end
end