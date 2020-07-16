%% looper2.m
% Created by: Gary Bruening
% Edited:     5-13-2019
% 
% This is the main function that is called to do the simulation. Used to be
% the main loop function. Call 3 main functions to do inverse dynamics,
% simulate the muscle actuators, and then calculate the energy.
function [out] = looper2( Data, forearm , upperarm, vars)
    %% Inverse dyanmics to joint torques
    [ shoulder , elbow , theta , eff_mass] = ...
        Calc_kine( Data, forearm, upperarm,vars.time_inc,vars.masses);
    
    out.shoulder = shoulder;
    out.elbow    = elbow;
    out.theta    = theta;
    out.eff_mass = eff_mass;
    out.time_inc = vars.time_inc;
    
    out.torque2 = sum(out.shoulder.torque.^2)*vars.time_inc+sum(out.shoulder.torque.^2)*vars.time_inc;
end

