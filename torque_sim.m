%% Torque Sim
% Created by: Gary Bruening
% Edited:     7/16/2020
% 
% The purpose of this script is to simulate minimum jerk and calculate sum
% of torque squared for a variety of reaching movements. This is to find
% how usm of torque squared changes with mass and movement duration in the
% effort model.

%%
clear

mass_count = 0;
added_masses = 0:.5:10;
move_durs = .3:.05:2;

for addedmass = 1:length(added_masses)
   for movedur = 1:length(move_durs)
       for t = 1:8
           
            sim_input{addedmass,movedur,t}.added_mass  = 0;
            sim_input{addedmass,movedur,t}.subj_mass   = 60; % in kg
            sim_input{addedmass,movedur,t}.subj_height = 1.75; % in m
            sim_input{addedmass,movedur,t}.movedur     = 1;
            sim_input{addedmass,movedur,t}.normforce   = 200E4;
            sim_input{addedmass,movedur,t}.start_pos   = [-.0758,0.4878]; % Starting location in m
            sim_input{addedmass,movedur,t}.tar_rel_pos = [0.0707, 0.0707]; % Relative Target position in m

            sim_input{addedmass,movedur,t}.added_mass = added_masses(addedmass);
            sim_input{addedmass,movedur,t}.movedur    = move_durs(movedur);
            center = [-.0758,0.4878];

            switch t
               case 1
                   sim_input{addedmass,movedur,t}.tar_rel_pos = [.0707 .0707];
                   sim_input{addedmass,movedur,t}.start_pos = [-.0758,0.4878];
               case 2
                   sim_input{addedmass,movedur,t}.tar_rel_pos = [-.0707 .0707];
                   sim_input{addedmass,movedur,t}.start_pos = [-.0758,0.4878];
               case 3
                   sim_input{addedmass,movedur,t}.tar_rel_pos = [-.0707 -.0707];
                   sim_input{addedmass,movedur,t}.start_pos = [-.0758,0.4878];
               case 4
                   sim_input{addedmass,movedur,t}.tar_rel_pos = [.0707 -.0707];
                   sim_input{addedmass,movedur,t}.start_pos = [-.0758,0.4878];
               case 5
                   sim_input{addedmass,movedur,t}.start_pos = [.0707 .0707]+center;
                   sim_input{addedmass,movedur,t}.tar_rel_pos = [-.0707 -.0707];
               case 6
                   sim_input{addedmass,movedur,t}.start_pos = [-.0707 .0707]+center;
                   sim_input{addedmass,movedur,t}.tar_rel_pos = [.0707 -.0707];
               case 7
                   sim_input{addedmass,movedur,t}.start_pos = [-.0707 -.0707]+center;
                   sim_input{addedmass,movedur,t}.tar_rel_pos = [.0707 .0707];
               case 8
                   sim_input{addedmass,movedur,t}.start_pos = [.0707 -.0707]+center;
                   sim_input{addedmass,movedur,t}.tar_rel_pos = [-.0707 .0707];
            end
       end
   end
end

parfor ii = 1:length(added_masses)*length(move_durs)*8
    [addedmass,movedur,t] = ind2sub([length(added_masses),length(move_durs),8],ii);
    torque_data{ii} = ...
        single_sim(sim_input{addedmass,movedur,t});
    torque_data{ii}.added_mass = added_masses(addedmass);
    torque_data{ii}.move_dur = move_durs(movedur);
end

for ii = 1:length(added_masses)*length(move_durs)*8
    [addedmass,movedur,t] = ind2sub([length(added_masses),length(move_durs),8],ii);
    torque2{addedmass,movedur,t} = torque_data{ii};
end

%% Write the data
fprintf('Writing data to excel.\n')
excel_file = 'sum_torque2.csv';
fileID=fopen(excel_file,'w');

delcount=0;

A={'movedur,'...
   'added_mass,'...
   'target,'...
   'effmass,'...
   'effmass_mean,'...
   'sum_t2'...
   };

fprintf(fileID,'%s',A{:});
fprintf(fileID,'\n');
for addedmass = 1:length(added_masses)
   for movedur = 1:length(move_durs)
       for t = 1:8
           data = torque2{addedmass,movedur,t};
           tar_avg = 0;
           
            if ~isempty(data)
                A={data.move_dur,...
                   data.added_mass,...
                   t,...
                   data.eff_mass(1),...
                   mean(data.eff_mass),...
                   data.torque2};
                    dlmwrite(excel_file,A,'-append')
            end
        end
    end
end

fclose(fileID);


