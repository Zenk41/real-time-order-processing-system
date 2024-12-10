package domain

import (
	"time"

	"github.com/google/uuid"
)

// Collection represents the collections table
type Collection struct {
	CollectionID uuid.UUID `json:"collection_id" db:"collection_id"`
	Name         string    `json:"name" db:"name"`
	Description  *string   `json:"description,omitempty" db:"description"`
	CreatedAt    time.Time `json:"created_at" db:"created_at"`
	UpdatedAt    time.Time `json:"updated_at" db:"updated_at"`
}
