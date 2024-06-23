#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT W_GOALS O_GOALS
do

  # WINNER TEAM NAME

  if [[ $WINNER != "winner" ]]
    then
      # GET TEAM NAME
      NAME=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
      # IF NAME NOT FOUND
      if [[ -z $NAME ]]
       then
        # INSERT TEAM NAME
        INSERT_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
        if [[ $INSERT_NAME == "INSERT 0 1" ]]
          then
            echo Inserted team, $WINNER
        fi
      fi
  fi
  
  # OPPONENT TEAM NAME

  if [[ $OPPONENT != "opponent" ]]
    then
      # GET TEAM NAME
      NAME=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
      # IF NAME NOT FOUND
      if [[ -z $NAME ]]
       then
        # INSERT TEAM NAME
        INSERT_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
        if [[ $INSERT_NAME == "INSERT 0 1" ]]
          then
            echo Inserted team, $OPPONENT
        fi
      fi
  fi

  # INSERT GAME TABLE DATA

  if [[ $YEAR != "year" ]]
    then
      # GET TEAMS ID
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
      # ADD GAMES
      GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $W_GOALS, $O_GOALS)")
      if [[ $GAME == "INSERT 0 1" ]]
        then
          echo Game inserted, $WINNER VS $OPPONENT
      fi
  fi
done



