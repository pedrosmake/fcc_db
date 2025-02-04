#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# Generate secret number
SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))

# Prompt for username
echo "Enter your username:"
read USERNAME

# Check if user exists in the database
USER_INFO=$($PSQL "SELECT games_played, best_game FROM number_guess WHERE username='$USERNAME'")

if [[ -z $USER_INFO ]]; then
  # New user
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  $PSQL "INSERT INTO number_guess(username, games_played, best_game) VALUES('$USERNAME', 0, NULL)"
else
  # Returning user
  IFS='|' read GAMES_PLAYED BEST_GAME <<< "$USER_INFO"
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

# Start guessing game
echo "Guess the secret number between 1 and 1000:"
GUESSES=0
while true; do
  read GUESS
  ((GUESSES++))

  # Validate input
  if ! [[ $GUESS =~ ^[0-9]+$ ]]; then
    echo "That is not an integer, guess again:"
    continue
  fi

  if (( GUESS < SECRET_NUMBER )); then
    echo "It's higher than that, guess again:"
  elif (( GUESS > SECRET_NUMBER )); then
    echo "It's lower than that, guess again:"
  else
    echo "You guessed it in $GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
    break
  fi
done

# Update user stats
if [[ -z $USER_INFO ]]; then
  $PSQL >/dev/null "UPDATE number_guess SET games_played = 1, best_game = $GUESSES WHERE username='$USERNAME'"
else
  NEW_GAMES_PLAYED=$(( GAMES_PLAYED + 1 ))
  if [[ -z $BEST_GAME || GUESSES -lt BEST_GAME ]]; then
    $PSQL >/dev/null "UPDATE number_guess SET games_played = $NEW_GAMES_PLAYED, best_game = $GUESSES WHERE username='$USERNAME'"
  else
    $PSQL >/dev/null "UPDATE number_guess SET games_played = $NEW_GAMES_PLAYED WHERE username='$USERNAME'"
  fi
fi
