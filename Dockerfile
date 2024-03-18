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
# Note: This step is necessary if your application's build process outputs more than just an index.html,
# such as JavaScript, CSS, images, etc. It copies the entire build directory to the Nginx web root.
COPY --from=build /app/dist/hello-world /usr/share/nginx/html

# NEW: Copy a specific index.html into the container at the Nginx web root, if needed.
# Ensure the path to index.html is correct relative to the Dockerfile's location.
# This step is optional if your build process already places index.html correctly.
# COPY ./path/to/index.html /usr/share/nginx/html/index.html

# Step 8: Expose port 80 to the outside world
EXPOSE 80

# Step 9: Run nginx
CMD ["nginx", "-g", "daemon off;"]
