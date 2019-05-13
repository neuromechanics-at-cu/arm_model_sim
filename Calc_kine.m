%% Calc_kine.m
% Created by: Gary Bruening
% Edited:     5-13-2019
% 
% The main inverse dynamics script.
% Calculates joint torques for shoulder and elbow. Does some smoothing of
% the data in the middle if your using resampled data from an experiment.

function [ shoulder , elbow , theta , eff_mass] = ...
    Calc_kine( Data , forearm , upperarm, time_inc , add_mass)

order = 5;
window = 21;

% Init Variables
shoulder.torque=zeros(max(size(Data.x,1)),size(Data.x,2));
elbow.torque=zeros(max(size(Data.x,1)),size(Data.x,2));
theta.E=zeros(max(size(Data.x,1)),size(Data.x,2));
theta.S=zeros(max(size(Data.x,1)),size(Data.x,2));
theta.Sd=zeros(max(size(Data.x,1)),size(Data.x,2));
theta.Ed=zeros(max(size(Data.x,1)),size(Data.x,2));
theta.Sdd=zeros(max(size(Data.x,1)),size(Data.x,2));
theta.Edd=zeros(max(size(Data.x,1)),size(Data.x,2));
    
%% Get joint angles
index = ~isnan(Data.x(:));

x=Data.x(~isnan(Data.x(index)));
y=Data.y(~isnan(Data.y(index)));

a = x.^2 + y.^2 - upperarm.length.^2 - forearm.length.^2;
b = 2 * upperarm.length * forearm.length;

theta.E(index) = acos(a./b);

k1 = upperarm.length + forearm.length*cos(theta.E(index));
k2 = forearm.length*sin(theta.E(index));
theta.S(index) = atan2(y,x)-asin(forearm.length.*sin(theta.E(index))./(sqrt(x.^2+y.^2)));

% Smooth and determine angular velocities.
s1 = diff23f5(theta.S,time_inc,3);
e1 = diff23f5(theta.E,time_inc,3);
theta.Sd = s1(:,2);
theta.Ed = e1(:,2);
theta.Sd(2) = (theta.Sd(1)+theta.Sd(3))/2;
theta.Ed(2) = (theta.Ed(1)+theta.Ed(3))/2;

% UNCOMMMENT this section if you want to do some smoothing at the beginning
% of movements when using resampled data.
% esp = 16;
% theta.Sd = [interp1([1 2 esp-2:esp'], [0 0 theta.Sd(esp-2:esp)'], [1:esp], 'spline')';...
%     theta.Sd(esp+1:end)];
% theta.Ed = [interp1([1 2 esp-2:esp'], [0 0 theta.Ed(esp-2:esp)'], [1:esp], 'spline')';...
%     theta.Ed(esp+1:end)];
% theta.Sdd = [s1(:,3)];
% theta.Edd = [e1(:,3)];
% theta.Sdd(2) = (theta.Sdd(1)+theta.Sdd(3))/2;
% theta.Edd(2) = (theta.Edd(1)+theta.Edd(3))/2;
% theta.Sdd = [interp1([1 2 esp-2:esp'], [0 0 theta.Sdd(esp-2:esp)'], [1:esp], 'spline')';...
%     theta.Sdd(esp+1:end)];
% theta.Edd = [interp1([1 2 esp-2:esp'], [0 0 theta.Edd(esp-2:esp)'], [1:esp], 'spline')';...
%     theta.Edd(esp+1:end)];


% Inverse dynamics calculations
a1 = (upperarm.mass * (upperarm.centl)^2 + upperarm.Ic);
a2 = (forearm.mass * (forearm.centl)^2 + forearm.Ic);
a3 = (forearm.mass * upperarm.length * abs(forearm.centl));
a4 = (forearm.mass * upperarm.length^2);

% Alaa's q1 is the shoulder angle
% This is basically line for line Alaa Ahmed's method for computing inverse
% dyanmics.
prm.m1 = upperarm.mass;
prm.r1 = upperarm.centl;
prm.l1 = upperarm.length;
prm.i1 = upperarm.Ic;

prm.m2 = forearm.mass;
prm.r2 = forearm.l_com;
prm.r22 = forearm.centl;
prm.l2 = forearm.length;
prm.i2 = forearm.Ic;

prm.m = add_mass;

M11 = prm.m1*prm.r1^2 + prm.i1 +...
    (prm.m+prm.m2)*(prm.l1^2+prm.r22^2+...
    2*prm.l1*prm.r22*cos(theta.E(:))) +...
    prm.i2;

M12 = (prm.m2+prm.m)*(prm.r22^2+...
    prm.l1*prm.r22*cos(theta.E(:))) +...
    prm.i2;

M21 = M12;

M22 = prm.m2*prm.r2^2+prm.m*prm.l2^2+prm.i2;

C1 = -forearm.mass*forearm.centl*upperarm.length*(theta.Ed(:).^2).*sin(theta.E(:))-...
    2*forearm.mass*forearm.centl*upperarm.length*theta.Sd(:).*theta.Ed(:).*sin(theta.E(:));

C2 = forearm.mass*forearm.centl*upperarm.length*(theta.Sd(:).^2).*sin(theta.E(:));

T1 = M11.*theta.Sdd(:)+M12.*theta.Edd(:)+C1;
T2 = M21.*theta.Sdd(:)+M22.*theta.Edd(:)+C2;

shoulder.torque_a(:) = T1;
elbow.torque_a(:) = T2;

shoulder.torque(:) = shoulder.torque_a(:);
elbow.torque(:) = elbow.torque_a(:);

% Effective mass calculation.
for ii = 1:length(M11)
    J11 = -upperarm.length.*sin(theta.S(ii))-forearm.length*sin(theta.S(ii)+theta.E(ii));
    J12 = -forearm.length*sin(theta.S(ii)+theta.E(ii));
    J21 = upperarm.length.*cos(theta.S(ii))+forearm.length*cos(theta.S(ii)+theta.E(ii));
    J22 = forearm.length*cos(theta.S(ii)+theta.E(ii));

    J = [J11 J12 ; J21 J22];
    arm.J = J;
    arm.I=[M11(ii) M12(ii); M21(ii) M22];
    arm.M=transpose(inv(arm.J))*arm.I*inv(arm.J);
    move_angle = atan2(Data.targetposition(1)-Data.startposition(1),...
        Data.targetposition(2)-Data.startposition(2));
    eff_mass(ii) = norm(arm.M*[cos(move_angle) sin(move_angle)]')+1;
end
    
end

