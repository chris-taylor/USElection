function results = runModel(data,biasMean,biasStd,nRespondents)

    nSimulation  = 1e5; % Number of times to simulate each state
    
    if nargin < 2
        biasMean = 0.0;
    end
    
    if nargin < 3
        biasStd  = 0.0;
    end
    
    if nargin < 4
        nRespondents = 150; % Number of poll respondents (assumed)
    end
    
    results.state = data.state;
    
    for ii = 1:length(data.state)
        
        fprintf('Simulating: %s\n',data.state{ii})
        
        effRespondents = nRespondents * data.npolls(ii);
        
        % Get poll averages for DEM and the standard error (assume that polls
        % are binomial). Also add on a mean bias term, and a random bias
        % in each case.
        % The probabilities are capped to be in (0,1).
        pdem  = data.p(ii,1) + biasMean + biasStd * randn(1,nSimulation);
        pdem(pdem < 0) = 0;
        pdem(pdem > 1) = 1;
        
        sigma = sqrt( pdem.*(1-pdem) / effRespondents );
            
        % Simulate what the real proportion of DEM voters *might* have been,
        % consistent with the poll numbers.
        ps = pdem + sigma .* randn(1,nSimulation);
        
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
    
    % Forecasts and confidence
    for ii = 1:length(results.state)
        if results.pStateDem(ii) > 0.5
            results.prediction{ii} = 'DEM';
            results.confidence(ii) = results.pStateDem(ii);
        else
            results.prediction{ii} = 'REP';
            results.confidence(ii) = results.pStateGop(ii);
        end
    end

end