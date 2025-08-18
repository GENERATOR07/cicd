import express from "express";
import type { Request, Response } from "express";

const app = express();
const PORT = 3000;

// Root route
app.get("/", (_req: Request, res: Response) => {
  res.send("Welcome");
});

// Start server
app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});
