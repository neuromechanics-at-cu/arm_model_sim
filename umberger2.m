%% umberger2.m
% Created by: Gary Bruening
% Edited:     5-13-2019
% 
% Function to calculate energy ependiture using the Umberger Energy model.
% Is implemented after all the other math, a similar method can be done to
% implement any other energy model as well.
% 
%%
function [ total, energy ] = umberger2( muscles , act1 , u1 )

for ii = 1:length(act1)
    F_iso = muscles.pcsa*Fl_Fv_for(muscles.length(ii)/muscles.l0,0,act1(ii));
    
    u = u1(ii);
    a = act1(ii);
    %Activation and Maintenance Heat Rate
    if u1(ii)>act1(ii)
        A = u;
    else
        A = (u+a)/2;
    end
    
    if muscles.length(ii) <= muscles.l0
        h_AM(ii) = (128*muscles.ft+25)*(A^0.6)*1.5;
    else
        h_AM(ii) = 0.4*(128*muscles.ft+25)+0.6*F_iso*(128*muscles.ft+25);
    end

    AMdot(ii) = h_AM(ii);
    
    % Shortening and lengthening heat rate.
    v_CE_norm = muscles.v(ii)/muscles.l0;
    v_CE_max = 12;
    alphaS_fast = 153/v_CE_max;
    alphaS_slow = 100/(v_CE_max/2.5);
    alphaL = 0.3*alphaS_slow;
    if muscles.length(ii) <= muscles.l0 & v_CE_norm >=0
        Sdot(ii) = muscles.m*(((alphaS_slow*v_CE_norm*(1-muscles.ft))+...
            (alphaS_fast*v_CE_norm*muscles.ft))*(A^2)*1.5);
    elseif muscles.length(ii) > muscles.l0 & v_CE_norm >=0
        Sdot(ii) = muscles.m*(((alphaS_slow*v_CE_norm*(1-muscles.ft))+...
            (alphaS_fast*v_CE_norm*muscles.ft))*(A^2)*1.5*F_iso);
    elseif muscles.length(ii) <= muscles.l0 & v_CE_norm < 0 
        Sdot(ii) = muscles.m*(alphaL*v_CE_norm*A*1.5);
    elseif muscles.length(ii) > muscles.l0 & v_CE_norm < 0
        Sdot(ii) = muscles.m*(alphaL*v_CE_norm*A*1.5*F_iso);
    end
    
    % Work done by muscles because moving the mass.
    if v_CE_norm>=0
        Wdot(ii) = (muscles.force(ii)*muscles.v(ii));
    else
        Wdot(ii) = 0;
    end
    
end
energy.h_SL = abs(Sdot) * 0.0025;
energy.h_AM = abs(AMdot) * 0.0025*muscles.m;
energy.w = abs(Wdot) * 0.0025;

total = (energy.h_SL + energy.h_AM + energy.w);
end

