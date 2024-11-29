package config

import (
	"context"
	"fmt"
	"log/slog"
	"os"
	"strconv"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
)

// PostgresConfig is the representation of a configuration that used for posgresql with pgxpool
// A PostgresConfig is a match config that fit pgxpool implementation
type PostgresConfig struct {
	USERNAME string
	PASSWORD string
	NAME     string
	HOST     string
	PORT     string
	TIMEZONE string
	SSL_MODE string
	// New fields for additional configuration
	MAX_CONNS          int32
	MIN_CONNS          int32
	MAX_CONN_LIFETIME  time.Duration
	MAX_CONN_IDLE_TIME time.Duration
	CONNECT_TIMEOUT    time.Duration
}


const (
	defaultMaxConns          = int32(4)
	defaultMinConns          = int32(0)
	defaultMaxConnLifetime   = time.Hour
	defaultMaxConnIdleTime   = time.Minute * 30
	defaultHealthCheckPeriod = time.Minute
	defaultConnectTimeout    = time.Second * 5
	defaultSSLMode           = "disable" // For development. Use "verify-full" for production
)

// getEnvWithDefault retrieves an environment variable with a fallback default value
func getEnvWithDefault(key, defaultValue string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return defaultValue
}

// getDurationEnv retrieves a duration from environment variable with a fallback
func getDurationEnv(key string, defaultValue time.Duration) time.Duration {
	if str := os.Getenv(key); str != "" {
		if duration, err := time.ParseDuration(str); err == nil {
			return duration
		}
		slog.Warn("invalid duration in env var, using default", "key", key, "default", defaultValue)
	}
	return defaultValue
}

// getInt32Env retrieves an int32 from environment variable with a fallback
func getInt32Env(key string, defaultValue int32) int32 {
	if str := os.Getenv(key); str != "" {
		if val, err := strconv.ParseInt(str, 10, 32); err == nil {
			return int32(val)
		}
		slog.Warn("invalid int32 in env var, using default", "key", key, "default", defaultValue)
	}
	return defaultValue
}


// loadPostgresConfig loads and returns the PostgreSQL configuration as a PostgresConfig struct.
// It retrieves values from environment variables, applying defaults if not set.
func loadPostgresConfig() PostgresConfig {

	slog.Info("loading postgres config")

	return PostgresConfig{
		USERNAME:           getEnvWithDefault("PSQL_USER", "postgres"),
		PASSWORD:           getEnvWithDefault("PSQL_PASS", ""),
		HOST:               getEnvWithDefault("PSQL_HOST", "localhost"),
		PORT:               getEnvWithDefault("PSQL_PORT", "5432"),
		NAME:               getEnvWithDefault("PSQL_NAME", "postgres"),
		TIMEZONE:           getEnvWithDefault("PSQL_TIME", "UTC"),
		SSL_MODE:           getEnvWithDefault("PSQL_SSL_MODE", defaultSSLMode),
		MAX_CONNS:          getInt32Env("PSQL_MAX_CONNS", defaultMaxConns),
		MIN_CONNS:          getInt32Env("PSQL_MIN_CONNS", defaultMinConns),
		MAX_CONN_LIFETIME:  getDurationEnv("PSQL_MAX_CONN_LIFETIME", defaultMaxConnLifetime),
		MAX_CONN_IDLE_TIME: getDurationEnv("PSQL_MAX_CONN_IDLE_TIME", defaultMaxConnIdleTime),
		CONNECT_TIMEOUT:    getDurationEnv("PSQL_CONNECT_TIMEOUT", defaultConnectTimeout),
	}
}


// PSQLConfig returns a pointer to a pgxpool.Config for initializing a PostgreSQL connection pool.
// It builds the configuration using environment variables and applies custom pool settings.
// Lifecycle hooks for connection acquisition, release, and closure are also configured.
// Logs errors and exits the application if configuration parsing fails.
func PSQLConfig() *pgxpool.Config {
	psqlConfig := loadPostgresConfig()

	// Build connection string with all necessary parameters
	dsn := fmt.Sprintf(
		"postgres://%s:%s@%s:%s/%s?sslmode=%s&timezone=%s",
		psqlConfig.USERNAME,
		psqlConfig.PASSWORD,
		psqlConfig.HOST,
		psqlConfig.PORT,
		psqlConfig.NAME,
		psqlConfig.SSL_MODE,
		psqlConfig.TIMEZONE,
	)

	dbConfig, err := pgxpool.ParseConfig(dsn)
	if err != nil {
		slog.Error("failed to create config", "error", err)
		os.Exit(1)
	}

	// Apply configuration
	dbConfig.MaxConns = psqlConfig.MAX_CONNS
	dbConfig.MinConns = psqlConfig.MIN_CONNS
	dbConfig.MaxConnLifetime = psqlConfig.MAX_CONN_LIFETIME
	dbConfig.MaxConnIdleTime = psqlConfig.MAX_CONN_IDLE_TIME
	dbConfig.HealthCheckPeriod = defaultHealthCheckPeriod
	dbConfig.ConnConfig.ConnectTimeout = psqlConfig.CONNECT_TIMEOUT

	// Connection pool lifecycle hooks
	dbConfig.BeforeAcquire = func(ctx context.Context, c *pgx.Conn) bool {
		slog.Debug("acquiring connection from pool",
			"host", psqlConfig.HOST,
			"database", psqlConfig.NAME)
		return true
	}

	dbConfig.AfterRelease = func(c *pgx.Conn) bool {
		slog.Debug("releasing connection to pool",
			"host", psqlConfig.HOST,
			"database", psqlConfig.NAME)
		return true
	}

	dbConfig.BeforeClose = func(c *pgx.Conn) {
		slog.Debug("closing connection",
			"host", psqlConfig.HOST,
			"database", psqlConfig.NAME)
	}

	return dbConfig
}