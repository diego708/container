#!/bin/bash
set -e

# Make messages
#/usr/src/app/manage.py makemessages -l pt_BR && \
#/usr/src/app/manage.py compilemessages -l pt_BR
echo "Applying Messages..."

# Generate static folder
#/usr/src/app/manage.py collectstatic --clear --noinput
echo "Applying Collectstatic..."

# Create cache table
#/usr/src/app/manage.py createcachetable
#echo "Applying Createcachetable..."

# Apply database migrations
if [[ "$APPLY_MIGRATIONS" = "1" ]]; then
    echo "Applying database Migrations..."
    #/usr/src/app/manage.py makemigrations --no-input
    #/usr/src/app/manage.py migrate --no-input
    
    python3 manage.py makemigrations
    python3 manage.py migrate
fi

# Apply database LOADDATA
if [[ "$APPLY_LOADDATA" = "1" ]]; then
    echo "Applying database LOADDATA..."
    #/usr/src/app/manage.py loaddata tabela
fi

# Start server
if [[ ! -z "$*" ]]; then
    echo "Applying Start Server..."
    "$@"

elif [[ "$DEV_SERVER" = "1" ]]; then
    echo "Applying Run Server..."
    #/usr/src/app/manage.py runserver 0.0.0.0:8000
    python3 manage.py runserver 0.0.0.0:8000
    
else
    echo "Applying Start uwsgi..."
    uwsgi --ini /usr/src/app/uwsgi.ini
fi
