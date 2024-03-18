# Step 1: Use an official Node image as a parent image
FROM node:18-alpine as build

# Step 2: Set the working directory
WORKDIR /app

# Step 3: Copy the current directory contents into the container
COPY . .

# Step 4: Install any needed packages specified in package.json
RUN npm install

# Step 5: Build the project for production
RUN npm run build

# Step 6: Use nginx to serve the application
FROM nginx:alpine

## Remove default nginx website
RUN rm -rf /usr/share/nginx/html/*

# Step 7: Copy the build output to replace the default nginx contents.
COPY --from=build /app/dist/hello-world /usr/share/nginx/html

# Step 8: Expose port 80 to the outside world
EXPOSE 4200

# Step 9: Run nginx
CMD ["nginx", "-g", "daemon off;"]
