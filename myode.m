function dadt=myode1(t,a,fgt,f1,g1,f2,g2,u)

% if f1(1)~=f1(2) || g1(1)~=g1(2) || u(1)~=u(2) 
%     fprintf('Not equal things');
% end

u=interp1(fgt,u,t);

f1=interp1(fgt,f1,t);
g1=interp1(fgt,g1,t);

% u=u(2);
% 
% f1=f1(1);
% g1=g1(1);

% 
% % f2=interp1(fgt,f2,t);
% % g2=interp1(fgt,g2,t);
% 
if length(f1)>1 || length(g1)>1 || length(u)>1
    1;
end

if u>a
    dadt=-f1.*a+g1.*u;
else
    dadt=-f2.*a+g2.*u;
end
