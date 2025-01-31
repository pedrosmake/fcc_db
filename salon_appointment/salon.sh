#! /bin/bash

PSQL="psql --username=postgres --dbname=salon --no-align --tuples-only -c"

echo -e "\n~~~~~ Welcome to My Salon ~~~~~\n"

# Function to display available services
display_services() {
	echo -e "\nHere are the available services:\n"
	SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
	echo "$SERVICES" | while IFS="|" read -r SERVICE_ID SERVICE_NAME; do
		echo "$SERVICE_ID) $SERVICE_NAME"
	done
}

# Function to get a valid service selection
get_service_selection() {
	while true; do
		display_services
		echo -e "\nEnter the service ID you want:"
		read -r SERVICE_ID_SELECTED

		# Check if input is a number
		if ! [[ "$SERVICE_ID_SELECTED" =~ ^[0-9]+$ ]]; then
			echo -e "\nInvalid input. Please enter a valid number."
			continue
		fi

		SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
		if [[ -z $SERVICE_NAME ]]; then
			echo -e "\nInvalid selection. Please try again."
		else
			break
		fi
	done
}

# Function to get customer details
get_customer_details() {
	echo -e "\nEnter your phone number:"
	read -r CUSTOMER_PHONE

	CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
	if [[ -z $CUSTOMER_NAME ]]; then
		echo -e "\nYou are a new customer. Please enter your name:"
		read -r CUSTOMER_NAME
		INSERT_CUSTOMER=$($PSQL "INSERT INTO customers (name, phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
		if [[ "$INSERT_CUSTOMER" != "INSERT 0 1" ]]; then
			echo -e "Failed to add customer. Please try again."
			exit 1
		fi
	fi
	CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
}

# Function to book an appointment
book_appointment() {
	echo -e "\nEnter the appointment time:"
	read -r SERVICE_TIME

	INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
	if [[ "$INSERT_APPOINTMENT" != "INSERT 0 1" ]]; then
		echo -e "Failed to book appointment. Please try again."
		exit 1
	fi
	echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}

# Run the program
get_service_selection
get_customer_details
book_appointment
