package main

import (
	"log/slog"
	"os"
	"rtops-backend/internal/repository/postgresql"

	"github.com/joho/godotenv"
)

// init initializes the application by loading environment variables from a .env file.
// Logs a warning if the file is not found, defaulting to existing environment variables.
func init() {
	err := godotenv.Load()
	if err != nil {
		slog.Warn(
			"Failed to load .env file",
			slog.String(
				"message",
				"Falling back to using environment variables set via export or command line",
			),
		)
	}
}


func main(){
	// make logging using json
	logger := slog.New(slog.NewJSONHandler(os.Stdout, nil))
	slog.SetDefault(logger) // set logger

	// init postgresql
	dbPSQL := postgresql.InitPSQL()
	defer dbPSQL.Close() // close postgresql after the shurrounding function returns
	
}