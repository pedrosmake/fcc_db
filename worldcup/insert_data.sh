#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat 'games.csv' | while IFS=',' read -r year round winner opponent winner_goals opponent_goals; do
  # Skip the header row
  if [[ "$year" == "year" ]]; then
    continue
  fi

  # Insert winner team into the database if not already present
  $PSQL "INSERT INTO teams (name) SELECT '$winner' WHERE NOT EXISTS (SELECT 1 FROM teams WHERE name = '$winner');"

  # Insert opponent team into the database if not already present
  $PSQL "INSERT INTO teams (name) SELECT '$opponent' WHERE NOT EXISTS (SELECT 1 FROM teams WHERE name = '$opponent');"

  # Get the winner_id
  winner_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$winner';")

  # Get the opponent_id
  opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$opponent';")

  # Insert game data into the games table
  $PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($year, '$round', $winner_id, $opponent_id, $winner_goals, $opponent_goals);"
done
