package domain

import (
	"time"

	"github.com/google/uuid"
)

// Category represents the category table
type Category struct {
	CategoryID  uuid.UUID `json:"category_id" db:"category_id"`
	Name        string    `json:"name" db:"name"`
	Description *string   `json:"description,omitempty" db:"description"`
	CreatedAt   time.Time `json:"created_at" db:"created_at"`
	UpdatedAt   time.Time `json:"updated_at" db:"updated_at"`
}
