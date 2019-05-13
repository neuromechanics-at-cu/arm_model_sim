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

    %% Minimization of cost function by time step
    [ muscles , act , u , est , tnew] =...
        compute_min_cost(shoulder,elbow,theta,...
        upperarm,forearm,vars);
        
    %% Calc Energy Rates
    muscle_nums = {'an','bs','br','da','dp','pc','bb','tb'};
    for k=1:8
        [~,energy.(muscle_nums{k})] = ...
            umberger2(muscles.(muscle_nums{k}) , act.(muscle_nums{k}) , u.(muscle_nums{k}) );
    end
    
    out.shoulder = shoulder;
    out.elbow    = elbow;
    out.theta    = theta;
    out.muscles  = muscles;
    out.act      = act;
    out.u        = u;
    out.est      = est;
    out.tnew     = tnew;
    out.energy   = energy;
    out.eff_mass = eff_mass;
end

