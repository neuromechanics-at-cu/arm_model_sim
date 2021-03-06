
% input.added_mass  = 0;
% input.subj_mass   = 60; % in kg
% input.subj_height = 1.50; % in m
% input.movedur     = 1;
% input.normforce   = 200E4;
% input.start_pos   = [-.0758,0.4878]; % Starting location in m from shoulder
% input.tar_rel_pos = [0.0707, 0.0707]; % Relative Target position in m
% 
% output = minjerk_single_sim(input);


input.added_mass  = 0;
input.subj_mass   = 60; % in kg
input.subj_height = 1.50; % in m
input.movedur     = 1;
input.normforce   = 200E4;
input.start_pos   = [-.0758,0.4878]; % Starting location in m from shoulder
input.tar_rel_pos = [0.0707, 0.0707]; % Relative Target position in m
load('Resamp_data_Nov2020.mat');
input.Resamp.X      = squeeze(Resamp.X(2,3,3,1,:));
input.Resamp.Y      = squeeze(Resamp.Y(2,3,3,1,:));
input.Resamp.T      = squeeze(Resamp.T(2,3,3,1,:));

output = kine_single_sim(input);


