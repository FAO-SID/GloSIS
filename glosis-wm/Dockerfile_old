FROM node:20-slim

WORKDIR /app

# Copy package files
COPY package.json ./

# Install dependencies with clean npm cache
RUN npm cache clean --force && \
    npm install && \
    npm install -g parcel

# Copy application code
COPY . .

# Expose port
EXPOSE 1234

# Start the development server
CMD ["npm", "start"]