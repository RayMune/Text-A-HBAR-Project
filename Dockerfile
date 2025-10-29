# ---------- Base Image ----------
FROM python:3.13-slim

# ---------- System Setup ----------
# Install Java 25 (for Hedera SDK) and system tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        openjdk-21-jdk-headless curl && \
    rm -rf /var/lib/apt/lists/*

# (Render’s Ubuntu base doesn’t yet support OpenJDK-25; 21 is fine for Hedera SDK)
# If Render adds 25 later, replace openjdk-21-jdk-headless with openjdk-25-jdk-headless

# ---------- Environment ----------
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:$PATH"
ENV PYTHONUNBUFFERED=1

# ---------- Working Directory ----------
WORKDIR /app

# ---------- Dependencies ----------
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt gunicorn

# ---------- Copy App ----------
COPY . .

# ---------- Expose Port ----------
EXPOSE 5000

# ---------- Start Command ----------
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "app:app"]
