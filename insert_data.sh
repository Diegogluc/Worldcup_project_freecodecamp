#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL "TRUNCATE TABLE games, teams RESTART IDENTITY;")"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONNENT_GOLS
do
  if [[ $YEAR != year ]]
    then
      #Insert team names in the teams table
      INSERT_TEAM=$($PSQL "INSERT INTO teams(name) SELECT '$WINNER' WHERE NOT EXISTS (SELECT 1 FROM teams WHERE name = '$WINNER')")
      INSERT_TEAM=$($PSQL "INSERT INTO teams(name) SELECT '$OPPONENT' WHERE NOT EXISTS (SELECT 1 FROM teams WHERE name = '$OPPONENT')")
  
      #Insert data in the games table
      INSERT_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) 
      VALUES ( $YEAR,'$ROUND', 
      (SELECT team_id FROM teams WHERE name = '$WINNER'), 
      (SELECT team_id FROM teams WHERE name = '$OPPONENT'),
      $WINNER_GOALS, $OPPONNENT_GOLS)")
  fi
done
