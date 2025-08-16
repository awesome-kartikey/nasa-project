# NASA Mission Control Dashboard

Welcome to the NASA Mission Control Dashboard project! This full-stack application allows users to explore habitable planets, schedule interstellar rocket launches, and view upcoming and historical mission data, including real SpaceX launches.

This project was originally developed as part of the [Complete Node.js Developer: Zero to Mastery](https://academy.zerotomastery.io/a/aff_jqtq5631/external?affcode=441520_1jw4f2ay) course.

## Features

- **Explore Habitable Planets:** Fetches and displays potential habitable exoplanets based on NASA Kepler data.
- **Schedule Launches:** Allows users to schedule new rocket missions to selected habitable planets.
- **View Upcoming Launches:** Lists all scheduled future missions (both user-added and SpaceX).
- **View Launch History:** Displays past missions (user-added and SpaceX) with success/failure status.
- **Abort Missions:** Provides the ability to cancel upcoming scheduled launches.
- **Interactive Sci-Fi UI:** Uses the Arwes library for a futuristic user interface experience.
- **Real SpaceX Data:** Integrates historical and upcoming launch data from the public SpaceX API.
- **Dockerized:** Includes a Dockerfile for easy containerization and deployment.

## Tech Stack

- **Frontend:**
  - React (v17)
  - React Router (v5)
  - Arwes (Futuristic Sci-Fi UI Framework)
  - Custom React Hooks
  - Fetch API (for backend communication)
- **Backend:**
  - Node.js
  - Express.js
  - MongoDB (with Mongoose ODM)
  - Axios (for fetching SpaceX data)
  - `csv-parse` (for reading Kepler data)
  - Morgan (HTTP request logging)
  - CORS
  - Dotenv
- **Database:**
  - MongoDB (Cloud Atlas or Local)
- **Development & Deployment:**
  - Docker
  - PM2 (Process Manager for Node.js)
  - Jest & Supertest (Backend Testing)
  - React Testing Library (Frontend Testing via `react-scripts test`)
  - Nodemon (Development auto-reload)

## Setup Instructions

1.  **Prerequisites:**
    - Node.js (LTS version recommended)
    - npm (usually comes with Node.js)
    - Git
    - Docker (Optional, for containerized deployment)
2.  **Clone the Repository:**
    ```bash
    git clone <your-repository-url>
    cd nasa-project
    ```
3.  **Database Setup:**
    - Obtain a MongoDB connection string. You can:
      - Create a free cluster on [MongoDB Atlas](https://www.mongodb.com/atlas/database).
      - Run MongoDB locally.
    - Create a `.env` file in the `server/` directory (`server/.env`).
    - Add your MongoDB connection string to the `server/.env` file:
      ```env
      MONGO_URL=mongodb+srv://<username>:<password>@<cluster-url>/<database-name>?retryWrites=true&w=majority
      # Or for local MongoDB: MONGO_URL=mongodb://localhost:27017/nasa
      PORT=8000 # Optional: specify a port, defaults to 8000
      ```
4.  **Install Dependencies:**
    - Run the following command from the _root_ directory (`nasa-project/`) to install both server and client dependencies:
      ```bash
      npm install
      ```

## Usage

### Running Locally

1.  **Start the Application:**
    - Run the following command from the _root_ directory. This will build the React client and start the Node.js server, serving the client build.
      ```bash
      npm run deploy
      ```
    - Alternatively, for development with auto-reloading for both client and server:
      ```bash
      npm run watch
      ```
      This starts the client on port 3000 and the server on port 8000 (or the `PORT` specified in `server/.env`). The client will proxy API requests to the server.
2.  **Access the Application:**
    - If using `npm run deploy`, browse to [http://localhost:8000](http://localhost:8000) (or your specified `PORT`).
    - If using `npm run watch`, browse to [http://localhost:3000](http://localhost:3000).

### Running with Docker

1.  **Build the Docker Image:**
    - Make sure Docker is running.
    - From the _root_ directory, run:
      ```bash
      docker build -t nasa-project .
      ```
2.  **Run the Docker Container:**
    - Ensure you have the `server/.env` file configured as described in Setup. The container needs the `MONGO_URL`. You can pass environment variables via the `docker run` command.
    - Run the container, mapping port 8000:
      ```bash
      # Replace <your_mongo_url> with your actual connection string
      docker run --env MONGO_URL=<your_mongo_url> -it -p 8000:8000 nasa-project
      ```
      _Note: Passing secrets like `MONGO_URL` directly in the command line might expose them in your shell history. Consider using Docker secrets or environment files for production._
3.  **Access the Application:**
    - Browse to [http://localhost:8000](http://localhost:8000).

### Running Tests

- To run all tests (both client and server):
  ```bash
  npm test
  ```
- To run only server tests:
  ```bash
  npm test --prefix server
  ```
- To run only client tests:
  ```bash
  npm test --prefix client
  ```

Enjoy scheduling your space missions!
