%% Fl_Fv_for.m
% Created by: Gary Bruening
% Edited:     5-13-2019
% 
% Determine force output given the length, velocity, and activation of the
% muscles. Negative passive force removed and is in compute_min_cost.m.

function [ T ] = Fl_Fv_for( l , v , a )
    
    % Passive Force
    Fp2 = -0.02*exp(13.8-18.7*l);
    
    % Velocity Component
    if v <= 0
        Fv = (-5.72-v)/(-5.72+(1.38+2.09*l)*v);
    else
        Fv = (0.62-(-3.12+4.21*l-2.67*(l^2))*v)/(0.62+v);
    end

    % Length Component
    Fl = exp(-(abs((l^1.93-1)/1.03)^1.87));

    % Normalized force/paramter
    Nf = 2.11 + 4.16*((1/l)-1);
    A = 1 - exp(-((a/(0.56*Nf))^Nf));
    
    % Normalized Tension
    T = A*(Fl*Fv+Fp2);    
end

