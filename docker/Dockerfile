# Use Node.js LTS version
FROM node:18-slim

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# Copy package.json and package-lock.json
COPY package*.json ./

RUN npm install

# Bundle app source
COPY . .

# Create non-root user
RUN useradd -r -u 1001 -g root nodeuser
RUN chown -R nodeuser:root /usr/src/app
USER nodeuser

EXPOSE 3000
CMD [ "npm", "start" ]
