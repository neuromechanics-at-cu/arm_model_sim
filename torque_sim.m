
input.added_mass  = 0;
input.subj_mass   = 60; % in kg
input.subj_height = 1.75; % in m
input.movedur     = 1;
input.normforce   = 200E4;
input.start_pos   = [-.0758,0.4878]; % Starting location in m
input.tar_rel_pos = [0.0707, 0.0707]; % Relative Target position in m

output = single_sim(input);

mass_count = 0;
for added_mass = 0:.5:10
   mass_count = mass_count+1;
   dur_count = 0;
   for movedur = .3:.05:2
       dur_count = dur_count + 1;
       for t = 1:8
           input.added_mass = added_mass;
           input.movedur    = movedur;
           center = [-.0758,0.4878];
            
           switch t
               case 1
                   input.tar_rel_pos = [.0707 .0707];
                   input.start_pos = [-.0758,0.4878];
               case 2
                   input.tar_rel_pos = [-.0707 .0707];
                   input.start_pos = [-.0758,0.4878];
               case 3
                   input.tar_rel_pos = [-.0707 -.0707];
                   input.start_pos = [-.0758,0.4878];
               case 4
                   input.tar_rel_pos = [.0707 -.0707];
                   input.start_pos = [-.0758,0.4878];
               case 5
                   input.start_pos = [.0707 .0707]+center;
                   input.tar_rel_pos = [-.0707 -.0707];
               case 6
                   input.start_pos = [-.0707 .0707]+center;
                   input.tar_rel_pos = [.0707 -.0707];
               case 7
                   input.start_pos = [-.0707 -.0707]+center;
                   input.tar_rel_pos = [.0707 .0707];
               case 8
                   input.start_pos = [.0707 -.0707]+center;
                   input.tar_rel_pos = [-.0707 .0707];
            end
            torque_data{mass_count,dur_count,t} = single_sim(input);
       end
   end
end