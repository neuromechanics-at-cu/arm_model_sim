function [ total, marg ] = margaria( muscles , act1 , u1, vars )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% muscle_nums = {'one','two','thr','fou','fiv','six'};

for ii = 1:length(act1)
    m_vel = muscles.v(ii);
    F = muscles.force(ii);
    
    if m_vel <= 0
        % Lengthening is Negative
        p_dot(ii) = F*m_vel/(-1.2);
    else
        p_dot(ii) = F*m_vel/(0.25);
    end

end
marg.p_dot = abs(p_dot) * 0.0025;

total = marg.p_dot;
marg.total = total;
end