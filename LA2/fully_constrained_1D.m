function[] = fully_constrained_1D

%initialize the gradients
s = [3;4;3;5;4;3];
t = [6;0;0;0;0;1];

%initialize A and b for matrix-vector form
b = zeros(4,1);
A = zeros(4,4);

%populate A with constraints
A(1,1) = 1;
A(2,1) = -1;
A(2,2) = 1;
A(3,2) = -1;
A(3,3) = 1; 
A(4,3) = -1;
A(4,4) = 1;

%populate b with constraints
b(1) = s(2)-s(1)+t(1);
b(2) = s(3)-s(2);
b(3) = s(4)-s(3);
b(4) = s(5)-s(4);

%solve for vector v
v = inv(A)*b;

%put the correct gradient values in for t
t(2) = v(1);
t(3) = v(2);
t(4) = v(3);
t(5) = v(4);

%visualize
bar(t);


end
