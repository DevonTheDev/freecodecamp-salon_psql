#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

MAIN_MENU() {
  echo -e "\nWelcome to my Salon, how can I help you?"
  echo -e "1) Cut \n2) Color \n3) Perm"
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
  '1') SERVICE_MENU "Cut" 1;;
  '2') SERVICE_MENU "Color" 2;;
  '3') SERVICE_MENU "Perm" 3;;
  *) MAIN_MENU "Sorry, I could not find that service";;
  esac
}

SERVICE_MENU() {
  echo -e "\nWhat is your phone number?"
  read CUSTOMER_PHONE

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    $PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')"
  fi
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  echo "What time would you like your $1,$CUSTOMER_NAME?"
  read SERVICE_TIME

  $PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $2, '$SERVICE_TIME')"
  echo "I have put you down for a $1 at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN_MENU
