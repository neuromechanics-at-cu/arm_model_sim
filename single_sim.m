%% single_sim
% Created by: Gary Bruening
% Edited:     5-13-2019
% 
% This funciton takes in some basic inputs and then simulated a reaching
% movement using inverse dynamics and an 8 muscle model. More details and
% full derivations can be found
% https://gbruening.github.io/projects/arm_model.
% 
% The input variable needs to have 5 components:
%   1. Mass added at the hand in kg. (input.added_mass)
%   2. Subject mass in kj. (input.subj_mass)
%   3. Subject height in m. (input.subj_height)
%   4. Movment duration of the sim. (input.movedur)
%   5. Normalized force parameter in Pa. (input.normforce)
%   6. NEED TO ADD START AND TARGET INPUT
% 
% This code utalizes a minimization function of neural drive squared for 
% determining muscle forces. This can be changed by the variable 
% vars.minparam. Options are:
%   'umberger''stress','force','act','drive','stress2','force2','act2','drive2'
% 
% Most variables are set at the beginning of the function, some are
% determined within the sub functions. The time_inc function can be reduced
% if you want a higher resolution sim, but it shouldn't be neccesary and
% may break fmincon in the time increment is to low.

%%
function [out] = single_sim(input)

% Initialize some variables. 
vars.masses = input.added_mass;
vars.rnjesus = 0;
vars.time_inc = 0.0050;
vars.speeds = input.movedur; % Movement Duration
vars.norm_force = input.normforce;
vars.minparam = 'drive2';

% Create the arm segments.
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

% Define the target spots.
ro = input.start_pos;
vars.target = input.tar_rel_pos;
rf = [vars.target(1)+ro(1),...
    vars.target(2)+ro(2)];

% If you have resampled data to simulate, use Gen_mvt_gb. Otherwise just
% use the minimum jerk.
% [Data] = Gen_mvt_gb(Resamp,c,subj,s,t,ro,rf,vars{c,subj,s,t}.time_inc);

% Create movement trajectory using minimum jerk.
Data = minjerk(ro,rf,vars.speeds,vars.time_inc);
Data.targetposition = rf;
Data.startposition  = ro;

% Simulate
out = looper2(Data,forearm,upperarm,vars);

end