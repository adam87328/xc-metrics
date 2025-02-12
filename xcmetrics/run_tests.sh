#!/bin/bash

# Start Uvicorn server in the background and save its PID
cd ./app
echo "Starting Uvicorn server..."
uvicorn main:app --port 8080&
UVICORN_PID=$!

# Wait for Uvicorn to fully start up (optional, but helpful to avoid timing issues)
sleep 2

# Run the test script (adjust the path as needed)
cd ../tests
echo "Running test script..."
python3 -m unittest tests

curl -F "file=@../../testdata/valid_xctrack.igc" http://127.0.0.1:8080/ > ../tests/response.json

# After the test script finishes, shut down Uvicorn
echo "Shutting down Uvicorn server..."
kill $UVICORN_PID

# Confirm the server is stopped
wait $UVICORN_PID

echo "Test completed and server shut down."