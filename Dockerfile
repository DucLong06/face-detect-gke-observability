FROM tiangolo/uvicorn-gunicorn:python3.10

# Install system dependencies
RUN apt update && \
    apt install -y htop libgl1-mesa-glx libglib2.0-0 && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt 

WORKDIR /app

# Copy application code and models
COPY api/ /app/api
COPY models/ /app/models/

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]