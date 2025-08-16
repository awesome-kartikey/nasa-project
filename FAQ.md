# Frequently Asked Questions (FAQ)

Here are some common questions about the NASA Mission Control project:

**Q1: What is the main purpose of this project?**

A: This project is a web application demonstrating a full-stack setup (React frontend, Node.js/Express backend, MongoDB database) for managing fictional space missions. It allows users to view habitable planets, schedule launches to these planets, view upcoming and past launches (including real SpaceX data), and abort scheduled missions. It originated as a learning project from the Zero To Mastery Node.js course.

**Q2: Is this an official NASA or SpaceX application?**

A: No, absolutely not. This is an educational project and is not affiliated with NASA, SpaceX, or any official space agency in any way.

**Q3: Where does the planet data come from?**

A: The initial list of potentially habitable planets comes from the `server/data/kepler_data.csv` file. This file is a dataset provided by the NASA Exoplanet Archive. The server processes this CSV file on startup, filters for planets meeting specific habitability criteria (based on stellar flux and planetary radius), and stores their names in the MongoDB database.

**Q4: Where does the launch data come from?**

A: The launch data comes from two sources:
1.  **SpaceX API:** On server startup, the backend fetches historical and upcoming launch data directly from the public [SpaceX-API (v4)](https://github.com/r-spacex/SpaceX-API). This data is stored in the MongoDB database.
2.  **User Input:** Users can schedule new launches via the application's UI. These user-scheduled launches are also stored in the MongoDB database.

**Q5: How do I set up the MongoDB connection?**

A:
1.  You need a MongoDB instance running, either locally or on a cloud service like MongoDB Atlas.
2.  Get the connection string (URI) for your database instance.
3.  Create a file named `.env` inside the `server/` directory (`server/.env`).
4.  Add the following line to the `server/.env` file, replacing `<your_mongo_url>` with your actual connection string:
    ```env
    MONGO_URL=<your_mongo_url>
    ```
5.  You can optionally add `PORT=xxxx` to specify the server port (defaults to 8000).
6.  The server uses the `dotenv` package to load this variable when it starts.

**Q6: Why was the `arwes` library chosen for the UI?**

A: `arwes` is a React UI framework specifically designed for creating futuristic, science-fiction-inspired interfaces. It was chosen to give the "NASA Mission Control" application a thematic and visually engaging look and feel, complete with animations and sound effects.

**Q7: How is data initially loaded into the database?**

A: When the server starts (`npm run deploy` or `npm start --prefix server`), the `startServer` function in `server/src/server.js` executes. Before listening for connections, it calls:
1.  `loadPlanetsData()`: Reads `kepler_data.csv`, filters for habitable planets, and saves them to the MongoDB `planets` collection.
2.  `loadLaunchData()`: Checks if SpaceX data is already loaded. If not, it fetches data from the SpaceX API (`axios.post`), processes it, and saves it to the MongoDB `launches` collection.
   This ensures the application has the necessary initial data to function.

**Q8: What do the main `npm` scripts in the root `package.json` do?**

*   `npm install`: Runs `npm install` in both `server/` and `client/` directories.
*   `npm run server`: Starts the backend server using `nodemon` for auto-restarts during development (`npm run watch --prefix server`).
*   `npm run client`: Starts the React development server (`npm start --prefix client`).
*   `npm run watch`: Runs both `server` and `client` scripts concurrently for development.
*   `npm run deploy`: Builds the production version of the React client (`npm run build --prefix client`) and then starts the production server (`npm start --prefix server`), which serves the client build.
*   `npm run deploy-cluster`: Builds the client and starts the server using `pm2` in cluster mode for better performance/resilience.
*   `npm test`: Runs test suites in both `server/` and `client/` directories.

**Q9: Can this project be deployed?**

A: Yes. The project includes a `Dockerfile` for containerization, making it suitable for deployment on platforms that support Docker containers (like AWS ECS, Google Cloud Run, Azure Container Instances, Render, Heroku Docker Deploy, etc.). The `npm run deploy` script prepares a production build. You'll need to ensure the production environment provides the `MONGO_URL` environment variable.

**Q10: How does pagination work for the launches API?**

A: The `GET /v1/launches` endpoint supports optional query parameters `page` and `limit`. The `getPagination` function in `server/src/services/query.js` calculates the `skip` and `limit` values based on these parameters (defaulting to page 1 and no limit). These values are then used in the Mongoose query (`.skip(skip).limit(limit)`) within the `getAllLaunches` model function to fetch the appropriate subset of data from the database.

**Q11: Why does the Dockerfile have multiple `FROM` statements (multi-stage build)?**

A: The multi-stage build optimizes the final Docker image.
*   **Stage 1 (`base`):** Sets up a base Node.js environment.
*   **Stage 2 (`client-builder`):** Installs client dependencies (`npm ci`) and builds the React application (`react-scripts build`). The build output is placed in `/app/server/public`.
*   **Stage 3 (`server-builder`):** Installs *only* server production dependencies (`npm ci --omit=dev`).
*   **Stage 4 (Final Image):** Starts from a lean Node.js alpine image, copies only the necessary production `node_modules` from `server-builder`, copies the server source code, copies the built client artifacts from `client-builder`, sets `NODE_ENV=production`, exposes the port, and defines the `CMD` to run the server. This results in a smaller, more secure final image without build tools or development dependencies.