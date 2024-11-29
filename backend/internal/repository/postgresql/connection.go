package postgresql

import (
	"context"
	"log/slog"
	"os"
	"time"

	"rtops-backend/app/config"
	"github.com/jackc/pgx/v5/pgxpool"
)


// InitPSQL initializes a PostgreSQL connection pool and ensures successful connection to the database.
// It sets up a structured logger, creates the connection pool, acquires a connection, and pings the database.
// Exits the application if any errors occur during initialization.
func InitPSQL() *pgxpool.Pool {
	// Initialize structured logger with timestamp
	logger := slog.New(slog.NewTextHandler(os.Stdout, &slog.HandlerOptions{
		AddSource: true,
		Level:     slog.LevelInfo,
		ReplaceAttr: func(groups []string, a slog.Attr) slog.Attr {
			if a.Key == slog.TimeKey {
				a.Value = slog.StringValue(time.Now().Format(time.RFC3339))
			}
			return a
		},
	}))
	slog.SetDefault(logger)

	connPool, err := pgxpool.NewWithConfig(context.Background(), config.PSQLConfig())
	if err != nil {
		slog.Error("failed to create database connection pool",
			"error", err)
		os.Exit(1)
	}

	connection, err := connPool.Acquire(context.Background())
	if err != nil {
		slog.Error("failed to acquire connection from pool",
			"error", err)
		os.Exit(1)
	}
	defer connection.Release()

	err = connection.Ping(context.Background())
	if err != nil {
		slog.Error("failed to ping database",
			"error", err)
		os.Exit(1)
	}

	slog.Info("successfully connected to database")
	return connPool
}

// ClosePSQL closes the PostgreSQL connection pool and logs the closure.
func ClosePSQL(pool *pgxpool.Pool) {
	pool.Close()
	slog.Info("database connection closed")
}