#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
echo Please provide an element as an argument.
else
if [[ $1 =~ ^[0-9]+$ ]]
then
TABLE_QUERY=$($PSQL "select elements.atomic_number,symbol,name,type,atomic_mass,melting_point_celsius,boiling_point_celsius,properties.type_id from elements inner join properties on elements.atomic_number = properties.atomic_number inner join types on properties.type_id = types.type_id where elements.atomic_number=$1")
if [[ -z $TABLE_QUERY ]]
then
echo I could not find that element in the database.
else
echo $TABLE_QUERY | while IFS='|' read ATOM_NUM SYMBOL NAME TYPE MASS MELT_POINT BOIL_POINT TYPE_ID
do
echo The element with atomic number $1 is $NAME \($SYMBOL\). It\'s a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT_POINT celsius and a boiling point of $BOIL_POINT celsius.  
done
fi
else 
TABLE_QUERY=$($PSQL "select elements.atomic_number,symbol,name,type,atomic_mass,melting_point_celsius,boiling_point_celsius,properties.type_id from elements inner join properties on elements.atomic_number = properties.atomic_number inner join types on properties.type_id= types.type_id where name='$1' or symbol='$1'")
if [[ -z $TABLE_QUERY ]]
then
echo I could not find that element in the database.
else
echo $TABLE_QUERY | while IFS='|' read ATOM_NUM SYMBOL NAME TYPE MASS MELT_POINT BOIL_POINT TYPE_ID
do
echo The element with atomic number $ATOM_NUM is $NAME \($SYMBOL\). It\'s a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT_POINT celsius and a boiling point of $BOIL_POINT celsius.  
done
fi
fi
fi