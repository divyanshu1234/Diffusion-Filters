function u = eed(u, timeStep, nIter, verbose, sigma)
% Perona and Malik diffusion 

if verbose
    figure(verbose);
    subplot(1, 2, 1);
    imshow(u);
    title('Original Image');
    drawnow;
end

[nRows, nCols] = size(u);
    
for iter = 1:nIter
    
    [guxList, guyList] = gradient(u);
    u = imgaussfilt(u, sigma);

    [a, b] = gradient(u);

%     gusList = imgaussfilt(guxList, sigma) + imgaussfilt(guyList, sigma)*1i;
    gusList = a + b*1i;
    gusPerpList = gusList * 1i;
    
    J = zeros(nRows, nCols, 2);

    for j = 1:nRows
        for k = 1:nCols
            gu = [guxList(j,k); guyList(j,k)];
            
            gus = [real(gusList(j,k)); imag(gusList(j,k))];
            gusPerp = [real(gusPerpList(j,k)); imag(gusPerpList(j,k))];
            
            v1 = gus / norm(gus);
            v2 = gusPerp / norm(gus);
            
            lamb1 = C(norm(gus)^2);
            lamb2 = 1;
            
            D = [v1, v2] * diag([lamb1, lamb2]) * [v1'; v2'];
            temp = D * gu;
            J(j,k,1) = temp(1);
            J(j,k,2) = temp(2);
        end
    end
    
    divJ = zeros(nRows, nCols);
    
    for j = 1:(nRows-1)
        for k = 1:(nCols-1)
            divJ(j,k) = (J(j,k)-J(j,k+1)) + (J(j,k)-J(j+1,k));
        end
    end
    u = u + timeStep * divJ;
    
    if verbose
        figure(verbose);
        subplot(1,2,2);
        imshow(u);
        title('Edge Enhanced Diffusion');
        drawnow;
    end
    disp(iter)        
end