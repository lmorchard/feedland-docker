FROM node:18-alpine

WORKDIR /app

# Copy package files
COPY feedlandInstall-main/package*.json ./

# Install dependencies with legacy peer deps to handle older packages
RUN npm install --legacy-peer-deps

# Install missing @babel/runtime that wpcom needs but doesn't declare properly
RUN npm install @babel/runtime --legacy-peer-deps

# Copy application files
COPY feedlandInstall-main/feedland.js ./
COPY feedlandInstall-main/emailtemplate.html ./

# Expose the application port and websocket port
EXPOSE 1452 1462

# Start the application
CMD ["node", "feedland.js"]
