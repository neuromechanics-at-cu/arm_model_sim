function[out]=minjerk(ro,rf,tm,dt)
% MINJERK Usage: minjerk(ro,rf,tm,dt) ro,rf are (x,y)
% initial and final positions
% tm is the movement time dt is time increment.
% Returns (x,y) positions through trajectory in r,
% velocities in v, acceleration in a 
% and time in tme


tme=[0:dt:tm];
ts=tme/tm;
xo=ro(1,1);
yo=ro(1,2);
xf=rf(1,1);
yf=rf(1,2);

t2=ts.*ts;
t3=t2.*ts;
t4=t3.*ts;
t5=t4.*ts;


r=ones(size(ts'))*ro+(15*t4-6*t5-10*t3)'*(ro-rf);
v=((60*t3-30*t4-30*t2)/tm)'*(ro-rf);
a=((180*t2-120*t3-60*ts)/(tm*tm))'*(ro-rf);
tme=tme';
tme=[0:dt:tm+.0075];

out.time = tme;

out.x=[r(1,1);r(1,1);r(1,1);r(:,1)];
out.y=[r(1,2);r(1,2);r(1,2);r(:,2)];

out.vx=[v(1,1);v(1,1);v(1,1);v(:,1)];
out.vy=[v(1,2);v(1,2);v(1,2);v(:,2)];

out.ax=[a(1,1);a(1,1);a(1,1);a(:,1)];
out.ay=[a(1,2);a(1,2);a(1,2);a(:,2)];






