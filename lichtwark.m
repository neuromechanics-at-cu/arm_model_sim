function [ total, lich ] = lichtwark( muscles , act1 , u1, vars )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% muscle_nums = {'one','two','thr','fou','fiv','six'};

for ii = 1:length(act1)
    F_iso = muscles.pcsa*Fl_Fv_for(muscles.length(ii)/muscles.l0,0,act1(ii));
    F = muscles.force(ii);
    
    P_iso = muscles.pcsa*Fl_Fv_for(muscles.length(ii)/muscles.l0,0,1);
    P = muscles.force(ii);
    
    act = P/P_iso;
    act = act1(ii);
    
    u = u1(ii);
    a = act1(ii);
    
    l_norm = muscles.norm_length(ii);
    m_vel = muscles.v(ii);
    
    a_rel = 0.1+0.4*(muscles.ft);
    b_rel = a_rel*12;
    G = 12/b_rel;
%     G = F_iso/a;

    m_dot(ii) = act*(12/G^2);

    % Shortening is positive
    if m_vel>0
    	s_dot(ii) = a*m_vel/G;
    end
    
    if m_vel<=0 %lengthening
        % Lengthening
    	if ii == 1
            if act == 0
                s_dot(ii) = 0.3*m_dot(ii)+0.7*(m_dot(ii)*exp(-8*((F/1e-7)-1)));
            else
                s_dot(ii) = 0.3*m_dot(ii)+0.7*(m_dot(ii)*exp(-8*((F/act)-1)));
            end
        else
            if act == 0
                s_dot(ii) = 0.3*m_dot(ii)+...
                    0.7*(m_dot(ii)*exp(-8*((F_iso/.000001)-1)))+...
                    P*m_vel;
            else
                s_dot(ii) = 0.3*(m_dot(ii)+...
                    0.7*m_dot(ii)*exp(-8*((F_iso/act)-1)))+...
                    P*m_vel;
            end
        end
    else
        % Shortening
        s_dot(ii) = act*m_vel/G;
    end

	if ii == 1
		t_dot(ii) = -0.014*(P);
	else
		t_dot(ii) = -0.014*(P-muscles.force(ii-1))/vars.time_inc;
	end

end

for ii = 1:length(m_dot)
    if ii>1
        temp = find(u1(1:ii)==0,1,'last');
        if isempty(temp)
            t(ii) = 1;
        else
            t(ii) = temp;
        end
    else
        t(ii) = 1;
    end
	if isempty(t)
		t(ii) = 1;
	end
	t_stim(ii) = (ii-t(ii))*vars.time_inc;
	l_dot(ii) = 0.8*m_dot(ii)*exp(-0.72*t_stim(ii))+...
				0.175*m_dot(ii)*exp(-0.022*t_stim(ii));
end

lich.m_dot = m_dot* vars.time_inc;
lich.l_dot = l_dot* vars.time_inc;
lich.s_dot = s_dot* vars.time_inc;
lich.t_dot = t_dot* vars.time_inc;

total = (lich.m_dot + lich.l_dot + lich.s_dot + lich.t_dot);
lich.total = total;

% lich_vars = {'m_dot','l_dot','s_dot','t_dot'}
% figure(35);clf(35);
% for k = 1:4
%     subplot(3,2,k);
%     plot(lich.(lich_vars{k}));
%     xlabel(lich_vars{k});
% end
% subplot(3,2,[5,6]);
% plot(lich.total);

end