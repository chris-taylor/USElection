## US Election Predictor
The election of the president and the vice president of the United States is an indirect election in which citizens of the United States who are registered to vote in one of the fifty U.S. states or in Washington, D.C., cast ballots not directly for those offices, but instead for members of the Electoral College.

Using publicly available poll data to get voter probabilities, run simulations of the US election in each of the 50 states, and use the results of the simulation to forecast probabilities for a Democratic/Republican win in the 2012 election.

To use the model, run `master` in Matlab. Sample output (4th November 2012)

    EDU>> master
    Simulating: Alabama
    Simulating: Alaska
    .
    . (etc)
    .
    Simulating: Wisconsin
    Simulating: Wyoming

    Results:
      P(Dem win) =  99.46%
      P(GOP win) =   0.49%
      P(Tie)     =   0.06%

### Update (2020/10/01)

I no longer endorse the modelling approach taken here! In particular the model does not allow for the following important effects -

- Drift in polling numbers in the run-up to the election
- Correlated errors in polls

The combination of these two means that the model makes forecasts which are *much* too confident, and they should not be relied on for anything serious at all.
