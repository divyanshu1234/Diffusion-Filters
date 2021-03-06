function u = ced(u, timeStep, nIter, verbose, sigma, rho, alpha, c, m)
% Edge Enhanhancing Diffusion 
% u           - Image
% timeStep    - delta t
% nIter       - Number of Iterations
% verbose     - Figure number
% sigma       - For Gaussian Kernel kSigma
% rho         - To get Gaussian Kernel kRho
% alpha, c, m - To calculate lambdas

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
    
limitXRho = -ceil(2*rho):ceil(2*rho);
kRho = exp(-(limitXRho.^2 / (2*rho^2)));
kRho = kRho / sum(kRho(:));

for iter = 1:nIter
    
    [guxList, guyList] = gradient(u);
    
%   Sigma of Gradient
    guSigmaX = imfilter(guxList, kSigma, 'same', 'replicate');
    guSigmaY = imfilter(guyList, kSigma, 'same', 'replicate');

    JRhoXX = imfilter(guSigmaX.^2, kRho, 'same', 'replicate');
    JRhoYY = imfilter(guSigmaY.^2, kRho, 'same', 'replicate');
    JRhoXY = imfilter(guSigmaX.*guSigmaY, kRho, 'same', 'replicate');    

    J = zeros(nRows, nCols, 2);

    for j = 1:nRows
        for k = 1:nCols                        
            JRho = [JRhoXX(j,k), JRhoXY(j,k); JRhoXY(j,k), JRhoYY(j,k)];
            [v, mew] = eig(JRho);
            lamb2 = alpha;
            lamb1 = alpha + (1-alpha) * exp(-c / (mew(1,1)-mew(2,2))^(2*m));
            
            D = v * diag([lamb1, lamb2]) * v';
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
        title('Coherence Enhancing Diffusion');
        drawnow;
    end
    disp(iter)        
end