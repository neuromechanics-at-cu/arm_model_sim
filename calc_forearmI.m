function [ forearm ] = calc_forearmI( forearm , mass )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    
    Il_new = (forearm.l_com*forearm.mass + forearm.length*mass)/...
        (forearm.mass+mass);
    if mass==0
        forearm.Ic = .01882;
        forearm.centl = forearm.l_com;
%         .01882
    else
        I = .01882 + forearm.mass*(forearm.l_com-Il_new).^2 + ...
            mass*(forearm.length-Il_new).^2;
%         forearm.mass*(forearm.l_com-Il_new).^2
%         mass*(forearm.length-Il_new).^2
        forearm.Ic = I;
        forearm.centl = Il_new;
%         I
    end
    
    
end

