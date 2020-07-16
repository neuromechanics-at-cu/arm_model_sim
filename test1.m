clear

addedmass=1
movedur=1
t=1
sim_input.added_mass  = 0;
sim_input.subj_mass   = 60; % in kg
sim_input.subj_height = 1.75; % in m
sim_input.movedur     = 1;
sim_input.normforce   = 200E4;
sim_input.start_pos   = [-.0758,0.4878]; % Starting location in m
sim_input.tar_rel_pos = [0.0707, 0.0707]; % Relative Target position in m

sim_input.added_mass = 20;
sim_input.movedur    = .5;

for t = 1:8

center = [-.0758,0.4878];

% Initialize some variables. 
vars.masses = sim_input.added_mass;
vars.rnjesus = 0;
vars.time_inc = 0.0050;
vars.speeds = sim_input.movedur; % Movement Duration
vars.norm_force = sim_input.normforce;
vars.minparam = 'drive2';

% Create the arm segments.
forearm.mass = 0.022*sim_input.subj_mass;%;+2*vars.masses(c);
forearm.length = (0.632-0.425)*sim_input.subj_height; % meters, taken from An iterative optimal control and estimation design for nonlinear stochastic system
forearm.l_com = 0.682*forearm.length;

forearm.l_com = (.417*(.632-.480)*sim_input.subj_height*.016*sim_input.subj_mass +...
        ((.632-.480)*sim_input.subj_height+.515*((.480-.370)/2)*sim_input.subj_height)*.006*sim_input.subj_mass)/...
        (.016*sim_input.subj_mass+.006*sim_input.subj_mass); % Using Enoka
    
[forearm] = calc_forearmI(forearm,vars.masses);

upperarm.length = (0.825-0.632)*sim_input.subj_height; % meters
upperarm.l_com = 0.436*upperarm.length;
upperarm.centl = 0.436*upperarm.length;
upperarm.mass = 0.028*sim_input.subj_mass; %kg
upperarm.Ic = .0141;

shoulder = [];
elbow = [];
theta = [];

% Define the target spots.
ro = sim_input.start_pos;
vars.target = sim_input.tar_rel_pos;
rf = [vars.target(1)+ro(1),...
    vars.target(2)+ro(2)];

switch t
   case 1
       sim_input.tar_rel_pos = [.0707 .0707];
       sim_input.start_pos = [-.0758,0.4878];
   case 2
       sim_input.tar_rel_pos = [-.0707 .0707];
       sim_input.start_pos = [-.0758,0.4878];
   case 3
       sim_input.tar_rel_pos = [-.0707 -.0707];
       sim_input.start_pos = [-.0758,0.4878];
   case 4
       sim_input.tar_rel_pos = [.0707 -.0707];
       sim_input.start_pos = [-.0758,0.4878];
   case 5
       sim_input.start_pos = [.0707 .0707]+center;
       sim_input.tar_rel_pos = [-.0707 -.0707];
   case 6
       sim_input.start_pos = [-.0707 .0707]+center;
       sim_input.tar_rel_pos = [.0707 -.0707];
   case 7
       sim_input.start_pos = [-.0707 -.0707]+center;
       sim_input.tar_rel_pos = [.0707 .0707];
   case 8
       sim_input.start_pos = [.0707 -.0707]+center;
       sim_input.tar_rel_pos = [-.0707 .0707];
end

test = single_sim(sim_input);
figure(1);clf(1); hold on
plot(test.shoulder.torque)
plot(test.elbow.torque)


figure(7);clf(7);
for ii = 1:3:length(test.elbow.torque(:))
    figure(7);clf(7);hold on;
    axis([-.3 .3 -.1 .7]);
    viscircles([sim_input.start_pos(1),sim_input.start_pos(2)],.1);
    plot(sim_input.start_pos(1),sim_input.start_pos(2),'*');
    plot(sim_input.tar_rel_pos(1)+sim_input.start_pos(1),sim_input.tar_rel_pos(2)+sim_input.start_pos(2),'x','Color','b');
    plot(test.x(ii),test.y(ii),'o');
    
    % Plot upperarm
    plot([0,cos(test.theta.S(ii))*upperarm.length],[0,sin(test.theta.S(ii))*upperarm.length],...
        'linewidth',3,'color','k');
    
    % Plot forearm
    plot([cos(test.theta.S(ii))*upperarm.length,...
        cos(test.theta.S(ii))*upperarm.length+cos(test.theta.E(ii)+test.theta.S(ii))*forearm.length],...
        [sin(test.theta.S(ii))*upperarm.length,...
        sin(test.theta.S(ii))*upperarm.length+sin(test.theta.E(ii)+test.theta.S(ii))*forearm.length],...
        'linewidth',3,'color','k');
    drawnow;
    
end



end