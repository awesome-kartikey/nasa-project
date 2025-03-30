# Stage 1: Base Node image
FROM node:lts-alpine as base
WORKDIR /app

# Stage 2: Install Client Dependencies & Build Client
FROM base as client-builder
WORKDIR /app/client
COPY client/package.json client/package-lock.json ./
# Use ci for faster, more reliable installs based on lockfile
RUN npm ci 
COPY client/ ./
# Set BUILD_PATH directly here and run the build
# Ensure the path is relative to the final server directory structure
RUN BUILD_PATH=/app/server/public npm run build

# Stage 3: Install Server Dependencies (server-builder)
FROM base as server-builder
WORKDIR /app/server
COPY server/package.json server/package-lock.json ./
RUN npm ci --omit=dev
COPY server/src ./src     # Explicitly copy src
COPY server/data ./data   # Explicitly copy data
# Add any other necessary server files/dirs here if they exist

# Stage 4: Production Image - Combine build artifacts
FROM node:lts-alpine
WORKDIR /app

# Set NODE_ENV (can also be set via Render ENV vars, but good practice here too)
ENV NODE_ENV=production 

# Copy necessary node_modules from builders
COPY --from=server-builder /app/server/node_modules ./server/node_modules
COPY --from=server-builder /app/server/package.json ./server/package.json
# Copy server source code
COPY --from=server-builder /app/server/src ./server/src
COPY --from=server-builder /app/server/data ./server/data # Do not forget data files

# Copy the built client static files from the client-builder stage
COPY --from=client-builder /app/server/public ./server/public

WORKDIR /app/server 

# Expose the port Render will map to
EXPOSE 8000 

# Run the server using Node directly (slightly more efficient than npm start)
CMD [ "node", "src/server.js" ] 