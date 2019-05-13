%% calc_drive.m
% Created by: Gary Bruening
% Edited:     5-13-2019
% 
% Main function for calculating the neural drive to all the muscles after
% the minimization and activation states have been computed. 
% Can have it solve at new timepoints, or force it to solve at specific
% time points.

function [ u_in , anew , fgt1,  tnew ] = calc_drive( act_state ,time_step )

% Error checking
if sum(act_state>1)>0
    fprintf('Act State over 1111111111111111111111111111111111111111111111111111 \n');
    ind = act_state>1;
    act_state(ind)
end
t_act = 0.05;%.050;
t_deact = 0.066;%.066;

sig = 0;
eps = 0;
a_e(1) = 0;

% Time array
fgt1=(0:length(act_state)-1)*time_step;
time_new = 0:time_step:max(fgt1);

% Interpolating at new time points if needed
act_state1 = interp1(fgt1,act_state,time_new,'pchip');

adot = diff(act_state1)/(time_step/10);
adot = [adot adot(end)];

u1 = (adot*t_deact + act_state1)./(1+sig*eps-adot*(t_act-t_deact));
u2 = (adot*t_deact + act_state1)./(1+sig*eps);

u_ind = (u1>act_state1);
u = u2;
u(u_ind) = u1(u_ind);

u_in = u;
u_uncap = u;

u_ind = (u_in>1);
u_in(u_ind) = 1;
u_ind = (u_in<0);
u_in(u_ind) = 0;

% Checks
if sum(u_in>1)>0
    fprintf('Neural Drive Over 1 \n')
elseif sum(u_in<0)>0
    fprintf('Neural Drive Less 0 \n')
end

if ~isreal(u_in)
    fprintf('Neural Drive is Imaginary');
end

% Similar method, mostly checking the math again.
fgt=(0:length(act_state1)-1)*time_step/10;
f1 = 1./(t_deact+u*(t_act-t_deact));
g1 = (1+eps*sig)./(t_deact+u*(t_act-t_deact));

f2 = 1./(t_deact);
g2 = (1+eps*sig)./(t_deact);

% ODE45 it
tspan=[0 fgt(end)];
ic = 0;
opts = odeset('RelTol',1e-7,'AbsTol',1e-7);
[tnew,anew]=ode45(@(tnew,anew) myode(tnew,anew,fgt,f1,g1,f2,g2,u_in),tspan,ic,opts);

end