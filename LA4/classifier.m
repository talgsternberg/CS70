function[] = classifier(data1,data2)
    %BUILD A CLASSIFIER
    
   

    %(3) mean calculation and zero mean matricies 
    
    Mu1 = mean(data1,2);
    Mu2 = mean(data2,2);
    Mu = mean(([data1 data2]),2);

    %zero mean matricies
    M1 = (data1-Mu1);
    M2 = (data2-Mu2);


    %(4) scatter matrix calculations
    %within class
    Sw = (M1*M1') + (M2*M2');

    %between class
    size1 = size(data1);
    size2 = size(data2);
    N1 = size1(2);
    N2 = size2(2);
    Sb = (N1* (Mu1-Mu)*(Mu1-Mu)')+ (N2*(Mu2-Mu)*(Mu2-Mu)');

    %(5) generalized eigenvectors
    %Sb*e = lamba*Sw*e
    [V,D] = eigs(Sb,Sw,1);
    e = V;


    %(6) projection into 1d linear subspace
    C1proj = zeros(8000,1);
    C2proj = zeros(8000,1);
    for i = 1:size1(2)
        C1proj(i,:) = dot((data1(:,i))',e);
        C2proj(i,:) = dot((data2(:,i))',e);
    end


    %(7) comparing histograms
    figure(1);
    hold on;
    h = histfit( C1proj ); set( h(1), 'FaceAlpha', 0.5 );
    h = histfit( C2proj ); set( h(1), 'FaceAlpha', 0.5 );
    hold off;

    %(8) Generating ROC curves

    %generare a vector of 500 spaced ins betw min and max proj data
    minT = min([C1proj C2proj]);
    maxT = max([C1proj C2proj]);
    spacedVector = linspace(minT(1,1),maxT(1,1),500);

    %initialize ROC vectors
    ROC1 = zeros(size(spacedVector,2));
    ROC2 = zeros(size(spacedVector,2));

    %loop over threshold vals -- this is wrong i think....
    i = 1;
    for T = spacedVector
        ind = find(C1proj <= T);
        ROC1(i) = 100*length(ind)/8000;
        ind = find( C2proj > T );
        ROC2(i) = 100*length(ind)/8000;
        i = i + 1;
    end 

    %plot the curves
    figure(2); cla;
    hold on;
    plot(spacedVector,ROC1); plot(spacedVector,ROC2);
    title('ROC CURVES');
    xlabel('threshold values');
    ylabel('success rate');
    legend('ROC1: cancer ','ROC2: no cancer')
    hold off;
    
    

    %(9) print threshold with highest success rate and specify success rate
    %iterate through ROC curve vals and keep track of success rate of
    %threshold... (how many classified correctly??)
    threshold = 0;
    highestSuccess = 0;
    j = 1;
    for i = minT(1,1):500:maxT(1,1)
        if ((ROC1(j) + ROC2(j)) > highestSuccess)
            threshold = i;
            highestSuccess = (ROC1(j) + ROC2(j))/2;
            j=j+1;
            
        end 
    end
    
    fprintf('The Threshold Is %d.\n', threshold);
    fprintf('The Success Rate Is %d.\n', highestSuccess);


