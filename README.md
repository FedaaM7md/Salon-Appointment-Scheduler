# Salon Appointment Scheduler

A freeCodeCamp Relational Database project: an interactive Bash program that books salon appointments and stores them in PostgreSQL.

## How it works

1. Lists the available services from the database and asks the customer to pick one (invalid choices show the list again).
2. Looks up the customer by phone number; a new customer is asked for a name and added.
3. Asks for a time and saves the appointment, then confirms the booking.

## Files

- `salon.sql` - database dump with the `services`, `customers` and `appointments` tables
- `salon.sh` - the booking script

## Tech

Bash, PostgreSQL, SQL

## Run

```bash
psql -U postgres < salon.sql
./salon.sh
```
