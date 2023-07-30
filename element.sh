#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
RESULT="I could not find that element in the database."
  while IFS='|' read ATOMIC_NUMBER SYMBOL NAME
  do
    if [[ $1 -eq $ATOMIC_NUMBER || $1 == $SYMBOL || $1 == $NAME ]]
    then
      QUERY_RESULT=$($PSQL "SELECT type_id,atomic_mass,melting_point_celsius,boiling_point_celsius FROM properties WHERE atomic_number='$ATOMIC_NUMBER'")
      IFS='|' read TYPE_ID ATOMIC_MASS MELTING_POINT BOILING_POINT <<< $QUERY_RESULT
      TYPE=$($PSQL "SELECT type FROM types WHERE type_id='$TYPE_ID'")
      RESULT="The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    fi
  done < <($PSQL "SELECT * FROM elements;")
  echo $RESULT
fi

