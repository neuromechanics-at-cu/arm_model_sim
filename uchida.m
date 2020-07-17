function [ total, uchida ] = uchida( muscles , act1 , u1, vars )

for ii = 1:length(act1)
    F_iso = muscles.pcsa*Fl_Fv_for(muscles.length(ii)/muscles.l0,0,act1(ii));
    
    u = u1(ii);
    a = act1(ii);
    
    u_fast = 1-cos((pi/2)*u);
    u_slow = sin((pi/2)*u);
    
    fs = 1-(1-muscles.ft);
    if u == 0
        f_rs = 1;
    else
        f_rs = (fs*u_slow)/(fs*u_slow+muscles.ft*u_fast);
    end
    
    %Activation and Maintenance Heat Rate
    if u1(ii)>act1(ii)
        A = u;
    else
        A = (u+a)/2;
    end
    
    if muscles.length(ii) <= muscles.l0
        h_AM(ii) = (128*(1-f_rs)+25)*(A^0.6)*1.5;
    else
        h_AM(ii) = 0.4*(128*(1-f_rs)+25)+0.6*F_iso*(128*(1-f_rs)+25);
    end
    AMdot(ii) = h_AM(ii);
    
    v_CE_norm = muscles.v(ii)/muscles.l0;
    v_CE_max = 12;
    alphaS_fast = 153/v_CE_max;
    alphaS_slow = 100/(v_CE_max/2.5);
    alphaL = 4*alphaS_slow;
    %Shortening
    if muscles.length(ii) <= muscles.l0 & v_CE_norm >=0
        Sdot(ii) = muscles.m*(((alphaS_slow*v_CE_norm*(1-(1-f_rs)))+...
            (alphaS_fast*v_CE_norm*(1-f_rs)))*(A^2)*1.5);
    elseif muscles.length(ii) > muscles.l0 & v_CE_norm >=0
        Sdot(ii) = muscles.m*(((alphaS_slow*v_CE_norm*(1-(1-f_rs)))+...
            (alphaS_fast*v_CE_norm*(1-f_rs)))*(A^2)*1.5*F_iso);
    %Lengthening
    elseif muscles.length(ii) <= muscles.l0 & v_CE_norm < 0 
        Sdot(ii) = muscles.m*(alphaL*v_CE_norm*A*1.5);
        if Sdot(ii)>0;
            Sdot(ii)=0;
        end
    elseif muscles.length(ii) > muscles.l0 & v_CE_norm < 0
        Sdot(ii) = muscles.m*(alphaL*v_CE_norm*A*1.5*F_iso);
        if Sdot(ii)>0;
            Sdot(ii)=0;
        end
    end
    
    if v_CE_norm>=0
        Wdot(ii) = (muscles.force(ii)*muscles.v(ii));
    else
        Wdot(ii) = 0;
    end
end

uchida.h_SL = abs(Sdot) * vars.time_inc;
uchida.h_AM = abs(AMdot) * vars.time_inc * muscles.m;
uchida.w = abs(Wdot) * vars.time_inc;

total = (uchida.h_SL + uchida.h_AM + uchida.w);
uchida.total = total;
end

