function r_dist = torus_dist(x,x_s,env_upper)

%x_s is (1x2) source location.
%N is linear dimension of space
%istorus is an indicator denoting whether space should be treated as
%Euclidean or periodic

%     temp_x = min([abs(x_s(1)-x(1)) abs(x_s(1)+env_upper-x(1)) abs(x(1)+env_upper-x_s(1))]);
%     temp_y = min([abs(x_s(2)-x(2)) abs(x_s(2)+env_upper-x(2)) abs(x(2)+env_upper-x_s(2))]);
%     r_dist = norm([temp_x temp_y]);
    
    temp_x = min([abs(x_s(1)-x(:,1)) abs(x_s(1)+env_upper-x(:,1)) abs(x(:,1)+env_upper-x_s(1))],[],2);
    temp_y = min([abs(x_s(2)-x(:,2)) abs(x_s(2)+env_upper-x(:,2)) abs(x(:,2)+env_upper-x_s(2))],[],2);
    r_dist = sqrt(temp_x.^2 + temp_y.^2);
end
