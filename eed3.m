function u = eed3(u, timeStep, nIter, verbose, sigma)
% Edge Enhanhancing Diffusion 
% u        - Image
% timeStep - delta t
% nIter    - Number of Iterations
% verbose  - Figure number
% sigma    - Standard Deviation for Gaussian Kernel

if verbose
    figure(verbose);
    subplot(1, 2, 1);
    imshow(u);
    title('Original Image');
    drawnow;
end

[nRows, nCols] = size(u);
limitX = -ceil(2*sigma):ceil(2*sigma);
kSigma = exp(-(limitX.^2 / (2*sigma^2)));
kSigma = kSigma / sum(kSigma(:));
    
for iter = 1:nIter
    
    [guxList, guyList] = gradient(u);

%   Gradient of Sigma
%     uSigma = imfilter(u, kSigma, 'same', 'replicate');
%     [a, b] = gradient(uSigma);
%     guSigmaList = a + b*1i;

%   Sigma of Gradient
    guSigmaList = imfilter(guxList, kSigma, 'same', 'replicate')...
        + imfilter(guyList, kSigma, 'same', 'replicate')*1i;

    guSigmaPerpList = guSigmaList * 1i;
    
    J = zeros(nRows, nCols, 2);

    for j = 1:nRows
        for k = 1:nCols            
            guSigma = [real(guSigmaList(j,k)); imag(guSigmaList(j,k))];
            guSigmaPerp = [real(guSigmaPerpList(j,k)); imag(guSigmaPerpList(j,k))];
            
            v1 = guSigma / norm(guSigma);
            v2 = guSigmaPerp / norm(guSigma);
            
            s = norm(guSigma)^2;
            lamb1 = 1 - exp(-3.3148 ./ (s/0.007).^4);
            lamb2 = 1;
            
            D = [v1, v2] * diag([lamb1, lamb2]) * [v1'; v2'];
            gu = [guxList(j,k); guyList(j,k)];

            tempJ = D * gu;
            J(j,k,1) = tempJ(1);
            J(j,k,2) = tempJ(2);
        end
    end

    divJ = divergence(J(:,:,1), J(:,:,2));
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