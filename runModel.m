function results = runModel(data)

    nSimulation = 1e5;  % Number of times to simulate each state
    nRespondents = 150; % Number of poll respondents (assumed)
    
    results.state = data.state;
    
    for ii = 1:length(data.state)
        
        fprintf('Simulating: %s\n',data.state{ii})
        
        effRespondents = nRespondents * data.npolls(ii);
        
        % Get poll averages and the covariance matrix (assume that polls
        % are binomial). NB the covariance matrix is singular, but that's
        % ok.
        p = data.p(ii,:);
        sigma = -p' * p;
        sigma = (sigma - diag(diag(sigma)) + diag(p.*(1-p))) / effRespondents;
            
        % Simulate what the proportion of voters *might* have been,
        % consistent with the poll numbers.
        ps = mvnrnd(p,sigma,nSimulation);
        
        % Record winner/loser/tie in each simulation
        results.dem(ii,:)   = (ps(:,1) > ps(:,2))';
        results.gop(ii,:)   = (ps(:,2) > ps(:,1))';
        
        % Record electoral college votes in each simulation
        results.evdem(ii,:) = data.ev(ii) * results.dem(ii,:);
        results.evgop(ii,:) = data.ev(ii) * results.gop(ii,:);
        
    end
    
    results.pStateDem = mean(results.dem,2);
    results.pStateGop = mean(results.gop,2);
    
    results.pDemWin = mean(sum(results.evdem) > sum(results.evgop));
    results.pGopWin = mean(sum(results.evgop) > sum(results.evdem));
    results.pTied   = mean(sum(results.evgop) == sum(results.evdem));

end