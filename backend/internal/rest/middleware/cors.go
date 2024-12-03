package middleware

import "github.com/gofiber/fiber/v2"

// CORS handles the CORS middleware
func CORS() fiber.Handler {
	return func(c *fiber.Ctx) error {
		c.Set("Access-Control-Allow-Origin", "*")
		return c.Next()
	}
}
