addpath('cs70lib/')

display_image(M1)
display_image(M2)

%part a
for R=1 : length(M1)
    for C=1 : length(M1)
        %generate S1
        S1a(R,C) = (M2(R,C)-(M1(R,C)*0.8))/0.2;
        
        %generate S2
        S2a(R,C) = (M2(R,C)-(M1(R,C)*1.6))/-0.6;
         
    end
end 

display_image(S1a)
display_image(S2a)



%part b
M1v = M1(:);
M2v = M2(:);

M1M2 = [M1v,M2v]';
matrixM = [0.25,0.75;0.4,0.6];

%solution vector
solutionS1S2 = inv(matrixM)* M1M2;

%seperate solution into vectors S1v and S2v
S1v = solutionS1S2(1,:);
S2v = solutionS1S2(2,:);


S1b = reshape(S1v, [125 125]);
S2b = reshape(S2v, [125 125]);

display_image(S1b)
display_image(S2b)







