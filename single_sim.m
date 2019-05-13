input.added_mass = 0;

input.subj_mass = 60; % in kg
input.subj_height = 1.50; % in m
input.thetaE_start = 1.7; % in rad
input.thetaS_start = .7; % in rad
input.movedur = 1;

time_step = .0050;
input.normforce = 200E4;

t_act= 0.05;%.0050;
t_deact = 0.066;%.066;

fold = pwd;
% load('Resamp_data_gb2.mat');

% fprintf('Processing %s \n',filename);
% clearvars -except time_step target_str input_normforce masses minparams L Resamp tic fold minfail rnjesus

vars.masses = input.added_mass;
vars.rnjesus = 0;
vars.time_inc = 0.0050;
vars.speeds = input.movedur; % Movement Duration
vars.norm_force = input.normforce;
vars.minparam = 'stress';
vars.L = 2;

% http://www.kdm.p.lodz.pl/articles/2017/3/21_3_4.pdf
% https://www.ele.uri.edu/faculty/vetter/BME207/anthropometric-data.pdf
forearm.mass = 0.022*input.subj_mass;%;+2*vars{c,subj,s,t}.masses(c);
forearm.length = (0.632-0.425)*input.subj_height; % meters, taken from An iterative optimal control and estimation design for nonlinear stochastic system
forearm.l_com = 0.682*forearm.length;

forearm.l_com = (.417*(.632-.480)*input.subj_height*.016*input.subj_mass +...
        ((.632-.480)*input.subj_height+.515*((.480-.370)/2)*input.subj_height)*.006*input.subj_mass)/...
        (.016*input.subj_mass+.006*input.subj_mass); % Using Enoka
    
[forearm] = calc_forearmI(forearm,vars.masses);

upperarm.length = (0.825-0.632)*input.subj_height; % meters
upperarm.l_com = 0.436*upperarm.length;
upperarm.centl = 0.436*upperarm.length;
upperarm.mass = 0.028*input.subj_mass; %kg
upperarm.Ic = .0141;

shoulder = [];
elbow = [];
theta = [];

ro = [-.0758,0.4878];
vars.target = [0,.1];
rf = [vars.target(1)+ro(1),...
    vars.target(2)+ro(2)];

% If you have resampled data to simulate, use Gen_mvt_gb. Otherwise just
% use the minimum jerk.
% [Data] = Gen_mvt_gb(Resamp,c,subj,s,t,ro,rf,vars{c,subj,s,t}.time_inc);

Data = minjerk(ro,rf,vars.speeds,vars.time_inc);
Data.targetposition = rf;
Data.startposition  = ro;

[shoulder,...
    elbow,...
    theta,...
    muscles,...
    act,...
    u,...
    est,...
    tnew,...
    energy,...
    eff_mass] =...
    looper2(Data,...
            forearm,...
            upperarm,...
            vars);
% 
% toc
% % fprintf('aa_%scost_01-21-2019',  minparams{L});
% if exist('rnjesus');
%     if rnjesus
%         filename = sprintf('aa_%scost_01-21-2019_rng',  minparams{L});
%     else
%         filename = sprintf('aa_%scost_01-21-2019',  minparams{L});
%     end
% else
%     filename = sprintf('aa_%scost_01-21-2019_rng',  minparams{L});
% end
% 
% save(filename);
% if exist(strcat(filename,'.mat'),'file')==2
%     fprintf('Complete. Saved as: %s\n',filename');
% end 
% 
% % end
