function[Data]=Gen_mvt_gb(Resamp,c,subj,s,t, ro, rf, time_inc)

re_size = length(squeeze(Resamp.P(c,subj,s,t,:)));

x = reshape(((Resamp.P(c,subj,s,t,:)-Resamp.P(c,subj,s,t,1))/max(Resamp.P(c,subj,s,t,:)))*(rf(1)-ro(1)),re_size,1)+ro(1);
y = reshape(((Resamp.P(c,subj,s,t,:)-Resamp.P(c,subj,s,t,1))/max(Resamp.P(c,subj,s,t,:)))*(rf(2)-ro(2)),re_size,1)+ro(2);

buff = 0.01;

x1 = spline([0,.0025,reshape(buff+Resamp.T(c,subj,s,t,4:end),1,length(Resamp.T(c,subj,s,t,4:end)))],...
    [ro(1);ro(1);x(4:end)],[0:time_inc:Resamp.T(c,subj,s,t,end)])';
y1 = spline([0,.0025,reshape(buff+Resamp.T(c,subj,s,t,4:end),1,length(Resamp.T(c,subj,s,t,4:end)))],...
    [ro(2);ro(2);y(4:end)],[0:time_inc:Resamp.T(c,subj,s,t,end)])';
x1(1) = ro(1);
y1(1) = ro(2);

x2 = diff23f5(x1,.0025,10);
x2(1,2) = 0;
x2(1,3) = 0;
y2 = diff23f5(y1,.0025,10);
y2(1,2) = 0;
y2(1,3) = 0;


% x = [x(1);x(1);x(1);x];
% y = [y(1);y(1);y(1);y];

vx = x2(:,2)*.0025;
vy = y2(:,2)*.0025;
ax = x2(:,3)*.0025*.0025;
ay = y2(:,3)*.0025*.0025;

x = reshape(x2(:,1),length(x2(:,1)),1);
y = reshape(y2(:,1),length(y2(:,1)),1);
time = time_inc*[0:length(x)-1];
time = reshape(time,length(time),1);

Data.time=time;
Data.x = x;
Data.y = y;
Data.vx = vx;
Data.vy = vy;
Data.ax = ax;
Data.ay = ay;