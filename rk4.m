%% find_min_max_state.m
% Created by: Gary Bruening
% Edited:     5-13-2019
% 
% Runge-Kutta ODE solver to determine activation states.

function [ out ] = rk4( act_state , drive, time_step, varargin )    
t_act = .050;%0.01;
t_deact = .066;%0.04;

step_size = .001;
h = step_size;
x=0:h:time_step;
y(1) = act_state;

if drive > act_state
    F_xy = @(a) (drive - a)/(t_deact+drive*(t_act-t_deact));
else
    F_xy = @(a) (drive - a)/(t_deact);
end

if nargin == 4
    p = varargin{1};
    t_act = [56.36,59.84,54.81,49.59,54.39,49.59]*1E-3;
    t_deact = [61.83,65.98,59.98,53.77,59.48,53.77]*1E-3;
    F_xy = @(a) (drive - a)*((drive/t_act(p))-(drive-1)/(t_deact(p)));
end

for i=1:(length(x)-1)                              % calculation loop
    k_1 = F_xy(y(i));
    k_2 = F_xy(y(i)+0.5*h*k_1);
    k_3 = F_xy(y(i)+0.5*h*k_2);
    k_4 = F_xy(y(i)+k_3*h);

    y(i+1) = y(i) + (1/6)*(k_1+2*k_2+2*k_3+k_4)*h;  % main equation
end
out = y(end);

end

