function output = grad_calc_nondim(C,l,x,y)
%2D Gradient calculation of nondimensionalized function: C*exp(-|x - y|) + exp(-l|x - y|)

% SBR: rewrite this to output vector, to remove loop in parent function

x1 = x(1);
x2 = x(2);
y1 = y(:,1);
y2 = y(:,2);

D = ((x1 - y1).^2 + (x2 - y2).^2).^0.5;
A = ((x1 - y1).^2 + (x2 - y2).^2).^-0.5;
B = 2 .* (x1 - y1);
E = 2 .* (x2 - y2);

Term1x1 = -C*(exp(-D).*(0.5.*(B.*A)));
Term2x1 = -(exp(-l.*D).*(l.*(0.5.*(B.*A))));

Term1x2 = -C.*(exp(-D).*(0.5.*(E.*A)));
Term2x2 = -(exp(-l.*D).*(l.*(0.5.*(E.*A))));

x1_component = Term1x1 - Term2x1;
x2_component = Term1x2 - Term2x2;
output = [x1_component, x2_component];        


