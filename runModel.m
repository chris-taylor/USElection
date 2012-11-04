function results = runModel(data)

    nSimulation = 1000;     % Number of times to simulate each state
    nPoll = 1000;           % Number of poll respondents (assumed)
    turnout = 0.5;          % Turnout (assumed)
    
    results.state = data.state;
    
    for ii = 1:length(data.state)
        
        fprintf('Simulating: %s\n',data.state{ii})
        
        % Get poll averages and the covariance matrix (assume that polls
        % are binomial). NB the covariance matrix is singular, but that's
        % ok.
        p = data.p(ii,:);
        sigma = -p' * p;
        sigma = (sigma - diag(diag(sigma)) + diag(p.*(1-p))) / nPoll;
            
        % Simulate what the proportion of voters *might* have been,
        % consistent with the poll numbers.
        ps = mvnrnd(p,sigma,nSimulation);
        
        % How many voters in this state (divide by 1000 or it's way slow..)
        nVoters = round(turnout * data.pop(ii) / 100);
        
        % Simulate the election.
        votes = mnrnd(nVoters,ps);
        
        % Record winner/loser/tie in each simulation
        results.dem(ii,:)   = (votes(:,1) > votes(:,2))';
        results.gop(ii,:)   = (votes(:,2) > votes(:,1))';
        results.tie(ii,:)   = (votes(:,1) == votes(:,2))';
        
        % Record electoral college votes in each simulation
        results.evdem(ii,:) = data.ev(ii) * results.dem(ii,:);
        results.evgop(ii,:) = data.ev(ii) * results.gop(ii,:);
        
    end
    
    results.pStateDem = mean(results.dem,2);
    results.pStateGop = mean(results.gop,2);
    results.pStateTie = mean(results.tie,2);
    
    results.pDemWin = mean(sum(results.evdem) > sum(results.evgop));
    results.pGopWin = mean(sum(results.evgop) > sum(results.evdem));
    results.pTied   = mean(sum(results.evgop) == sum(results.evdem));

end