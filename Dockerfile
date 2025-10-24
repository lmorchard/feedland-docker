FROM node:18-alpine

WORKDIR /app

# Copy package files
COPY feedlandInstall-main/package*.json ./

# Install dependencies
RUN npm install

# Copy application files
COPY feedlandInstall-main/feedland.js ./
COPY feedlandInstall-main/emailtemplate.html ./
COPY config.json ./

# Expose the application port and websocket port
EXPOSE 1452 1462

# Start the application
CMD ["node", "feedland.js"]
