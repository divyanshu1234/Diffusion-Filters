function u = eedfinal(u, timeStep, nIter, verbose, sigma, m, km, cm)
% Edge Enhancing Diffusion 
% u         - Image
% timeStep  - delta t
% nIter     - Number of Iterations
% verbose   - Figure number
% sigma     - For Gaussian Kernel kSigma
% m, km, cm - To calculate lamda

if verbose
    figure(verbose);
    subplot(1, 2, 1);
    imshow(u);
    title('Original Image');
    drawnow;
end

[nRows, nCols] = size(u);

for iter = 1:nIter
    
    guSigmaList = gD(u, sigma, 1, 0) + gD(u, sigma, 0, 1) * 1i;
    guSigmaPerpList = guSigmaList * 1i;
    
    Dxx = zeros(nRows, nCols);
    Dxy = zeros(nRows, nCols);
    Dyy = zeros(nRows, nCols);
    
    for j = 1:nRows
        for k = 1:nCols            
            guSigma = [real(guSigmaList(j,k)); imag(guSigmaList(j,k))];
            guSigmaPerp = [real(guSigmaPerpList(j,k)); imag(guSigmaPerpList(j,k))];
            
            v1 = guSigma / norm(guSigma);
            v2 = guSigmaPerp / norm(guSigma);
            
            s = norm(guSigma)^2;
            lamb1 = 1 - exp(-cm ./ (s/km).^m);
            lamb2 = 1;
            
            D = [v1, v2] * diag([lamb1, lamb2]) * [v1'; v2'];

            Dxx(j,k) = D(1,1);
            Dxy(j,k) = D(1,2);
            Dyy(j,k) = D(2,2);
            
        end
    end

    divJ = tnldStep(u, Dxx, Dxy, Dyy, 1);
    u = u + timeStep * divJ;
    
    if verbose
        figure(verbose);
        subplot(1,2,2);
        imshow(u);
        title('Edge Enhancing Diffusion');
        drawnow;
    end
    disp(iter)        
end