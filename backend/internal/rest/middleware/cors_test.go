package middleware_test

import (
	"net/http"
	test "net/http/httptest"
	"rtops-backend/internal/rest/middleware"
	"testing"

	"github.com/gofiber/fiber/v2"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestCORS(t *testing.T) {
	// Initialize Fiber app
	app := fiber.New()

	// Register middleware and test route
	app.Use(middleware.CORS())
	app.Get("/", func(c *fiber.Ctx) error {
		return c.SendStatus(http.StatusOK)
	})

	// Create test request and response
	req := test.NewRequest(http.MethodGet, "/", nil)
	res, err := app.Test(req)

	// Validate the response
	require.NoError(t, err)
	assert.Equal(t, http.StatusOK, res.StatusCode)
	assert.Equal(t, "*", res.Header.Get("Access-Control-Allow-Origin"))
}
