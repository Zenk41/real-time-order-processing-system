package domain

import (
	"time"

	"github.com/google/uuid"
)

// Admin represents the admin table
type Admin struct {
	AdminID       uuid.UUID `json:"admin_id" db:"admin_id"`
	AdminName     string    `json:"admin_name" db:"admin_name"`
	AdminEmail    string    `json:"admin_email" db:"admin_email"`
	AdminPassword string    `json:"-" db:"admin_password"`
	Role          string    `json:"role" db:"role"`
	CreatedAt     time.Time `json:"created_at" db:"created_at"`
	UpdatedAt     time.Time `json:"updated_at" db:"updated_at"`
}
