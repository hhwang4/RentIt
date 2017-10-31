# Use an official Python runtime as a parent image
FROM python:2.7-slim

RUN apt-get update && apt-get install -y gcc python-mysqldb libmysqlclient-dev

# Copy the current directory contents into the container at /app
ADD . /app
ADD . /code/web

# Set the working directory to /app
WORKDIR /code/web

# Install any needed packages specified in requirements.txt
RUN pip install -r requirements.txt

# Make port 80 available to the world outside this container
EXPOSE 8080

# Define environment variable
ENV NAME World
ENV FLASK_APP app.py
ENV FLASK_DEBUG 1

# Run app.py when the container launches
# CMD ["python", "app.py"]
CMD ["python", "-m", "flask", "run", "--host", "0.0.0.0", "--port", "8080"]
