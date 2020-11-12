function[Data]=Gen_mvt_gb(Resamp, ro, rf, time_inc)

if isfield(Resamp,'X')
    re_size = length(squeeze(Resamp.X(:)));
    x = reshape(Resamp.X(:)-Resamp.X(1),re_size,1)+ro(1);
    y = reshape(Resamp.Y(:)-Resamp.Y(1),re_size,1)+ro(2);
elseif isfield(Resamp,'P')
    re_size = length(squeeze(Resamp.P(:)));
    x = reshape(((Resamp.P(:)-Resamp.P(1))/max(Resamp.P(:)))*(rf(1)-ro(1)),re_size,1)+ro(1);
    y = reshape(((Resamp.P(:)-Resamp.P(1))/max(Resamp.P(:)))*(rf(2)-ro(2)),re_size,1)+ro(2);
else
    error('No X or P field in resamp data.')
end
buff = 0.01;

x1 = spline([0,.0025,reshape(buff+Resamp.T(4:end),1,length(Resamp.T(4:end)))],...
    [ro(1);ro(1);x(4:end)],[0:time_inc:Resamp.T(end)])';
y1 = spline([0,.0025,reshape(buff+Resamp.T(4:end),1,length(Resamp.T(4:end)))],...
    [ro(2);ro(2);y(4:end)],[0:time_inc:Resamp.T(end)])';
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