# -------------------------
# Stage 1: Build Stage
# -------------------------
    FROM node:22-alpine AS builder

    # Set working directory inside container
    WORKDIR /app
    
    # Copy only package.json and lock file first (better layer caching)
    COPY package*.json ./
    
    # Install all dependencies (including devDeps for building)
    RUN npm install
    
    # Copy rest of the app
    COPY . .
    
    # Build TypeScript -> JavaScript
    RUN npm run build
    
    
    # -------------------------
    # Stage 2: Production Stage
    # -------------------------
    FROM node:22-alpine AS runner
    
    # Alternative: Use distroless for maximum security
    # FROM gcr.io/distroless/nodejs22-debian12:latest AS runner
    
    WORKDIR /app
    
    # Copy only package.json again
    COPY package*.json ./
    
    # Install only production dependencies
    RUN npm install --omit=dev --ignore-scripts
    
    # Copy dist output from builder
    COPY --from=builder /app/dist ./dist
    
    # Optional: copy config files if needed (env, etc.)
    # COPY --from=builder /app/.env ./
    
    # Expose port (change if your app listens on another)
    EXPOSE 3000
    
    # Start the app
    CMD ["npm", "start"]
    