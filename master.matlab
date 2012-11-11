function res = master(year,window,method,biasStd)

    if nargin < 1
        year = 2012;
    end
    
    if nargin < 2
        window = 30;
    end
    
    if nargin < 3
        method = 'median';
    end
    
    if nargin < 4
        biasStd = 0.0;
    end

    data   = readData(year);
    munged = mungeData(data,window,method);
    result = runModel(munged,0.0,biasStd);
    
    fprintf('Results:\n')
    fprintf('  P(Dem win) = %6.2f%%\n',100*result.pDemWin)
    fprintf('  P(GOP win) = %6.2f%%\n',100*result.pGopWin)
    fprintf('  P(Tie)     = %6.2f%%\n',100*result.pTied)
    
    % Probability of particular vote ranges
    ranges = {[0   309]
              [310 329]
              [330 349]
              [350 369]
              [370 389]
              [390 538]};
    fprintf('Probability of democratic EV total:\n'); 
    for ii = 1:length(ranges)
        r    = ranges{ii};
        loc  = result.demVotes >= r(1) & result.demVotes <= r(2);
        prob = mean(loc);
        fprintf('  %3d-%3d: %4.0f%%\n',r(1),r(2),100*prob);
    end
    
    % Write output file
    fname = sprintf('forecast/USElectionForecast%s.csv',num2str(year));
    fid = fopen(fname,'w');
    fprintf(fid,'State,Winner,Confidence\n');
    
    for ii = 1:length(result.state)
        if result.pStateDem(ii) > 0.5
            party = 'DEM';
            conf  = 100 * result.pStateDem(ii);
        else
            party  = 'REP';
            conf   = 100 * result.pStateGop(ii);
        end
        
        fprintf(fid,'%s,%s,%.0f%%\n',result.state{ii},party,conf);
    end
    fclose(fid);
    
    % Write nicely formatted output file
    fname = sprintf('forecast/USElectionForecastFormatted%s.txt',num2str(year));
    fid = fopen(fname,'w');
    fprintf(fid,'State                  Winner  Confidence\n');
    [tmp idx] = sort(result.pStateGop);
    
    for ii = 1:length(result.state)
        if result.pStateDem(idx(ii)) > 0.5
            party = 'DEM';
            conf  = 100 * result.pStateDem(idx(ii));
        else
            party = 'REP';
            conf  = 100 * result.pStateGop(idx(ii));
        end
        fprintf(fid,'%-23s%-8s%-.0f%%\n',result.state{idx(ii)},party,conf);
    end
    fclose(fid);
    
    % Plot a histogram of electoral college votes
    ev = loadElectoralVotes;
    totalEV = sum(ev.ev);
    
    hist(result.demVotes,20);
    ylimits = ylim;
    hold on
    plot([totalEV totalEV]/2, ylimits, 'r');
    hold off
    
    xlabel('Total electoral college votes (DEM)');
    ylabel('Number of simulations');
    legend({'Electoral college votes','Required to win'});
    
    % If looking at 2004 or 2008 data, assess forecasts
    if ismember(year,[2004 2008 2012])
        
        forecast   = loadForecast(year);
        actual     = loadResults(year);
        assessment = compareForecast(forecast,actual);
        
        fprintf('Forecast performance:\n');
        fprintf('  %d / 51 correctly forecast\n',assessment.nCorrect);
        fprintf('Brier score:\n')
        fprintf('  %.4f\n',assessment.brierScore)
        fprintf('Negative log likelihood:\n')
        fprintf('  %.4f\n',assessment.logLikelihood)
        fprintf('Incorrect predictions:\n');
        for ii = 1:length(assessment.wrong)
            fprintf('  %s\n',assessment.wrong{ii});
        end
    end
    
    %Output
    if nargout > 0
        res = result;
    end
    
end