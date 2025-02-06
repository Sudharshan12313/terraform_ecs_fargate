# Use Node.js as the base image
FROM node:18

# Set working directory for your app
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install app dependencies
RUN npm install

# Copy your app code
COPY . .


# Install Prometheus (adjust version as needed)
RUN curl -LO https://github.com/prometheus/prometheus/releases/download/v2.33.1/prometheus-2.33.1.linux-amd64.tar.gz && \
  tar -xvzf prometheus-2.33.1.linux-amd64.tar.gz && \
  mv prometheus-2.33.1.linux-amd64/prometheus /usr/local/bin/ && \
  mv prometheus-2.33.1.linux-amd64/promtool /usr/local/bin/ && \
  rm -rf prometheus-2.33.1.linux-amd64

# Copy Prometheus config
COPY prometheus.yml /etc/prometheus/prometheus.yml

# Expose necessary ports
EXPOSE 3001
EXPOSE 9090

# Run Prometheus, CloudWatch Agent, and your app
CMD ["/bin/bash", "-c", "prometheus --config.file=/etc/prometheus/prometheus.yml & npm start"]
