#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# IF NO ARGUMENT
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  # CHECK WHAT TYPE THE ARGUMENT IS
    if [[ $1 =~ [0-9]+ ]] # NUMBER
    then
      # GET ELEMENT BY ATOMIC NUMBER
      ELEMENT_RESULT=$( $PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number=$1;" )

      # CHECK IF ELEMENT EXISTS
      if [[ -z $ELEMENT_RESULT ]]
      then
        echo "I could not find that element in the database."
        exit
      fi

      # ELEMENT EXISTS, READ DATA INTO VARIABLES
      echo $ELEMENT_RESULT | while IFS='|' read ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS TYPE
      do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
      done
    elif [[ $1 =~ [a-zA-Z]+ ]] # TEXT
    then
      # GET ELEMENT BY SYMBOL/NAME
      ELEMENT_RESULT=$( $PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE symbol='$1' OR name='$1';" )

      # CHECK IF ELEMENT EXISTS
      if [[ -z $ELEMENT_RESULT ]]
      then
        echo "I could not find that element in the database."
        exit
      fi

      # ELEMENT EXISTS, READ DATA INTO VARIABLES
      echo $ELEMENT_RESULT | while IFS='|' read ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS TYPE
      do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
      done
    fi
fi