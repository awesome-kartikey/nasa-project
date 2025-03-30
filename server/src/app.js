const path = require("path");
const express = require("express");
const cors = require("cors");
const morgan = require("morgan");

const api = require("./routes/api");

const app = express();

const clientOrigin = process.env.CLIENT_ORIGIN || 'http://localhost:3000';

app.use(
  cors({
    origin: "https://nasa-mission-kartikey.netlify.app", // Updated URL
  })
);
app.use(morgan("combined"));

app.use(express.json());
app.use(express.static(path.join(__dirname,"..","public")));

app.use("/v1", api);

app.get("/*", (req, res) => {
  res.sendFile(path.join(__dirname,"..","public","index.html"));
});

module.exports = app;
