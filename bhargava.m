function [ total, bhar ] = bhargava( muscles , act1 , u1, vars )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% muscle_nums = {'one','two','thr','fou','fiv','six'};

for ii = 1:length(act1)
    F_iso = muscles.pcsa*Fl_Fv_for(muscles.length(ii)/muscles.l0,0,act1(ii));
    F = muscles.force(ii);
    
    u = u1(ii);
    a = act1(ii);
    
    l_norm = muscles.norm_length(ii);
    m_vel = muscles.v(ii);
    
    %Activation and Maintenance Heat Rate
    t_stim = sum(u1(1:ii)>.1)*vars.time_inc;    
    phi = 0.06+exp(-t_stim*u/.045);
    
    u_fast = 1-cos((pi/2)*u);
    u_slow = sin((pi/2)*u);
    
    A_fast = 133; %W/kg
    A_slow = 40; %W/kg
    
    a_dot(ii) = phi*muscles.m*muscles.ft*A_fast*u_fast+...
        phi*muscles.m*(1-muscles.ft)*A_slow*u_slow;
    
    M_fast = 111; %W/kg
    M_slow = 74; %W/kg
    
    m_dot(ii) = p_wise(l_norm)*muscles.m*muscles.ft*M_fast*u_fast+...
        p_wise(l_norm)*muscles.m*(1-muscles.ft)*M_slow*u_slow;
    
    if m_vel>=0
        alpha = 0.16*F_iso+0.18*F;
    else m_vel<0;
        alpha = 0.157*F;
    end
    
    %Here positive should be lengthening
    s_dot(ii) = -alpha*m_vel;
    
    w_dot(ii) = F*m_vel;

end
bhar.a_dot = abs(a_dot) * vars.time_inc;
bhar.m_dot = abs(m_dot) * vars.time_inc;
bhar.s_dot = abs(s_dot) * vars.time_inc;
bhar.w_dot = abs(w_dot) * vars.time_inc;

total = (bhar.a_dot + bhar.m_dot + bhar.s_dot + bhar.w_dot);
bhar.total = total;
end

function L = p_wise(l_norm)

    if l_norm<.5;
        L = 0.5;
    end
    
    if l_norm>1.5;
        L = 0;
    end
    
    if l_norm<1 & l_norm>.5;
        L = l_norm;
    end
    
    if l_norm>1 & l_norm<1.5;
        L = -2*l_norm+3;
    end   

end