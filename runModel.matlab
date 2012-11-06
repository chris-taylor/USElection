function results = runModel(data)

    nSimulation  = 1e5; % Number of times to simulate each state
    nRespondents = 150; % Number of poll respondents (assumed)
    
    results.state = data.state;
    
    for ii = 1:length(data.state)
        
        fprintf('Simulating: %s\n',data.state{ii})
        
        effRespondents = nRespondents * data.npolls(ii);
        
        % Get poll averages for DEM and the standard error (assume that polls
        % are binomial).
        pdem  = data.p(ii,1);
        sigma = sqrt( pdem.*(1-pdem) / effRespondents );
            
        % Simulate what the real proportion of DEM voters *might* have been,
        % consistent with the poll numbers.
        ps = pdem + sigma * randn(1,nSimulation);
        
        % Record winner/loser in each simulation.
        results.dem(ii,:)   = ps > 0.5;
        results.gop(ii,:)   = ps < 0.5;
        
        % Record electoral college votes in each simulation.
        results.evdem(ii,:) = data.ev(ii) * results.dem(ii,:);
        results.evgop(ii,:) = data.ev(ii) * results.gop(ii,:);
        
    end
    
    % Get the probability of a DEM/GOP win in each state.
    results.pStateDem = mean(results.dem,2);
    results.pStateGop = mean(results.gop,2);
    
    % Total DEM/GOP electoral college votes in each simulation.
    results.demVotes = sum(results.evdem);
    results.gopVotes = sum(results.evgop);
    
    % Final probability of a DEM win/GOP win/tie.
    results.pDemWin = mean(results.demVotes >  results.gopVotes);
    results.pGopWin = mean(results.demVotes <  results.gopVotes);
    results.pTied   = mean(results.demVotes == results.gopVotes);

end