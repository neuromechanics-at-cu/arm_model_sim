%% looper2.m
% Created by: Gary Bruening
% Edited:     5-13-2019
% 
% This is the main function that is called to do the simulation. Used to be
% the main loop function. Call 3 main functions to do inverse dynamics,
% simulate the muscle actuators, and then calculate the energy.

% The houdijk and Minetti energy models currently do not produce reasonable
% values. 7/17/2020

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
        %Houdijk and Minetti Currently not working
%     % Calc houdijk Energy Rates
%         [~,houd.(muscle_nums{k})] = ...
%             houdijk(muscles.(muscle_nums{k}) , act.(muscle_nums{k}) , u.(muscle_nums{k}), vars );
%         
%     % Calc Minetti Energy Rates
%         [~,mine.(muscle_nums{k})] = ...
%             minetti(muscles.(muscle_nums{k}) , act.(muscle_nums{k}) , u.(muscle_nums{k}), vars  );
        
    % Calc Umberger Energy Rates
        [~,umber.(muscle_nums{k})] = ...
            umberger2(muscles.(muscle_nums{k}) , act.(muscle_nums{k}) , u.(muscle_nums{k}) );
        
    % Calc Bhargava Energy Rates
        [~,bhar.(muscle_nums{k})] = ...
            bhargava(muscles.(muscle_nums{k}) , act.(muscle_nums{k}) , u.(muscle_nums{k}), vars );
        
    % Calc uchida Energy Rates
        [~,uch.(muscle_nums{k})] = ...
            uchida(muscles.(muscle_nums{k}) , act.(muscle_nums{k}) , u.(muscle_nums{k}), vars );
        
    % Calc lichtwark Energy Rates
        [~,lich.(muscle_nums{k})] = ...
            lichtwark(muscles.(muscle_nums{k}) , act.(muscle_nums{k}) , u.(muscle_nums{k}), vars );
        
    % Calc Margaria Energy Rates
        [~,marg.(muscle_nums{k})] = ...
            margaria(muscles.(muscle_nums{k}) , act.(muscle_nums{k}) , u.(muscle_nums{k}), vars );
        
    end
    out.shoulder = shoulder;
    out.elbow    = elbow;
    out.theta    = theta;
    out.muscles  = muscles;
    out.act      = act;
    out.u        = u;
    out.est      = est;
    out.tnew     = tnew;
    out.umber    = umber;
    out.bhar     = bhar;
    out.uch      = uch;
    out.lich     = lich;
    out.marg     = umber;
    out.eff_mass = eff_mass;
end

