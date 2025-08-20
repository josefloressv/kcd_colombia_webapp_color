# Use the official Python image from the Docker Hub
FROM python:3.12-slim

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container
COPY app/requirements.txt .

# Install the dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code into the container
COPY ./app/ .

# Expose port 8080
EXPOSE 8080

# Set environment variables
ENV FLASK_APP=main.py

# Run the application
CMD ["python", "main.py"]