%% AmPgui
% a GUI to create 4 structures

%%
function AmPgui(action)
% created 2020/06/05 by  Bas Kooijman

%% Syntax
% <../AmPgui.m *AmPgui*>

%% Description
% Like mydata_my_pet.m, it writes 4 data-structures from scratch
%
% * data: structure with data
% * auxData: structure with auxilirary data 
% * metaData: structure with metaData 
% * txtData: structure with text for data 
%
% Input: no explicit input (facultative input is set by the function itself in multiple calls) 
%
% Output: no explicit output, but global exit-flag infoAmPgui is set with
%
% * 0 stay in AmPgui
% * 1 stay in AmPeps
% * 2 stay quit AmPeps, and proceed to load files in Matlab editor

%% Remarks
%
% * Set metaData on global before use of this function.
% * Files will be saved in your local directory, which should not contain results_my_pet.mat files, other than written my this function 
% * Use the cd command to the dir of your choice BEFORE running this function to save files in the desired place.
% * All weights are set at default values in the resulting file; 
% * This function is called in AmPeps
% * Font colors in main AmPgui mean:
%
%   - red: editing required
%   - green: editing not necessary
%   - black: editing facultative
% 
% Notice that font colors only represent intennal consistency, irrespective of content.

global data auxData metaData txtData select_id id_links eco_types color
global hspecies hecoCode hT_typical hauthor hcurator hgrp hdiscussion hfacts hacknowledgment hlinks hbiblist hdata_0        
global Hspecies Hfamily Horder Hclass Hphylum Hcommon Hwarning
global Hauthor Hemail Haddress HK HD HDb HF HFb HT HL H0v H0T H0b H0c D1 Hb d0
global Hclimate Hecozone Hhabitat Hembryo Hmigrate Hfood Hgender Hreprod

%UIControl_FontSize_bak = get(0, 'DefaultUIControlFontSize'); % 8
set(0, 'DefaultUIControlFontSize', 9);
%set(0, 'DefaultUIControlFontSize', UIControl_FontSize_bak);

if nargin == 0 % initiate structures and create the GUI

%% initiation

if ~isfield(data, 'data_0') 
  data.data_0 = [];
end   
if ~isfield(data, 'data_1') 
  data.data_1 = [];
end   
if ~isfield(auxData, 'temp') 
  auxData.temp = [];
end
if ~isfield(txtData, 'units')
  txtData.units = []; txtData.label = [];
end

if ~isfield(metaData, 'species') 
  metaData.species = [];
end   
if ~isfield(metaData, 'species_en') 
  metaData.species_en = [];
end  
if ~isfield(metaData, 'family') 
  metaData.family = [];
end   
if ~isfield(metaData, 'order') 
  metaData.order = [];
end  
if ~isfield(metaData, 'class') 
  metaData.class = [];
end  
if ~isfield(metaData, 'phylum') 
  metaData.phylum = [];
end  
if ~isfield(metaData, 'ecoCode')
  metaData.ecoCode = [];
end
if ~isfield(metaData.ecoCode, 'climate')
  metaData.ecoCode.climate = [];
end
if ~isfield(metaData.ecoCode, 'ecozone')
   metaData.ecoCode.ecozone = [];
end
if ~isfield(metaData.ecoCode, 'habitat')
   metaData.ecoCode.habitat = [];
end
if ~isfield(metaData.ecoCode, 'embryo')
  metaData.ecoCode.embryo = [];
end
if ~isfield(metaData.ecoCode, 'migrate')
  metaData.ecoCode.migrate = [];
end
if ~isfield(metaData.ecoCode, 'food')
  metaData.ecoCode.food = [];
end
if ~isfield(metaData.ecoCode, 'gender')
  metaData.ecoCode.gender = [];
end
if ~isfield(metaData.ecoCode, 'reprod')
  metaData.ecoCode.reprod = [];
end
if ~isfield(metaData, 'T_typical')
  metaData.T_typical = [];
end
if ~isfield(metaData, 'bibkey')
  metaData.bibkey = [];
end
if ~isfield(metaData, 'comment') 
  metaData.comment = [];
end
if ~isfield(metaData, 'links') 
  metaData.links = [];
end
if ~isfield(metaData, 'author')
  metaData.author = [];
end
if ~isfield(metaData, 'email')
  metaData.email = [];
end
if ~isfield(metaData, 'address')
  metaData.address = [];
end
if ~isfield(metaData, 'discussion')
  metaData.discussion = []; metaData.discussion.D1 = []; metaData.bibkey.D1 = [];
end
if ~isfield(metaData, 'facts')
  metaData.facts = []; metaData.facts.F1 = []; metaData.bibkey.F1 = [];
end
if ~isfield(metaData, 'acknowledgment')
  metaData.acknowledgment = [];
end
if ~isfield(metaData, 'biblist')
  metaData.biblist = [];
end

if ~exist('color','var')
  color = []; % font colors for items in main AmPgui
end
if isempty(color)
  color.species = [1 0 0]; color.ecoCode = [1 0 0];    color.T_typical = [1 0 0]; color.author = [1 0 0];         color.curator = [1 0 0];
  color.grp = [0 0 0];     color.discussion = [0 0 0]; color.facts = [0 0 0];     color.acknowledgment = [0 0 0]; color.links = [1 0 0];
  color.biblist = [1 0 0]; color.data_0 = [1 0 0];     color.links = [0 0 0];     color.discussion = [0 0 0];     color.facts = [0 0 0]; 
end
if isempty(eco_types)
  get_eco_types;
end


%% setup gui
  dmydata = dialog('Position',[150 100 120 460], 'Name','AmPgui');
  hspecies  = uicontrol('Parent',dmydata, 'Callback','AmPgui species',        'Position',[10 430 100 20], 'String','species',        'Style','pushbutton');
  hecoCode  = uicontrol('Parent',dmydata, 'Callback','AmPgui ecoCode',        'Position',[10 405 100 20], 'String','ecoCode',        'Style','pushbutton');
  hT_typical= uicontrol('Parent',dmydata, 'Callback','AmPgui T_typical',      'Position',[10 380 100 20], 'String','T_typical',      'Style','pushbutton');
  hauthor   = uicontrol('Parent',dmydata, 'Callback','AmPgui author',         'Position',[10 355 100 20], 'String','author',         'Style','pushbutton');
  hcurator  = uicontrol('Parent',dmydata, 'Callback','AmPgui curator',        'Position',[10 330 100 20], 'String','curator',        'Style','pushbutton');
  hgrp      = uicontrol('Parent',dmydata, 'Callback','AmPgui grp',            'Position',[10 305 100 20], 'String','grp',            'Style','pushbutton');
  hdiscussion  = uicontrol('Parent',dmydata, 'Callback','AmPgui discussion',     'Position',[10 280 100 20], 'String','discussion',     'Style','pushbutton');
  hfacts  = uicontrol('Parent',dmydata, 'Callback','AmPgui facts',          'Position',[10 255 100 20], 'String','facts',          'Style','pushbutton');
  hacknowledgment  = uicontrol('Parent',dmydata, 'Callback','AmPgui acknowledgment', 'Position',[10 230 100 20], 'String','acknowledgment', 'Style','pushbutton');
  hlinks  = uicontrol('Parent',dmydata, 'Callback','AmPgui links',          'Position',[10 205 100 20], 'String','links',          'Style','pushbutton');
  hbiblist  = uicontrol('Parent',dmydata, 'Callback','AmPgui biblist',        'Position',[10 180 100 20], 'String','biblist',        'Style','pushbutton');
  
        uicontrol('Parent',dmydata, 'Callback','AmPgui data_0',       'Position',[10 135 100 20], 'String','0-var data',     'Style','pushbutton');
        uicontrol('Parent',dmydata, 'Callback','AmPgui data_1',       'Position',[10 110 100 20], 'String','1-var data',     'Style','pushbutton');
  
        uicontrol('Parent',dmydata, 'Callback','AmPgui resume',         'Position',[10  65 100 20], 'String','resume',         'Style','pushbutton');
        uicontrol('Parent',dmydata, 'Callback','AmPgui pause',          'Position',[10  40 100 20], 'String','pause/save',     'Style','pushbutton');
        uicontrol('Parent',dmydata, 'Callback',{@OKCb,dmydata},         'Position',[50  15  20 20], 'String','OK',             'Style','pushbutton');
        
  % set default colors
  set(hspecies, 'ForegroundColor', color.species);       set(hecoCode, 'ForegroundColor', color.ecoCode); 
  set(hT_typical, 'ForegroundColor', color.T_typical);   set(hauthor, 'ForegroundColor', color.author); 
  set(hcurator, 'ForegroundColor', color.curator);       set(hgrp, 'ForegroundColor', color.grp); 
  set(hdiscussion, 'ForegroundColor', color.discussion); set(hfacts, 'ForegroundColor', color.facts); 
  set(hlinks, 'ForegroundColor', color.links);           set(hbiblist, 'ForegroundColor', color.biblist);
  set(hacknowledgment, 'ForegroundColor', color.acknowledgment); set(d0, 'ForegroundColor', color.data_0);
    
else % perform action
%% fill fields
  switch(action)
      case 'species'
        dS = dialog('Position',[150 150 600 150], 'Name','species dlg');
        Warning = ''; Hwarning = uicontrol('Parent',dS, 'Position',[110 60 350 20], 'Style','text', 'String',Warning);
        Hfamily  = uicontrol('Parent',dS, 'Position',[50 110 140 20], 'Style','text', 'String',['family: ',metaData.family]);
        Horder  = uicontrol('Parent',dS, 'Position',[200 110 140 20], 'Style','text', 'String',['order: ',metaData.order]);
        Hclass  = uicontrol('Parent',dS, 'Position',[350 110 140 20], 'Style','text', 'String',['class: ',metaData.class]);
        Hphylum  = uicontrol('Parent',dS, 'Position',[50 80 140 20], 'Style','text', 'String',['phylum: ',metaData.phylum]);
        Hcommon = uicontrol('Parent',dS, 'Position',[200 80 240 20], 'Style','text', 'String',['common name: ',metaData.species_en]);
        select_id = true(14,1);
        Hspecies = uicontrol('Parent',dS, 'Callback',{@speciesCb,dS}, 'Position',[110 15 350 20], 'Style','edit', 'String',metaData.species); 
         
      case 'ecoCode'
        dE = dialog('Position',[550 250 500 270], 'Name','ecoCode dlg');
        
        % climate
        uicontrol('Parent',dE, 'Position',[10 230 146 20], 'String','climate', 'Style','text');
        Hclimate = uicontrol('Parent',dE, 'Position',[110 230 250 20], 'String',cell2str(metaData.ecoCode.climate)); 
        uicontrol('Parent',dE, 'Callback',{@climateCb,Hclimate}, 'Position',[370 230 50 20], 'Style','pushbutton', 'String','edit'); 
        
        % ecozone
        uicontrol('Parent',dE, 'Position',[10 200 146 20], 'String','ecozone', 'Style','text');
        Hecozone = uicontrol('Parent',dE, 'Position',[110 200 250 20], 'String',cell2str(metaData.ecoCode.ecozone));
        uicontrol('Parent',dE, 'Callback',{@ecozoneCb,Hecozone}, 'Position',[370 200 50 20], 'Style','pushbutton', 'String','edit'); 

        % habitat
        uicontrol('Parent',dE, 'Position',[10 170 146 20], 'String','habitat', 'Style','text');
        Hhabitat = uicontrol('Parent',dE, 'Position',[110 170 250 20], 'String',cell2str(metaData.ecoCode.habitat)); 
        uicontrol('Parent',dE, 'Callback',{@habitatCb,Hhabitat}, 'Position',[370 170 50 20], 'Style','pushbutton', 'String','edit'); 

        % embryo
        uicontrol('Parent',dE, 'Position',[10 140 146 20], 'String','embryo', 'Style','text');
        Hembryo = uicontrol('Parent',dE, 'Position',[110 140 250 20], 'String',cell2str(metaData.ecoCode.embryo));
        uicontrol('Parent',dE, 'Callback',{@embryoCb,Hembryo}, 'Position',[370 140 50 20], 'Style','pushbutton', 'String','edit'); 

        % migrate
        uicontrol('Parent',dE, 'Position',[10 110 146 20], 'String','migrate', 'Style','text');
        Hmigrate = uicontrol('Parent',dE, 'Position',[110 110 250 20], 'String',cell2str(metaData.ecoCode.migrate)); 
        uicontrol('Parent',dE, 'Callback',{@migrateCb,Hmigrate}, 'Position',[370 110 50 20], 'Style','pushbutton', 'String','edit'); 

        % food
        uicontrol('Parent',dE, 'Position',[10 80 146 20], 'String','food', 'Style','text');
        Hfood = uicontrol('Parent',dE, 'Position',[110 80 250 20], 'String',cell2str(metaData.ecoCode.food)); 
        uicontrol('Parent',dE, 'Callback',{@foodCb,Hfood}, 'Position',[370 80 50 20], 'Style','pushbutton', 'String','edit'); 

        % gender
        uicontrol('Parent',dE, 'Position',[10 50 146 20], 'String','gender', 'Style','text');
        Hgender = uicontrol('Parent',dE, 'Position',[110 50 250 20], 'String',cell2str(metaData.ecoCode.gender)); 
        uicontrol('Parent',dE, 'Callback',{@genderCb,Hgender}, 'Position',[370 50 50 20], 'Style','pushbutton', 'String','edit'); 

        % reprod
        uicontrol('Parent',dE, 'Position',[10 20 146 20], 'String','reprod', 'Style','text');
        Hreprod = uicontrol('Parent',dE, 'Position',[110 20 250 20], 'String',cell2str(metaData.ecoCode.reprod)); 
        uicontrol('Parent',dE, 'Callback',{@reprodCb,Hreprod}, 'Position',[370 20 50 20], 'Style','pushbutton', 'String','edit'); 
        uicontrol('Parent',dE, 'Callback',{@OKCb,dE}, 'Position',[430 20 50 20], 'Style','pushbutton', 'String','OK'); 
        
      case 'T_typical'
        dT = dialog('Position',[300 250 300 100], 'Name','T_typical dlg');
        uicontrol('Parent',dT, 'Position',[10 50 200 20], 'String','Typical body temperature in C', 'Style','text');
        HT = uicontrol('Parent',dT, 'Callback',@T_typicalCb, 'Position',[200 50 50 20], 'Style','edit', 'String',num2str(K2C(metaData.T_typical))); 
        uicontrol('Parent',dT, 'Callback',{@OKCb,dT}, 'Position',[100 20 20 20], 'String','OK', 'Style','pushbutton');

      case 'author'
        Datevec = datevec(datenum(date)); metaData.date_subm = Datevec(1:3);
        dA = dialog('Position',[150 150 500 150], 'Name','author dlg');
        uicontrol('Parent',dA, 'Position',[10 95 146 20], 'String','Name', 'Style','text');
        Hauthor  = uicontrol('Parent',dA, 'Callback',@authorCb, 'Position',[110 95 350 20], 'Style','edit', 'String',metaData.author); 
        uicontrol('Parent',dA, 'Position',[10 70 146 20], 'String','email', 'Style','text');
        Hemail   = uicontrol('Parent',dA, 'Callback',@emailCb, 'Position',[110 70 350 20], 'Style','edit', 'String',metaData.email); 
        uicontrol('Parent',dA, 'Position',[10 45 146 20], 'String','address', 'Style','text');
        Haddress = uicontrol('Parent',dA, 'Callback',@addressCb, 'Position',[110 45 350 20], 'Style','edit', 'String',metaData.address); 
        uicontrol('Parent',dA, 'Callback',{@OKCb,dA}, 'Position',[110 20 20 20], 'String','OK', 'Style','pushbutton');

      case 'curator'
        curList = {'Starrlight Augustine', 'Dina Lika', 'Nina Marn', 'Mike Kearney', 'Bas Kooijman'};
        emailList = {'starrlight.augustine@akvaplan.niva.no', 'lika@uoc.gr' ,'nina.marn@gmail.com', 'mrke@unimelb.edu.au', 'salm.kooijman@gmail.com'};
        i_cur =  listdlg('ListString',curList, 'SelectionMode','single', 'Name','curator dlg', 'ListSize',[140 80], 'InitialValue',1);
        metaData.curator = curList{i_cur}; metaData.email_cur = emailList{i_cur}; 
        Datevec = datevec(datenum(date)); metaData.date_acc = Datevec(1:3);
        
      case 'grp'
        sets = {{'tL_f', 'tL_m'}, {'tWw_f', 'tWw_m'}, {'tWd_f', 'tLWd_m'}, {'LWw_f', 'LWw_m'}, ...
            {'LWd_f', 'tWd_m'}, {'LdL_f', 'LdL_m'}}; 
        comment = {'Data for females, males', 'Data for females, males', 'Data for females, males', 'Data for females, males', ...
            'Data for females, males', 'Data for females, males'};
        
        n_sets = length(sets); setsList = sets; sel_sets = false(n_sets,1);
        for i = 1:n_sets
          setsList{1} = cell2str(sets{i});
          seti = sets{i};
          if isfield(data.data_1, seti{1}) && isfield(data.data_1, seti{2})
            sel_sets(1) = true;
          end
        end
                
        dG = dialog('Position',[150 150 350 250], 'Name','grp dlg');
        uicontrol('Parent',dG, 'Position',[20 210 30 20], 'Callback',{@OKCb,dG}, 'String','OK');
        
        if isempty(data.data_1)
          uicontrol('Parent',dG, 'Position',[70 210 250 20], 'String','no 1-variate data found');
          
        elseif any(sel_sets)
          setsList = setsList(sel_sets);
          i_sets =  listdlg('ListString',setsList,  'Name','grp dlg', 'ListSize',[200 80], 'InitialValue',1);
          n_sets = length(i_sets);
          for i=1:n_sets
            hight = 180 - i * 25;
            uicontrol('Parent',dG, 'Position',[ 20 hight 150 20], 'String',['set', num2str(i), ': ', setsList{i}]);  
            uicontrol('Parent',dG, 'Position',[170 hight 175 20], 'String',['comment', num2str(i), ': ', comment{i}]); 
          end
          metaData.grp.sets = sets(sel_sets);
          metaData.grp.comment = comment(sel_sets);

        else
          uicontrol('Parent',dG, 'Position',[70 210 250 20], 'String','no 1-variate data found that can be grouped');
        end
 
      case 'discussion'
        dD = dialog('Position',[150 150 950 550], 'Name','discussion dlg');
        uicontrol('Parent',dD, 'Callback',{@OKCb,dD}, 'Position',[30 500 20 20], 'String','OK');
        uicontrol('Parent',dD, 'Callback',{@addDiscussionCb,dD}, 'Position',[110 500 150 20], 'String','add discussion point', 'Style','pushbutton');
        uicontrol('Parent',dD, 'Position',[790 500 146 20], 'String','bibkey', 'Style','text');
        
        if ~isempty(metaData.discussion)
          fld = fieldnames(metaData.discussion); n = length(fld);
          for i = 1:n
            hight = 475 - i * 25;
            uicontrol('Parent',dD, 'Position',[10, hight, 146, 20], 'String',fld{i}, 'Style','text');
            HD(i)  = uicontrol('Parent',dD, 'Callback',{@discussionCb, i}, 'Position',[110, hight, 650, 20], 'Style','edit', 'String',metaData.discussion.(fld{i})); 
            if ~isfield(metaData.bibkey, fld{i})
              metaData.bibkey.(fld{i}) = [];
            end
            HDb(i) = uicontrol('Parent',dD, 'Callback',{@discussionCb, i}, 'Position',[850, hight, 80, 20], 'Style','edit', 'String',metaData.bibkey.(fld{i})); 
          end
        end

      case 'facts'
        dF = dialog('Position',[150 150 950 550], 'Name','facts dlg');
        uicontrol('Parent',dF, 'Callback',{@OKCb,dF}, 'Position',[30 500 20 20], 'String','OK');
        HF = uicontrol('Parent',dF, 'Callback',{@addFactCb,dF}, 'Position',[110 500 150 20], 'String','add fact', 'Style','pushbutton');
        uicontrol('Parent',dF, 'Position',[790 500 146 20], 'String','bibkey', 'Style','text');
        
        if ~isempty(metaData.discussion)
          fld = fieldnames(metaData.facts); n = length(fld);
          for i = 1:n
            hight = 475 - i * 25;
            uicontrol('Parent',dF, 'Position',[10, hight, 146, 20], 'String',fld{i}, 'Style','text');
            HF(i)  = uicontrol('Parent',dF, 'Callback',{@factsCb, i}, 'Position',[110, hight, 650, 20], 'Style','edit', 'String',metaData.facts.(fld{i})); 
            HFb(i) = uicontrol('Parent',dF, 'Callback',{@factsCb, i}, 'Position',[850, hight, 80, 20], 'Style','edit', 'String',metaData.facts.(fld{i})); 
          end
        end

      case 'acknowledgment'
        dK = dialog('Position',[150 150 700 150], 'Name','acknowledgment dlg');
        uicontrol('Parent',dK, 'Position',[10 95 146 20], 'String','Text', 'Style','text');
        uicontrol('Parent',dK, 'Callback',{@OKCb,dK}, 'Position',[110 70 20 20], 'String','OK');
        HK = uicontrol('Parent',dK, 'Callback',@acknowledgmentCb, 'Position',[110 95 550 20], 'Style','edit', 'String',metaData.acknowledgment); 
        
      case 'links'
        dL = dialog('Position',[150 150 350 350],'Name','links dlg');
        links = {...
          'http://www.catalogueoflife.org/col/'; ...
          'http://eol.org/'; ...
          'http://en.wikipedia.org/wiki/'; ...
          'http://animaldiversity.org/'; ...
          'http://taxonomicon.taxonomy.nl/'; ...
          'http://marinespecies.org/'; ...
          % taxon-specific links
          'http://www.molluscabase.org/'; ...
          'http://www.fishbase.org/'; ...
          'http://amphibiaweb.org/search/'; ...
          'http://reptile-database.reptarium.cz/'; ...
          'https://avibase.bsc-eoc.org/'; ...
          'http://datazone.birdlife.org/'; ...
          'https://www.departments.bucknell.edu/biology/resources/msw3/'; ...
          'http://genomics.senescence.info/'};
      
        id_links = {'id_CoL', 'id_EoL', 'id_Wiki', 'id_ADW', 'id_Taxo', 'id_WoRMS', ...                                                
         'id_molluscabase', 'id_fishbase', 'id_amphweb', 'id_ReptileDB', 'id_avibase', 'id_birdlife', 'id_MSW3', 'id_AnAge'};
     
        if isempty(select_id)
          select_id = true(14,1); select_id(7:14) = false; % selection vector for links
          for i = 1:14
            metaData.links.(id_links{i}) = [];
          end
        end
       
        if isfield(metaData.links, 'id_EoL') && isempty(metaData.links.id_EoL)
          metaData.links.id_EoL =  'some number (replace)';
        end
        if isfield(metaData.links, 'id_Wiki') && isempty(metaData.links.id_Wiki)
          metaData.links.id_Wiki =  [metaData.species, '? (replace)'];
        end
        if isfield(metaData.links, 'id_ADW') && isempty(metaData.links.id_ADW)
          metaData.links.id_ADW =  [metaData.species, '? (replace)'];
        end
        if isfield(metaData.links, 'id_Taxo') && isempty(metaData.links.id_Taxo)
          metaData.links.id_Taxo =  'some number (replace)';
        end
        if isfield(metaData.links, 'id_WoRMS') && isempty(metaData.links.id_WoRMS)
          metaData.links.id_WoRMS =  'some number (replace)';
        end

        if strcmp(metaData.class, 'Mollusca')
          select_id(7) = true;
          if isfield(metaData.links, 'id_molluscabase') && isempty(metaData.links.id_molluscabase)
            metaData.links.id_molluscabase = 'some number (replace)';
          end
        end
        if ismember(metaData.class, {'Cyclostomata', 'Chondrichthyes', 'Actinopterygii', 'Actinistia', 'Dipnoi'})
          select_id(8) = true;
          if isfield(metaData.links, 'id_fishbase') && isempty(metaData.links.id_fishbase)
            metaData.links.id_molluscabase = [strrep(metaData.species,'_','-'), '? (replace)'];
          end
        end
        if strcmp(metaData.class, 'Amphibia')
          select_id(9) = true;
          if isfield(metaData.links, 'id_amphweb') && isempty(metaData.links.id_amphweb)
            metaData.links.id_amphweb = [strrep(metaData.species,'_','+'), '? (replace)'];
          end
        end
        if strcmp(metaData.class, 'Reptilia')
          select_id(10) = true;
          nm = strspilt(metaData.species);
          if isfield(metaData.links, 'id_ReptileDB') && isempty(metaData.links.id_ReptileDB)
            metaData.links.id_ReptileDB = ['genus=',nm{1}, '&species=', nm{2}, '? (replace)'];
          end
        end
        if strcmp(metaData.class, 'Aves')
          select_id(11:12) = true;
          if isfield(metaData.links, 'id_avibase') && isempty(metaData.links.id_avibase)
            metaData.links.id_avibase = 'some code (replace)';
          end
          if isfield(metaData.links, 'id_birdlife') && isempty(metaData.links.id_birdlife)
            metaData.links.id_birdlife = 'some sci. & common names (replace)';
          end
        end
        if strcmp(metaData.class, 'Mammalia')
          select_id(13) = true;
          if isfield(metaData.links, 'id_MSW3') && isempty(metaData.links.id_MSW3)
            metaData.links.id_MSW3 = 'some number (replace)';
          end
        end
        if ismember(metaData.class, {'Aves', 'Mammalia'})
          select_id(14) = true;
          if isfield(metaData.links, 'id_AnAge') && isempty(metaData.links.id_AnAge)
            metaData.links.id_AnAge = [metaData.species, '? (replace)'];
          end
        end
        
        selId_links = id_links(select_id); selLinks = links(select_id); n_selLinks = length(selId_links);
        for i= 1:n_selLinks 
          if i>1
            web(selLinks{i},'-browser');
          end
          hight = 275 - i * 25;
          if ~isfield(metaData.links, selId_links{i})
            metaData.links.(selId_links{i}) = [];
          end
          uicontrol('Parent',dL, 'Position',[0, hight, 146, 20], 'String',selId_links{i}, 'Style','text');
          uicontrol('Parent',dL, 'Callback',{@OKCb,dL}, 'Position',[110 10 20 20], 'Style','pushbutton', 'String','OK'); 
          if i == 1
            uicontrol('Parent',dL, 'Position',[110, hight, 210, 20], 'Style','text', 'String',metaData.links.(selId_links{i})); 
          else
            HL(i)  = uicontrol('Parent',dL, 'Callback',{@linksCb,selId_links}, 'Position',[110, hight, 210, 20], 'Style','edit', 'String',metaData.links.(selId_links{i})); 
          end
        end
        
    case 'biblist'
      bibTypeList.article =       {'author', 'title', 'journal',     'year', 'volume', 'pages', 'dio', 'url'};
      bibTypeList.book =          {'author', 'title', 'publisher',   'year', 'series', 'volume', 'isbn', 'url'};
      bibTypeList.incollection =  {'author', 'title', 'editor', 'booktitle', 'publisher', 'year', 'series', 'volume', 'isbn', 'url'};
      bibTypeList.mastersthesis = {'author', 'title', 'school',      'year', 'address', 'doi', 'isbn', 'url'};
      bibTypeList.phdthesis =     {'author', 'title', 'school',      'year', 'address', 'doi', 'isbn', 'url'};
      bibTypeList.techreport =    {'author', 'title', 'institution', 'year', 'address', 'doi', 'isbn', 'url'};
      bibTypeList.misc =          {'author', 'note',                 'year', 'doi', 'isbn', 'url'};
        
      db = dialog('Position',[150 100 190 400], 'Name','biblist dlg');
      uicontrol('Parent',db, 'Position',[ 10 370  50 20], 'Callback',{@OKCb,db}, 'Style','pushbutton', 'String','OK'); 
      uicontrol('Parent',db, 'Position',[70 370 100 20], 'Callback',{@addBibCb,db}, 'String','add bib item', 'Style','pushbutton');
      
      if ~isempty(metaData.biblist)
        fld = fieldnames(metaData.biblist); n = length(fld);
        for i = 1:n
          hight = 350 - i * 25; 
          Hb(i) = uicontrol('Parent',db,  'Position',[ 10, hight,  100, 20], 'Style','text', 'String',fld{i}); % name
          uicontrol('Parent',db, 'Callback',{@DbCb,bibTypeList,fld{i},i}, 'Position',[100, hight,  70 20], 'Style','pushbutton', 'String','edit');
        end          
      end
        
    case 'data_0' 
        
      code0 = { ...
          'ah',   'd', 1, 'age at hatch';          
          'ab',   'd', 1, 'age at birth';
          'tx',   'd', 1, 'time since birth at weaning';
          'tp',   'd', 1, 'time since birth at puberty';
          'tpm',  'd', 1, 'time since birth at puberty for males'; 
          'tR',   'd', 1, 'time since birth at first egg production';
          'am',   'd', 1, 'life span';

          'Lh',  'cm', 0, 'length at hatch';
          'Lb',  'cm', 0, 'length at birth'
          'Lp',  'cm', 0, 'length at puberty';
          'Lpm', 'cm', 0, 'length at puberty for males';
          'Li',  'cm', 0, 'ultimate length';
          'Lim', 'cm', 0, 'ultimate length for males';

          'Ww0',  'g', 0, 'initial wet weight';
          'Wwh',  'g', 0, 'wet weight at hatch';
          'Wwb',  'g', 0, 'wet weight at birth';
          'Wwp',  'g', 0, 'wet weight at puberty';
          'Wwpm', 'g', 0, 'wet weight at puberty for males';
          'Wwi',  'g', 0, 'ultimate wet weight';
          'Wwim', 'g', 0, 'ultimate wet weight for males';

          'Wdh',  'g', 0, 'dry weight at hatch';
          'Wdb',  'g', 0, 'dry weight at birth';
          'Wdpm', 'g', 0, 'dry weight at puberty for males';
          'Wdi',  'g', 0, 'ultimate dry weight';
          'Wdim', 'g', 0, 'ultimate dry weight for males';
          
          'E0',   'J', 0, 'initial energy content';

          'Ri', '#/d', 1, 'ultimate reproduction rate';
          }; 
        
      d0 = dialog('Position',[150 35 1000 620], 'Name','0-variate data dlg');
      uicontrol('Parent',d0, 'Position',[ 60 580  50 20], 'Callback',{@OKCb,d0}, 'Style','pushbutton', 'String','OK'); 
      uicontrol('Parent',d0, 'Position',[400 580 150 20], 'Callback',{@add0Cb,code0,d0}, 'String','add 0-var data', 'Style','pushbutton');
      uicontrol('Parent',d0, 'Position',[ 60 550  70 20], 'String','name', 'Style','text');
      uicontrol('Parent',d0, 'Position',[140 550  70 20], 'String','value', 'Style','text');
      uicontrol('Parent',d0, 'Position',[200 550  70 20], 'String','units', 'Style','text');
      uicontrol('Parent',d0, 'Position',[260 550  70 20], 'String','temp in C', 'Style','text');
      uicontrol('Parent',d0, 'Position',[390 550  70 20], 'String','label', 'Style','text');
      uicontrol('Parent',d0, 'Position',[550 550  70 20], 'String','bibkey', 'Style','text');
      uicontrol('Parent',d0, 'Position',[640 550  70 20], 'String','comment', 'Style','text');

      if ~isempty(data.data_0)
        fld = fieldnames(data.data_0); n = size(fld);
        for i = 1:n
          hight = 550 - i * 25; 
          uicontrol('Parent',d0,                                  'Position',[ 60, hight,  70, 20], 'Style','text', 'String',fld{i}); % name
          H0v(i) = uicontrol('Parent',d0,   'Callback',{@d0Cb,i}, 'Position',[150, hight,  70, 20], 'Style','edit', 'String',num2str(data.data_0.(fld{i}))); % value
          H0u(i) = uicontrol('Parent',d0,                         'Position',[230, hight,  30, 20], 'Style','text', 'String',txtData.units.(fld{i})); % units
          if isfield(auxData.temp, fld{i})
            H0T(i) = uicontrol('Parent',d0, 'Callback',{@d0Cb,i}, 'Position',[270, hight,  40, 20], 'Style','edit', 'String',num2str(K2C(auxData.temp.(fld{i})))); % temp(C)
          else
            H0T(i) = uicontrol('Parent',d0,                       'Position',[270, hight,  40, 20], 'Style','text', 'String','');         
          end
          H0l(i) = uicontrol('Parent',d0,                         'Position',[320, hight, 220, 20], 'Style','text', 'String',txtData.label.(fld{i})); % label
          H0b(i) = uicontrol('Parent',d0,   'Callback',{@d0Cb,i}, 'Position',[550, hight,  70, 20], 'Style','edit', 'String',cell2str(txtData.bibkey.(fld{i}))); % bibkey
          if ~isfield(txtData.comment, fld{i})
            txtData.comment.(fld{i}) = [];
          end
          H0c(i) = uicontrol('Parent',d0,   'Callback',{@d0Cb,i}, 'Position',[650, hight, 300, 20], 'Style','edit', 'String',txtData.comment.(fld{i})); % comment
        end
      end

    case 'data_1' 

      code1 = { ...
          'tL',    {'d','cm'}, 1, {'time','length'}, '';
          'tL_f'   {'d','cm'}, 1, {'time','length'}, 'Data for females'; 
          'tL_m'   {'d','cm'}, 1, {'time','length'}, 'Data for males'; 
          
          'tWw',   {'d', 'g'}, 1, {'time','wet weight'}, ''; 
          'tWw_m', {'d', 'g'}, 1, {'time','wet weight'}, 'Data for females'; 
          'tWw_f', {'d', 'g'}, 1, {'time','wet weight'}, 'Data for males';
          
          'tWd',   {'d', 'g'}, 1, {'time','dry weight'}, ''; 
          'tWd_f', {'d', 'g'}, 1, {'time','dry weight'}, 'Data for males';
          'tWd_m', {'d', 'g'}, 1, {'time','dry weight'}, 'Data for females'; 
          
          'LWw',   {'cm','g'}, 0, {'length','wet weight'}, '';
          'LWw_f', {'cm','g'}, 0, {'length','wet weight'}, 'Data for females';
          'LWw_m', {'cm','g'}, 0, {'length','wet weight'}, 'Data for males';
          
          'LWd',   {'cm','g'}, 0, {'length','dry weight'}, '';
          'LWd_f', {'cm','g'}, 0, {'length','dry weight'}, 'Data for females';
          'LWd_m', {'cm','g'}, 0, {'length','dry weight'}, 'Data for males';
          
          'LdL',   {'cm','cm/d'}, 1, {'length','change in length'}, '';
          'LdL_f', {'cm','cm/d'}, 1, {'length','change in length'}, 'Data for females';
          'LdL_m', {'cm','cm/d'}, 1, {'length','change in length'}, 'Data for males';
          }; 
        
      d1 = dialog('Position',[150 35 500 400], 'Name','1-variate data dlg');
      uicontrol('Parent',d1, 'Position',[ 10 380  50 20], 'Callback',{@OKCb,d1}, 'Style','pushbutton', 'String','OK'); 
      uicontrol('Parent',d1, 'Position',[150 380 150 20], 'Callback',{@add1Cb,code1,d1}, 'String','add 1-var data', 'Style','pushbutton');
      uicontrol('Parent',d1, 'Position',[ 10 350  60 20], 'String','name', 'Style','text');
      uicontrol('Parent',d1, 'Position',[100 350  90 20], 'String','x-label', 'Style','text');
      uicontrol('Parent',d1, 'Position',[200 350  90 20], 'String','y-label', 'Style','text');

      if ~isempty(data.data_1)
        fld = fieldnames(data.data_1); n = size(fld);
        for i = 1:n
          hight = 350 - i * 25; 
          uicontrol('Parent',d1,  'Position',[ 10, hight,  70, 20], 'Style','text', 'String',fld{i}); % name
          label = txtData.label.(fld{i}); 
          uicontrol('Parent',d1,  'Position',[100, hight,  100, 20], 'Style','text', 'String',label{1}); % x-label
          uicontrol('Parent',d1,  'Position',[200, hight,  100, 20], 'Style','text', 'String',label{2}); % y-label
          D1(i) = uicontrol('Parent',d1, 'Callback',{@D1Cb,fld{i},i}, 'Position',[380, hight,  70 20], 'Style','pushbutton', 'String','edit');
        end
      end

    case 'resume'
      list = cellstr(ls);
      list = list(contains(list,'results_'));
      if length(list) == 1
        load(list);
      elseif isempty(list)
        fprintf('Warning from AmPgui: no results_my_pet.mat found\n');
      else
        fprintf('Warning from AmPgui: more than a single file results_my_pet.mat found, remove the wrong ones first\n');
      end
      
    case 'pause'
      nm = ['results_', metaData.species, '.mat'];
      list = cellstr(ls);
      list = list(contains(list,'results_'));
      if length(list) > 1
        fprintf('Warning from AmPgui: more than one file results_my_pet.mat found; this will give problems when resuming\n');
      elseif length(list) == 1 && strcmp(list{1}, nm)
        fprintf(['Warning from AmPgui: file ', list{1}, ' found; this will give problems when resuming\n']);
      end
      save(nm, 'data', 'auxData', 'metaData', 'txtData', 'color', 'select_id', 'id_links', 'eco_types');
      dP = dialog('Position',[150 150 500 150],'Name','pause dlg');
      uicontrol('Parent',dP, 'Position',[ 50 95 400 20], 'String',['File ', nm, ' has been written'], 'Style','text');
      uicontrol('Parent',dP, 'Position',[130 60 100 20], 'Callback',{@OKCb,dP,0},  'String','stay in AmPgui', 'Style','pushbutton');
      uicontrol('Parent',dP, 'Position',[250 60 100 20], 'Callback',{@OKCb,dP,1}, 'String','stay in AmPeps', 'Style','pushbutton');
  end
end
  % color settings: run this part only with AmPgui('setColor')
  
  if ~isempty(metaData.species)
    color.species = [0 .6 0]; set(hspecies, 'ForegroundColor', color.species);
  end

  if any([isempty(metaData.ecoCode.climate), isempty(metaData.ecoCode.ecozone), isempty(metaData.ecoCode.habitat), ...
    isempty(metaData.ecoCode.embryo), isempty(metaData.ecoCode.food), isempty(metaData.ecoCode.gender), isempty(metaData.ecoCode.reprod)])
    color.ecoCode = [1 0 0]; set(hecoCode, 'ForegroundColor', color.ecoCode);
  else
    color.ecoCode = [0 0.6 0]; set(hecoCode, 'ForegroundColor', color.ecoCode);
  end

  if ~isempty(metaData.T_typical)
    color.T_typical = [0 .6 0]; set(hT_typical, 'ForegroundColor', color.T_typical);
  end

  if isfield(metaData, 'author') && ~isempty(metaData.author)
    color.author = [0 .6 0]; set(hauthor, 'ForegroundColor', color.author);
  end
  
  if isfield(metaData, 'curator') && ~isempty(metaData.curator)
    color.curator = [0 .6 0]; set(hcurator, 'ForegroundColor', color.curator);
  end
            
  fld_male_0 = {'tpm', 'Lpm', 'Lim', 'Wwpm', 'Wwim', 'Wdpm', 'Wdim'};
  fld_male_1 = {'tL_m', 'tWw_m', 'tWd_m', 'LWd_m', 'LdL_m'};
  if (~isempty(data.data_0) & ~ismember(fieldnames(data.data_0),fld_male_0)) | ...
     (~isempty(data.data_1) & ~ismember(fieldnames(data.data_1),fld_male_1)) &  ~isfield(metaData.discussion)
     color.discussion = [1 0 0]; 
  else
     color.discussion = [0 0 0]; 
  end
  set(hdiscussion, 'ForegroundColor', color.discussion);

  if isfield(metaData, 'facts') && ~isempty(metaData.facts)
    fld = fieldnames(metaData.facts); n_fld = length(fld); 
    color.facts = [0 .6 0]; 
    for i = 1:n_fld
       if ~isfield(metaData.bibkey, fld{i}) & ~isempty(metaData.bibkey,(fld{i}))
         color.facts = [1 0 0]; 
       end
    end
  end
  set(hfacts, 'ForegroundColor', color.facts);
 
  if isfield(metaData, 'acknowledgment') && ~isempty(metaData.acknowledgment)
    color.acknowledgment = [0 .6 0]; set(hacknowledgment, 'ForegroundColor', color.acknowledgment);
  end

  if exist('select_id','var')
    color.links = [0 .6 0]; set(hlinks, 'ForegroundColor', color.links)
  end
  
  if ~isempty(data.data_0)
    color.data_0 = [0 0.6 0]; set(hdata_0, 'ForegroundColor', color.data_0);
  end
 
  if isfield(metaData, 'biblist') & ~isempty(metaData.biblist)
    bibitems = fieldnames(metaData.biblist);
  else
    bibitems = {};
  end
  bibkeys = {};
  if ~isempty(data.data_0)
    fld = fieldnames(data.data_0); n_fld = length(fld);
    for i=1:n_fld
      bibkeys = [bibkeys, txtData.bibkey.(fld{i})];
    end
  end
  if ~isempty(data.data_1)
    fld = fieldnames(data.data_1); n_fld = length(fld);
    for i=1:n_fld
      bibkeys = [bibkeys, txtData.bibkey.(fld{i})];
    end
    bibkeys = unique(bibkeys);
  end 
  if ~isempty(metaData.bibkey)
    fld = fieldnames(metaData.bibkey); n_fld = length(fld);
    for i=1:n_fld
      bibkeys = [bibkeys, metaData.bibkey.(fld{i})];
    end
  end
  bibkeys = unique(bibkeys);
  if any(~ismember(bibkeys,bibitems))
    color.biblist = [1 0 0];
    fprintf(['Warning from AmPgui: missing bibitems are ', cell2str(bibkeys(~ismember(bibkeys,bibitems))),'\n']);
  else
    color.biblist = [0 0.6 0];
  end
  set(hbiblist, 'ForegroundColor', color.biblist);
end

%% callback functions
function speciesCb(~, ~, dS)  
  global metaData Hspecies hspecies Hfamily Horder Hclass Hphylum Hcommon Hwarning infoAmpgui color 
   
  my_pet = strrep(get(Hspecies, 'string'), ' ', '_'); metaData.species = my_pet;
  [id_CoL, my_pet] = get_id_CoL(my_pet); 
  if isempty(id_CoL)
    web('http://www.catalogueoflife.org/col/','-browser');
    set(Hfamily,'String',''); set(Horder,'String',''); set(Hclass,'String',''); set(Hphylum,'String',''); set(Hcommon,'String','');
    set(Hwarning, 'String','species not recognized, search CoL');
  elseif ismember(my_pet,select)
    set(Hfamily,'String',''); set(Horder,'String',''); set(Hclass,'String',''); set(Hphylum,'String',''); set(Hcommon,'String','');
    uicontrol('Parent',dS, 'Position',[110 95 350 20], 'Style','text', 'String','species is already in AmP');
    uicontrol('Parent',dS, 'Position',[110 75 350 20], 'Style','text', 'String','close and proceed to post-editing phase of AmPeps');
    set(Hwarning, 'String', ''); infoAmpgui = 2;
  else
    [lin, rank] = lineage_CoL(my_pet);
    metaData.links.id_CoL = id_CoL;
    metaData.species_en = get_common_CoL(id_CoL); set(Hcommon,'String',['common name: ',metaData.species_en]);
    nm = lin(ismember(rank, 'Family')); metaData.family = nm{1}; set(Hfamily,'String',['family: ',metaData.family]);
    nm = lin(ismember(rank, 'Order'));  metaData.order = nm{1};  set(Horder,'String',['order: ',metaData.order]);
    nm = lin(ismember(rank, 'Class'));  metaData.class = nm{1};  set(Hclass,'String',['class: ',metaData.class]);
    nm = lin(ismember(rank, 'Phylum')); metaData.phylum = nm{1}; set(Hphylum,'String',['phylum: ',metaData.phylum]); 
    color.species = [0 0.6 0]; set(hspecies, 'ForegroundColor', color.species);
  end
  uicontrol('Parent',dS, 'Position',[40 15 20 20], 'Callback',{@OKCb,dS}, 'Style','pushbutton', 'String','OK');
  AmPgui('setColor')
end

function climateCb(~, ~, Hclimate)  
  global metaData eco_types 
  climateCode = fieldnames(eco_types.climate); n_climate = length(climateCode); i_climate = 1:n_climate;
  if isempty(metaData.ecoCode.climate)
    i_climate = 1;
  else
    sel_climate = ismember(climateCode,metaData.ecoCode.climate); i_climate = i_climate(sel_climate);
  end
  i_climate =  listdlg('ListString',climateCode, 'Name','climate dlg', 'ListSize',[100 600], 'InitialValue',i_climate);
   
  metaData.ecoCode.climate = climateCode(i_climate); 
  set(Hclimate, 'String', cell2str(metaData.ecoCode.climate)); 
  AmPgui('setColor')
end

function ecozoneCb(~, ~, Hecozone)  
  global metaData eco_types
  ecozoneCode = fieldnames(eco_types.ecozone); n_ecozone = length(ecozoneCode); i_ecozone = 1:n_ecozone;
  ecozoneCodeList = ecozoneCode;
   for i=1:n_ecozone
     ecozoneCodeList{i} = [ecozoneCodeList{i}, ': ', eco_types.ecozone.(ecozoneCode{i})];
   end
   if isempty(metaData.ecoCode.ecozone)
     i_ecozone = 1;
   else
     sel_ecozone = ismember(ecozoneCode,metaData.ecoCode.ecozone); i_ecozone = i_ecozone(sel_ecozone);
   end
   i_ecozone =  listdlg('ListString', ecozoneCodeList,'Name', 'ecozone dlg','ListSize',[450 500], 'InitialValue',i_ecozone);
   metaData.ecoCode.ecozone = ecozoneCode(i_ecozone); 
   set(Hecozone, 'String', cell2str(metaData.ecoCode.ecozone)); 
   AmPgui('setColor')
end
 
function habitatCb(~, ~, Hhabitat)  
  global metaData eco_types
  habitatCode = fieldnames(eco_types.habitat); n_habitat = length(habitatCode); 
  habitatCodeList = habitatCode;
  for i=1:n_habitat
    habitatCodeList{i} = [habitatCodeList{i}, ': ', eco_types.habitat.(habitatCode{i})];
  end
  if isempty(metaData.ecoCode.habitat)
    i_habitat = 1;
  else
    i_habitat = 1:n_habitat;
    i_habitat = i_habitat(i_habitat(ismember(habitatCode,metaData.ecoCode.habitat)));
  end
  i_habitat =  listdlg('ListString',habitatCodeList, 'Name','habitat dlg', 'ListSize',[400 500], 'InitialValue',i_habitat);
  habitatCode = prependStage(habitatCode(i_habitat));
  metaData.ecoCode.habitat = habitatCode; 
  set(Hhabitat, 'String', cell2str(metaData.ecoCode.habitat)); 
  AmPgui('setColor')
end

function embryoCb(~, ~, Hembryo)  
  global metaData eco_types
  embryoCode = fieldnames(eco_types.embryo); n_embryo = length(embryoCode); 
  embryoCodeList = embryoCode;
  for i=1:n_embryo
    embryoCodeList{i} = [embryoCodeList{i}, ': ', eco_types.embryo.(embryoCode{i})];
  end
  if isempty(metaData.ecoCode.embryo)
    i_embryo = 1;
  else
    i_embryo = 1:n_embryo;
    i_embryo = i_embryo(i_embryo(ismember(embryoCode,metaData.ecoCode.embryo)));
  end
  i_embryo =  listdlg('ListString',embryoCodeList, 'Name','embryo dlg', 'ListSize',[450 500], 'InitialValue',i_embryo);
  metaData.ecoCode.embryo = embryoCode(i_embryo); 
  set(Hembryo, 'String', cell2str(metaData.ecoCode.embryo));
  AmPgui('setColor')
end

function migrateCb(~, ~, Hmigrate)  
  global metaData eco_types
  migrateCode = fieldnames(eco_types.migrate); n_migrate = length(migrateCode); 
  migrateCodeList = migrateCode;
  for i=1:n_migrate
    migrateCodeList{i} = [migrateCodeList{i}, ': ', eco_types.migrate.(migrateCode{i})];
  end
  if isempty(metaData.ecoCode.migrate)
    i_migrate = 1;
  else
    i_migrate = 1:n_migrate;
    i_migrate = i_migrate(i_migrate(ismember(migrateCode,metaData.ecoCode.migrate)));
  end
  i_migrate =  listdlg('ListString',migrateCodeList, 'Name','migrate dlg', 'ListSize',[550 140], 'InitialValue',i_migrate);
  metaData.ecoCode.migrate = migrateCode(i_migrate); 
  set(Hmigrate, 'String', cell2str(metaData.ecoCode.migrate)); 
  AmPgui('setColor')
end

function foodCb(~, ~, Hfood)  
  global metaData eco_types
  foodCode = fieldnames(eco_types.food); n_food = length(foodCode); 
  foodCodeList = foodCode;
  for i=1:n_food
    foodCodeList{i} = [foodCodeList{i}, ': ', eco_types.food.(foodCode{i})];
  end
  if isempty(metaData.ecoCode.food)
    i_food = 1;
  else
    i_food = 1:n_food;
    i_food = i_food(i_food(ismember(foodCode,metaData.ecoCode.food)));
  end
  i_food =  listdlg('ListString',foodCodeList, 'Name','food dlg', 'ListSize',[450 500], 'InitialValue',i_food);
  foodCode = prependStage(foodCode(i_food));
  metaData.ecoCode.food = foodCode; 
  set(Hfood, 'String', cell2str(metaData.ecoCode.food)); 
  AmPgui('setColor')
end

function genderCb(~, ~, Hgender)  
  global metaData eco_types
  genderCode = fieldnames(eco_types.gender); n_gender = length(genderCode); 
  genderCodeList = genderCode;
  for i=1:n_gender
    genderCodeList{i} = [genderCodeList{i}, ': ', eco_types.gender.(genderCode{i})];
  end
  if isempty(metaData.ecoCode.gender)
    i_gender = 1;
  else
    i_gender = 1:n_gender;
    i_gender = i_gender(i_gender(ismember(genderCode,metaData.ecoCode.gender)));
  end
  i_gender =  listdlg('ListString',genderCodeList, 'Name','gender dlg', 'ListSize',[450 190], 'InitialValue',i_gender);
  metaData.ecoCode.gender = genderCode(i_gender); 
  set(Hgender, 'String', cell2str(metaData.ecoCode.gender)); 
  AmPgui('setColor')
end

function reprodCb(~, ~, Hreprod)  
  global metaData eco_types
  reprodCode = fieldnames(eco_types.reprod); n_reprod = length(reprodCode); 
  reprodCodeList = reprodCode;
  for i=1:n_reprod
    reprodCodeList{i} = [reprodCodeList{i}, ': ', eco_types.reprod.(reprodCode{i})];
  end
  if isempty(metaData.ecoCode.reprod)
    i_reprod = 1;
  else
    i_reprod = 1:n_reprod;
    i_reprod = i_reprod(i_reprod(ismember(reprodCode,metaData.ecoCode.reprod)));
  end
  i_reprod =  listdlg('ListString',reprodCodeList, 'Name','reprod dlg', 'ListSize',[450 120], 'InitialValue',i_reprod);
  metaData.ecoCode.reprod = reprodCode(i_reprod); 
  set(Hreprod, 'String', cell2str(metaData.ecoCode.reprod));
  AmPgui('setColor')
end

function T_typicalCb(~, ~)  
   global metaData HT
   metaData.T_typical = C2K(str2double(get(HT, 'string')));
   AmPgui('setColor')
end
 
 function authorCb(~, ~)  
   global metaData Hauthor
   metaData.author = str2cell(get(Hauthor, 'string'));
   AmPgui('setColor')
 end
 
 function emailCb(~, ~) 
   global metaData Hemail
   metaData.email = get(Hemail, 'string');
 end
 
 function addressCb(~, ~)  
   global metaData Haddress
   metaData.address = get(Haddress, 'string');
 end

 function addDiscussionCb(~, ~, dD)
  global metaData 
  n = 1 + length(fieldnames(metaData.discussion)); nm = ['D', num2str(n)]; 
  metaData.discussion.(nm) = []; metaData.bibkey.(nm) = [];
  delete(dD)
  AmPgui('discussion')
 end
  
 function discussionCb(~, ~, i)
   global metaData HD HDb 
   nm = ['D', num2str(i)];
   metaData.discussion.(nm) = get(HD(i), 'string');
   metaData.bibkey.(nm) = str2cell(get(HDb(i), 'string'));
 end
 
 function addFactCb(~, ~, dF)
   global metaData 
   n = 1 + length(fieldnames(metaData.facts)); nm = ['F', num2str(n)]; 
   metaData.facts.(nm) = []; metaData.bibkey.(nm) = [];
   delete(dF)
   AmPgui('facts')
 end

 function factsCb(~, ~, i)  
   global metaData HF HFb
   nm = ['F', num2str(i)];
   metaData.facts.(nm) = get(HF(i), 'string');
   metaData.bibkey.(nm) = str2cell(get(HFb(i), 'string'));
 end
 
 function acknowledgmentCb(~, ~)  
   global metaData HK
   metaData.acknowledgment = get(HK, 'string');
 end
 
function linksCb(~, ~, id_links)  
  global metaData HL
  fldnm = fieldnames(metaData.links); n_links = length(fldnm);
  for i = 2:n_links
    metaData.links.(id_links{i}) = get(HL(i), 'string');
  end
  AmPgui('setColor')
end

function addBibCb(~, ~, db)
   global metaData
   metaData.biblist.new = [];
   delete(db)
   AmPgui('biblist')
end

function DbCb(~, ~, bibTypeList, bibkey, i_bibkey)
   global metaData Dbb Dbi
   Db = dialog('Position',[350 320 800 320], 'Name','bibitem dlg');
   uicontrol('Parent',Db, 'Position',[ 20 280  50 20], 'Callback',{@OKCb,Db}, 'Style','pushbutton', 'String','OK'); 
   uicontrol('Parent',Db, 'Position',[100 280  50 20], 'Style','text', 'String','bibkey: '); 
   Dbb = uicontrol('Parent',Db, 'Position',[160 280  80 20], 'Callback',{@bibkeyCb,bibTypeList,bibkey,Db,i_bibkey}, 'Style','edit', 'String',bibkey); 
   if ~isempty(metaData.biblist) && isfield(metaData.biblist, bibkey) && ~strcmp(bibkey, 'new')
     uicontrol('Parent',Db, 'Position',[300 280 150 20], 'String',['type: ',metaData.biblist.(bibkey).type], 'Style','text');
     fld = bibTypeList.(metaData.biblist.(bibkey).type); n_fld = length(fld);
     for i=1:n_fld
       hight = 260 - i * 25;
       if ~isfield(metaData.biblist.(bibkey), fld{i})
         metaData.biblist.(bibkey).(fld{i}) = [];
       end
       str = metaData.biblist.(bibkey).(fld{i});
       uicontrol('Parent',Db, 'Position',[20 hight 80 20], 'Style','text', 'String',[fld{i},': ']); 
       Dbi(i) = uicontrol('Parent',Db, 'Position',[100 hight 680 20], 'Callback',{@bibitemCb,bibkey,fld{i},i}, 'Style','edit', 'String',str); 
     end
   end
end

function bibkeyCb(~, ~, bibTypeList, bibkey, Db, i_bibkey)
  global metaData Dbb Hb
  bibkeyNew = get(Dbb(1), 'string');
  metaData.biblist = renameStructField(metaData.biblist, bibkey, bibkeyNew); 
  fld = fieldnames(bibTypeList);
  i_type =  listdlg('ListString',fieldnames(bibTypeList), 'Name','biblist dlg', 'ListSize',[100 150], 'SelectionMode','single', 'InitialValue',1);
  metaData.biblist.(bibkeyNew).type = fld{i_type};
  fld = bibTypeList.(fld{i_type}); n_fld = length(fld);
  for i=1:n_fld
    metaData.biblist.(bibkeyNew).(fld{i}) = [];
  end
  set(Hb(i_bibkey), 'String', bibkeyNew);
  delete(Db);
  DbCb([], [], bibTypeList, bibkeyNew, i_bibkey)
end

function bibitemCb(~, ~, bibkey, fld, i)
  global metaData Dbi
  metaData.biblist.(bibkey).(fld) = get(Dbi(i), 'string');
end

function add0Cb(~, ~, code0, d0)
   global data txtData auxData metaData
   n_code0 = size(code0,1); codeList0 = code0(:,1);
   for i = 1:n_code0
     codeList0{i} = [code0{i,1}, ': ', code0{i,4}];
   end
   i_code0 =  listdlg('ListString',codeList0, 'Name','0-var data dlg', 'ListSize',[300 400], 'InitialValue',n_code0);
   code0 = code0(i_code0,:); 
   if ~isempty(data.data_0)
     data_0 = fieldnames(data.data_0); 
     code0 = code0(~ismember(code0(:,1), data_0),:);
   end
   n = size(code0,1);
   for i = 1:n
     data.data_0.(code0{i,1}) = []; 
     txtData.units.(code0{i,1}) = code0{i,2};
     txtData.label.(code0{i,1}) = code0{i,4};
     txtData.comment.(code0{i,1}) = '';
     if code0{i,3}
       auxData.temp.(code0{i,1}) = [];
     end
     metaData.bibkey.(code0{i,1}) = [];
   end
   delete(d0);
   AmPgui('data_0');
end 

% function d0NmCb(~, ~, i)
%    global data auxData txtData metaData H0n
%    fld = fieldnames(data.data_0); n = length(fld);
%    nm = get(H0n(i), 'string'); 
%    data.data_0 = renameStructField(data.data_0, fld{i}, nm); 
%    
%    if isfield(txtData.units, fld{i})
%      txtData.units = renameStructField(txtData.units, fld{i}, nm);  
%      txtData.label = renameStructField(txtData.label, fld{i}, nm);  
%    end
%    if isfield(auxData.temp, fld{i})
%      auxData.temp = renameStructField(auxData.temp, fld{i}, nm);  
%    end 
%    if isfield(metaData.bibkey, fld{i})
%      metaData.bibkey = renameStructField(metaData.bibkey, fld{i}, nm);  
%    end 
% 
% end

function d0Cb(~, ~, i)  
   global data auxData txtData metaData H0v H0T H0b H0c
   fld = fieldnames(data.data_0);
   data.data_0.(fld{i}) = str2double(get(H0v(i), 'string'));
   if isfield(auxData.temp, fld{i})
     auxData.temp.(fld{i}) = C2K(str2double(get(H0T(i), 'string')));
     txtData.units.temp = 'K';
     txtData.label.temp = 'temperature';
   end
   metaData.bibkey.(fld{i}) = str2cell(get(H0b(i), 'string'));
   txtData.comment.(fld{i}) = str2cell(get(H0c(i), 'string'));
end

function add1Cb(~, ~, code1, d1)
   global data txtData auxData metaData
   n_code1 = size(code1,1); codeList1 = code1(:,1);
   for i = 1:n_code1
     codeList1{i} = [code1{i,1}, ': ', cell2str(code1{i,4})];
   end
   i_code1 =  listdlg('ListString',codeList1, 'Name','1-var data dlg', 'ListSize',[300 350], 'InitialValue',n_code1);
   code1 = code1(i_code1,:); 
   if ~isempty(data.data_1)
     data_1 = fieldnames(data.data_1); 
     code1 = code1(~ismember(code1(:,1), data_1),:);
   end
   n = size(code1,1);
   for i = 1:n
     data.data_1.(code1{i,1}) = []; 
     txtData.units.(code1{i,1}) = code1{i,2};
     txtData.label.(code1{i,1}) = code1{i,4};
     txtData.comment.(code1{i,1}) = [];
     if code1{i,3}
       auxData.temp.(code1{i,1}) = [];
     end
     metaData.bibkey.(code1{i,1}) = [];
   end 
   delete(d1);
   AmPgui('data_1');
end 

function D1Cb(~, ~, fld, i)  
   global data auxData txtData metaData D1 H1v H1T H1b H1c
   D1(i) = dialog('Position',[150 35 475 500], 'Name','1-variate data set dlg');
   units = txtData.units.(fld); label = txtData.label.(fld); keyB = true;
   uicontrol('Parent',D1(i), 'Position',[ 20 480  50 20], 'Callback',{@OKCb,D1(i)}, 'Style','pushbutton', 'String','OK'); 
   uicontrol('Parent',D1(i), 'Position',[ 80 480 150 20], 'String',['name: ', fld], 'Style','text');
   uicontrol('Parent',D1(i), 'Position',[225 480 100 20], 'String',['units: ', units{1},' , ',units{2}], 'Style','text');
   H1v(i) = uicontrol('Parent',D1(i), 'Min',0, 'Max',300, 'Position',[20 20  200 450], 'Callback',{@d1Cb,fld,i}, 'String',num2str(data.data_1.(fld)), 'Style','edit');
   uicontrol('Parent',D1(i), 'Position',[225 400  100 20], 'String','x-label:', 'Style','text');
   uicontrol('Parent',D1(i), 'Position',[245 375  200 20], 'String',label{1}, 'Style','text');
   uicontrol('Parent',D1(i), 'Position',[225 350  100 20], 'String','y-label:', 'Style','text');
   uicontrol('Parent',D1(i), 'Position',[245 325  200 20], 'String',label{2}, 'Style','text');
   if isfield(auxData.temp,(fld))
     uicontrol('Parent',D1(i), 'Position',[225 300 100 20], 'String','temperature in C', 'Style','text');
     H1T(i) = uicontrol('Parent',D1(i), 'Position',[325 300  50 20], 'Callback',{@d1TCb,fld,i}, 'String',auxData.temp.(fld), 'Style','edit');
   end
   uicontrol('Parent',D1(i), 'Position',[225 275  100 20], 'String','bibkey', 'Style','text');
   H1b(i) = uicontrol('Parent',D1(i), 'Position',[300 275  100 20], 'Callback',{@d1bCb,fld,i}, 'String',txtData.bibkey.(fld), 'Style','edit');
   uicontrol('Parent',D1(i), 'Position',[225 250  70 20], 'String','comment', 'Style','text');
   H1c(i) = uicontrol('Parent',D1(i), 'Position',[225 225  240 20], 'Callback',{@d1cCb,fld,i}, 'String',txtData.comment.(fld), 'Style','edit');
end

function d1Cb(~, ~, fld, i)
  global data H1v
  data.data_1.(fld) = str2num(get(H1v(i), 'string'));
end

  
function d1TCb(~, ~, fld, i)
  global auxData H1T 
  auxData.temp.(fld) = get(H1T(i), 'string');
end  

function d1bCb(~, ~, fld, i)
  global metaData H1b 
  metaData.bibkey.(fld) = get(H1b(i), 'string');
end  

function d1cCb(~, ~, fld, i)
  global metaData H1c
  metaData.comment.(fld) = get(H1c(i), 'string');
end  

function OKCb(~, ~, H, i) 
  global infoAmPgui
  if exist('i','var')
    infoAmPgui = i;
  end
  delete(H);
end

%% other support functions
function str = cell2str(cell)
  if isempty(cell)
    str = []; return
  end
  if ~iscell(cell)
    str = cell;
    return
  end
  n = length(cell); str = [];
  for i=1:n
    str = [str, cell{i}, ','];
  end
  str(end) = [];
end

function c = str2cell(str)
  if isempty(str)
    c = []; return
  end
  str = strsplit(str, ',');
  n = length(str); 
  if n == 1
    c = str;
  else
    c = cell(1,n);
    for i=1:n
      c{i} = str(i);
     end
  end
end

function code = prependStage(code)
  stageList = {'0b', '0j', '0x', '0p', '0i', 'bj', 'bx', 'bp', 'bi', 'jp', 'ji', 'xp', 'xi', 'pi'};
  n = length(code);
  for i = 1:n
    fprintf(['Prepend stage for code ', code{i},'\n']);
    i_stage =  listdlg('ListString',stageList, 'Name','stage dlg', 'SelectionMode','single', 'ListSize',[150 150], 'InitialValue',2);
    code{i} = [stageList{i_stage}, code{i}];
  end
end

