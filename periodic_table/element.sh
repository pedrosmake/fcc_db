#!/bin/bash

# Set PSQL command
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# Check if an argument is provided
if [[ -z $1 ]]; then
  echo "Please provide an element as an argument."
  exit 0
fi

# Store the argument in a variable
ARGUMENT=$1

# Check if the input is numeric (atomic number)
if [[ $ARGUMENT =~ ^[0-9]+$ ]]; then
  # Input is a number, search by atomic_number
  RESULT=$($PSQL "SELECT e.atomic_number, e.symbol, e.name, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius
                  FROM elements e
                  JOIN properties p ON e.atomic_number = p.atomic_number
                  JOIN types t ON p.type_id = t.type_id
                  WHERE e.atomic_number = $ARGUMENT;")

# Check if the input is a symbol (1 or 2 letters)
elif [[ $ARGUMENT =~ ^[A-Za-z]{1,2}$ ]]; then
  # Input is 1 or 2 letters, search by symbol
  RESULT=$($PSQL "SELECT e.atomic_number, e.symbol, e.name, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius
                  FROM elements e
                  JOIN properties p ON e.atomic_number = p.atomic_number
                  JOIN types t ON p.type_id = t.type_id
                  WHERE e.symbol = '$ARGUMENT';")

# Otherwise, assume the input is the name (word with more than 2 letters)
else
  # Input is a name, search by name
  RESULT=$($PSQL "SELECT e.atomic_number, e.symbol, e.name, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius
                  FROM elements e
                  JOIN properties p ON e.atomic_number = p.atomic_number
                  JOIN types t ON p.type_id = t.type_id
                  WHERE e.name ILIKE '$ARGUMENT';")
fi

# Check if the result is empty
if [[ -z $RESULT ]]; then
  echo "I could not find that element in the database."
else
  # Parse the result
  ATOMIC_NUMBER=$(echo $RESULT | cut -d '|' -f 1)
  SYMBOL=$(echo $RESULT | cut -d '|' -f 2)
  NAME=$(echo $RESULT | cut -d '|' -f 3)
  TYPE=$(echo $RESULT | cut -d '|' -f 4)
  ATOMIC_MASS=$(echo $RESULT | cut -d '|' -f 5)
  MELTING_POINT=$(echo $RESULT | cut -d '|' -f 6)
  BOILING_POINT=$(echo $RESULT | cut -d '|' -f 7)

  # Output the result in the requested format
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
fi
