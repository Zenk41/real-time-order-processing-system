package middleware

import (
	"log/slog"
	"os"
	"time"

	"github.com/gofiber/fiber/v2"
)

// StructuredLogger logs a Fiber HTTP request using slog.
func StructuredLogger() fiber.Handler {
	// Initialize a JSON logger
	logger := slog.New(slog.NewJSONHandler(os.Stdout, nil))

	return func(c *fiber.Ctx) error {
		start := time.Now() // Start timer

		// Process request
		err := c.Next()

		// Create log entry
		logger.LogAttrs(
			c.Context(),
			slog.LevelInfo,
			"HTTP Request",
			slog.String("time", time.Now().Format(time.RFC3339)),
			slog.String("client_ip", c.IP()),
			slog.String("method", c.Method()),
			slog.String("path", c.OriginalURL()), // Includes query string if present
			slog.Int("status_code", c.Response().StatusCode()),
			slog.String("latency", time.Since(start).String()),
			slog.Int("body_size", len(c.Response().Body())),
			slog.String("user_agent", c.Get("User-Agent")),
			slog.String("error", errorString(err)), // Include error, if any
		)

		return err
	}
}

// errorString converts an error to a string or returns an empty string if nil.
func errorString(err error) string {
	if err != nil {
		return err.Error()
	}
	return ""
}
