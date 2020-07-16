%% Animation
% Created by: Gary Bruening
% Edited:     7/16/2020
% 
% Used to animate the arm motion, I mainly use for checking.
% Need to run the torque sim first.
% Then decide the addedmass, movedur, and t you want to plot.

%%
plot_data = torque2{addedmass,movedur,t};
sim_input_plot = sim_input{addedmass,movedur,t};
upperarm = plot_data.upperarm;
forearm = plot_data.forearm;

figure(7);clf(7);
for ii = 1:3:length(plot_data.elbow.torque(:))
    figure(7);clf(7);
    
    subplot(1,2,1)
    hold on;
    axis([-.3 .3 -.1 .7]);
    viscircles([sim_input_plot.start_pos(1),sim_input_plot.start_pos(2)],.1);
    plot(sim_input_plot.start_pos(1),sim_input_plot.start_pos(2),'*');
    plot(sim_input_plot.tar_rel_pos(1)+sim_input_plot.start_pos(1),sim_input_plot.tar_rel_pos(2)+sim_input_plot.start_pos(2),'x','Color','b');
    plot(plot_data.x(ii),plot_data.y(ii),'o');
    
    % Plot upperarm
    plot([0,cos(plot_data.theta.S(ii))*plot_data.upperarm.length],[0,sin(plot_data.theta.S(ii))*plot_data.upperarm.length],...
        'linewidth',3,'color','k');
    
    % Plot forearm
    plot([cos(plot_data.theta.S(ii))*upperarm.length,...
        cos(plot_data.theta.S(ii))*upperarm.length+cos(plot_data.theta.E(ii)+plot_data.theta.S(ii))*forearm.length],...
        [sin(plot_data.theta.S(ii))*upperarm.length,...
        sin(plot_data.theta.S(ii))*upperarm.length+sin(plot_data.theta.E(ii)+plot_data.theta.S(ii))*forearm.length],...
        'linewidth',3,'color','k');
    
    subplot(1,2,2)
    hold on
    axis([0 plot_data.time_inc*length(plot_data.elbow.torque(:))...
        min(min(plot_data.shoulder.torque), min(plot_data.elbow.torque))...
        max(max(plot_data.shoulder.torque), max(plot_data.elbow.torque))]);
    plot(0:plot_data.time_inc:(ii-1)*plot_data.time_inc,plot_data.shoulder.torque(1:ii));
    plot(0:plot_data.time_inc:(ii-1)*plot_data.time_inc,plot_data.elbow.torque(1:ii));
    legend({'Shoulder','Elbow'})
    ylabel('Torque')
    xlabel('Time (s)');
    drawnow;
end
