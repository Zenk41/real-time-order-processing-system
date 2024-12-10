package domain

import (
	"time"

	"github.com/google/uuid"
)

// FeaturedProduct represents the featured_product table
type FeaturedProduct struct {
	FeaturedID uuid.UUID  `json:"featured_id" db:"featured_id"`
	ProductID  uuid.UUID  `json:"product_id" db:"product_id"`
	StartDate  *time.Time `json:"start_date,omitempty" db:"start_date"`
	EndDate    *time.Time `json:"end_date,omitempty" db:"end_date"`
}
