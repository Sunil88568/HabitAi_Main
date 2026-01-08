import express from 'express';
import dotenv from 'dotenv';
dotenv.config();

const app = express();
app.use(express.json());

app.post("/api/openai", async (req, res) => {
  const prompt = req.body.prompt;
  // Call OpenAI API here using process.env.OPENAI_API_KEY
  res.send("working open Ai");
});

app.listen(process.env.PORT || 5000, () => console.log("Server running"));
