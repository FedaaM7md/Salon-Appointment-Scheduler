#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -q -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo "Welcome to My Salon, how can I help you?"

# Display services and get service selection
while true
do
  echo
  $PSQL "SELECT service_id || ') ' || name FROM services ORDER BY service_id"

  echo -e "\n"
  read SERVICE_ID_SELECTED

  if ! [[ "$SERVICE_ID_SELECTED" =~ ^[0-9]+$ ]]
  then
    echo -e "\nI could not find that service. What would you like today?"
    continue
  fi

  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")

  if [[ -z "$SERVICE_NAME" ]]
  then
    echo -e "\nI could not find that service. What would you like today?"
  else
    break
  fi
done

# Get customer phone
echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE

PHONE_SQL=$(printf "%s" "$CUSTOMER_PHONE" | sed "s/'/''/g")

CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$PHONE_SQL'")

# Register new customer if necessary
if [[ -z "$CUSTOMER_ID" ]]
then
  echo -e "\nWhat's your name?"
  read CUSTOMER_NAME

  NAME_SQL=$(printf "%s" "$CUSTOMER_NAME" | sed "s/'/''/g")

  CUSTOMER_ID=$($PSQL "INSERT INTO customers(phone, name) VALUES('$PHONE_SQL', '$NAME_SQL') RETURNING customer_id")
else
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id = $CUSTOMER_ID")
fi

# Get appointment time
echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
read SERVICE_TIME

TIME_SQL=$(printf "%s" "$SERVICE_TIME" | sed "s/'/''/g")

# Insert appointment
$PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$TIME_SQL')"

# Confirmation
echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
