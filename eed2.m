function u = eed2(u, timeStep, nIter, verbose, sigma)
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
    
%     uSigma = imgaussfilt(u, sigma, 'FilterDomain', 'spatial');
%     [a, b] = gradient(uSigma);
%     guSigmaList = a + b*1i;

    [guxList, guyList] = gradient(u);
    guSigmaList = imgaussfilt(guxList, sigma, 'FilterDomain', 'spatial')...
        + imgaussfilt(guyList, sigma, 'FilterDomain', 'spatial')*1i;

    guSigmaPerpList = guSigmaList * 1i;
    
    J = zeros(nRows, nCols, 2);

    for j = 1:nRows
        for k = 1:nCols            
            guSigma = [real(guSigmaList(j,k)); imag(guSigmaList(j,k))];
            guSigmaPerp = [real(guSigmaPerpList(j,k)); imag(guSigmaPerpList(j,k))];
            
            v1 = guSigma / norm(guSigma);
            v2 = guSigmaPerp / norm(guSigma);
            
            s = norm(guSigma)^2;
            lamb1 = 1 - exp(-3.3148 ./ (s/0.01).^4);
            lamb2 = 1;
            
            D = [v1, v2] * diag([lamb1, lamb2]) * [v1'; v2'];
            gu = [guxList(j,k); guyList(j,k)];

            tempJ = D * gu;
            J(j,k,1) = tempJ(1);
            J(j,k,2) = tempJ(2);
        end
    end
    
%     divJ = zeros(nRows, nCols);
%     for j = 1:(nRows-1)
%         for k = 1:(nCols-1)
%             divJ(j,k) = (J(j,k)-J(j,k+1)) + (J(j,k)-J(j+1,k));
%         end
%     end

    divJ = divergence(J(:,:,1), J(:,:,2));
    disp(size(divJ));
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