function dydt = yeastGlycolysisEq(t, y, params)
    % Implements the yeast glycolysis oscillator model from:
    % Daniels & Nemenman (2015) "Efficient Inference of Parsimonious Phenomenological 
    % Models of Cellular Dynamics Using S-Systems and Alternating Regression"
    % PLOS ONE 10(3): e0119821. https://doi.org/10.1371/journal.pone.0119821
    %
    % Arguments:
    %   t: Time point
    %   y: Vector of 7 species concentrations
    %   params: Vector of 14 parameters [J0,k1,k2,k3,k4,k5,k6,k,kappa,q,K1,psi,N,A]
    %
    % Returns:
    %   dydt: Vector of derivatives for the 7 species
    
    % Extract parameters
    J0 = params(1);
    k1 = params(2);
    k2 = params(3);
    k3 = params(4);
    k4 = params(5);
    k5 = params(6);
    k6 = params(7);
    k = params(8);
    kappa = params(9);
    q = params(10);
    K1 = params(11);
    psi = params(12);
    N = params(13);
    A = params(14);

    % Equations
    dydt = zeros(7, 1);
    dydt(1) = J0 - k1*y(1)*y(6) / (1 + (y(6)/K1)^q);
    dydt(2) = 2 * k1*y(1)*y(6) / (1 + (y(6)/K1)^q) - k2*y(2)*(N - y(5)) - k6*y(2)*y(6);
    dydt(3) = k2*y(2)*(N - y(5)) - k3*y(3)*(A - y(6));
    dydt(4) = k3*y(3)*(A - y(6)) - k4*y(4)*y(5) - kappa*(y(4) - y(7));
    dydt(5) = k2*y(2)*(N - y(5)) - k4*y(4)*y(5) - k6*y(2)*y(5);
    dydt(6) = -2 * k1*y(1)*y(6) / (1 + (y(6)/K1)^q) + 2*k3*y(3)*(A - y(6)) - k5*y(6);
    dydt(7) = psi*kappa*(y(4) - y(7)) - k*y(7);
end