%% find_min_max_state.m
% Created by: Gary Bruening
% Edited:     5-13-2019
% 
% Feed an neural drive of 0 and one into the activation dynamics to see
% where each muscle can be at the next time step. Used to determine the
% constratins on the muscles.

function [ mini , max ] = find_minmax_state( act_state, time_step )

[ mini ] = rk4( act_state , 0 , time_step);
[ max ]  = rk4( act_state , 1 , time_step);

end

% Legacy code that runs slower because ode45 is slow.
% t_act = .050;
% t_deact = .066; 
% 
% sig = 0;
% eps = 0;
% 
% u_in = [1,1];
% 
% fgt=(0:1)*time_step;
% f1 = 1./(t_deact+u_in*(t_act-t_deact));
% g1 = (1+eps*sig)./(t_deact+u_in*(t_act-t_deact));
% 
% f2 = 1./(t_deact);
% g2 = (1+eps*sig)./(t_deact);
% 
% tspan=[0 fgt(end)];
% ic = act_state;
% opts = odeset('RelTol',1e-7,'AbsTol',1e-7);
% [~,anew]=ode45(@(tnew,anew) myode1(tnew,anew,fgt,f1,g1,f2,g2,u_in),tspan,ic,opts);
% 
% max = anew(end);
% 
% u_in = [0,0];
% fgt=(0:1)*time_step;
% f1 = 1./(t_deact+u_in*(t_act-t_deact));
% g1 = (1+eps*sig)./(t_deact+u_in*(t_act-t_deact));
% 
% f2 = 1./(t_deact);
% g2 = (1+eps*sig)./(t_deact);
% 
% tspan=[0 fgt(end)];
% ic = act_state;
% opts = odeset('RelTol',5e-4,'AbsTol',5e-4);%,'MinStep',5e-4);
% [~,anew]=ode45(@(tnew,anew) myode1(tnew,anew,fgt,f1,g1,f2,g2,u_in),tspan,ic,opts);
% 
% mini = anew(end);